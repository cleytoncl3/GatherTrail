-- GatherTrail: guia de coleta para Mineracao, Herbalismo e Esfolamento.
--
-- O cliente Classic NAO deixa addons ler os pontos de tracking do minimapa,
-- entao o addon aprende os locais: cada vez que voce coleta um recurso
-- (cast da profissao + item no loot de um objeto do mundo) a posicao e gravada.
-- Depois ele mostra uma seta, uma linha no minimapa e icones no minimapa e no
-- mapa-mundi (amarelo = sua skill alcanca, vermelho = skill insuficiente).
-- Alcance ajustavel em /gt. O addon apenas MOSTRA informacao: nao automatiza
-- nenhuma acao do personagem.

local ADDON, ns = ...
local L = ns.L

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

-- minerio bruto -> barra fundida (o icone da barra identifica melhor o tipo de veio)
local BAR_OF = {
    [2770] = 2840, [2771] = 3576, [2775] = 2842, [2772] = 3575, [2776] = 3577, [3858] = 3860,
    [7911] = 6037, [11370] = 11371, [10620] = 12359, [23424] = 23445, [23425] = 23446,
    [23426] = 23449, [23427] = 23447, [36909] = 36916, [36912] = 36913, [36910] = 41163,
}

local SKIN_ICON = "Interface/Icons/INV_Misc_Pelt_Wolf_01"
-- um icone por tipo, facil de reconhecer: picareta, flor, couro
local KIND_ICON = {
    mine = "Interface/Icons/Trade_Mining",
    herb = "Interface/Icons/Trade_Herbalism",
    skin = SKIN_ICON,
}
-- kind -> { spells que nomeiam o cast e a skill, classe/subclasse do item no loot }
local KINDS = {
    mine = { cast = { 2575 }, skill = { 2575 }, cls = 7, sub = 7, label = L.KIND_mine },
    herb = { cast = { 2366 }, skill = { 2366, 2368, 3570, 11993, 28695, 50300 }, cls = 7, sub = 9, label = L.KIND_herb,
             names = { "herbalism", "herbalismo", "herboristeria", "herboristería", "herboristerie", "kräuterkunde", "erboristeria" } },
    skin = { cast = { 8613 }, skill = { 8613 }, label = L.KIND_skin,
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
    minimapButton = true,
    minimapAngle = 225,
    pinSize = 100,        -- tamanho dos icones (porcento)
    pinTransp = 30,       -- transparencia dos icones (porcento)
    autoHide = true,      -- esconde pontos vazios ao passar o mouse e nao ver nada (precisa do rastreamento ligado)
    emptySecs = 900,      -- por quanto tempo um ponto vazio fica escondido
    lowGap = 0,           -- esconde veios X niveis abaixo da skill (0 = desligado)
    onlyConfirmed = false,
    hideOre = {},         -- [itemID] = true: recurso escondido
    autoLoot = true,
    autoLootQuest = true, -- autoloot inteligente: so itens de missao e dinheiro (mobs, bas...)      -- pega sozinho o que veio de coleta (minerio/erva/couro)
    skipSecs = 1800,      -- tempo que um veio pulado fica escondido
    hoverLearn = true,    -- aprende veios passando o mouse no minimapa
}

BINDING_HEADER_GATHERTRAIL = "Trailsmith"
BINDING_NAME_GATHERTRAIL_SKIP = L.BINDING_SKIP

local db
local currentTarget
local SkipTarget, UpdateMMButton, ScanNow -- definidos mais abaixo
local MAX_PINS = 50
local DIAM_IN = { 300, 240, 192, 150, 120, 96 }
local DIAM_OUT = { 466.67, 400, 333.33, 266.67, 200, 133.33 }
local YELLOW = { 0.3, 0.85, 0.35 } -- verde: a skill alcanca (nome antigo da variavel)
local RED = { 0.85, 0.25, 0.25 }

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

local skills = {
    mine = { has = false, skill = 0, known = false },
    herb = { has = false, skill = 0, known = false },
    skin = { has = false, skill = 0, known = false },
}

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

-- grava o nivel de uma profissao pelo nome (qualquer idioma: compara com o nome dos feiticos)
local function SetSkill(name, level)
    if not name or issecret(name) or issecret(level) then return end
    local ln = Lower(name)
    for kind, set in pairs(kindNames) do
        if set[ln] then
            skills[kind].has, skills[kind].known, skills[kind].skill = true, true, level or 0
        end
    end
end

local function RefreshSkill()
    BuildKindNames()
    for _, s in pairs(skills) do s.has, s.skill, s.known = false, 0, false end
    -- fonte 1: lista de skills (clientes classicos)
    if GetNumSkillLines and GetSkillLineInfo then
        for i = 1, GetNumSkillLines() do
            local n, header, _, rank, _, mod = GetSkillLineInfo(i)
            if not header and n then SetSkill(n, (rank or 0) + (mod or 0)) end
        end
    end
    -- fonte 2: profissoes (clientes mais novos)
    if GetProfessions and GetProfessionInfo then
        local list = { GetProfessions() }
        for i = 1, 8 do
            local idx = list[i]
            if idx then
                local n, _, rank, _, _, _, _, mod = GetProfessionInfo(idx)
                SetSkill(n, (rank or 0) + (mod or 0))
            end
        end
    end
    -- se so sabemos que a pessoa tem a profissao (feitico conhecido), marca "has"
    for kind, def in pairs(KINDS) do
        local sp = def.skill[1]
        if not skills[kind].has and sp then
            local known = (IsPlayerSpell and IsPlayerSpell(sp)) or (IsSpellKnown and IsSpellKnown(sp))
            if known then skills[kind].has = true end
        end
    end
end

-- "Sua pericia em Mineracao subiu para 73." -> atualiza o nivel na hora
local skillPat
do
    local g = _G.SKILL_RANK_UP
    if type(g) == "string" then
        local p = g:gsub("%%s", "@S@"):gsub("%%d", "@D@")
        p = p:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
        p = p:gsub("@S@", "(.+)"):gsub("@D@", "(%%d+)")
        skillPat = "^" .. p .. "$"
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

-- raridade do veio: veios raros ficam menos transparentes que os comuns
local RARITY = {
    [2770] = 0, [2771] = 0.05, [2775] = 0.3, [2772] = 0.4, [2776] = 0.55, [3858] = 0.6, [7911] = 0.75,
    [10620] = 0.8, [11370] = 0.9, [4278] = 0.3, [3340] = 0.2, [5833] = 0.5,
    [23424] = 0.6, [23425] = 0.75, [23426] = 1, [23427] = 0.9,
    [36909] = 0.6, [36912] = 0.8, [36910] = 0.95,
}

local barIcon, barOwner
local function BuildBarIcons()
    if barIcon or not GetItemInfoInstant then return end
    local bi, owner, list = {}, {}, {}
    for ore, bar in pairs(BAR_OF) do list[#list + 1] = ore end
    table.sort(list, function(x, y) return (ORE_REQ[x] or 0) > (ORE_REQ[y] or 0) end)
    for _, ore in ipairs(list) do
        local icon = select(5, GetItemInfoInstant(BAR_OF[ore]))
        if icon then
            bi[ore] = icon
            if not owner[icon] then owner[icon] = ore end
        end
    end
    barIcon, barOwner = bi, owner
end

local function MineIcon(ore)
    BuildBarIcons()
    local icon = barIcon and barIcon[ore]
    if icon and barOwner[icon] == ore then return icon end
    return OreIcon(ore)
end

-- preco no leilao: le o banco do Auctionator (ultimo scan), se estiver instalado
local function PriceOf(id)
    local A = _G.Auctionator
    if not (A and A.API and A.API.v1 and A.API.v1.GetAuctionPriceByItemID) then return nil end
    local ok, p = pcall(A.API.v1.GetAuctionPriceByItemID, "GatherTrail", id)
    if ok and type(p) == "number" and p > 0 then return p end
    return nil
end

local function Money(c)
    if not c then return nil end
    c = floor(c)
    local g, sv, cu = floor(c / 10000), floor(c / 100) % 100, c % 100
    if g > 0 then return ("|cffffd700%d|rg |cffc0c0c0%d|rs"):format(g, sv) end
    if sv > 0 then return ("|cffc0c0c0%d|rs |cffeda55f%d|rc"):format(sv, cu) end
    return ("|cffeda55f%d|rc"):format(cu)
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
    print("|cffffd100Trailsmith:|r " .. msg)
end

---------------------------------------------------------------- gravacao

local function NodeKey(n)
    return floor(n.a + 0.5) .. ":" .. floor(n.b + 0.5)
end

local function IsSkipped(n)
    local e = db.skipped and db.skipped[NodeKey(n)]
    return e and e > time()
end

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
local seedWarned = false
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
    if not seedWarned and not _G.GatherMateData2MineDB and not _G.GatherMateData2HerbDB then
        seedWarned = true
        Print(L.NO_DATA)
    end
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
                        local skey = map .. ":" .. ore .. ":" .. floor(x * 10000 + 0.5) .. ":" .. floor(y * 10000 + 0.5)
                        local community = _G.GatherTrailConfirmed
                        list[#list + 1] = {
                            kind = kind, ore = ore, req = ORE_REQ[ore] or 0,
                            a = na, b = nb, inst = inst, map = map, mx = x, my = y, seed = true,
                            key = skey, conf = (community and community[skey]) and true or nil,
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

-- ponto do banco inicial do mesmo veio mais perto de (a, b): usado para confirmar o local exato
local function SnapSeed(ore, kind, a, b, inst, map)
    local list = map and seedCache[map]
    if not list then return nil end
    local best, bd = nil, 35 * 35
    for _, n in ipairs(list) do
        if n.ore == ore and n.inst == inst then
            local da, dw = n.a - a, n.b - b
            local d = da * da + dw * dw
            if d < bd then best, bd = n, d end
        end
    end
    return best
end

local function Record(oreID, kind)
    if not pending then return end
    local snap = SnapSeed(oreID, kind, pending.a, pending.b, pending.inst, pending.map)
    if snap then
        pending.a, pending.b, pending.mx, pending.my = snap.a, snap.b, snap.mx, snap.my
    end
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
        t = now, mined = now, confirmed = snap ~= nil, key = snap and snap.key,
    }
end

---------------------------------------------------------------- pins

-- Redondo com duas MaskTextures: uma recorta o anel (borda), outra o icone, um pouco menor.
-- Se o cliente nao criar mascaras, o pin fica quadrado.
local MASK_TEX = "Interface/CharacterFrame/TempPortraitAlphaMask"

local function MakePin(parent, size, noMask)
    local f = CreateFrame("Frame", nil, parent)
    f.baseSize = size
    f:SetSize(size, size)
    f.border = f:CreateTexture(nil, "BACKGROUND")
    f.border:SetAllPoints()
    f.border:SetColorTexture(1, 1, 1, 1)
    f.icon = f:CreateTexture(nil, "ARTWORK")
    f.icon:SetPoint("TOPLEFT", 2, -2)
    f.icon:SetPoint("BOTTOMRIGHT", -2, 2)
    f.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    if f.CreateMaskTexture and not noMask then
        local ok1, m1 = pcall(f.CreateMaskTexture, f)
        local ok2, m2 = pcall(f.CreateMaskTexture, f)
        if ok1 and m1 and ok2 and m2 then
            m1:SetTexture(MASK_TEX)
            m1:SetAllPoints()
            m2:SetTexture(MASK_TEX)
            m2:SetPoint("TOPLEFT", 2, -2)
            m2:SetPoint("BOTTOMRIGHT", -2, 2)
            f.border:AddMaskTexture(m1)
            f.icon:AddMaskTexture(m2)
            f.mask, f.imask = m1, m2
        end
    end
    f:Hide()
    return f
end

local function StylePin(pin, node, can)
    local c = can and YELLOW or RED
    pin.border:SetColorTexture(c[1], c[2], c[3], 0.8)
    local kind = node.kind or "mine"
    local tex = kind == "mine" and MineIcon(node.ore) or KIND_ICON[kind] or OreIcon(node.ore)
    if pin.curTex ~= tex then
        pin.curTex = tex
        pin.icon:SetTexture(tex)
    end
    pin.icon:SetDesaturated(not can)
    if not pin.noScale then
        local sz = pin.baseSize * (db.pinSize or 100) / 100
        pin:SetSize(sz, sz)
    end
    local f = RARITY[node.ore] or min(1, (node.req or 0) / 300)
    local base = 1 - (db.pinTransp or 0) / 100
    pin:SetAlpha(base + (1 - base) * f)
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
    for i = 1, MAX_PINS do miniPins[i] = MakePin(miniFrame, 20) end
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
arrow.pin.noScale = true
arrow.pin:SetPoint("BOTTOM", arrow, "TOP", 0, 2)
arrow.text = arrow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
arrow.text:SetPoint("TOP", arrow, "BOTTOM", 0, -2)

do
    local ok, b = pcall(CreateFrame, "Button", nil, arrow, "UIPanelButtonTemplate")
    if not ok or not b then
        b = CreateFrame("Button", nil, arrow)
        b.fs = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.fs:SetAllPoints()
        b.SetText = function(self, t) self.fs:SetText(t) end
    end
    b:SetSize(64, 20)
    b:SetPoint("TOP", arrow.text, "BOTTOM", 0, -3)
    b:SetText(L.SKIP_BTN)
    b:SetScript("OnClick", function() if SkipTarget then SkipTarget(IsShiftKeyDown()) end end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(L.SKIP_TIP1, 1, 1, 1)
        GameTooltip:AddLine(L.SKIP_TIP2, 0.8, 0.8, 0.8)
        GameTooltip:AddLine(L.SKIP_TIP3, 0.8, 0.8, 0.8)
        GameTooltip:AddLine(L.SKIP_TIP4, 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    arrow.skip = b

    b:RegisterForDrag("LeftButton")
    b:SetScript("OnDragStart", function()
        if not db.arrowLocked or IsShiftKeyDown() or db.testMode then arrow:StartMoving() end
    end)
    b:SetScript("OnDragStop", function()
        local stop = arrow:GetScript("OnDragStop")
        if stop then stop(arrow) end
    end)
end
arrow:Hide()

arrow:RegisterForDrag("LeftButton")
arrow:SetScript("OnDragStart", function(self)
    if not db.arrowLocked or IsShiftKeyDown() or db.testMode then self:StartMoving() end
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
    arrow:EnableMouse(true)
end

---------------------------------------------------------------- mapa-mundi

local worldFrame, worldPins = nil, {}
local worldDirty, worldAt = true, 0
local worldHidden, worldLast, worldWarn = 0, 0, 0

local function SetupWorldMap()
    if worldFrame or not WorldMapFrame or not WorldMapFrame.GetCanvas then return end
    local canvas = WorldMapFrame:GetCanvas()
    worldFrame = CreateFrame("Frame", nil, canvas)
    worldFrame:SetAllPoints()
    worldFrame:SetFrameStrata("DIALOG")
    worldFrame:SetFrameLevel(canvas:GetFrameLevel() + 500)
    for i = 1, 100 do
        local p = MakePin(worldFrame, 18, true)
        p:EnableMouse(true)
        p:SetScript("OnEnter", function(self)
            local n = self.node
            if not n then return end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            local name = n.kind == "skin" and L.SKIN_PREFIX:format(n.name or L.CREATURE) or (n.ore and GetItemInfo and GetItemInfo(n.ore)) or KINDS[n.kind or "mine"].label
            GameTooltip:AddLine(name, 1, 1, 1)
            if (n.req or 0) > 0 then
                GameTooltip:AddLine(L.REQ_SKILL:format(n.req, skills[n.kind or "mine"].skill),
                    self.can and 0.3 or 1, self.can and 1 or 0.3, 0.3)
            end
            local pr = n.kind ~= "skin" and n.ore and PriceOf(n.ore)
            if pr then GameTooltip:AddLine(L.PRICE_AH .. ": " .. Money(pr), 1, 1, 1) end
            if n.conf or not n.seed then GameTooltip:AddLine(L.CONFIRMED, 0.3, 1, 0.3) end
            if n.mined then
                GameTooltip:AddLine(L.MINED_AGO:format((time() - n.mined) / 60), 0.7, 0.7, 0.7)
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
    if not skills[k].known then return true end -- nivel desconhecido: nao esconde nada
    return (n.req or 0) <= skills[k].skill
end

local function NodeAllowed(n)
    if n.ore and db.hideOre[n.ore] then return false end
    local gap = db.lowGap or 0
    if gap > 0 then
        local sk = skills[n.kind or "mine"]
        if sk and sk.known and (n.req or 0) < sk.skill - gap then return false end
    end
    if db.onlyConfirmed and n.seed and not n.conf then return false end
    return true
end

local function HasReal(n)
    for _, m in ipairs(db.nodes) do
        if m.ore == n.ore and m.inst == n.inst then
            local da, dw = m.a - n.a, m.b - n.b
            if da * da + dw * dw < 25 * 25 then return true end
        end
    end
    return false
end

local function UpdateWorldMap(pa, pb, inst)
    if not (worldFrame and WorldMapFrame:IsShown()) then return end
    for _, p in ipairs(worldPins) do p:Hide() end
    if not db.mapPins or not pa then return end
    worldFrame:Show()
    local mapID = WorldMapFrame:GetMapID()
    local w, h = worldFrame:GetWidth(), worldFrame:GetHeight()
    local now, used, r2 = time(), 0, db.range * db.range
    local function consider(n, seed)
        if n.map == mapID and n.inst == inst and n.mx and KindOn(n.kind or "mine") and not IsSkipped(n) and NodeAllowed(n) then
            local da, dw = n.a - pa, n.b - pb
            if da * da + dw * dw <= r2 then
                local hidden = db.hideMinedSecs > 0 and n.mined and (now - n.mined) < db.hideMinedSecs
                local can = NodeCan(n)
                if not hidden and (can or db.showRed) and used < #worldPins and not (seed and HasReal(n)) then
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
    for _, n in ipairs(db.nodes) do consider(n, false) end
    if db.useSeed and seedCache[mapID] then
        for _, n in ipairs(seedCache[mapID]) do consider(n, true) end
    end
    -- aviso unico se os icones sumirem de uma atualizacao para outra (diagnostico)
    if used == 0 and worldLast > 0 and worldWarn < 3 then
        worldWarn = worldWarn + 1
        Print(("map: icons gone (mapID %s, seeds %s, %dx%d)"):format(tostring(mapID),
            tostring(seedCache[mapID] and #seedCache[mapID]), w, h))
    end
    worldLast = used
end

---------------------------------------------------------------- loop principal

local cache, cacheAt = {}, 0
local lastInst

local function Rebuild(pa, pb, inst)
    wipe(cache)
    local r = db.range * 1.3
    local r2, now = r * r, time()
    for _, n in ipairs(db.nodes) do
        if n.inst == inst and KindOn(n.kind or "mine") and not IsSkipped(n) and NodeAllowed(n) then
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
                if n.inst == inst and KindOn(n.kind) and not IsSkipped(n) and NodeAllowed(n) then
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

SkipTarget = function(permanent)
    local n = currentTarget
    if not n or not db then return end
    db.skipped = db.skipped or {}
    db.skipped[NodeKey(n)] = permanent and 2147483647 or (time() + db.skipSecs)
    cacheAt = 0
    worldDirty = true
    Print(permanent and L.SKIPPED_FOREVER or L.SKIPPED_TEMP)
end

ScanNow = function()
    if not db then return end
    RefreshSkill()
    local pa, pb, inst = PlayerPos()
    if not pa then Print(L.POS_UNAVAILABLE) return end
    Rebuild(pa, pb, inst)
    cacheAt, lastInst = GetTime(), inst
    worldDirty = true
    local cnt = { mine = { 0, 0 }, herb = { 0, 0 }, skin = { 0, 0 } }
    local bestN, bestD
    for _, n in ipairs(cache) do
        local dN, dW = n.a - pa, n.b - pb
        local d = sqrt(dN * dN + dW * dW)
        if d <= db.range then
            local k = n.kind or "mine"
            local can = NodeCan(n)
            cnt[k][1] = cnt[k][1] + 1
            if can then
                cnt[k][2] = cnt[k][2] + 1
                if not bestD or d < bestD then bestN, bestD = n, d end
            end
        end
    end
    local parts = {}
    for _, k in ipairs({ "mine", "herb", "skin" }) do
        if cnt[k][1] > 0 and KindOn(k) then
            parts[#parts + 1] = L.SCAN_PART:format(KINDS[k].label, cnt[k][1], cnt[k][2])
        end
    end
    if #parts == 0 then
        Print(L.SCAN_NONE:format(db.range))
        return
    end
    Print(L.SCAN_RESULT:format(db.range, table.concat(parts, "; ")))
    if bestN then
        local name = bestN.kind ~= "skin" and bestN.ore and GetItemInfo and GetItemInfo(bestN.ore) or KINDS[bestN.kind or "mine"].label
        Print(L.SCAN_NEAREST:format(name, bestD))
    end
end

function GatherTrail_Skip()
    if SkipTarget then SkipTarget(false) end
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
                m = (m:gsub("^mineral d[eao]s? ", ""))
                m = (m:gsub("^mena d[eao]s? ", ""))
                m = (m:gsub(" ore$", ""))
                m = (m:gsub("^ore of ", ""))
            end
            if #m >= 3 then materials[#materials + 1] = { m = m, id = id, kind = kind } end
        end
    end
    table.sort(materials, function(x, y) return #x.m > #y.m end)
    return not missing
end

local hoverSeen = {} -- kind -> GetTime() da ultima vez que a dica do minimapa mostrou um recurso
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
    hoverSeen[hit.kind] = t

    local cx, cy = GetCursorPosition()
    local s = Minimap:GetEffectiveScale()
    local mx, my = Minimap:GetCenter()
    if not (cx and mx) then return end
    local dx, dy = cx / s - mx, cy / s - my
    local d = sqrt(dx * dx + dy * dy) * ypp
    local theta = atan2(-dx, dy) + rot
    local na, nb = pa + d * cos(theta), pb + d * sin(theta)

    local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local snap = SnapSeed(hit.id, hit.kind, na, nb, inst, map)
    if snap then na, nb = snap.a, snap.b end
    for _, n in ipairs(db.nodes) do
        if n.inst == inst and n.ore == hit.id and (n.kind or "mine") == hit.kind then
            local da, dw = n.a - na, n.b - nb
            if da * da + dw * dw < 20 * 20 then return end
        end
    end
    db.nodes[#db.nodes + 1] = {
        ore = hit.id, kind = hit.kind, req = ORE_REQ[hit.id] or 0,
        a = na, b = nb, inst = inst, t = time(), learned = "hover",
        map = snap and snap.map, mx = snap and snap.mx, my = snap and snap.my,
        confirmed = snap ~= nil, key = snap and snap.key,
    }
    cacheAt = 0
end

-- O rastreamento do jogo (Localizar Minerais/Ervas) desenha os veios reais no minimapa.
-- Se nosso icone esta ali e o mouse fica parado em cima dele sem nenhuma dica aparecer,
-- nao ha veio nesse ponto agora: esconde por emptySecs.
local trackAt, trackCache = {}, {}
local function TrackingOn(kind)
    local t = GetTime()
    if hoverSeen[kind] and t - hoverSeen[kind] < 600 then return true end
    if trackAt[kind] and t - trackAt[kind] < 2 then return trackCache[kind] end
    trackAt[kind] = t
    local want = Lower(SpellName(kind == "herb" and 2383 or 2580))
    local on = false
    if want ~= "" then
        if C_Minimap and C_Minimap.GetNumTrackingTypes and C_Minimap.GetTrackingInfo then
            for i = 1, C_Minimap.GetNumTrackingTypes() do
                local info = C_Minimap.GetTrackingInfo(i)
                if info and info.active and info.name and not issecret(info.name) and Lower(info.name) == want then
                    on = true
                    break
                end
            end
        elseif GetNumTrackingTypes and GetTrackingInfo then
            for i = 1, GetNumTrackingTypes() do
                local name, _, active = GetTrackingInfo(i)
                if active and name and not issecret(name) and Lower(name) == want then on = true break end
            end
        end
    end
    trackCache[kind] = on
    return on
end

local dwell = { pin = nil, t = 0, cx = 0, cy = 0 }
local function EmptyCheck(t)
    if not db.autoHide or not Minimap:IsMouseOver() or GameTooltip:IsShown() then
        dwell.pin = nil
        return
    end
    local cx, cy = GetCursorPosition()
    local best, bd
    for i = 1, MAX_PINS do
        local p = miniPins[i]
        if p and p:IsShown() and p.node then
            local px, py = p:GetCenter()
            if px then
                local sc = p:GetEffectiveScale()
                local dx, dy = px * sc - cx, py * sc - cy
                local d = sqrt(dx * dx + dy * dy)
                if d <= p:GetWidth() * sc * 0.3 and (not bd or d < bd) then best, bd = p, d end
            end
        end
    end
    if not best then dwell.pin = nil return end
    if best ~= dwell.pin or math.abs(cx - dwell.cx) + math.abs(cy - dwell.cy) > 4 then
        dwell.pin, dwell.t, dwell.cx, dwell.cy = best, t, cx, cy
        return
    end
    if t - dwell.t >= 0.7 then
        local n = best.node
        if n and TrackingOn(n.kind or "mine") then
            db.skipped = db.skipped or {}
            db.skipped[NodeKey(n)] = time() + (db.emptySecs or 900)
            cacheAt = 0
            worldDirty = true
        end
        dwell.pin = nil
    end
end

local function Tick()
    if not db.enabled and not db.testMode then HideAll() return end
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

    if miniFrame then
        HoverLearn(pa, pb, inst, rot, ypp)
        EmptyCheck(t)
    end

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
    currentTarget = target

    if target and db.arrow and not db.testMode then
        local dN, dW = target.a - pa, target.b - pb
        local theta = atan2(dW, dN)
        arrow.tex:SetRotation(theta - facing)
        local c = tcan and YELLOW or RED
        arrow.tex:SetVertexColor(c[1], c[2], c[3])
        StylePin(arrow.pin, target, tcan)
        arrow.pin:Show()
        local label = KINDS[target.kind or "mine"].label
        if target.kind ~= "skin" and target.ore and GetItemInfo then
            label = GetItemInfo(target.ore) or label
        elseif target.name then
            label = L.SKIN_PREFIX:format(target.name)
        end
        arrow.text:SetText(L.ARROW_TEXT:format(label, td))
        arrow:Show()

        if miniFrame and db.line and td > 6 and (target.conf or not target.seed) then
            local rel = theta - rot
            local px = min(td / ypp, (Minimap:GetWidth() / 2) * 0.95)
            miniLine:SetStartPoint("CENTER", Minimap, 0, 0)
            miniLine:SetEndPoint("CENTER", Minimap, -px * sin(rel), px * cos(rel))
            miniLine:SetColorTexture(c[1], c[2], c[3], 0.85)
            miniLine:Show()
        elseif miniLine then
            miniLine:Hide()
        end
    elseif db.testMode or not db.arrowLocked then
        -- previa para poder posicionar a seta
        arrow.tex:SetRotation(0)
        arrow.tex:SetVertexColor(1, 1, 1)
        arrow.pin:Hide()
        arrow.text:SetText(db.testMode and L.TEST_TEXT or L.DRAG_TEXT)
        arrow:Show()
        if miniLine then miniLine:Hide() end
    else
        arrow:Hide()
        if miniLine then miniLine:Hide() end
    end

    if worldFrame and WorldMapFrame:IsShown() and not worldFrame:IsShown() then
        worldFrame:Show()
        worldDirty = true
        worldHidden = worldHidden + 1
    end
    if worldDirty or (worldFrame and WorldMapFrame:IsShown() and t - (worldAt or 0) > 0.5) then
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
            Print(L.ERR_TICK:format(tostring(err)))
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

local function ItemName(id)
    local n = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(id)
    if not n and GetItemInfo then n = GetItemInfo(id) end
    if not n and C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(id) end
    if issecret(n) then return nil end
    return n
end

local function BuildOptions()
    if options then return options end
    local f = TryCreate("Frame", "GatherTrailOptions", UIParent, { "BasicFrameTemplateWithInset", "DialogBoxFrame" })
    f:SetSize(db.optW or 440, db.optH or 590)
    f:SetResizable(true)
    if f.SetResizeBounds then f:SetResizeBounds(400, 420, 900, 900)
    elseif f.SetMinResize then f:SetMinResize(400, 420) end
    f:SetPoint("LEFT", UIParent, "LEFT", 60, 0)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG")
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -8)
    title:SetText(L.OPT_TITLE)
    f:Hide()
    tinsert(UISpecialFrames, "GatherTrailOptions")

    local refreshers, nameUpdaters = {}, {}
    local fixw = {} -- { fontstring, margem }: largura = largura da janela - margem
    local function ForceUpdate() cacheAt = 0 worldDirty = true end

    local function NewPage()
        local p = CreateFrame("Frame", nil, f)
        p:SetPoint("TOPLEFT", 14, -66)
        p:SetPoint("BOTTOMRIGHT", -14, 14)
        p:Hide()
        p.y = 0
        return p
    end

    local function Check(page, label, key, after)
        local cb = TryCreate("CheckButton", nil, page, { "UICheckButtonTemplate", "ChatConfigCheckButtonTemplate" })
        cb:SetSize(24, 24)
        cb:SetPoint("TOPLEFT", 0, page.y)
        local fs = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fs:SetPoint("LEFT", cb, "RIGHT", 4, 0)
        fs:SetWidth(360)
        fixw[#fixw + 1] = { fs, 60 }
        fs:SetJustifyH("LEFT")
        fs:SetWordWrap(false)
        fs:SetText(label)
        cb:SetScript("OnClick", function(self)
            db[key] = self:GetChecked() and true or false
            if after then after() end
        end)
        refreshers[#refreshers + 1] = function() cb:SetChecked(db[key]) end
        page.y = page.y - 26
    end

    local sliderN = 0
    local function Slider(page, label, key, minV, maxV, step, unit, after, fmt)
        sliderN = sliderN + 1
        local name = "GatherTrailSlider" .. sliderN
        local y = page.y
        local cap = page:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        cap:SetPoint("TOPLEFT", 4, y)
        cap:SetWidth(300)
        fixw[#fixw + 1] = { cap, 142 }
        cap:SetJustifyH("LEFT")
        cap:SetWordWrap(false)
        cap:SetText(label)
        local val = page:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        val:SetPoint("TOPRIGHT", -4, y - 1)
        local s = TryCreate("Slider", name, page, { "OptionsSliderTemplate", "MinimalSliderTemplate" })
        for _, suf in ipairs({ "Low", "High", "Text" }) do
            local extra = _G[name .. suf]
            if extra then extra:SetText("") extra:Hide() end
        end
        s:SetOrientation("HORIZONTAL")
        s:SetPoint("TOPLEFT", 6, y - 20)
        s:SetPoint("TOPRIGHT", -6, y - 20)
        s:SetHeight(16)
        s:SetMinMaxValues(minV, maxV)
        s:SetValueStep(step)
        if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
        local function show(v) val:SetText(fmt and fmt(v) or (v .. unit)) end
        s:SetScript("OnValueChanged", function(self, v)
            v = floor(v / step + 0.5) * step
            show(v)
            if self.syncing then return end
            db[key] = v
            if after then after() end
        end)
        refreshers[#refreshers + 1] = function()
            s.syncing = true
            s:SetValue(db[key] or 0)
            s.syncing = false
            show(db[key] or 0)
        end
        page.y = y - 44
    end

    local function Button(parent, text, w)
        local b = TryCreate("Button", nil, parent, { "UIPanelButtonTemplate" })
        b:SetSize(w, 24)
        b:SetText(text)
        return b
    end

    local pages = { general = NewPage(), display = NewPage(), nodes = NewPage() }

    ---------------------------------------------------------- Geral
    local g = pages.general
    Check(g, L.OPT_ENABLED, "enabled")
    Check(g, L.OPT_AUTOLOOT, "autoLoot")
    Check(g, L.OPT_AUTOLOOTQ, "autoLootQuest")
    Check(g, L.OPT_MINE, "trackMine", ForceUpdate)
    Check(g, L.OPT_HERB, "trackHerb", ForceUpdate)
    Check(g, L.OPT_SEED, "useSeed", ForceUpdate)
    Check(g, L.OPT_HOVER, "hoverLearn")
    Check(g, L.OPT_AUTOHIDE, "autoHide")
    Check(g, L.OPT_TEST, "testMode")
    g.y = g.y - 8
    Slider(g, L.OPT_RANGE, "range", 50, 2000, 50, L.UNIT_YD, ForceUpdate)
    Slider(g, L.OPT_HIDE, "hideMinedSecs", 0, 900, 30, L.UNIT_S, ForceUpdate)
    Slider(g, L.OPT_EMPTYSECS, "emptySecs", 60, 1800, 60, "", ForceUpdate, function(v) return floor(v / 60) .. " min" end)

    local info = g:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    info:SetPoint("BOTTOMLEFT", 4, 70)
    info:SetWidth(390)
    fixw[#fixw + 1] = { info, 36 }
    info:SetJustifyH("LEFT")
    f.info = info

    local unskip = Button(g, L.BTN_UNSKIP, 190)
    unskip:SetPoint("BOTTOMLEFT", 4, 34)
    unskip:SetScript("OnClick", function()
        db.skipped = {}
        ForceUpdate()
        Print(L.MSG_UNSKIPPED)
    end)
    local clear = Button(g, L.BTN_CLEAR, 190)
    clear:SetPoint("BOTTOMLEFT", 4, 4)
    clear:SetScript("OnClick", function()
        wipe(db.nodes)
        ForceUpdate()
        f:Refresh()
        Print(L.MSG_CLEARED)
    end)

    ---------------------------------------------------------- Exibicao
    local d = pages.display
    Check(d, L.OPT_ARROW, "arrow")
    Check(d, L.OPT_LOCK, "arrowLocked", function() ApplyArrowPos() end)
    Check(d, L.OPT_MMBTN, "minimapButton", function() if UpdateMMButton then UpdateMMButton() end end)
    Check(d, L.OPT_MMPINS, "minimapPins")
    Check(d, L.OPT_MAPPINS, "mapPins", ForceUpdate)
    Check(d, L.OPT_LINE, "line")
    Check(d, L.OPT_RED, "showRed", ForceUpdate)
    Check(d, L.OPT_ARROWRED, "arrowToRed")
    Check(d, L.OPT_CONFONLY, "onlyConfirmed", ForceUpdate)
    d.y = d.y - 8
    Slider(d, L.OPT_PINSIZE, "pinSize", 50, 200, 10, "%", ForceUpdate)
    Slider(d, L.OPT_TRANSP, "pinTransp", 0, 80, 5, "%", ForceUpdate)
    Slider(d, L.OPT_SCALE, "arrowScale", 50, 200, 10, "%", ApplyArrowPos)

    ---------------------------------------------------------- Recursos
    local n = pages.nodes
    Slider(n, L.OPT_LOWGAP, "lowGap", 0, 300, 25, "", ForceUpdate, function(v) return v == 0 and L.OFF or ("-" .. v) end)

    local hint = n:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hint:SetPoint("TOPLEFT", 4, n.y)
    hint:SetWidth(396)
    fixw[#fixw + 1] = { hint, 36 }
    hint:SetJustifyH("LEFT")
    hint:SetWordWrap(false)
    f.hint = hint
    n.y = n.y - 20

    local allBtn = Button(n, L.BTN_ALL, 130)
    allBtn:SetPoint("TOPLEFT", 4, n.y)
    local noneBtn = Button(n, L.BTN_NONE, 130)
    noneBtn:SetPoint("LEFT", allBtn, "RIGHT", 6, 0)
    n.y = n.y - 28
    local sortBtn = Button(n, "", 130)
    sortBtn:SetPoint("TOPLEFT", 4, n.y)
    local bestBtn = Button(n, L.BTN_BEST, 130)
    bestBtn:SetPoint("LEFT", sortBtn, "RIGHT", 6, 0)
    n.y = n.y - 30

    local sf = TryCreate("ScrollFrame", "GatherTrailNodesScroll", n, { "UIPanelScrollFrameTemplate" })
    sf:SetPoint("TOPLEFT", 0, n.y)
    sf:SetPoint("BOTTOMRIGHT", -26, 0)
    local content = CreateFrame("Frame", nil, sf)
    content:SetSize(380, 10)
    sf:SetScrollChild(content)
    sf:EnableMouseWheel(true)
    sf:SetScript("OnMouseWheel", function(self, delta)
        local cur, max = self:GetVerticalScroll(), self:GetVerticalScrollRange()
        self:SetVerticalScroll(math.max(0, math.min(max, cur - delta * 48)))
    end)

    local ids = {}
    for id in pairs(ORE_REQ) do ids[#ids + 1] = id end

    local rows, headers = {}, {}
    for _, kind in ipairs({ "mine", "herb" }) do
        local h = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        h:SetText(KINDS[kind].label)
        local cs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        cs:SetWidth(40)
        cs:SetJustifyH("RIGHT")
        cs:SetText(L.COL_SKILL)
        local cp = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        cp:SetPoint("TOPRIGHT", content, "TOPRIGHT", -6, 0)
        cp:SetText(L.COL_PRICE)
        headers[kind] = { h = h, cs = cs, cp = cp }
    end

    for _, id in ipairs(ids) do
        local kind = HERB_REQ[id] and "herb" or "mine"
        local cb = TryCreate("CheckButton", nil, content, { "UICheckButtonTemplate", "ChatConfigCheckButtonTemplate" })
        cb:SetSize(22, 22)
        local icon = content:CreateTexture(nil, "ARTWORK")
        icon:SetSize(18, 18)
        icon:SetPoint("LEFT", cb, "RIGHT", 2, 0)
        icon:SetTexture(kind == "mine" and MineIcon(id) or OreIcon(id))
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        local nm = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        nm:SetPoint("LEFT", icon, "RIGHT", 6, 0)
        nm:SetWidth(160)
        nm:SetJustifyH("LEFT")
        nm:SetWordWrap(false)
        local rq = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        rq:SetText(tostring(ORE_REQ[id]))
        rq:SetWidth(40)
        rq:SetJustifyH("RIGHT")
        local pr = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        pr:SetWidth(110)
        pr:SetJustifyH("RIGHT")
        cb:SetScript("OnClick", function(self)
            db.hideOre[id] = (not self:GetChecked()) or nil
            ForceUpdate()
        end)
        refreshers[#refreshers + 1] = function() cb:SetChecked(not db.hideOre[id]) end
        nameUpdaters[#nameUpdaters + 1] = function() nm:SetText(ItemName(id) or ("#" .. id)) end
        rows[#rows + 1] = { id = id, kind = kind, cb = cb, nm = nm, rq = rq, pr = pr }
    end

    local function Layout()
        local ry = 0
        for _, kind in ipairs({ "mine", "herb" }) do
            local list = {}
            for _, r in ipairs(rows) do if r.kind == kind then list[#list + 1] = r end end
            table.sort(list, function(a, b)
                if db.sortByPrice then
                    local pa, pb = a.price or -1, b.price or -1
                    if pa ~= pb then return pa > pb end
                end
                if ORE_REQ[a.id] ~= ORE_REQ[b.id] then return ORE_REQ[a.id] < ORE_REQ[b.id] end
                return a.id < b.id
            end)
            local hd = headers[kind]
            hd.h:ClearAllPoints()
            hd.h:SetPoint("TOPLEFT", content, "TOPLEFT", 4, ry - 2)
            hd.cp:ClearAllPoints()
            hd.cp:SetPoint("TOPRIGHT", content, "TOPRIGHT", -6, ry - 4)
            hd.cs:ClearAllPoints()
            hd.cs:SetPoint("TOPRIGHT", content, "TOPRIGHT", -124, ry - 4)
            ry = ry - 22
            for _, r in ipairs(list) do
                r.cb:ClearAllPoints()
                r.cb:SetPoint("TOPLEFT", content, "TOPLEFT", 0, ry)
                r.rq:ClearAllPoints()
                r.rq:SetPoint("TOPRIGHT", content, "TOPRIGHT", -124, ry - 6)
                r.pr:ClearAllPoints()
                r.pr:SetPoint("TOPRIGHT", content, "TOPRIGHT", -6, ry - 6)
                ry = ry - 24
            end
        end
        content:SetHeight(-ry + 10)
    end

    function f.UpdatePrices()
        local have = _G.Auctionator and _G.Auctionator.API and true or false
        hint:SetText(have and L.NODES_HINT or L.NO_AUCTIONATOR)
        for _, r in ipairs(rows) do
            r.price = PriceOf(r.id)
            r.pr:SetText(Money(r.price) or "-")
            local sk = skills[r.kind]
            if not sk.has then
                r.rq:SetTextColor(0.6, 0.6, 0.6)
            elseif not sk.known or ORE_REQ[r.id] <= sk.skill then
                r.rq:SetTextColor(0.4, 1, 0.4)
            else
                r.rq:SetTextColor(1, 0.3, 0.3)
            end
        end
        sortBtn:SetText(db.sortByPrice and L.SORT_PRICE or L.SORT_SKILL)
        Layout()
    end

    allBtn:SetScript("OnClick", function() wipe(db.hideOre) ForceUpdate() f:Refresh() end)
    noneBtn:SetScript("OnClick", function()
        for _, id in ipairs(ids) do db.hideOre[id] = true end
        ForceUpdate()
        f:Refresh()
    end)
    sortBtn:SetScript("OnClick", function()
        db.sortByPrice = not db.sortByPrice
        f.UpdatePrices()
    end)
    -- mantem so os 5 recursos mais caros (por profissao) que a skill atual alcanca
    bestBtn:SetScript("OnClick", function()
        for _, kind in ipairs({ "mine", "herb" }) do
            local sk = skills[kind]
            local cand = {}
            for _, r in ipairs(rows) do
                if r.kind == kind and r.price and (not sk.known or ORE_REQ[r.id] <= sk.skill) then
                    cand[#cand + 1] = r
                end
            end
            if #cand > 0 then
                table.sort(cand, function(a, b) return a.price > b.price end)
                local keep = {}
                for i = 1, math.min(5, #cand) do keep[cand[i].id] = true end
                for _, r in ipairs(rows) do
                    if r.kind == kind then db.hideOre[r.id] = (not keep[r.id]) or nil end
                end
            end
        end
        ForceUpdate()
        f:Refresh()
    end)

    ---------------------------------------------------------- redimensionar
    local function Resize()
        local w = f:GetWidth()
        for _, e in ipairs(fixw) do e[1]:SetWidth(math.max(60, w - e[2])) end
        local cw = w - 28 - 26
        content:SetWidth(cw)
        for _, r in ipairs(rows) do r.nm:SetWidth(math.max(80, cw - 50 - 175)) end
    end
    f:SetScript("OnSizeChanged", Resize)

    local grip = CreateFrame("Button", nil, f)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", -4, 4)
    grip:SetFrameLevel(f:GetFrameLevel() + 20)
    grip:SetNormalTexture("Interface/ChatFrame/UI-ChatIM-SizeGrabber-Up")
    grip:SetPushedTexture("Interface/ChatFrame/UI-ChatIM-SizeGrabber-Down")
    grip:SetHighlightTexture("Interface/ChatFrame/UI-ChatIM-SizeGrabber-Highlight")
    grip:SetScript("OnMouseDown", function() f:StartSizing("BOTTOMRIGHT") end)
    grip:SetScript("OnMouseUp", function()
        f:StopMovingOrSizing()
        db.optW, db.optH = floor(f:GetWidth()), floor(f:GetHeight())
    end)

    ---------------------------------------------------------- abas
    local tabBtns = {}
    local order = { { "general", L.TAB_GENERAL }, { "display", L.TAB_DISPLAY }, { "nodes", L.TAB_NODES } }
    local function ShowTab(id)
        for key, page in pairs(pages) do
            if key == id then page:Show() else page:Hide() end
        end
        for key, b in pairs(tabBtns) do
            if key == id then b:Disable() else b:Enable() end
        end
        db.lastTab = id
    end
    for i, def in ipairs(order) do
        local b = Button(f, def[2], 130)
        b:SetPoint("TOPLEFT", 16 + (i - 1) * 134, -34)
        b:SetScript("OnClick", function() ShowTab(def[1]) end)
        tabBtns[def[1]] = b
    end

    function f.RefreshNames()
        for _, u in ipairs(nameUpdaters) do u() end
    end

    function f:Refresh()
        for _, r in ipairs(refreshers) do r() end
        local function sk(k)
            return skills[k].known and L.HAS_SKILL:format(skills[k].skill) or (skills[k].has and "?" or L.NO_SKILL)
        end
        info:SetText(L.INFO:format(#db.nodes, sk("mine"), sk("herb"), sk("skin")))
        f.RefreshNames()
        f.UpdatePrices()
        ShowTab(pages[db.lastTab or ""] and db.lastTab or "general")
    end
    f:SetScript("OnShow", f.Refresh)
    Resize()
    options = f
    return f
end

local function ToggleOptions()
    local f = BuildOptions()
    if f:IsShown() then f:Hide() else f:Show() end
end

---------------------------------------------------------------- botao do minimapa

local mmButton

local function PlaceMMButton()
    if not mmButton then return end
    local ang = math.rad(db.minimapAngle or 225)
    local r = Minimap:GetWidth() / 2 + 5
    local x, y = cos(ang) * r, sin(ang) * r
    if GetMinimapShape and GetMinimapShape() == "SQUARE" then
        local h = Minimap:GetWidth() / 2 + 5
        x = math.max(-h, math.min(h, x * 1.4142))
        y = math.max(-h, math.min(h, y * 1.4142))
    end
    mmButton:ClearAllPoints()
    mmButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

UpdateMMButton = function()
    if not (db and Minimap) then return end
    if not mmButton then
        local b = CreateFrame("Button", "GatherTrailMinimapButton", Minimap)
        b:SetSize(31, 31)
        b:SetFrameStrata("MEDIUM")
        b:SetFrameLevel(Minimap:GetFrameLevel() + 8)
        b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        b:RegisterForDrag("LeftButton")
        local bg = b:CreateTexture(nil, "BACKGROUND")
        bg:SetSize(20, 20)
        bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
        bg:SetPoint("TOPLEFT", 7, -5)
        local icon = b:CreateTexture(nil, "ARTWORK")
        icon:SetSize(17, 17)
        icon:SetTexture("Interface\\Icons\\INV_Pick_02")
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        icon:SetPoint("TOPLEFT", 7, -6)
        b.icon = icon
        local border = b:CreateTexture(nil, "OVERLAY")
        border:SetSize(53, 53)
        border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        border:SetPoint("TOPLEFT")
        b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

        b:SetScript("OnClick", function(_, button)
            if button == "RightButton" then
                db.enabled = not db.enabled
                UpdateMMButton()
                Print(db.enabled and L.MSG_ENABLED or L.MSG_DISABLED_MM)
            else
                ToggleOptions()
            end
        end)
        b:SetScript("OnDragStart", function(self)
            self:SetScript("OnUpdate", function()
                local mx, my = Minimap:GetCenter()
                local cx, cy = GetCursorPosition()
                local sc = Minimap:GetEffectiveScale()
                db.minimapAngle = math.deg(atan2(cy / sc - my, cx / sc - mx))
                PlaceMMButton()
            end)
        end)
        b:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
        b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:AddLine("Trailsmith", 1, 0.82, 0)
            GameTooltip:AddLine(L.MM_LEFT, 1, 1, 1)
            GameTooltip:AddLine(L.MM_RIGHT, 1, 1, 1)
            GameTooltip:AddLine(L.MM_DRAG, 0.7, 0.7, 0.7)
            GameTooltip:AddLine(db.enabled and L.MM_ON or L.MM_OFF,
                db.enabled and 0.3 or 1, db.enabled and 1 or 0.3, 0.3)
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
        mmButton = b
    end
    mmButton.icon:SetDesaturated(not db.enabled)
    PlaceMMButton()
    if db.minimapButton then mmButton:Show() else mmButton:Hide() end
end

SLASH_GATHERTRAIL1 = "/gt"
SLASH_GATHERTRAIL2 = "/gathertrail"
SlashCmdList.GATHERTRAIL = function(msg)
    msg = (msg or ""):lower()
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    if cmd == "range" and tonumber(arg) then
        db.range = math.max(50, math.min(2000, tonumber(arg)))
        cacheAt = 0 worldDirty = true
        Print(L.MSG_RANGE:format(db.range))
    elseif cmd == "lock" then
        db.arrowLocked = not db.arrowLocked
        ApplyArrowPos()
        Print(db.arrowLocked and L.MSG_LOCKED or L.MSG_UNLOCKED)
    elseif cmd == "test" then
        db.testMode = not db.testMode
        Print(db.testMode and L.MSG_TEST_ON or L.MSG_TEST_OFF)
        if options and options:IsShown() then options:Refresh() end
    elseif cmd == "scan" then
        ScanNow()
    elseif cmd == "skip" then
        SkipTarget(arg == "always")
    elseif cmd == "unskip" then
        db.skipped = {}
        cacheAt = 0 worldDirty = true
        Print(L.MSG_UNSKIPPED)
    elseif cmd == "toggle" then
        db.enabled = not db.enabled
        UpdateMMButton()
        Print(db.enabled and L.MSG_ENABLED or L.MSG_DISABLED)
    elseif cmd == "clear" then
        wipe(db.nodes)
        Print(L.MSG_CLEARED)
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
    elseif cmd == "map" then
        local shown = 0
        for _, p in ipairs(worldPins) do if p:IsShown() then shown = shown + 1 end end
        local mid = WorldMapFrame and WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
        Print(("map: frame=%s visible=%s size=%dx%d mapID=%s seeds=%s pins=%d strata=%s reshown=%d"):format(
            tostring(worldFrame ~= nil), tostring(worldFrame and worldFrame:IsVisible()),
            worldFrame and worldFrame:GetWidth() or 0, worldFrame and worldFrame:GetHeight() or 0,
            tostring(mid), tostring(mid and seedCache[mid] and #seedCache[mid]), shown,
            tostring(worldFrame and worldFrame:GetFrameStrata()), worldHidden))
    elseif cmd == "debug" then
        local ns_ = 0
        for _, l in pairs(seedCache) do ns_ = ns_ + #l end
        Print(("banco inicial: %d pontos carregados, calibrado=%s"):format(ns_, tostring(coordSwap)))
        Print(("skill API: GetNumSkillLines=%s GetProfessions=%s | mine known=%s (%d) herb known=%s (%d) | autoLoot=%s"):format(tostring(GetNumSkillLines ~= nil), tostring(GetProfessions ~= nil), tostring(skills.mine.known), skills.mine.skill, tostring(skills.herb.known), skills.herb.skill, tostring(db.autoLoot)))
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

-- Autoloot inteligente: dinheiro e itens de missao. O resto fica na janela.
local function WantSlot(i)
    local stype = GetLootSlotType and GetLootSlotType(i)
    if stype == (LOOT_SLOT_MONEY or 2) then return true end
    local link = GetLootSlotLink and GetLootSlotLink(i)
    if not stype and not link then return true end -- sem link: dinheiro em clientes sem GetLootSlotType
    if GetLootSlotInfo then
        local info = { GetLootSlotInfo(i) }
        -- classic: (icone, nome, qtd, qualidade, travado, missao...)
        -- novo:    (icone, nome, qtd, moeda, qualidade, travado, missao...)
        local isQuest, locked
        if type(info[5]) == "boolean" then locked, isQuest = info[5], info[6] else locked, isQuest = info[6], info[7] end
        if locked then return false end
        if isQuest then return true end
    end
    if link and not issecret(link) and GetItemInfoInstant then
        local _, _, _, _, _, cls = GetItemInfoInstant(link)
        if cls == 12 then return true end
    end
    return false
end

local lootGUID, lootPos, skinCastAt

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("UNIT_SPELLCAST_SENT")
ev:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
ev:RegisterEvent("LOOT_OPENED")
ev:RegisterEvent("LOOT_CLOSED")
ev:RegisterEvent("CHAT_MSG_SKILL")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
local function Handle(_, event, ...)
    if event == "ADDON_LOADED" then
        if (...) ~= ADDON then return end
        GatherTrailDB = GatherTrailDB or ForagerOreDB or {}
        db = GatherTrailDB
        for k, v in pairs(DEFAULTS) do
            if db[k] == nil then db[k] = v end
        end
        db.nodes = db.nodes or {}
        db.skipped = db.skipped or {}
        db.testMode = false
        db.trackSkin = false -- rastreio de cadaveres removido (nao era confiavel)
    elseif event == "PLAYER_LOGIN" then
        BuildCastNames()
        RefreshSkill()
        ApplyArrowPos()
        UpdateMMButton()
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
        if kind == "skin" then skinCastAt = GetTime() end
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
        local now = GetTime()
        local fromCreature = guid and guid:find("^Creature")
        local fromObject = guid and guid:find("^GameObject")
        local recent = pending and now - pending.t <= 20
        -- tem item de coleta na janela? (funciona mesmo se o cast nao foi detectado)
        local gid, gicon, gkind
        if not fromCreature then
            for i = 1, (GetNumLootItems() or 0) do
                local link = GetLootSlotLink and GetLootSlotLink(i)
                if link and not issecret(link) then
                    local id, _, _, _, icon, cls, sub = GetItemInfoInstant(link)
                    if id and (ORE_REQ[id] or (cls == 7 and (sub == 7 or sub == 9))) then
                        gid, gicon = id, icon
                        gkind = (HERB_REQ[id] or sub == 9) and "herb" or "mine"
                        break
                    end
                end
            end
        end
        local isGather = not fromCreature and ((gid and (fromObject or recent)) or recent)
        local isSkin = skinCastAt and now - skinCastAt <= 15 and (fromCreature or not guid)
        if isGather and gid then
            if not recent then
                local a, b, inst = PlayerPos()
                if a then
                    local map, mx, my = MapPos()
                    pending = { t = now, kind = gkind, a = a, b = b, inst = inst, map = map, mx = mx, my = my }
                end
            end
            if pending then
                if gicon then iconCache[gid] = gicon end
                Record(gid, gkind)
                cacheAt = 0
                worldDirty = true
            end
        end
        pending = nil
        if db.autoLootQuest and not (isGather or isSkin) then
            C_Timer.After(0, function()
                for i = (GetNumLootItems() or 0), 1, -1 do
                    local ok, want = pcall(WantSlot, i)
                    if ok and want then pcall(LootSlot, i) end
                end
            end)
        end
        if (isGather or isSkin) and db.autoLoot then
            skinCastAt = nil
            -- depois do registro acima, que le os itens
            C_Timer.After(0, function()
                for i = (GetNumLootItems() or 0), 1, -1 do pcall(LootSlot, i) end
            end)
        end
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
    elseif event == "CHAT_MSG_SKILL" then
        local text = ...
        if db and skillPat and type(text) == "string" and not issecret(text) then
            local name, rank = text:match(skillPat)
            if name and rank then SetSkill(name, tonumber(rank)) cacheAt = 0 worldDirty = true end
        end
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        if options and options.RefreshNames and options:IsShown() then options.RefreshNames() end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if db then RefreshSkill() cacheAt = 0 end
    end
end

local reported
ev:SetScript("OnEvent", function(self, event, ...)
    local ok, err = pcall(Handle, self, event, ...)
    if not ok and not reported then
        reported = true
        Print(L.ERR_EVENT:format(tostring(event), tostring(err)))
    end
end)
