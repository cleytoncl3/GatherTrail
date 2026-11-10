-- GatherTrail: guia de coleta para Mineracao, Herbalismo e Esfolamento.
--
-- O cliente Classic NAO deixa addons ler os pontos de tracking do minimapa,
-- entao o addon aprende os locais: cada vez que voce coleta um recurso
-- (cast da profissao + item no loot de um objeto do mundo) a posicao e gravada.
-- Depois ele mostra uma seta, uma linha no minimapa e icones no minimapa e no
-- mapa-mundi (amarelo = sua skill alcanca, vermelho = skill insuficiente).
-- Alcance ajustavel em /gt. O addon apenas MOSTRA informacao: nao automatiza
-- nenhuma acao do personagem.

local ADDON = ...

local sqrt, atan2, sin, cos, floor, min = math.sqrt, math.atan2 or function(y, x) return math.atan(y, x) end, math.sin, math.cos, math.floor, math.min

-- itemID do minerio -> skill de Mineracao necessaria
local ORE_REQ = {
    [2770] = 1,    -- Cobre
    [2771] = 65,   -- Estanho
    [2775] = 75,   -- Prata
    [2772] = 125,  -- Ferro
    [2776] = 155,  -- Ouro
    [3858] = 175,  -- Mithril
    [7911] = 230,  -- Verdeprata
    [11370] = 230, -- Ferro Negro
    [10620] = 245, -- Torio
    [23424] = 275, -- Ferro Vil
    [23425] = 325, -- Adamantita
    [23426] = 375, -- Khorium
    [23427] = 350, -- Eternium
    [36909] = 350, -- Cobalto
    [36912] = 400, -- Saronita
    [36910] = 450, -- Titanio
    [4278] = 75,   -- Pedra de Sangue Menor
    [3340] = 65,   -- Incendicita
    [5833] = 150,  -- Indurio
}

local HERB_REQ = {
    [2447]=1,[765]=1,[2449]=15,[785]=50,[2450]=70,[3820]=85,[2453]=100,[3355]=115,[3369]=120,[3356]=125,
    [3357]=150,[3818]=160,[3821]=170,[3358]=185,[3819]=195,[4625]=205,[8831]=210,[8836]=220,[8838]=230,
    [8839]=235,[8845]=245,[8846]=250,[13464]=260,[13463]=270,[13465]=280,[13466]=285,[13467]=290,[13468]=300,
    [22785]=300,[22786]=315,[22787]=325,[22789]=325,[22790]=340,[22791]=350,[22792]=365,[22793]=375,[22788]=335,
}
for id, r in pairs(HERB_REQ) do ORE_REQ[id] = r end

local SKIN_ICON = "Interface/Icons/INV_Misc_Pelt_Wolf_01"
-- kind -> { spells que nomeiam o cast e a skill, classe/subclasse do item no loot }
local KINDS = {
    mine = { cast = { 2575 }, skill = { 2575 }, cls = 7, sub = 7, label = "Mineracao" },
    herb = { cast = { 2366 }, skill = { 2366, 2368, 3570, 11993, 28695, 50300 }, cls = 7, sub = 9, label = "Herbalismo",
             names = { "herbalism", "herbalismo", "herboristeria", "herboristería", "herboristerie", "kräuterkunde", "erboristeria" } },
    skin = { cast = { 8613 }, skill = { 8613 }, label = "Esfolamento",
             names = { "skinning", "esfolamento", "desuello", "dépeçage", "kürschnerei", "scuoiatura" } },
}

local DEFAULTS = {
    trackMine = true,
    trackHerb = true,
    trackSkin = true,
    skinCorpseSecs = 420,
    enabled = true,
    range = 600,          -- jardas
    arrow = true,
    line = true,
    minimapPins = true,
    mapPins = true,
    showRed = true,       -- mostrar veios que sua skill ainda nao alcanca
    arrowToRed = false,   -- seta tambem para veios vermelhos se nao houver amarelo
    hideMinedSecs = 300,  -- esconde um veio recem-minerado (respawn)
    arrowLocked = true,
    arrowScale = 100,     -- porcento
    useSeed = true,       -- usa o banco inicial (addon GatherTrailData)
    hoverLearn = true,    -- aprende veios passando o mouse no minimapa
}

local db
local MAX_PINS = 50
local DIAM_IN = { 300, 240, 192, 150, 120, 96 }
local DIAM_OUT = { 466.67, 400, 333.33, 266.67, 200, 133.33 }
local YELLOW = { 1, 0.82, 0 }
local RED = { 0.9, 0.1, 0.1 }

---------------------------------------------------------------- utilidades

local function SpellName(id)
    local n
    if C_Spell and C_Spell.GetSpellName then
        n = C_Spell.GetSpellName(id)
    elseif GetSpellInfo then
        n = GetSpellInfo(id)
    end
    if type(n) == "table" then n = n.name end
    return n
end

local skills = { mine = { has = false, skill = 0 }, herb = { has = false, skill = 0 }, skin = { has = false, skill = 0 } }

-- Clientes novos devolvem "valores secretos" (GUID, nome...) em varias situacoes.
-- Eles nao podem ser comparados nem indexados pelo addon: sempre ignorar.
local issecret = issecretvalue or function() return false end

local function Lower(x)
    if not x or issecret(x) then return "" end
    return x:lower()
end

local kindNames = {}
local function BuildKindNames()
    for kind, def in pairs(KINDS) do
        local set = {}
        for _, id in ipairs(def.skill) do
            local n = SpellName(id)
            if n then set[Lower(n)] = true end
        end
        for _, n in ipairs(def.names or {}) do set[Lower(n)] = true end
        kindNames[kind] = set
    end
end

local castKind = {}
local function BuildCastNames()
    wipe(castKind)
    for kind, def in pairs(KINDS) do
        for _, id in ipairs(def.cast) do
            local n = SpellName(id)
            if n then castKind[Lower(n)] = kind end
        end
    end
end

local function RefreshSkill()
    BuildKindNames()
    for _, s in pairs(skills) do s.has, s.skill = false, 0 end
    if not GetNumSkillLines then return end
    for i = 1, GetNumSkillLines() do
        local n, header, _, rank, temp, mod = GetSkillLineInfo(i)
        if not header and n then
            local ln = Lower(n)
            for kind, set in pairs(kindNames) do
                if set[ln] then
                    skills[kind].has = true
                    skills[kind].skill = (rank or 0) + (mod or 0)
                end
            end
        end
    end
end

local function SkinReq(level)
    level = level or 1
    if level <= 10 then return 0 end
    if level <= 20 then return level * 10 - 100 end
    return level * 5
end

local function KindOn(kind)
    if kind == "herb" then return db.trackHerb end
    if kind == "skin" then return db.trackSkin end
    return db.trackMine
end

local iconCache = {}
local function OreIcon(id)
    local icon = iconCache[id]
    if icon then return icon end
    if GetItemInfoInstant then
        icon = select(5, GetItemInfoInstant(id))
    end
    if icon then iconCache[id] = icon end
    return icon or "Interface\\Icons\\INV_Misc_QuestionMark"
end

local function PlayerPos()
    local a, b, _, inst = UnitPosition("player")
    if not a then return nil end
    return a, b, inst
end

local function MapPos()
    if not (C_Map and C_Map.GetBestMapForUnit) then return end
    local map = C_Map.GetBestMapForUnit("player")
    if not map then return end
    local pos = C_Map.GetPlayerMapPosition(map, "player")
    if not pos then return end
    local x, y = pos:GetXY()
    if not x or (x == 0 and y == 0) then return end
    return map, x, y
end

local function Print(msg)
    print("|cffffd100GatherTrail:|r " .. msg)
end

---------------------------------------------------------------- gravacao

---------------------------------------------------------------- banco inicial (GatherTrailData)
-- Tabelas do GatherMate2_Data: [mapID][XXXXYYYY00] = nodeID. Convertidas sob demanda,
-- uma zona por vez, para as mesmas coordenadas de mundo que UnitPosition usa.

local SEED_ITEM = {
    mine = {
        [201] = 2770, [202] = 2771, [203] = 2772, [204] = 2775, [209] = 2775, [205] = 2776, [210] = 2776,
        [206] = 3858, [207] = 3858, [208] = 7911, [211] = 7911, [212] = 10620, [213] = 10620, [214] = 10620,
        [215] = 10620, [217] = 11370, [218] = 4278, [219] = 3340, [220] = 5833,
    },
    herb = {
        [401] = 2447, [402] = 765, [403] = 2449, [404] = 785, [405] = 2450, [407] = 3820, [408] = 2453,
        [409] = 3355, [410] = 3369, [411] = 3356, [412] = 3357, [413] = 3818, [414] = 3821, [415] = 3358,
        [416] = 3819, [417] = 4625, [418] = 8831, [420] = 8836, [421] = 8838, [422] = 8839, [423] = 8845,
        [424] = 8846, [425] = 13464, [426] = 13463, [427] = 13465, [428] = 13466, [429] = 13467, [431] = 13468,
    },
}
local SEED_GLOBAL = { mine = "GatherMateData2MineDB", herb = "GatherMateData2HerbDB" }

local seedCache = {}
local coordSwap -- nil = ainda nao calibrado; true: a = world.y, b = world.x

local function Calibrate(a, b, map, mx, my)
    if coordSwap ~= nil then return true end
    if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D and map and a) then return false end
    local _, wp = C_Map.GetWorldPosFromMapPos(map, CreateVector2D(mx, my))
    if not wp then return false end
    local x, y = wp.x, wp.y
    local e1 = math.abs(a - x) + math.abs(b - y)
    local e2 = math.abs(a - y) + math.abs(b - x)
    if math.abs(e1 - e2) < 10 then return false end -- ambiguo: tenta de novo mais tarde
    coordSwap = e2 < e1
    return true
end

local function SeedFor(map)
    local cached = seedCache[map]
    if cached ~= nil then return cached or nil end
    local a, b, inst = PlayerPos()
    local pm, mx, my = MapPos()
    if not (a and pm == map and Calibrate(a, b, pm, mx, my)) then return nil end
    local list = {}
    seedCache[map] = list
    local load = (C_AddOns and C_AddOns.LoadAddOn) or LoadAddOn
    if load then pcall(load, "GatherTrailData") end
    for kind, glob in pairs(SEED_GLOBAL) do
        local zone = _G[glob] and _G[glob][map]
        if zone then
            for key, nid in pairs(zone) do
                local ore = SEED_ITEM[kind][nid]
                if ore then
                    local x = floor(key / 1000000) / 10000
                    local y = (floor(key / 100) % 10000) / 10000
                    local _, wp = C_Map.GetWorldPosFromMapPos(map, CreateVector2D(x, y))
                    if wp then
                        local na, nb = wp.x, wp.y
                        if coordSwap then na, nb = wp.y, wp.x end
                        list[#list + 1] = {
                            kind = kind, ore = ore, req = ORE_REQ[ore] or 0,
                            a = na, b = nb, inst = inst, map = map, mx = x, my = y, seed = true,
                        }
                    end
                end
            end
        end
    end
    return list
end

local corpses = {} -- esfolaveis: so em memoria, somem sozinhos
local pending -- { t = GetTime(), a, b, inst, map, mx, my }

local function Record(oreID, kind)
    if not pending then return end
    local now = time()
    for _, n in ipairs(db.nodes) do
        if n.inst == pending.inst and n.ore == oreID and (n.kind or "mine") == kind then
            local da, dbb = n.a - pending.a, n.b - pending.b
            if da * da + dbb * dbb < 15 * 15 then
                n.mined = now
                return
            end
        end
    end
    db.nodes[#db.nodes + 1] = {
        ore = oreID, kind = kind, req = ORE_REQ[oreID] or 0,
        a = pending.a, b = pending.b, inst = pending.inst,
        map = pending.map, mx = pending.mx, my = pending.my,
        t = now, mined = now,
    }
end

---------------------------------------------------------------- pins

local function MakePin(parent, size)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(size, size)
    f.border = f:CreateTexture(nil, "BACKGROUND")
    f.border:SetAllPoints()
    f.icon = f:CreateTexture(nil, "ARTWORK")
    f.icon:SetPoint("TOPLEFT", 2, -2)
    f.icon:SetPoint("BOTTOMRIGHT", -2, 2)
    f.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    f:Hide()
    return f
end

local function StylePin(pin, node, can)
    local c = can and YELLOW or RED
    pin.border:SetColorTexture(c[1], c[2], c[3], 1)
    pin.icon:SetTexture(node.icon or OreIcon(node.ore))
    pin.icon:SetDesaturated(not can)
    pin.node, pin.can = node, can
end

local miniFrame, miniLine, miniPins = nil, nil, {}
local function EnsureMinimap()
    if miniFrame or not Minimap then return end
    miniFrame = CreateFrame("Frame", nil, Minimap)
    miniFrame:SetAllPoints()
    miniFrame:SetFrameLevel(Minimap:GetFrameLevel() + 6)
    miniLine = miniFrame:CreateLine(nil, "OVERLAY")
    miniLine:SetThickness(2)
    miniLine:SetColorTexture(1, 0.82, 0, 0.85)
    miniLine:Hide()
    for i = 1, MAX_PINS do miniPins[i] = MakePin(miniFrame, 16) end
end

---------------------------------------------------------------- seta

local arrow = CreateFrame("Frame", "GatherTrailArrow", UIParent)
arrow:SetSize(64, 64)
arrow:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
arrow:SetMovable(true)
arrow:SetClampedToScreen(true)
arrow:SetFrameStrata("MEDIUM")
arrow.tex = arrow:CreateTexture(nil, "ARTWORK")
arrow.tex:SetAllPoints()
arrow.tex:SetTexture("Interface\\Minimap\\ROTATING-MINIMAPARROW")
arrow.pin = MakePin(arrow, 22)
arrow.pin:SetPoint("BOTTOM", arrow, "TOP", 0, 2)
arrow.text = arrow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
arrow.text:SetPoint("TOP", arrow, "BOTTOM", 0, -2)
arrow:Hide()

arrow:RegisterForDrag("LeftButton")
arrow:SetScript("OnDragStart", function(self)
    if not db.arrowLocked then self:StartMoving() end
end)
arrow:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local p, _, rp, x, y = self:GetPoint()
    db.arrowPos = { p, rp, x, y }
end)

local function ApplyArrowPos()
    arrow:ClearAllPoints()
    local p = db.arrowPos
    if p then
        arrow:SetPoint(p[1], UIParent, p[2], p[3], p[4])
    else
        arrow:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
    end
    arrow:SetScale(db.arrowScale / 100)
    arrow:EnableMouse(not db.arrowLocked)
end

---------------------------------------------------------------- mapa-mundi

local worldFrame, worldPins = nil, {}
local worldDirty, worldAt = true, 0

local function SetupWorldMap()
    if worldFrame or not WorldMapFrame or not WorldMapFrame.GetCanvas then return end
    local canvas = WorldMapFrame:GetCanvas()
    worldFrame = CreateFrame("Frame", nil, canvas)
    worldFrame:SetAllPoints()
    worldFrame:SetFrameLevel(canvas:GetFrameLevel() + 50)
    for i = 1, 100 do
        local p = MakePin(worldFrame, 18)
        p:EnableMouse(true)
        p:SetScript("OnEnter", function(self)
            local n = self.node
            if not n then return end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            local name = n.kind == "skin" and ("Esfolar: " .. (n.name or "criatura")) or (n.ore and GetItemInfo and GetItemInfo(n.ore)) or KINDS[n.kind or "mine"].label
            GameTooltip:AddLine(name, 1, 1, 1)
            if (n.req or 0) > 0 then
                GameTooltip:AddLine(("Skill necessaria: %d (a sua: %d)"):format(n.req, skills[n.kind or "mine"].skill),
                    self.can and 0.3 or 1, self.can and 1 or 0.3, 0.3)
            end
            if n.mined then
                GameTooltip:AddLine(("Coletado ha %d min"):format((time() - n.mined) / 60), 0.7, 0.7, 0.7)
            end
            GameTooltip:Show()
        end)
        p:SetScript("OnLeave", function() GameTooltip:Hide() end)
        worldPins[i] = p
    end
    hooksecurefunc(WorldMapFrame, "OnMapChanged", function() worldDirty = true end)
    WorldMapFrame:HookScript("OnShow", function() worldDirty = true end)
end

local function NodeCan(n)
    local k = n.kind or "mine"
    return (n.req or 0) <= skills[k].skill
end

local function UpdateWorldMap(pa, pb, inst)
    if not (worldFrame and WorldMapFrame:IsShown()) then return end
    for _, p in ipairs(worldPins) do p:Hide() end
    if not db.mapPins or not pa then return end
    local mapID = WorldMapFrame:GetMapID()
    local w, h = worldFrame:GetWidth(), worldFrame:GetHeight()
    local now, used, r2 = time(), 0, db.range * db.range
    local function consider(n)
        if n.map == mapID and n.inst == inst and n.mx and KindOn(n.kind or "mine") then
            local da, dw = n.a - pa, n.b - pb
            if da * da + dw * dw <= r2 then
                local hidden = db.hideMinedSecs > 0 and n.mined and (now - n.mined) < db.hideMinedSecs
                local can = NodeCan(n)
                if not hidden and (can or db.showRed) and used < #worldPins then
                    used = used + 1
                    local p = worldPins[used]
                    StylePin(p, n, can)
                    p:ClearAllPoints()
                    p:SetPoint("CENTER", worldFrame, "TOPLEFT", n.mx * w, -n.my * h)
                    p:Show()
                end
            end
        end
    end
    for _, n in ipairs(db.nodes) do consider(n) end
    if db.useSeed and seedCache[mapID] then
        for _, n in ipairs(seedCache[mapID]) do consider(n) end
    end
end

---------------------------------------------------------------- loop principal

local cache, cacheAt = {}, 0
local lastInst

local function Rebuild(pa, pb, inst)
    wipe(cache)
    local r = db.range * 1.3
    local r2, now = r * r, time()
    for _, n in ipairs(db.nodes) do
        if n.inst == inst and KindOn(n.kind or "mine") then
            local da, dw = n.a - pa, n.b - pb
            if da * da + dw * dw <= r2 then
                local hidden = db.hideMinedSecs > 0 and n.mined and (now - n.mined) < db.hideMinedSecs
                if not hidden then cache[#cache + 1] = n end
            end
        end
    end
    if db.useSeed then
        local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
        local seed = map and SeedFor(map)
        if seed then
            local real = {}
            for _, n in ipairs(cache) do real[#real + 1] = n end
            for _, n in ipairs(seed) do
                if n.inst == inst and KindOn(n.kind) then
                    local da, dw = n.a - pa, n.b - pb
                    if da * da + dw * dw <= r2 then
                        local dup = false
                        for _, m in ipairs(real) do
                            if m.ore == n.ore and not m.seed then
                                local xa, xb = m.a - n.a, m.b - n.b
                                if xa * xa + xb * xb < 25 * 25 then dup = true break end
                            end
                        end
                        if not dup then cache[#cache + 1] = n end
                    end
                end
            end
        end
    end
    for i = #corpses, 1, -1 do
        local c = corpses[i]
        if c.exp < now then
            table.remove(corpses, i)
        elseif c.inst == inst and db.trackSkin then
            local da, dw = c.a - pa, c.b - pb
            if da * da + dw * dw <= r2 then cache[#cache + 1] = c end
        end
    end
end

local function HideAll()
    arrow:Hide()
    if miniLine then miniLine:Hide() end
    for _, p in ipairs(miniPins) do p:Hide() end
end

---------------------------------------------------------------- aprender pelo mouse
-- O jogo desenha os veios do rastreamento no minimapa e mostra o nome numa dica
-- quando o mouse passa por cima, mas nao entrega a posicao. Entao, quando a dica
-- do minimapa mostra um veio/erva conhecido, a posicao e calculada pelo cursor.

local materials, materialsAt = {}, 0

local function BuildMaterials()
    wipe(materials)
    local missing = false
    for id in pairs(ORE_REQ) do
        local name = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(id) or (GetItemInfo and GetItemInfo(id))
        if not name then
            missing = true
            if C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(id) end
        else
            local m = Lower(name)
            local kind = HERB_REQ[id] and "herb" or "mine"
            if kind == "mine" then
                m = (m:gsub("^min.-rio d[eao]s? ", ""))
                m = (m:gsub(" ore$", ""))
                m = (m:gsub("^ore of ", ""))
            end
            if #m >= 3 then materials[#materials + 1] = { m = m, id = id, kind = kind } end
        end
    end
    table.sort(materials, function(x, y) return #x.m > #y.m end)
    return not missing
end

local hoverOK
local hoverAt = 0
local function HoverLearn(pa, pb, inst, rot, ypp)
    if not db.hoverLearn then return end
    local t = GetTime()
    if t - hoverAt < 0.15 then return end
    hoverAt = t
    if not Minimap:IsMouseOver() or not GameTooltip:IsShown() then return end
    local fs = GameTooltipTextLeft1
    local text = fs and fs:GetText()
    if not text or issecret(text) then return end
    text = Lower(text)

    if not hoverOK and t - materialsAt > 5 then
        materialsAt = t
        hoverOK = BuildMaterials()
    end
    local hit
    for _, e in ipairs(materials) do
        if text:find(e.m, 1, true) then hit = e break end
    end
    if not hit or not KindOn(hit.kind) then return end

    local cx, cy = GetCursorPosition()
    local s = Minimap:GetEffectiveScale()
    local mx, my = Minimap:GetCenter()
    if not (cx and mx) then return end
    local dx, dy = cx / s - mx, cy / s - my
    local d = sqrt(dx * dx + dy * dy) * ypp
    local theta = atan2(-dx, dy) + rot
    local na, nb = pa + d * cos(theta), pb + d * sin(theta)

    for _, n in ipairs(db.nodes) do
        if n.inst == inst and n.ore == hit.id and (n.kind or "mine") == hit.kind then
            local da, dw = n.a - na, n.b - nb
            if da * da + dw * dw < 20 * 20 then return end
        end
    end
    db.nodes[#db.nodes + 1] = {
        ore = hit.id, kind = hit.kind, req = ORE_REQ[hit.id] or 0,
        a = na, b = nb, inst = inst, t = time(), learned = "hover",
    }
    cacheAt = 0
    Print("aprendido pelo mouse: " .. text)
end

local function Tick()
    if not db.enabled then HideAll() return end
    EnsureMinimap()
    local pa, pb, inst = PlayerPos()
    if not pa then HideAll() return end

    local t = GetTime()
    if t - cacheAt > 0.5 or inst ~= lastInst then
        Rebuild(pa, pb, inst)
        cacheAt, lastInst = t, inst
    end

    local facing = GetPlayerFacing() or 0
    local rotating = GetCVar("rotateMinimap") == "1"
    local rot = rotating and facing or 0

    local mmYards, ypp = 0, 1
    if miniFrame then
        local z = Minimap:GetZoom() or 0
        local diam = (IsIndoors() and DIAM_IN or DIAM_OUT)[z + 1] or 300
        mmYards = diam / 2
        ypp = mmYards / (Minimap:GetWidth() / 2)
    end

    if miniFrame then HoverLearn(pa, pb, inst, rot, ypp) end

    local bestY, bestYd, bestR, bestRd
    local used = 0
    for _, n in ipairs(cache) do
        local dN, dW = n.a - pa, n.b - pb
        local d = sqrt(dN * dN + dW * dW)
        if d <= db.range then
            local can = NodeCan(n)
            if can then
                if not bestYd or d < bestYd then bestY, bestYd = n, d end
            elseif db.showRed then
                if not bestRd or d < bestRd then bestR, bestRd = n, d end
            end
            if miniFrame and db.minimapPins and (can or db.showRed)
                and d <= mmYards * 0.92 and used < MAX_PINS then
                used = used + 1
                local pin = miniPins[used]
                StylePin(pin, n, can)
                local rel = atan2(dW, dN) - rot
                pin:ClearAllPoints()
                pin:SetPoint("CENTER", Minimap, "CENTER", -d * sin(rel) / ypp, d * cos(rel) / ypp)
                pin:Show()
            end
        end
    end
    for i = used + 1, MAX_PINS do
        if miniPins[i] then miniPins[i]:Hide() end
    end

    local target, td, tcan = bestY, bestYd, true
    if not target and db.arrowToRed and bestR then target, td, tcan = bestR, bestRd, false end

    if target and db.arrow then
        local dN, dW = target.a - pa, target.b - pb
        local theta = atan2(dW, dN)
        arrow.tex:SetRotation(theta - facing)
        local c = tcan and YELLOW or RED
        arrow.tex:SetVertexColor(c[1], c[2], c[3])
        StylePin(arrow.pin, target, tcan)
        arrow.pin:Show()
        arrow.text:SetText(("%s - %d jardas"):format(KINDS[target.kind or "mine"].label, td))
        arrow:Show()

        if miniFrame and db.line and td > 6 then
            local rel = theta - rot
            local px = min(td / ypp, (Minimap:GetWidth() / 2) * 0.95)
            miniLine:SetStartPoint("CENTER", Minimap, 0, 0)
            miniLine:SetEndPoint("CENTER", Minimap, -px * sin(rel), px * cos(rel))
            miniLine:SetColorTexture(c[1], c[2], c[3], 0.85)
            miniLine:Show()
        elseif miniLine then
            miniLine:Hide()
        end
    elseif not db.arrowLocked then
        -- previa para poder posicionar a seta
        arrow.tex:SetRotation(0)
        arrow.tex:SetVertexColor(1, 1, 1)
        arrow.pin:Hide()
        arrow.text:SetText("Arraste para mover")
        arrow:Show()
        if miniLine then miniLine:Hide() end
    else
        arrow:Hide()
        if miniLine then miniLine:Hide() end
    end

    if worldDirty or (worldFrame and WorldMapFrame:IsShown() and t - (worldAt or 0) > 1) then
        worldAt, worldDirty = t, false
        UpdateWorldMap(pa, pb, inst)
    end
end

local elapsed, tickErr = 0, false
local driver = CreateFrame("Frame")
driver:SetScript("OnUpdate", function(_, dt)
    elapsed = elapsed + dt
    if elapsed < 0.03 then return end
    elapsed = 0
    if db then
        local ok, err = pcall(Tick)
        if not ok and not tickErr then
            tickErr = true
            Print("erro interno (Tick): " .. tostring(err))
        end
    end
end)

---------------------------------------------------------------- opcoes

local options

local function TryCreate(kind, name, parent, templates)
    for _, template in ipairs(templates) do
        local ok, made = pcall(CreateFrame, kind, name, parent, template)
        if ok and made then return made end
    end
    return CreateFrame(kind, name, parent)
end

local function BuildOptions()
    if options then return options end
    local f = TryCreate("Frame", "GatherTrailOptions", UIParent, { "BasicFrameTemplateWithInset", "DialogBoxFrame" })
    f:SetSize(360, 620)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG")
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -8)
    title:SetText("Forager - Guia de Minerios")
    f:Hide()
    tinsert(UISpecialFrames, "GatherTrailOptions")

    local refreshers = {}
    local y = -38

    local function Check(label, key, after)
        local cb = TryCreate("CheckButton", nil, f, { "UICheckButtonTemplate", "ChatConfigCheckButtonTemplate" })
        cb:SetSize(24, 24)
        cb:SetPoint("TOPLEFT", 16, y)
        local fs = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fs:SetPoint("LEFT", cb, "RIGHT", 4, 0)
        fs:SetText(label)
        cb:SetScript("OnClick", function(self)
            db[key] = self:GetChecked() and true or false
            if after then after() end
        end)
        refreshers[#refreshers + 1] = function() cb:SetChecked(db[key]) end
        y = y - 26
    end

    local sliderN = 0
    local function Slider(label, key, minV, maxV, step, unit, after)
        sliderN = sliderN + 1
        local name = "GatherTrailSlider" .. sliderN
        local cap = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        cap:SetPoint("TOPLEFT", 20, y)
        cap:SetText(label)
        local val = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        val:SetPoint("TOPRIGHT", -20, y - 1)
        local s = TryCreate("Slider", name, f, { "OptionsSliderTemplate", "MinimalSliderTemplate" })
        for _, suf in ipairs({ "Low", "High", "Text" }) do
            local extra = _G[name .. suf]
            if extra then extra:SetText("") extra:Hide() end
        end
        s:SetOrientation("HORIZONTAL")
        s:SetPoint("TOPLEFT", 22, y - 20)
        s:SetSize(316, 16)
        s:SetMinMaxValues(minV, maxV)
        s:SetValueStep(step)
        if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
        s:SetScript("OnValueChanged", function(self, v)
            v = floor(v / step + 0.5) * step
            val:SetText(v .. unit)
            if self.syncing then return end
            db[key] = v
            if after then after() end
        end)
        refreshers[#refreshers + 1] = function()
            s.syncing = true
            s:SetValue(db[key])
            s.syncing = false
            val:SetText(db[key] .. unit)
        end
        y = y - 46
    end

    local function ForceUpdate() cacheAt = 0 worldDirty = true end

    Check("Ativar addon", "enabled")
    Check("Rastrear Mineracao", "trackMine", ForceUpdate)
    Check("Rastrear Herbalismo", "trackHerb", ForceUpdate)
    Check("Rastrear Esfolamento (cadaveres)", "trackSkin", ForceUpdate)
    Check("Usar banco inicial de locais (GatherTrailData)", "useSeed", ForceUpdate)
    Check("Aprender veios passando o mouse no minimapa", "hoverLearn")
    Check("Seta direcional na tela", "arrow")
    Check("Linha no minimapa ate o veio", "line")
    Check("Icones no minimapa", "minimapPins")
    Check("Icones no mapa-mundi (M)", "mapPins", ForceUpdate)
    Check("Mostrar veios vermelhos (skill insuficiente)", "showRed", ForceUpdate)
    Check("Seta tambem para vermelhos se nao houver amarelo", "arrowToRed")
    y = y - 6
    Slider("Alcance de deteccao", "range", 50, 2000, 50, " jd", ForceUpdate)
    Slider("Esconder veio minerado por (respawn)", "hideMinedSecs", 0, 900, 30, " s", ForceUpdate)
    Slider("Tamanho da seta", "arrowScale", 50, 200, 10, "%", ApplyArrowPos)

    local lock = TryCreate("CheckButton", nil, f, { "UICheckButtonTemplate", "ChatConfigCheckButtonTemplate" })
    lock:SetSize(24, 24)
    lock:SetPoint("TOPLEFT", 16, y)
    local lfs = lock:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    lfs:SetPoint("LEFT", lock, "RIGHT", 4, 0)
    lfs:SetText("Seta travada (desmarque para arrastar)")
    lock:SetScript("OnClick", function(self)
        db.arrowLocked = self:GetChecked() and true or false
        ApplyArrowPos()
    end)
    refreshers[#refreshers + 1] = function() lock:SetChecked(db.arrowLocked) end
    y = y - 30

    local info = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    info:SetPoint("TOPLEFT", 20, y)
    info:SetWidth(320)
    info:SetJustifyH("LEFT")
    f.info = info

    local clear = TryCreate("Button", nil, f, { "UIPanelButtonTemplate" })
    clear:SetSize(150, 24)
    clear:SetPoint("BOTTOM", 0, 14)
    clear:SetText("Apagar veios salvos")
    clear:SetScript("OnClick", function()
        wipe(db.nodes)
        ForceUpdate()
        f:Refresh()
        Print("veios apagados.")
    end)

    function f:Refresh()
        for _, r in ipairs(refreshers) do r() end
        local function sk(k) return skills[k].has and ("skill " .. skills[k].skill) or "nao tem" end
        info:SetText(("Pontos memorizados: %d\nMineracao: %s | Herbalismo: %s | Esfolamento: %s"):format(#db.nodes, sk("mine"), sk("herb"), sk("skin")))
    end
    f:SetScript("OnShow", f.Refresh)
    options = f
    return f
end

local function ToggleOptions()
    local f = BuildOptions()
    if f:IsShown() then f:Hide() else f:Show() end
end

SLASH_GATHERTRAIL1 = "/gt"
SLASH_GATHERTRAIL2 = "/gathertrail"
SlashCmdList.GATHERTRAIL = function(msg)
    msg = (msg or ""):lower()
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    if cmd == "range" and tonumber(arg) then
        db.range = math.max(50, math.min(2000, tonumber(arg)))
        cacheAt = 0 worldDirty = true
        Print("alcance: " .. db.range .. " jardas")
    elseif cmd == "lock" then
        db.arrowLocked = not db.arrowLocked
        ApplyArrowPos()
        Print(db.arrowLocked and "seta travada" or "seta destravada: arraste para mover")
    elseif cmd == "clear" then
        wipe(db.nodes)
        Print("veios apagados.")
    elseif cmd == "probe" then
        -- diagnostico: o que o cliente expoe de pontos no minimapa?
        Print("--- probe ---")
        if C_Minimap and C_Minimap.GetNumTrackingTypes then
            for i = 1, C_Minimap.GetNumTrackingTypes() do
                local info = C_Minimap.GetTrackingInfo(i)
                if info and info.active then Print("tracking ativo: " .. tostring(info.name)) end
            end
        end
        if not (C_VignetteInfo and C_VignetteInfo.GetVignettes) then
            Print("C_VignetteInfo nao existe neste cliente.")
            return
        end
        local guids = C_VignetteInfo.GetVignettes() or {}
        Print(#guids .. " vignettes visiveis")
        local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
        for i, g in ipairs(guids) do
            if i > 25 then Print("...") break end
            local v = C_VignetteInfo.GetVignetteInfo(g)
            if v then
                local pos = map and C_VignetteInfo.GetVignettePosition(g, map)
                local x, y = 0, 0
                if pos then x, y = pos:GetXY() end
                Print(("%s | atlas=%s | obj=%s | %.1f,%.1f"):format(tostring(v.name), tostring(v.atlasName),
                    tostring(v.objectGUID and v.objectGUID:match("^(%a+)")), x * 100, y * 100))
            end
        end
    elseif cmd == "debug" then
        local ns_ = 0
        for _, l in pairs(seedCache) do ns_ = ns_ + #l end
        Print(("banco inicial: %d pontos carregados, calibrado=%s"):format(ns_, tostring(coordSwap)))
        Print(("pontos=%d cadaveres=%d mine=%d herb=%d skin=%d cache=%d"):format(#db.nodes, #corpses, skills.mine.skill, skills.herb.skill, skills.skin.skill, #cache))
    else
        ToggleOptions()
    end
end

---------------------------------------------------------------- eventos

local scan = CreateFrame("GameTooltip", "GatherTrailScan", nil, "GameTooltipTemplate")
scan:SetOwner(UIParent, "ANCHOR_NONE")

local skinStrings
local function IsSkinnableUnit(unit)
    if not skinStrings then
        skinStrings = {}
        for _, g in ipairs({ "UNIT_SKINNABLE_LEATHER", "UNIT_SKINNABLE_HERB", "UNIT_SKINNABLE_ROCK", "UNIT_SKINNABLE_BOLTS" }) do
            if _G[g] then skinStrings[#skinStrings + 1] = _G[g] end
        end
    end
    scan:ClearLines()
    scan:SetUnit(unit)
    for i = 2, scan:NumLines() do
        local fs = _G["GatherTrailScanTextLeft" .. i]
        local text = fs and fs:GetText()
        if text then
            for _, str in ipairs(skinStrings) do
                if not issecret(text) and text == str then return true end
            end
        end
    end
    return false
end

-- registra o cadaver na posicao do jogador (precisa estar perto ao lootear)
local function AddCorpse(unit, guid, a, b, inst, precise)
    if not (db and db.trackSkin and skills.skin.has and a) then return end
    for _, c in ipairs(corpses) do
        if c.guid == guid then
            if precise and not c.precise then c.a, c.b, c.precise = a, b, true end
            return
        end
    end
    local level = UnitLevel(unit)
    if not level or issecret(level) then level = 1 end
    local uname = UnitName(unit)
    if issecret(uname) then uname = nil end
    local map, mx, my = MapPos()
    corpses[#corpses + 1] = {
        kind = "skin", guid = guid, name = uname, icon = SKIN_ICON,
        a = a, b = b, inst = inst, map = map, mx = mx, my = my,
        req = SkinReq(level), precise = precise,
        exp = time() + db.skinCorpseSecs,
    }
    cacheAt = 0
    worldDirty = true
end

local function CheckUnit(unit, precise)
    if not (UnitExists(unit) and UnitIsDead(unit)) or UnitIsPlayer(unit) then return end
    local guid = UnitGUID(unit)
    if not guid or issecret(guid) or not guid:find("^Creature") then return end
    if IsSkinnableUnit(unit) then
        local a, b, inst = PlayerPos()
        AddCorpse(unit, guid, a, b, inst, precise)
    end
end

local function RemoveNearestCorpse()
    local a, b, inst = PlayerPos()
    if not a then return end
    local best, bd
    for i, c in ipairs(corpses) do
        if c.inst == inst then
            local d = (c.a - a) ^ 2 + (c.b - b) ^ 2
            if d < 40 * 40 and (not bd or d < bd) then best, bd = i, d end
        end
    end
    if best then
        table.remove(corpses, best)
        cacheAt = 0
        worldDirty = true
    end
end

local lootGUID, lootPos

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("UNIT_SPELLCAST_SENT")
ev:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
ev:RegisterEvent("LOOT_OPENED")
ev:RegisterEvent("LOOT_CLOSED")
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
ev:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
local function Handle(_, event, ...)
    if event == "ADDON_LOADED" then
        if (...) ~= ADDON then return end
        GatherTrailDB = GatherTrailDB or ForagerOreDB or {}
        db = GatherTrailDB
        for k, v in pairs(DEFAULTS) do
            if db[k] == nil then db[k] = v end
        end
        db.nodes = db.nodes or {}
    elseif event == "PLAYER_LOGIN" then
        BuildCastNames()
        RefreshSkill()
        ApplyArrowPos()
        SetupWorldMap()
        if not worldFrame then
            local waiter = CreateFrame("Frame")
            waiter:RegisterEvent("ADDON_LOADED")
            waiter:SetScript("OnEvent", function(self)
                SetupWorldMap()
                if worldFrame then self:UnregisterAllEvents() end
            end)
        end
    elseif event == "SKILL_LINES_CHANGED" then
        BuildCastNames()
        RefreshSkill()
        cacheAt = 0
    elseif event == "UNIT_SPELLCAST_SENT" then
        local unit, _, _, spellID = ...
        if unit ~= "player" or not db then return end
        if issecret(spellID) then return end
        local kind = castKind[Lower(SpellName(spellID))]
        if kind and kind ~= "skin" then
            local a, b, inst = PlayerPos()
            if a then
                local map, mx, my = MapPos()
                pending = { t = GetTime(), kind = kind, a = a, b = b, inst = inst, map = map, mx = mx, my = my }
            end
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, _, spellID = ...
        if unit ~= "player" or not db then return end
        if issecret(spellID) then return end
        if castKind[Lower(SpellName(spellID))] == "skin" then RemoveNearestCorpse() end
    elseif event == "LOOT_OPENED" then
        if not db then return end
        -- cadaver: guarda o guid para checar depois se da para esfolar
        local guid = GetLootSourceInfo and GetLootSourceInfo(1)
        if guid and issecret(guid) then guid = nil end
        if guid and guid:find("^Creature") then
            lootGUID = guid
            local a, b, inst = PlayerPos()
            lootPos = a and { a, b, inst } or nil
        end
        if not pending then return end
        -- so conta recurso de objeto do mundo (nao drop de criatura)
        if guid and not guid:find("^GameObject") then pending = nil return end
        if GetTime() - pending.t > 20 then
            pending = nil
            return
        end
        local def = KINDS[pending.kind]
        for i = 1, GetNumLootItems() do
            local link = GetLootSlotLink and GetLootSlotLink(i)
            if link then
                local id, _, _, _, icon, cls, sub = GetItemInfoInstant(link)
                if id and (ORE_REQ[id] or (cls == def.cls and sub == def.sub)) then
                    if icon then iconCache[id] = icon end
                    Record(id, pending.kind)
                    cacheAt = 0
                    worldDirty = true
                    break
                end
            end
        end
        pending = nil
    elseif event == "LOOT_CLOSED" then
        if lootGUID and db then
            local guid, pos = lootGUID, lootPos
            lootGUID, lootPos = nil, nil
            -- o corpo so mostra "Esfolavel" depois de lootado
            C_Timer.After(0.4, function()
                for _, unit in ipairs({ "target", "mouseover" }) do
                    if pos and UnitExists(unit) and UnitGUID(unit) == guid and UnitIsDead(unit)
                        and IsSkinnableUnit(unit) then
                        AddCorpse(unit, guid, pos[1], pos[2], pos[3], true)
                        return
                    end
                end
            end)
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        if db then CheckUnit("target", false) end
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        if db then CheckUnit("mouseover", false) end
    end
end

local reported
ev:SetScript("OnEvent", function(self, event, ...)
    local ok, err = pcall(Handle, self, event, ...)
    if not ok and not reported then
        reported = true
        Print("erro interno (" .. tostring(event) .. "): " .. tostring(err))
    end
end)
