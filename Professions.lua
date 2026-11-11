-- Trailsmith Professions: leveling planner for crafting professions.
-- Data (RecipeData.lua) is generated from public sources, see tools/build_recipes.js.
local ADDON, ns = ...
local floor, max, min, ceil = math.floor, math.max, math.min, math.ceil
local pairs, ipairs, type, tonumber, tostring = pairs, ipairs, type, tonumber, tostring

---------------------------------------------------------------- idioma
local LOC = {}
LOC.en = {
    TITLE = "Trailsmith Professions", PLAN = "Plan", MATS = "Materials", RECIPES = "Recipes", SETTINGS = "Settings",
    FROM = "From", TO = "To", MYSKILL = "My skill", MAXSKILL = "Max",
    MODE_CHEAP = "Cheapest", MODE_PROFIT = "Best profit", MODE_FAST = "Fewest crafts",
    CARD_POINTS = "Points", CARD_CRAFTS = "Crafts", CARD_COST = "Cost", CARD_TIME = "Time", CARD_NET = "Net if sold",
    SEARCH_TOP = "Search recipes, items, materials...", OPT_FONT_TEXT = "Text size", OPT_FONT_NUM = "Numbers size", RESULT_NONE = "Nothing found",
    SRC_T = "Trainer", SRC_V = "Vendor recipe", SRC_I = "Recipe item", SRC_A = "Starting recipe", SRC_U = "Other source", KNOWN = "Known",
    NEED = "Need", HAVE = "Have", MISSING = "Missing", UNIT = "Unit", TOTAL = "Total", NOPRICE = "no price",
    NOREC = "No recipe for skill %d-%d. Allow more sources in Settings or level by gathering.",
    LEARN = "Learn", MATSHDR = "Shopping list (raw materials)", SEARCH = "Search",
    PRICES = "Prices: %s", PRICES_NONE = "Prices: vendor only",
    NOPROF = "You do not have this profession yet. Showing a plan from skill 1.",
    OPT_GATHER = "I gather raw materials myself (count them as free)",
    OPT_KNOWN = "Use only recipes I already know",
    OPT_SRC_T = "Allow trainer recipes", OPT_SRC_V = "Allow recipes sold by vendors", OPT_SRC_I = "Allow recipe items (drops, quests, rare)", OPT_SRC_U = "Allow recipes of other or unknown source",
    OPT_PROVIDER = "Price source", OPT_SKIN = "Skin", OPT_SCALE = "Window scale", OPT_ALPHA = "Window opacity", OPT_AUTO = "Automatic",
    OPT_AHCUT = "Subtract the 5% auction house cut when selling", OPT_VENDOR = "Vendor only",
    UNIT_MIN = "min", CRAFT_X = "%d crafts", ORANGE = "orange", YELLOW = "yellow", GREEN = "green", GREY = "grey",
    LEGEND = "Difficulty: orange / yellow / green / grey",
    CLOSE = "Close", TIP_ROW = "Click a profession on the left, set the skill range and read the plan.",
    PROFS = { alchemy = "Alchemy", blacksmithing = "Blacksmithing", cooking = "Cooking", enchanting = "Enchanting", engineering = "Engineering", firstaid = "First Aid", leatherworking = "Leatherworking", mining = "Mining", tailoring = "Tailoring" },
    SKINS = { dark = "Dark", classic = "Classic", slate = "Slate", forest = "Forest" },
    NOTE_ESTIMATE = "Skill-up odds are estimates (orange 100%, yellow 75%, green 25%). Recipe requirements come from public data; a few are estimated.",
}
LOC.es = {
    TITLE = "Trailsmith Profesiones", PLAN = "Plan", MATS = "Materiales", RECIPES = "Recetas", SETTINGS = "Ajustes",
    FROM = "Desde", TO = "Hasta", MYSKILL = "Mi nivel", MAXSKILL = "Máx.",
    MODE_CHEAP = "Más barato", MODE_PROFIT = "Mayor beneficio", MODE_FAST = "Menos creaciones",
    CARD_POINTS = "Puntos", CARD_CRAFTS = "Creaciones", CARD_COST = "Coste", CARD_TIME = "Tiempo", CARD_NET = "Neto",
    SEARCH_TOP = "Buscar recetas, objetos, materiales...", OPT_FONT_TEXT = "Tamaño del texto", OPT_FONT_NUM = "Tamaño de los números", RESULT_NONE = "No se encontró nada",
    SRC_T = "Instructor", SRC_V = "Receta de vendedor", SRC_I = "Objeto de receta", SRC_A = "Receta inicial", SRC_U = "Otra fuente", KNOWN = "Conocida",
    NEED = "Necesitas", HAVE = "Tienes", MISSING = "Faltan", UNIT = "Unidad", TOTAL = "Total", NOPRICE = "sin precio",
    NOREC = "Sin receta para el nivel %d-%d. Permite más fuentes en Ajustes o sube recolectando.",
    LEARN = "Aprender", MATSHDR = "Lista de compra (materiales base)", SEARCH = "Buscar",
    PRICES = "Precios: %s", PRICES_NONE = "Precios: solo vendedor",
    NOPROF = "Aún no tienes esta profesión. Se muestra un plan desde el nivel 1.",
    OPT_GATHER = "Recolecto los materiales base yo mismo (cuentan como gratis)",
    OPT_KNOWN = "Usar solo recetas que ya conozco",
    OPT_SRC_T = "Permitir recetas de instructor", OPT_SRC_V = "Permitir recetas vendidas por vendedores", OPT_SRC_I = "Permitir objetos de receta (botín, misiones, raros)", OPT_SRC_U = "Permitir recetas de otra fuente o desconocida",
    OPT_PROVIDER = "Fuente de precios", OPT_SKIN = "Aspecto", OPT_SCALE = "Escala de la ventana", OPT_ALPHA = "Opacidad de la ventana", OPT_AUTO = "Automático",
    OPT_AHCUT = "Restar el 5% de comisión de la casa de subastas al vender", OPT_VENDOR = "Solo vendedor",
    UNIT_MIN = "min", CRAFT_X = "%d creaciones", ORANGE = "naranja", YELLOW = "amarillo", GREEN = "verde", GREY = "gris",
    LEGEND = "Dificultad: naranja / amarillo / verde / gris",
    CLOSE = "Cerrar", TIP_ROW = "Elige una profesión a la izquierda, define el rango de nivel y lee el plan.",
    PROFS = { alchemy = "Alquimia", blacksmithing = "Herrería", cooking = "Cocina", enchanting = "Encantamiento", engineering = "Ingeniería", firstaid = "Primeros auxilios", leatherworking = "Peletería", mining = "Minería", tailoring = "Sastrería" },
    SKINS = { dark = "Oscuro", classic = "Clásico", slate = "Pizarra", forest = "Bosque" },
    NOTE_ESTIMATE = "Las probabilidades de subida son estimadas (naranja 100%, amarillo 75%, verde 25%). Los requisitos vienen de datos públicos; algunos son estimados.",
}
LOC.pt = {
    TITLE = "Trailsmith Profissões", PLAN = "Plano", MATS = "Materiais", RECIPES = "Receitas", SETTINGS = "Opções",
    FROM = "De", TO = "Até", MYSKILL = "Minha perícia", MAXSKILL = "Máx.",
    MODE_CHEAP = "Mais barato", MODE_PROFIT = "Maior lucro", MODE_FAST = "Menos criações",
    CARD_POINTS = "Pontos", CARD_CRAFTS = "Criações", CARD_COST = "Custo", CARD_TIME = "Tempo", CARD_NET = "Líquido",
    SEARCH_TOP = "Buscar receitas, itens, materiais...", OPT_FONT_TEXT = "Tamanho do texto", OPT_FONT_NUM = "Tamanho dos números", RESULT_NONE = "Nada encontrado",
    SRC_T = "Treinador", SRC_V = "Receita de vendedor", SRC_I = "Item de receita", SRC_A = "Receita inicial", SRC_U = "Outra fonte", KNOWN = "Conhecida",
    NEED = "Precisa", HAVE = "Tem", MISSING = "Falta", UNIT = "Unid.", TOTAL = "Total", NOPRICE = "sem preço",
    NOREC = "Sem receita para a perícia %d-%d. Permita mais fontes nas Opções ou suba coletando.",
    LEARN = "Aprender", MATSHDR = "Lista de compras (materiais básicos)", SEARCH = "Buscar",
    PRICES = "Preços: %s", PRICES_NONE = "Preços: só vendedor",
    NOPROF = "Você ainda não tem esta profissão. Mostrando um plano a partir da perícia 1.",
    OPT_GATHER = "Eu mesmo coleto os materiais básicos (contam como grátis)",
    OPT_KNOWN = "Usar só receitas que eu já conheço",
    OPT_SRC_T = "Permitir receitas de treinador", OPT_SRC_V = "Permitir receitas vendidas por vendedores", OPT_SRC_I = "Permitir itens de receita (drops, missões, raras)", OPT_SRC_U = "Permitir receitas de outra fonte ou desconhecida",
    OPT_PROVIDER = "Fonte de preços", OPT_SKIN = "Visual", OPT_SCALE = "Escala da janela", OPT_ALPHA = "Opacidade da janela", OPT_AUTO = "Automático",
    OPT_AHCUT = "Descontar os 5% da casa de leilões ao vender", OPT_VENDOR = "Só vendedor",
    UNIT_MIN = "min", CRAFT_X = "%d criações", ORANGE = "laranja", YELLOW = "amarelo", GREEN = "verde", GREY = "cinza",
    LEGEND = "Dificuldade: laranja / amarelo / verde / cinza",
    CLOSE = "Fechar", TIP_ROW = "Clique numa profissão à esquerda, defina a faixa de perícia e leia o plano.",
    PROFS = { alchemy = "Alquimia", blacksmithing = "Ferraria", cooking = "Culinária", enchanting = "Encantamento", engineering = "Engenharia", firstaid = "Primeiros Socorros", leatherworking = "Couraria", mining = "Mineração", tailoring = "Alfaiataria" },
    SKINS = { dark = "Escuro", classic = "Clássico", slate = "Ardósia", forest = "Floresta" },
    NOTE_ESTIMATE = "As chances de subir são estimativas (laranja 100%, amarelo 75%, verde 25%). Os requisitos vêm de dados públicos; alguns são estimados.",
}
local lang = "en"
do
    local l = (GetLocale and GetLocale()) or "enUS"
    local p = l:sub(1, 2)
    if p == "pt" then lang = "pt" elseif p == "es" then lang = "es" end
end
local S = setmetatable({}, { __index = function(_, k)
    local v = LOC[lang][k]
    if v == nil then v = LOC.en[k] end
    return v == nil and k or v
end })
local function ProfLabel(key)
    local t = LOC[lang].PROFS
    return (t and t[key]) or LOC.en.PROFS[key] or key
end

---------------------------------------------------------------- profissoes
-- spellId only used to learn the localized skill name from the game
local PROFS = {
    { key = "alchemy", spell = 2259, icon = "Interface\\Icons\\Trade_Alchemy" },
    { key = "blacksmithing", spell = 2018, icon = "Interface\\Icons\\Trade_BlackSmithing" },
    { key = "cooking", spell = 2550, icon = "Interface\\Icons\\INV_Misc_Food_15" },
    { key = "enchanting", spell = 7411, icon = "Interface\\Icons\\Trade_Engraving" },
    { key = "engineering", spell = 4036, icon = "Interface\\Icons\\Trade_Engineering" },
    { key = "firstaid", spell = 3273, icon = "Interface\\Icons\\Spell_Holy_SealOfSacrifice" },
    { key = "leatherworking", spell = 2108, icon = "Interface\\Icons\\Trade_LeatherWorking" },
    { key = "mining", spell = 2575, icon = "Interface\\Icons\\Trade_Mining" },
    { key = "tailoring", spell = 3908, icon = "Interface\\Icons\\Trade_Tailoring" },
}
local PROF_BY_KEY = {}
for _, p in ipairs(PROFS) do PROF_BY_KEY[p.key] = p end

local issecret = issecretvalue or function() return false end
local QMARK = "Interface\\Icons\\INV_Misc_QuestionMark"
local DEFAULTS = {
    sel = "mining", skin = "dark", scale = 1, alpha = 0.96, fontText = 1, fontNum = 1, provider = "auto", mode = "cheap",
    free = false, knownOnly = false, srcT = true, srcV = true, srcI = false, srcU = false, ahCut = true,
    range = {},
}
local P -- saved settings (GatherTrailDB.prof)

local function SpellName(id)
    local n
    if C_Spell and C_Spell.GetSpellName then n = C_Spell.GetSpellName(id) end
    if not n and GetSpellInfo then n = GetSpellInfo(id) end
    if issecret(n) then return nil end
    return n
end
local function SpellKnown(id)
    if IsPlayerSpell and IsPlayerSpell(id) then return true end
    if IsSpellKnown and IsSpellKnown(id) then return true end
    return false
end
local function ItemName(id)
    local n
    if C_Item and C_Item.GetItemNameByID then n = C_Item.GetItemNameByID(id) end
    if not n and GetItemInfo then n = GetItemInfo(id) end
    if not n and C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(id) end
    if issecret(n) then return nil end
    return n
end
local function ItemIcon(id)
    local t
    if C_Item and C_Item.GetItemIconByID then t = C_Item.GetItemIconByID(id) end
    if not t and GetItemIcon then t = GetItemIcon(id) end
    return t or QMARK
end
local function SpellIcon(id)
    local t
    if C_Spell and C_Spell.GetSpellTexture then t = C_Spell.GetSpellTexture(id) end
    if not t and GetSpellTexture then t = GetSpellTexture(id) end
    return t or QMARK
end
local function ItemCount(id)
    if GetItemCount then return GetItemCount(id, true) or 0 end
    return 0
end

local function Money(c)
    if not c then return "?" end
    local neg = c < 0
    c = floor(abs(c) + 0.5)
    local g, sv, cu = floor(c / 10000), floor(c / 100) % 100, c % 100
    local s
    if g > 0 then s = ("|cffffd700%d|rg |cffc0c0c0%02d|rs"):format(g, sv)
    elseif sv > 0 then s = ("|cffc0c0c0%d|rs |cffeda55f%02d|rc"):format(sv, cu)
    else s = ("|cffeda55f%d|rc"):format(cu) end
    return neg and ("-" .. s) or s
end

---------------------------------------------------------------- dados
local decoded, producers, meta = {}, {}, {}
local function ItemMeta(id)
    local m = meta[id]
    if m then return m[1], m[2] end
    local line = ns.ItemData and ns.ItemData[id]
    local a, b = 0, 0
    if line then
        local x, y = line:match("^(%d+)|(%d+)$")
        a, b = tonumber(x) or 0, tonumber(y) or 0
    end
    meta[id] = { a, b }
    return a, b
end

local function Decode(key)
    if decoded[key] then return decoded[key], producers[key] end
    local out, prod = {}, {}
    local d = ns.RecipeData and ns.RecipeData[key]
    if d then
        for _, line in ipairs(d.recipes) do
            local sp, rq, lo, hi, it, qt, src, si, rg = line:match("^(%d+)|(%d+)|(%d+)|(%d+)|(%d+)|(%d+)|(%a)|(%d+)|(.*)$")
            if sp then
                local r = { spell = tonumber(sp), req = tonumber(rq), low = tonumber(lo), high = tonumber(hi), item = tonumber(it),
                    qty = tonumber(qt), src = src, srcItem = tonumber(si), reag = {} }
                for id, n in rg:gmatch("(%d+):(%d+)") do r.reag[#r.reag + 1] = { tonumber(id), tonumber(n) } end
                out[#out + 1] = r
                if r.item > 0 then
                    prod[r.item] = prod[r.item] or {}
                    prod[r.item][#prod[r.item] + 1] = r
                end
            end
        end
    end
    decoded[key], producers[key] = out, prod
    return out, prod
end

---------------------------------------------------------------- precos
local PROVIDERS = {
    { key = "auctionator", name = "Auctionator",
      ok = function() local A = _G.Auctionator return A and A.API and A.API.v1 and A.API.v1.GetAuctionPriceByItemID and true or false end,
      get = function(id) return _G.Auctionator.API.v1.GetAuctionPriceByItemID("Trailsmith", id) end },
    { key = "tsm", name = "TradeSkillMaster",
      ok = function() return _G.TSM_API and _G.TSM_API.GetCustomPriceValue and true or false end,
      get = function(id) return _G.TSM_API.GetCustomPriceValue("DBMarket", "i:" .. id) end },
    { key = "auctioneer", name = "Auctioneer",
      ok = function() local A = _G.AucAdvanced return A and A.API and A.API.GetMarketValue and true or false end,
      get = function(id)
          local link = select(2, GetItemInfo(id))
          if not link then return nil end
          return _G.AucAdvanced.API.GetMarketValue(link)
      end },
}
local function ActiveProvider()
    if P.provider ~= "auto" then
        for _, pr in ipairs(PROVIDERS) do
            if pr.key == P.provider and pr.ok() then return pr end
        end
    end
    if P.provider == "vendor" then return nil end
    for _, pr in ipairs(PROVIDERS) do
        if pr.ok() then return pr end
    end
    return nil
end

local pcache, ccache, known = {}, {}, {}
local curProd, curRecipes
local function ClearCaches() pcache, ccache, known = {}, {}, {} end

local function MarketPrice(id)
    local pr = ActiveProvider()
    if not pr then return nil end
    local ok, v = pcall(pr.get, id)
    if ok and type(v) == "number" and v > 0 then return v end
    return nil
end

-- cost to acquire one item by buying it (vendor or market); nil = unknown
local function BuyPrice(id)
    local c = pcache[id]
    if c ~= nil then return c or nil end
    local sell, vbuy = ItemMeta(id)
    local best = vbuy > 0 and vbuy or nil
    local ah = MarketPrice(id)
    if ah and (not best or ah < best) then best = ah end
    if P.free and not (curProd and curProd[id]) and not (vbuy > 0) then best = 0 end
    -- no market data: the vendor sell price is a floor estimate
    if not best and sell > 0 then best = sell end
    pcache[id] = best or false
    return best
end

local function SellValue(id)
    local sell = ItemMeta(id)
    local ah = MarketPrice(id)
    local v = ah or sell
    if ah and P.ahCut then v = ah * 0.95 end
    if v and sell and sell > v then v = sell end
    return v or 0
end

local function Allowed(r)
    if known[r.spell] == nil then known[r.spell] = SpellKnown(r.spell) end
    if known[r.spell] or r.src == "a" then return true end
    if P.knownOnly then return false end
    if r.src == "t" then return P.srcT end
    if r.src == "v" then return P.srcV end
    if r.src == "i" then return P.srcI end
    return P.srcU
end

local busy = {}
local ItemCost
-- returns cost per unit, missing flag, producing recipe (nil if bought)
ItemCost = function(id, depth)
    local c = ccache[id]
    if c then return c[1], c[2], c[3] end
    local buy = BuyPrice(id)
    local best, bestR = buy, nil
    local miss = buy == nil
    if depth < 3 and curProd and curProd[id] and not busy[id] then
        busy[id] = true
        for _, r in ipairs(curProd[id]) do
            if Allowed(r) then
                local total, m = 0, false
                for _, rg in ipairs(r.reag) do
                    local rc, rm = ItemCost(rg[1], depth + 1)
                    if rc then total = total + rc * rg[2] end
                    if rm then m = true end
                end
                total = total / r.qty
                if not m and (best == nil or total < best) then best, bestR, miss = total, r, false end
            end
        end
        busy[id] = nil
    end
    if depth == 0 or not busy[id] then ccache[id] = { best, miss, bestR } end
    return best, miss, bestR
end

local function RecipeCost(r)
    local total, missing = 0, false
    for _, rg in ipairs(r.reag) do
        local c, m = ItemCost(rg[1], 0)
        if c then total = total + c * rg[2] end
        if m then missing = true end
    end
    return total, missing
end

local function Chance(r, s)
    if s >= r.high then return 0 end
    if s < r.low then return 1 end
    if s < floor((r.low + r.high) / 2) then return 0.75 end
    return 0.25
end
local function BandColor(r, s)
    if s >= r.high then return "ff808080", "grey" end
    if s < r.low then return "ffff8040", "orange" end
    if s < floor((r.low + r.high) / 2) then return "ffffff00", "yellow" end
    return "ff40c040", "green"
end

local function OutputValue(r)
    if r.item > 0 then return SellValue(r.item) * r.qty end
    return 0
end

---------------------------------------------------------------- planejador
-- returns { steps = {...}, points, crafts, cost, net, secs, missing, gaps }
local function BuildPlan(key, from, to)
    ClearCaches()
    local recipes, prod = Decode(key)
    curProd, curRecipes = prod, recipes
    local plan = { steps = {}, points = 0, crafts = 0, cost = 0, net = 0, secs = 0, missing = false, mats = {}, key = key, from = from, to = to }
    if to <= from then return plan end
    local mode = P.mode
    local info = {}
    for _, r in ipairs(recipes) do
        if known[r.spell] == nil then known[r.spell] = SpellKnown(r.spell) end
        local cost, miss = RecipeCost(r)
        info[r] = { cost = cost, miss = miss, value = OutputValue(r) }
    end
    local prev
    local cur
    for s = from, to - 1 do
        local best, bestScore
        for _, r in ipairs(recipes) do
            if s < r.high and (r.req <= s or known[r.spell]) and Allowed(r) then
                local ch = Chance(r, s)
                if ch > 0 then
                    local i = info[r]
                    local score
                    if mode == "fast" then score = (1 / ch) * 1000000 + i.cost
                    elseif mode == "profit" then score = (i.cost - i.value) / ch
                    else score = i.cost / ch end
                    if r == prev then score = score - abs(score) * 0.04 end
                    if not bestScore or score < bestScore then best, bestScore = r, score end
                end
            end
        end
        if not best then
            if cur and cur.gap then cur.to = s + 1 else
                cur = { gap = true, from = s, to = s + 1, crafts = 0, cost = 0 }
                plan.steps[#plan.steps + 1] = cur
            end
            prev = nil
        else
            local ch = Chance(best, s)
            if cur and cur.r == best then
                cur.to = s + 1
                cur.crafts = cur.crafts + 1 / ch
            else
                cur = { r = best, from = s, to = s + 1, crafts = 1 / ch }
                plan.steps[#plan.steps + 1] = cur
            end
            prev = best
        end
    end
    local pr = ActiveProvider()
    for _, st in ipairs(plan.steps) do
        if not st.gap then
            st.crafts = ceil(st.crafts - 0.0001)
            local i = info[st.r]
            st.unit, st.miss = i.cost, i.miss
            st.cost = i.cost * st.crafts
            st.value = i.value * st.crafts
            st.known = known[st.r.spell] or st.r.src == "a"
            plan.crafts = plan.crafts + st.crafts
            plan.cost = plan.cost + st.cost
            plan.net = plan.net + st.value
            if i.miss then plan.missing = true end
            -- expand reagents down to what must be bought
            local function Expand(id, n, depth)
                local _, _, pr2 = ItemCost(id, 0)
                if pr2 and depth < 3 then
                    local times = n / pr2.qty
                    for _, rg in ipairs(pr2.reag) do Expand(rg[1], rg[2] * times, depth + 1) end
                else
                    plan.mats[id] = (plan.mats[id] or 0) + n
                end
            end
            for _, rg in ipairs(st.r.reag) do Expand(rg[1], rg[2] * st.crafts, 0) end
        end
        plan.points = plan.points + (st.to - st.from)
    end
    plan.net = plan.net - plan.cost
    plan.secs = plan.crafts * 3
    plan.provider = pr and pr.name or nil
    return plan
end

ns.Prof = { BuildPlan = BuildPlan, Decode = Decode, Chance = Chance }

---------------------------------------------------------------- habilidade do jogador
local nameToKey
local function BuildNameMap()
    nameToKey = {}
    for _, p in ipairs(PROFS) do
        local n = SpellName(p.spell)
        if n then nameToKey[n:lower()] = p.key end
        for _, l in pairs(LOC) do
            local t = l.PROFS and l.PROFS[p.key]
            if t then nameToKey[t:lower():gsub("%s*%b()", "")] = p.key end
        end
    end
end
local skills = {}
local function ReadSkills()
    if not nameToKey then BuildNameMap() end
    for k in pairs(skills) do skills[k] = nil end
    if GetNumSkillLines and GetSkillLineInfo then
        for i = 1, GetNumSkillLines() do
            local n, header, _, rank, _, _, maxRank = GetSkillLineInfo(i)
            if n and not header and not issecret(n) then
                local key = nameToKey[n:lower()]
                if key then skills[key] = { rank = rank or 0, max = (maxRank and maxRank > 0) and maxRank or 300 } end
            end
        end
    end
    if GetProfessions and GetProfessionInfo then
        local list = { GetProfessions() }
        for i = 1, 8 do
            local idx = list[i]
            if idx then
                local n, _, rank, maxRank = GetProfessionInfo(idx)
                local key = n and nameToKey[n:lower()]
                if key and not skills[key] then skills[key] = { rank = rank or 0, max = maxRank or 300 } end
            end
        end
    end
end

---------------------------------------------------------------- interface
local THEMES = {
    dark = { bg = { 0.04, 0.05, 0.08 }, panel = { 0.09, 0.10, 0.15 }, hi = { 0.16, 0.18, 0.26 }, edge = { 0.22, 0.25, 0.35 }, accent = { 1, 0.82, 0.15 } },
    classic = { bg = { 0.10, 0.07, 0.04 }, panel = { 0.18, 0.13, 0.08 }, hi = { 0.28, 0.20, 0.10 }, edge = { 0.55, 0.42, 0.18 }, accent = { 1, 0.82, 0 } },
    slate = { bg = { 0.07, 0.09, 0.11 }, panel = { 0.12, 0.16, 0.19 }, hi = { 0.20, 0.27, 0.32 }, edge = { 0.30, 0.40, 0.48 }, accent = { 0.45, 0.8, 1 } },
    forest = { bg = { 0.03, 0.08, 0.05 }, panel = { 0.07, 0.14, 0.09 }, hi = { 0.12, 0.24, 0.15 }, edge = { 0.25, 0.45, 0.28 }, accent = { 0.6, 1, 0.5 } },
}
local SKIN_ORDER = { "dark", "classic", "slate", "forest" }
local PROVIDER_ORDER = { "auto", "auctionator", "tsm", "auctioneer", "vendor" }

local UI = { skinned = {}, accents = {}, tab = "plan" }
local W, H, SIDE = 900, 590, 196

local function SetColor(tex, c, a)
    if tex.SetColorTexture then tex:SetColorTexture(c[1], c[2], c[3], a or 1)
    else tex:SetTexture(c[1], c[2], c[3], a or 1) end
end

local ApplyFonts
-- flat panel: background + 1px border
local function Skin(frame, kind)
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    frame.skinBG = bg
    local e = {}
    for i = 1, 4 do e[i] = frame:CreateTexture(nil, "BORDER") end
    e[1]:SetPoint("TOPLEFT") e[1]:SetPoint("TOPRIGHT") e[1]:SetHeight(1)
    e[2]:SetPoint("BOTTOMLEFT") e[2]:SetPoint("BOTTOMRIGHT") e[2]:SetHeight(1)
    e[3]:SetPoint("TOPLEFT") e[3]:SetPoint("BOTTOMLEFT") e[3]:SetWidth(1)
    e[4]:SetPoint("TOPRIGHT") e[4]:SetPoint("BOTTOMRIGHT") e[4]:SetWidth(1)
    frame.skinEdges = e
    frame.skinKind = kind
    UI.skinned[#UI.skinned + 1] = frame
end
local function ApplySkin()
    local t = THEMES[P.skin] or THEMES.dark
    for _, f in ipairs(UI.skinned) do
        local c = t[f.skinKind] or t.panel
        if f.selected then c = t.hi end
        SetColor(f.skinBG, c, f.skinKind == "bg" and (P.alpha or 1) or 1)
        local ec = f.selected and t.accent or t.edge
        for i = 1, 4 do SetColor(f.skinEdges[i], ec, 1) end
    end
    for _, fs in ipairs(UI.accents) do fs:SetTextColor(t.accent[1], t.accent[2], t.accent[3]) end
    ApplyFonts()
end

UI.fonts = {}
local function RegFont(obj, kind)
    if not obj.GetFont then return end
    local path, size, flags = obj:GetFont()
    if type(path) == "string" and type(size) == "number" then
        UI.fonts[#UI.fonts + 1] = { obj, path, size, flags, kind }
    end
end
local lastFontKey
ApplyFonts = function(force)
    local key = (P.fontText or 1) .. "|" .. (P.fontNum or 1)
    if key == lastFontKey and not force then return end
    lastFontKey = key
    for _, e in ipairs(UI.fonts) do
        local sc = e[5] == "num" and (P.fontNum or 1) or (P.fontText or 1)
        e[1]:SetFont(e[2], floor(e[3] * sc + 0.5), e[4])
    end
end
-- kind: "num" for numbers (money, counts), nil for text
local function Label(parent, text, font, accent, kind)
    local fs = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    fs:SetJustifyH("LEFT")
    if text then fs:SetText(text) end
    if accent then UI.accents[#UI.accents + 1] = fs end
    RegFont(fs, kind)
    return fs
end

local function FlatButton(parent, text, w, h, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w, h)
    Skin(b, "panel")
    local fs = Label(b, text, "GameFontHighlightSmall")
    fs:SetPoint("CENTER")
    fs:SetJustifyH("CENTER")
    b.text = fs
    local hl = b:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    if hl.SetColorTexture then hl:SetColorTexture(1, 1, 1, 0.08) else hl:SetTexture(1, 1, 1, 0.08) end
    b:SetScript("OnClick", onClick)
    return b
end
local function SetSelected(b, on)
    b.selected = on and true or false
end

local function Tip(frame, fn)
    frame:SetScript("OnEnter", function(self)
        if not GameTooltip then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local ok = pcall(fn, GameTooltip, self)
        if ok then GameTooltip:Show() else GameTooltip:Hide() end
    end)
    frame:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
end

-- virtual list: a fixed set of row frames reused while scrolling
local function NewList(parent, x, y, w, h, rowH, makeRow, fillRow)
    local list = { data = {}, offset = 0, rows = {}, rowH = rowH }
    local view = CreateFrame("Frame", nil, parent)
    view:SetPoint("TOPLEFT", x, y)
    view:SetSize(w - 16, h)
    view:EnableMouseWheel(true)
    list.view = view
    local n = floor(h / rowH)
    for i = 1, n do
        local row = makeRow(view)
        row:SetPoint("TOPLEFT", 0, -(i - 1) * rowH)
        row:SetPoint("TOPRIGHT", 0, -(i - 1) * rowH)
        row:SetHeight(rowH - 2)
        list.rows[i] = row
    end
    local sb = CreateFrame("Slider", nil, parent)
    sb:SetPoint("TOPLEFT", view, "TOPRIGHT", 4, 0)
    sb:SetSize(8, h)
    Skin(sb, "panel")
    local thumb = sb:CreateTexture(nil, "OVERLAY")
    thumb:SetSize(8, 28)
    if thumb.SetColorTexture then thumb:SetColorTexture(0.7, 0.7, 0.7, 0.6) else thumb:SetTexture(0.7, 0.7, 0.7, 0.6) end
    sb:SetThumbTexture(thumb)
    sb:SetOrientation("VERTICAL")
    sb:SetMinMaxValues(0, 1)
    sb:SetValueStep(1)
    sb:SetValue(0)
    list.sb = sb
    function list:Update()
        local total = #self.data
        local maxOff = max(0, total - n)
        if self.offset > maxOff then self.offset = maxOff end
        self.syncing = true
        sb:SetMinMaxValues(0, max(1, maxOff))
        sb:SetValue(self.offset)
        self.syncing = false
        if maxOff == 0 then sb:Hide() else sb:Show() end
        for i = 1, n do
            local d = self.data[self.offset + i]
            local row = self.rows[i]
            if d then fillRow(row, d, self.offset + i) row:Show() else row:Hide() end
        end
    end
    function list:SetData(d, keepOffset)
        self.data = d
        if not keepOffset then self.offset = 0 end
        self:Update()
    end
    sb:SetScript("OnValueChanged", function(_, v)
        if list.syncing then return end
        list.offset = floor(v + 0.5)
        list:Update()
    end)
    view:SetScript("OnMouseWheel", function(_, delta)
        list.offset = max(0, list.offset - delta * 3)
        list:Update()
    end)
    return list
end

local function ModeLabel() return P.mode == "profit" and S.MODE_PROFIT or P.mode == "fast" and S.MODE_FAST or S.MODE_CHEAP end

local function FormatTime(secs)
    local m = ceil(secs / 60)
    if m >= 60 then return ("%dh %02d%s"):format(floor(m / 60), m % 60, S.UNIT_MIN) end
    return ("%d %s"):format(m, S.UNIT_MIN)
end

local current -- last plan
local function RangeFor(key)
    local r = P.range[key]
    local sk = skills[key]
    if not r then
        r = { from = sk and sk.rank or 1, to = sk and sk.max or 300 }
        if r.from < 1 then r.from = 1 end
        if r.to <= r.from then r.to = min(375, r.from + 50) end
        P.range[key] = r
    end
    return r
end

local function ItemOrSpellTip(tt, r)
    if r.item and r.item > 0 then tt:SetHyperlink("item:" .. r.item)
    else tt:SetHyperlink("spell:" .. r.spell) end
end

local function SrcLabel(r)
    if r.src == "t" then return S.SRC_T elseif r.src == "v" then return S.SRC_V elseif r.src == "i" then return S.SRC_I
    elseif r.src == "a" then return S.SRC_A end
    return S.SRC_U
end

local function MatLine(r, crafts)
    local parts = {}
    for _, rg in ipairs(r.reag) do
        parts[#parts + 1] = ("%d× %s"):format(rg[2] * crafts, ItemName(rg[1]) or ("#" .. rg[1]))
    end
    return table.concat(parts, ", ")
end

function UI:MakePlanRow(parent)
    local row = CreateFrame("Button", nil, parent)
    Skin(row, "panel")
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(32, 32)
    row.icon:SetPoint("LEFT", 6, 0)
    row.t1 = Label(row, nil, "GameFontHighlight")
    row.t1:SetPoint("TOPLEFT", 46, -5)
    row.t1:SetPoint("RIGHT", -112, 0)
    row.t1:SetWordWrap(false)
    row.t2 = Label(row, nil, "GameFontHighlightSmall")
    row.t2:SetPoint("BOTTOMLEFT", 46, 5)
    row.t2:SetPoint("RIGHT", -112, 0)
    row.t2:SetWordWrap(false)
    row.t2:SetTextColor(0.7, 0.7, 0.7)
    row.cost = Label(row, nil, "GameFontHighlight", false, "num")
    row.cost:SetPoint("RIGHT", -8, 6)
    row.cost:SetJustifyH("RIGHT")
    row.sub = Label(row, nil, "GameFontHighlightSmall", false, "num")
    row.sub:SetPoint("RIGHT", -8, -8)
    row.sub:SetJustifyH("RIGHT")
    row.sub:SetTextColor(0.7, 0.7, 0.7)
    local hl = row:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    if hl.SetColorTexture then hl:SetColorTexture(1, 1, 1, 0.06) else hl:SetTexture(1, 1, 1, 0.06) end
    Tip(row, function(tt, self) if self.rec then ItemOrSpellTip(tt, self.rec) end end)
    return row
end
function UI.FillPlanRow(row, st)
    if st.gap then
        row.rec = nil
        row.icon:SetTexture(QMARK)
        row.t1:SetText(("|cffff5050%d – %d|r"):format(st.from, st.to))
        row.t2:SetText(S.NOREC:format(st.from, st.to))
        row.t2:SetTextColor(1, 0.6, 0.5)
        row.cost:SetText("")
        row.sub:SetText("")
        return
    end
    local r = st.r
    row.rec = r
    row.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
    local col = BandColor(r, st.from)
    local name = SpellName(r.spell) or (r.item > 0 and ItemName(r.item)) or ("#" .. r.spell)
    local learn = ""
    if not st.known then learn = ("  |cff66ccff[%s]|r"):format(SrcLabel(r)) end
    row.t1:SetText(("|c%s%d – %d|r   %s%s"):format(col, st.from, st.to, name, learn))
    row.t2:SetTextColor(0.7, 0.7, 0.7)
    row.t2:SetText(MatLine(r, st.crafts))
    row.cost:SetText(st.miss and ("|cffff8080" .. S.NOPRICE .. "|r") or Money(st.cost))
    row.sub:SetText(S.CRAFT_X:format(st.crafts))
end

function UI:MakeMatRow(parent)
    local row = CreateFrame("Button", nil, parent)
    Skin(row, "panel")
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(22, 22)
    row.icon:SetPoint("LEFT", 6, 0)
    row.name = Label(row, nil, "GameFontHighlight")
    row.name:SetPoint("LEFT", 34, 0)
    row.name:SetWidth(250)
    row.name:SetWordWrap(false)
    row.need = Label(row, nil, "GameFontHighlight", false, "num")
    row.need:SetPoint("LEFT", 292, 0)
    row.need:SetWidth(50)
    row.have = Label(row, nil, "GameFontHighlight", false, "num")
    row.have:SetPoint("LEFT", 346, 0)
    row.have:SetWidth(50)
    row.miss = Label(row, nil, "GameFontHighlight", false, "num")
    row.miss:SetPoint("LEFT", 400, 0)
    row.miss:SetWidth(50)
    row.total = Label(row, nil, "GameFontHighlight", false, "num")
    row.total:SetPoint("RIGHT", -8, 0)
    row.total:SetJustifyH("RIGHT")
    Tip(row, function(tt, self) if self.id then tt:SetHyperlink("item:" .. self.id) end end)
    return row
end
function UI.FillMatRow(row, m)
    row.id = m.id
    row.icon:SetTexture(ItemIcon(m.id))
    row.name:SetText(ItemName(m.id) or ("#" .. m.id))
    row.need:SetText(tostring(m.need))
    row.have:SetText(tostring(m.have))
    local miss = max(0, m.need - m.have)
    row.miss:SetText(miss > 0 and ("|cffff8080" .. miss .. "|r") or "|cff40c040OK|r")
    row.total:SetText(m.cost and Money(m.cost * miss) or ("|cffff8080" .. S.NOPRICE .. "|r"))
end

function UI:MakeRecRow(parent)
    local row = CreateFrame("Button", nil, parent)
    Skin(row, "panel")
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(22, 22)
    row.icon:SetPoint("LEFT", 6, 0)
    row.name = Label(row, nil, "GameFontHighlight")
    row.name:SetPoint("LEFT", 34, 0)
    row.name:SetWidth(230)
    row.name:SetWordWrap(false)
    row.bands = Label(row, nil, "GameFontHighlightSmall", false, "num")
    row.bands:SetPoint("LEFT", 270, 0)
    row.bands:SetWidth(120)
    row.src = Label(row, nil, "GameFontHighlightSmall")
    row.src:SetPoint("LEFT", 394, 0)
    row.src:SetWidth(120)
    row.src:SetWordWrap(false)
    row.cost = Label(row, nil, "GameFontHighlightSmall", false, "num")
    row.cost:SetPoint("RIGHT", -8, 0)
    row.cost:SetJustifyH("RIGHT")
    Tip(row, function(tt, self) if self.rec then ItemOrSpellTip(tt, self.rec) end end)
    return row
end
function UI.FillRecRow(row, d)
    local r = d.r
    row.rec = r
    row.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
    local name = SpellName(r.spell) or (r.item > 0 and ItemName(r.item)) or ("#" .. r.spell)
    row.name:SetText((d.known and "|cff40c040" or "") .. name .. (d.known and "|r" or ""))
    local mid = floor((r.low + r.high) / 2)
    row.bands:SetText(("|cffff8040%d|r |cffffff00%d|r |cff40c040%d|r |cff808080%d|r"):format(r.req, r.low, mid, r.high))
    row.src:SetText(d.known and S.KNOWN or SrcLabel(r))
    row.cost:SetText(d.miss and ("|cffff8080" .. S.NOPRICE .. "|r") or Money(d.cost))
end

local function Recompute()
    if not UI.frame then return end
    ReadSkills()
    local key = P.sel
    local r = RangeFor(key)
    r.from = max(1, min(r.from, 374))
    r.to = max(r.from + 1, min(r.to, 375))
    current = BuildPlan(key, r.from, r.to)
end

local function BuildMatList(plan)
    local out = {}
    for id, n in pairs(plan.mats) do
        local c = ItemCost(id, 0)
        local need = ceil(n - 0.0001)
        out[#out + 1] = { id = id, need = need, have = ItemCount(id), cost = c }
    end
    table.sort(out, function(a, b)
        local ta, tb = (a.cost or 0) * a.need, (b.cost or 0) * b.need
        if ta ~= tb then return ta > tb end
        return a.id < b.id
    end)
    return out
end

local function BuildRecList(key, filter)
    local recipes = Decode(key)
    ClearCaches()
    curProd = producers[key]
    local out = {}
    filter = filter and filter:lower() or ""
    for _, r in ipairs(recipes) do
        local name = SpellName(r.spell) or ""
        if filter == "" or name:lower():find(filter, 1, true) then
            local cost, miss = RecipeCost(r)
            if known[r.spell] == nil then known[r.spell] = SpellKnown(r.spell) end
            out[#out + 1] = { r = r, cost = cost, miss = miss, known = known[r.spell] }
        end
    end
    return out
end

function UI:Refresh()
    if not self.frame or not self.frame:IsShown() then return end
    Recompute()
    local key = P.sel
    local sk = skills[key]
    -- sidebar
    for _, b in ipairs(self.profBtns) do
        local s = skills[b.key]
        SetSelected(b, b.key == key)
        b.sub:SetText(s and ("%d / %d"):format(s.rank, s.max) or "|cff808080—|r")
    end
    -- controls
    local rg = P.range[key]
    self.fromBox:SetText(tostring(rg.from))
    self.toBox:SetText(tostring(rg.to))
    for _, b in ipairs(self.modeBtns) do SetSelected(b, b.mode == P.mode) end
    for _, b in ipairs(self.tabBtns) do SetSelected(b, b.tab == self.tab) end
    -- cards
    local p = current
    self.cards.points.v:SetText(tostring(p.points))
    self.cards.crafts.v:SetText(tostring(p.crafts))
    self.cards.cost.v:SetText(p.missing and (Money(p.cost) .. " |cffff8080+?|r") or Money(p.cost))
    self.cards.time.v:SetText(FormatTime(p.secs))
    self.cards.net.v:SetText(Money(p.net))
    self.priceLine:SetText(p.provider and S.PRICES:format(p.provider) or S.PRICES_NONE)
    self.noProf:SetText(sk and "" or S.NOPROF)
    -- tabs
    self.planPane:SetShown(self.tab == "plan")
    self.matPane:SetShown(self.tab == "mats")
    self.recPane:SetShown(self.tab == "recipes")
    self.setPane:SetShown(self.tab == "settings")
    if self.tab == "plan" then self.planList:SetData(p.steps, true)
    elseif self.tab == "mats" then self.matList:SetData(BuildMatList(p), true)
    elseif self.tab == "recipes" then self.recList:SetData(BuildRecList(key, self.search:GetText()), true)
    end
    ApplySkin()
end

local function Close() if UI.frame then UI.frame:Hide() end end

-- global search across every profession: recipe name, crafted item and reagents
local nameIndex
local function SearchAll(q)
    q = q and q:lower() or ""
    local out = {}
    if #q < 2 then return out end
    if not nameIndex then
        nameIndex = {}
        for _, p in ipairs(PROFS) do
            for _, r in ipairs(Decode(p.key)) do
                local n = SpellName(r.spell)
                if n then nameIndex[#nameIndex + 1] = { key = p.key, r = r, name = n, low = n:lower() } end
            end
        end
    end
    for _, e in ipairs(nameIndex) do
        local score
        if e.low:find(q, 1, true) then score = e.low:sub(1, #q) == q and 1 or 2 end
        if not score and e.r.item > 0 then
            local n = ItemName(e.r.item)
            if n and n:lower():find(q, 1, true) then score = 3 end
        end
        if not score then
            for _, rg in ipairs(e.r.reag) do
                local n = ItemName(rg[1])
                if n and n:lower():find(q, 1, true) then score = 4 break end
            end
        end
        if score then out[#out + 1] = { e = e, score = score } end
    end
    table.sort(out, function(a, b)
        if a.score ~= b.score then return a.score < b.score end
        if a.e.r.low ~= b.e.r.low then return a.e.r.low < b.e.r.low end
        return a.e.r.spell < b.e.r.spell
    end)
    return out
end

ns.Prof.SearchAll = SearchAll

function UI:BuildSearch()
    local f = self.frame
    local box = CreateFrame("EditBox", nil, f)
    box:SetSize(300, 22)
    box:SetPoint("TOP", f, "TOP", 10, -9)
    box:SetAutoFocus(false)
    box:SetFontObject("GameFontHighlight")
    RegFont(box)
    box:SetTextInsets(8, 8, 0, 0)
    Skin(box, "panel")
    self.topBox = box
    local ph = Label(box, S.SEARCH_TOP, "GameFontHighlightSmall")
    ph:SetPoint("LEFT", 8, 0)
    ph:SetTextColor(0.5, 0.5, 0.5)
    local dd = CreateFrame("Frame", nil, f)
    dd:SetPoint("TOPLEFT", box, "BOTTOMLEFT", 0, -2)
    dd:SetSize(420, 10)
    dd:SetFrameStrata("DIALOG")
    Skin(dd, "bg")
    dd:Hide()
    self.dropdown = dd
    dd.rows = {}
    local N = 9
    for i = 1, N do
        local b = CreateFrame("Button", nil, dd)
        b:SetPoint("TOPLEFT", 3, -3 - (i - 1) * 26)
        b:SetPoint("TOPRIGHT", -3, -3 - (i - 1) * 26)
        b:SetHeight(24)
        local ic = b:CreateTexture(nil, "ARTWORK")
        ic:SetSize(20, 20)
        ic:SetPoint("LEFT", 3, 0)
        b.icon = ic
        b.name = Label(b, nil, "GameFontHighlightSmall")
        b.name:SetPoint("LEFT", 30, 0)
        b.name:SetWidth(250)
        b.name:SetWordWrap(false)
        b.prof = Label(b, nil, "GameFontNormalSmall", true)
        b.prof:SetPoint("RIGHT", -6, 0)
        b.prof:SetJustifyH("RIGHT")
        local hl = b:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints()
        if hl.SetColorTexture then hl:SetColorTexture(1, 1, 1, 0.1) else hl:SetTexture(1, 1, 1, 0.1) end
        b:SetScript("OnClick", function(self2)
            local e = self2.entry
            if type(e) ~= "table" then return end
            P.sel = e.key
            UI.tab = "recipes"
            box:SetText("")
            box:ClearFocus()
            dd:Hide()
            UI.search:SetText(e.name)
            UI:Refresh()
        end)
        dd.rows[i] = b
    end
    local function Update()
        local txt = box:GetText() or ""
        ph:SetShown(txt == "")
        if #txt < 2 then dd:Hide() return end
        local res = SearchAll(txt)
        local n = min(N, #res)
        if n == 0 then
            dd.rows[1].entry = nil
            dd.rows[1].icon:SetTexture(QMARK)
            dd.rows[1].name:SetText(S.RESULT_NONE)
            dd.rows[1].prof:SetText("")
            dd.rows[1]:Show()
            n = 1
            for i = 2, N do dd.rows[i]:Hide() end
        else
            for i = 1, N do
                local b, r = dd.rows[i], res[i]
                if r then
                    local e = r.e
                    b.entry = e
                    b.icon:SetTexture(e.r.item > 0 and ItemIcon(e.r.item) or SpellIcon(e.r.spell))
                    b.name:SetText(e.name)
                    b.prof:SetText(ProfLabel(e.key))
                    b:Show()
                else b:Hide() end
            end
        end
        dd:SetHeight(6 + n * 26)
        dd:Show()
    end
    box:SetScript("OnTextChanged", Update)
    box:SetScript("OnEscapePressed", function(s2) s2:SetText("") s2:ClearFocus() dd:Hide() end)
    box:SetScript("OnEnterPressed", function(s2)
        local first = dd.rows[1]
        if first and first:IsShown() and type(first.entry) == "table" then first:Click() end
    end)
end

function UI:BuildSettings(pane)
    local y = -4
    local checks = {}
    local function Check(label, key)
        local cb = CreateFrame("CheckButton", nil, pane, "UICheckButtonTemplate")
        cb:SetSize(24, 24)
        cb:SetPoint("TOPLEFT", 0, y)
        local fs = Label(cb, label, "GameFontHighlight")
        fs:SetPoint("LEFT", cb, "RIGHT", 4, 0)
        cb:SetScript("OnClick", function(self)
            P[key] = self:GetChecked() and true or false
            UI:Refresh()
        end)
        checks[#checks + 1] = function() cb:SetChecked(P[key]) end
        y = y - 28
    end
    Check(S.OPT_GATHER, "free")
    Check(S.OPT_KNOWN, "knownOnly")
    Check(S.OPT_SRC_T, "srcT")
    Check(S.OPT_SRC_V, "srcV")
    Check(S.OPT_SRC_I, "srcI")
    Check(S.OPT_SRC_U, "srcU")
    Check(S.OPT_AHCUT, "ahCut")
    y = y - 8
    local provBtn = FlatButton(pane, "", 240, 24, function()
        local i = 1
        for n, k in ipairs(PROVIDER_ORDER) do if k == P.provider then i = n end end
        P.provider = PROVIDER_ORDER[i % #PROVIDER_ORDER + 1]
        UI:Refresh()
        UI:RefreshSettings()
    end)
    provBtn:SetPoint("TOPLEFT", 0, y)
    local provCap = Label(pane, S.OPT_PROVIDER, "GameFontNormalSmall", true)
    provCap:SetPoint("LEFT", provBtn, "RIGHT", 10, 0)
    local skinBtn = FlatButton(pane, "", 240, 24, function()
        local i = 1
        for n, k in ipairs(SKIN_ORDER) do if k == P.skin then i = n end end
        P.skin = SKIN_ORDER[i % #SKIN_ORDER + 1]
        UI:Refresh()
        UI:RefreshSettings()
    end)
    skinBtn:SetPoint("TOPLEFT", 0, y - 32)
    local skinCap = Label(pane, S.OPT_SKIN, "GameFontNormalSmall", true)
    skinCap:SetPoint("LEFT", skinBtn, "RIGHT", 10, 0)
    y = y - 70
    local function Slide(label, key, lo, hi, step, apply)
        local cap = Label(pane, label, "GameFontNormalSmall", true)
        cap:SetPoint("TOPLEFT", 0, y)
        local val = Label(pane, "", "GameFontHighlightSmall")
        val:SetPoint("TOPLEFT", 250, y)
        local s = CreateFrame("Slider", nil, pane)
        s:SetPoint("TOPLEFT", 0, y - 18)
        s:SetSize(240, 14)
        Skin(s, "panel")
        local th = s:CreateTexture(nil, "OVERLAY")
        th:SetSize(10, 18)
        if th.SetColorTexture then th:SetColorTexture(0.85, 0.85, 0.85, 0.9) else th:SetTexture(0.85, 0.85, 0.85, 0.9) end
        s:SetThumbTexture(th)
        s:SetOrientation("HORIZONTAL")
        s:SetMinMaxValues(lo, hi)
        s:SetValueStep(step)
        s:SetScript("OnValueChanged", function(self, v)
            v = floor(v / step + 0.5) * step
            val:SetText(("%.2f"):format(v))
            if self.syncing then return end
            P[key] = v
            apply()
        end)
        UI.sliders[#UI.sliders + 1] = function()
            s.syncing = true
            s:SetValue(P[key])
            s.syncing = false
            val:SetText(("%.2f"):format(P[key]))
        end
        y = y - 44
    end
    UI.sliders = {}
    Slide(S.OPT_SCALE, "scale", 0.7, 1.3, 0.05, function() UI.frame:SetScale(P.scale) end)
    Slide(S.OPT_ALPHA, "alpha", 0.4, 1, 0.02, function() ApplySkin() end)
    Slide(S.OPT_FONT_TEXT, "fontText", 0.8, 1.3, 0.05, function() ApplyFonts() end)
    Slide(S.OPT_FONT_NUM, "fontNum", 0.8, 1.4, 0.05, function() ApplyFonts() end)
    local note = Label(pane, S.NOTE_ESTIMATE, "GameFontHighlightSmall")
    note:SetPoint("BOTTOMLEFT", 0, 0)
    note:SetWidth(600)
    note:SetTextColor(0.65, 0.65, 0.65)
    note:SetJustifyV("BOTTOM")
    self.settingsRefresh = function()
        for _, f in ipairs(checks) do f() end
        for _, f in ipairs(UI.sliders) do f() end
        local pv = P.provider
        local name = pv == "auto" and S.OPT_AUTO or pv == "vendor" and S.OPT_VENDOR or pv
        for _, pr in ipairs(PROVIDERS) do if pr.key == pv then name = pr.name .. (pr.ok() and "" or " (-)") end end
        if pv == "auto" then
            local a = ActiveProvider()
            name = S.OPT_AUTO .. (a and (": " .. a.name) or "")
        end
        provBtn.text:SetText(name)
        skinBtn.text:SetText(S.SKINS[P.skin] or P.skin)
    end
end
function UI:RefreshSettings() if self.settingsRefresh then self.settingsRefresh() end end

function UI:Build()
    local f = CreateFrame("Frame", "TrailsmithProfFrame", UIParent)
    f:SetSize(W, H)
    f:SetPoint("CENTER")
    f:SetFrameStrata("HIGH")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    Skin(f, "bg")
    f:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, "TrailsmithProfFrame") end
    self.frame = f

    local title = Label(f, S.TITLE, "GameFontNormalLarge", true)
    title:SetPoint("TOPLEFT", 14, -12)
    local close = FlatButton(f, "X", 22, 22, Close)
    close:SetPoint("TOPRIGHT", -8, -8)
    self.priceLine = Label(f, "", "GameFontHighlightSmall")
    self.priceLine:SetPoint("TOPRIGHT", -40, -14)
    self.priceLine:SetWidth(170)
    self.priceLine:SetJustifyH("RIGHT")
    self.priceLine:SetTextColor(0.7, 0.7, 0.7)

    -- sidebar
    local side = CreateFrame("Frame", nil, f)
    side:SetPoint("TOPLEFT", 10, -40)
    side:SetSize(SIDE - 10, H - 52)
    Skin(side, "panel")
    self.profBtns = {}
    for i, p in ipairs(PROFS) do
        local b = CreateFrame("Button", nil, side)
        b:SetPoint("TOPLEFT", 4, -4 - (i - 1) * 46)
        b:SetSize(SIDE - 18, 42)
        Skin(b, "bg")
        b.skinKind = "bg"
        b.key = p.key
        local ic = b:CreateTexture(nil, "ARTWORK")
        ic:SetSize(30, 30)
        ic:SetPoint("LEFT", 6, 0)
        ic:SetTexture(p.icon)
        local nm = Label(b, nil, "GameFontHighlightSmall")
        nm:SetPoint("TOPLEFT", 42, -7)
        nm:SetPoint("RIGHT", -4, 0)
        nm:SetWordWrap(false)
        b.nameFS = nm
        b.sub = Label(b, "", "GameFontHighlightSmall", false, "num")
        b.sub:SetPoint("BOTTOMLEFT", 42, 6)
        b.sub:SetTextColor(0.7, 0.7, 0.7)
        local hl = b:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints()
        if hl.SetColorTexture then hl:SetColorTexture(1, 1, 1, 0.07) else hl:SetTexture(1, 1, 1, 0.07) end
        b:SetScript("OnClick", function() P.sel = p.key UI:Refresh() end)
        self.profBtns[i] = b
    end

    local X = SIDE + 14 -- main area left
    local MW = W - X - 12

    -- range controls
    local function Box(label, x)
        local cap = Label(f, label, "GameFontNormalSmall", true)
        cap:SetPoint("TOPLEFT", x, -48)
        local eb = CreateFrame("EditBox", nil, f)
        eb:SetSize(44, 22)
        eb:SetPoint("LEFT", cap, "RIGHT", 6, 0)
        eb:SetAutoFocus(false)
        eb:SetNumeric(true)
        eb:SetMaxLetters(3)
        eb:SetFontObject("GameFontHighlight")
        RegFont(eb, "num")
        eb:SetJustifyH("CENTER")
        Skin(eb, "panel")
        return eb
    end
    self.fromBox = Box(S.FROM, X)
    self.toBox = Box(S.TO, X + 100)
    local function Commit()
        local rg = P.range[P.sel] or RangeFor(P.sel)
        local a, b = tonumber(UI.fromBox:GetText()), tonumber(UI.toBox:GetText())
        if a then rg.from = max(1, min(374, a)) end
        if b then rg.to = max(rg.from + 1, min(375, b)) end
        UI:Refresh()
    end
    for _, eb in ipairs({ self.fromBox, self.toBox }) do
        eb:SetScript("OnEnterPressed", function(s) s:ClearFocus() Commit() end)
        eb:SetScript("OnEscapePressed", function(s) s:ClearFocus() end)
        eb:SetScript("OnEditFocusLost", function() Commit() end)
    end
    local mine = FlatButton(f, S.MYSKILL, 100, 22, function()
        local sk = skills[P.sel]
        local rg = RangeFor(P.sel)
        if sk then rg.from = max(1, sk.rank) end
        UI:Refresh()
    end)
    mine:SetPoint("TOPLEFT", X + 206, -47)
    local maxb = FlatButton(f, S.MAXSKILL, 70, 22, function()
        local sk = skills[P.sel]
        local rg = RangeFor(P.sel)
        rg.to = sk and sk.max or 300
        if rg.to <= rg.from then rg.to = min(375, rg.from + 25) end
        UI:Refresh()
    end)
    maxb:SetPoint("LEFT", mine, "RIGHT", 6, 0)

    self.modeBtns = {}
    local modes = { { "cheap", S.MODE_CHEAP }, { "profit", S.MODE_PROFIT }, { "fast", S.MODE_FAST } }
    for i, m in ipairs(modes) do
        local b = FlatButton(f, m[2], 120, 22, function() P.mode = m[1] UI:Refresh() end)
        b:SetPoint("TOPLEFT", X + (i - 1) * 126, -76)
        b.mode = m[1]
        self.modeBtns[i] = b
    end
    self.noProf = Label(f, "", "GameFontHighlightSmall")
    self.noProf:SetPoint("TOPLEFT", X + 390, -80)
    self.noProf:SetTextColor(1, 0.6, 0.3)

    -- cards
    self.cards = {}
    local cardDefs = { { "points", S.CARD_POINTS }, { "crafts", S.CARD_CRAFTS }, { "cost", S.CARD_COST }, { "time", S.CARD_TIME }, { "net", S.CARD_NET } }
    local cw = floor((MW - 4 * 6) / 5)
    for i, c in ipairs(cardDefs) do
        local card = CreateFrame("Frame", nil, f)
        card:SetPoint("TOPLEFT", X + (i - 1) * (cw + 6), -104)
        card:SetSize(cw, 50)
        Skin(card, "panel")
        local cap = Label(card, c[2], "GameFontNormalSmall", true)
        cap:SetPoint("TOPLEFT", 8, -6)
        cap:SetPoint("RIGHT", -6, 0)
        cap:SetWordWrap(false)
        local v = Label(card, "", "GameFontHighlightLarge", false, "num")
        v:SetPoint("BOTTOMLEFT", 8, 6)
        v:SetPoint("RIGHT", -4, 0)
        v:SetWordWrap(false)
        card.v = v
        self.cards[c[1]] = card
    end

    -- tabs
    self.tabBtns = {}
    local tabs = { { "plan", S.PLAN }, { "mats", S.MATS }, { "recipes", S.RECIPES }, { "settings", S.SETTINGS } }
    for i, t in ipairs(tabs) do
        local b = FlatButton(f, t[2], 110, 24, function() UI.tab = t[1] UI:Refresh() end)
        b:SetPoint("TOPLEFT", X + (i - 1) * 114, -162)
        b.tab = t[1]
        self.tabBtns[i] = b
    end

    local LY, LH = -192, H - 192 - 14
    local function Pane()
        local p = CreateFrame("Frame", nil, f)
        p:SetPoint("TOPLEFT", X, LY)
        p:SetSize(MW, LH)
        p:Hide()
        return p
    end
    self.planPane, self.matPane, self.recPane, self.setPane = Pane(), Pane(), Pane(), Pane()
    self.planList = NewList(self.planPane, 0, 0, MW, LH, 46, function(p) return UI:MakePlanRow(p) end, UI.FillPlanRow)

    -- materials: column header + list
    local hdr = self.matPane
    local hy = -2
    local function H1(text, x, w, right)
        local fs = Label(hdr, text, "GameFontNormalSmall", true)
        fs:SetPoint("TOPLEFT", x, hy)
        if w then fs:SetWidth(w) end
        if right then fs:SetPoint("TOPRIGHT", -24, hy) fs:SetJustifyH("RIGHT") end
        return fs
    end
    H1(S.MATSHDR, 6, 280)
    H1(S.NEED, 292, 50)
    H1(S.HAVE, 346, 50)
    H1(S.MISSING, 400, 50)
    H1(S.TOTAL, 0, nil, true)
    self.matList = NewList(self.matPane, 0, -20, MW, LH - 20, 28, function(p) return UI:MakeMatRow(p) end, UI.FillMatRow)

    -- recipes: search + list
    local sl = Label(self.recPane, S.SEARCH, "GameFontNormalSmall", true)
    sl:SetPoint("TOPLEFT", 6, -5)
    self.search = CreateFrame("EditBox", nil, self.recPane)
    self.search:SetSize(200, 20)
    self.search:SetPoint("LEFT", sl, "RIGHT", 8, 0)
    self.search:SetAutoFocus(false)
    self.search:SetFontObject("GameFontHighlight")
    RegFont(self.search)
    Skin(self.search, "panel")
    self.search:SetTextInsets(4, 4, 0, 0)
    self.search:SetScript("OnTextChanged", function() UI:Refresh() end)
    self.search:SetScript("OnEscapePressed", function(s) s:ClearFocus() end)
    local legend = Label(self.recPane, S.LEGEND, "GameFontHighlightSmall")
    legend:SetPoint("TOPRIGHT", -24, -6)
    legend:SetTextColor(0.7, 0.7, 0.7)
    self.recList = NewList(self.recPane, 0, -28, MW, LH - 28, 28, function(p) return UI:MakeRecRow(p) end, UI.FillRecRow)

    self:BuildSettings(self.setPane)
    self:BuildSearch()

    f:SetScript("OnShow", function() UI:RefreshSettings() UI:Refresh() end)
    f:SetScript("OnHide", function() if GameTooltip then GameTooltip:Hide() end end)
    f:SetScale(P.scale or 1)
    ApplyFonts(true)
end

---------------------------------------------------------------- abrir
local function Setup()
    local db = _G.GatherTrailDB
    if not db then return false end
    db.prof = db.prof or {}
    P = db.prof
    for k, v in pairs(DEFAULTS) do
        if P[k] == nil then
            if type(v) == "table" then P[k] = {} else P[k] = v end
        end
    end
    return true
end

local function RefreshNames()
    for _, b in ipairs(UI.profBtns or {}) do
        b.nameFS:SetText(ProfLabel(b.key))
    end
end

function ns.OpenProf(arg)
    if not P and not Setup() then return end
    if not UI.frame then UI:Build() RefreshNames() end
    arg = arg and arg:lower() or ""
    if arg ~= "" then
        for _, p in ipairs(PROFS) do
            if p.key:find(arg, 1, true) or ProfLabel(p.key):lower():find(arg, 1, true) then P.sel = p.key break end
        end
    end
    if UI.frame:IsShown() and arg == "" then UI.frame:Hide() else UI.frame:Show() UI:Refresh() end
end

-- when the player opens a profession window, jump to its key on the next open
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:RegisterEvent("TRADE_SKILL_SHOW")
local pending = false
ev:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        Setup()
    elseif event == "GET_ITEM_INFO_RECEIVED" or event == "SKILL_LINES_CHANGED" then
        if UI.frame and UI.frame:IsShown() and not pending then
            pending = true
            C_Timer.After(0.4, function() pending = false UI:Refresh() end)
        end
    elseif event == "TRADE_SKILL_SHOW" then
        if not P and not Setup() then return end
        local n
        if GetTradeSkillLine then n = GetTradeSkillLine() end
        if C_TradeSkillUI and C_TradeSkillUI.GetBaseProfessionInfo then
            local info = C_TradeSkillUI.GetBaseProfessionInfo()
            n = n or (info and info.professionName)
        end
        if n and not issecret(n) then
            if not nameToKey then BuildNameMap() end
            local k = nameToKey[n:lower()]
            if k then P.sel = k end
        end
    end
end)

SLASH_TRAILSMITHPROF1 = "/tsp"
SLASH_TRAILSMITHPROF2 = "/professions"
SlashCmdList.TRAILSMITHPROF = function(msg) ns.OpenProf(msg) end
