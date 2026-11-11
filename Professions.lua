-- Trailsmith Professions: leveling planner for crafting professions.
-- Data (RecipeData.lua) is generated from public sources, see tools/build_recipes.js.
local ADDON, ns = ...
local floor, max, min, ceil = math.floor, math.max, math.min, math.ceil
local unpack = unpack or table.unpack
local pairs, ipairs, type, tonumber, tostring = pairs, ipairs, type, tonumber, tostring

---------------------------------------------------------------- idioma
local LOC = {}
LOC.en = {
    TAB_CRAFT = "Crafting", TAB_GATHER = "Gathering", NORECIPES = "%s has no crafting recipes. Use the Gathering tab for the guide and options.", SKILL = "Skill",
    OPT_SHOWALL = "Show professions I do not have in the side list", KEY_USE = "Open this window with a key (replaces that key's default action)",
    KEY_NOTE = "The old action stays on Shift + the same key.", KEY_PRESS = "Press a key... (Esc cancels)", KEY_BTN = "Key: %s (click to change)", BTN_BLIZZ = "Blizzard's window",
    GATHER_TITLE = "Gathering guide", GATHER_INFO = "Trailsmith points to the nearest ore and herb you can gather and draws it on the minimap and world map. More options (resources, display, filters) are in the full options.",
    G_ENABLED = "Gathering guide enabled", G_MINE = "Track ore (Mining)", G_HERB = "Track herbs (Herbalism)", G_SEED = "Use the seed database", G_AUTOLOOT = "Gathering autoloot",
    G_AUTOLOOTQ = "Quest and gold autoloot", G_AUTOHIDE = "Auto-hide empty points", G_HOVER = "Learn nodes when hovering the minimap", G_RANGE = "Range", BTN_FULLOPT = "Open full options",
    CRAFTOPT = "Crafting options", MODE_TITLE = "Plan mode", SRC_TITLE = "Recipe sources", PRICE_TITLE = "Prices",
    OPT_AUTOTEXT = "Scale text with the window size", BTN_RESETSIZE = "Reset window size and text",
    GO_TRAINER = "Find trainer", GO_VENDOR = "Find vendor", FOOT_REQ = "Requires: %s", FOOT_NOREQ = "No special tool or station needed", FOOT_HAVE = "have %d",
    BTN_CRAFT = "Craft", BTN_CRAFTALL = "Craft all", MSG_CRAFT_OPEN = "Opening the profession window. Click Craft again.", MSG_CRAFT_FAIL = "Could not start the craft. Open the profession window and try again.",
    MSG_NEAREST = "Nearest %s: %s in %s (%.1f, %.1f). Marked on the map.", MSG_NOSPOT = "No known location for this recipe.", FOOT_SELECT = "Click a recipe to see its details here.",
    FOCUS = { Anvil = "Anvil", Forge = "Forge", Loom = "Loom", ["Cooking Fire"] = "Cooking fire", ["Alchemy Lab"] = "Alchemy lab", ["Tanning Rack"] = "Tanning rack", ["Spinning Wheel"] = "Spinning wheel", ["Master Forge"] = "Master forge", ["Iron Oven"] = "Iron oven" },
    OPT_LOG = "Record a debug log of craft attempts", BTN_SHOWLOG = "Show log (copy with Ctrl+C)", BTN_CLEARLOG = "Clear log",
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
    OPT_PROVIDER = "Price source", OPT_SKIN = "Skin", OPT_SCALE = "Window scale", OPT_ALPHA = "Window opacity", OPT_AUTO = "Auto",
    OPT_AHCUT = "Subtract the 5% auction house cut when selling", OPT_VENDOR = "Vendor only",
    UNIT_MIN = "min", CRAFT_X = "%d crafts", ORANGE = "orange", YELLOW = "yellow", GREEN = "green", GREY = "grey",
    LEGEND = "Difficulty: orange / yellow / green / grey",
    CLOSE = "Close", TIP_ROW = "Click a profession on the left, set the skill range and read the plan.",
    PROFS = { alchemy = "Alchemy", blacksmithing = "Blacksmithing", cooking = "Cooking", enchanting = "Enchanting", engineering = "Engineering", firstaid = "First Aid", leatherworking = "Leatherworking", mining = "Mining", tailoring = "Tailoring", herbalism = "Herbalism", skinning = "Skinning", fishing = "Fishing" },
    SKINS = { dark = "Dark", classic = "Classic", slate = "Slate", forest = "Forest" },
    NOTE_ESTIMATE = "Skill-up odds are estimates (orange 100%, yellow 75%, green 25%). Recipe requirements come from public data; a few are estimated.",
}
LOC.es = {
    TAB_CRAFT = "Fabricación", TAB_GATHER = "Recolección", NORECIPES = "%s no tiene recetas de fabricación. Usa la pestaña Recolección para la guía y las opciones.", SKILL = "Habilidad",
    OPT_SHOWALL = "Mostrar en la lista lateral las profesiones que no tengo", KEY_USE = "Abrir esta ventana con una tecla (reemplaza la acción original de esa tecla)",
    KEY_NOTE = "La acción original queda en Mayús + la misma tecla.", KEY_PRESS = "Pulsa una tecla... (Esc cancela)", KEY_BTN = "Tecla: %s (clic para cambiar)", BTN_BLIZZ = "Ventana de Blizzard",
    GATHER_TITLE = "Guía de recolección", GATHER_INFO = "Trailsmith señala el mineral y la hierba más cercanos que puedes recolectar y los dibuja en el minimapa y el mapa del mundo. Más opciones (recursos, visualización, filtros) en las opciones completas.",
    G_ENABLED = "Guía de recolección activada", G_MINE = "Rastrear minerales (Minería)", G_HERB = "Rastrear hierbas (Herboristería)", G_SEED = "Usar la base de datos inicial", G_AUTOLOOT = "Autobotín de recolección",
    G_AUTOLOOTQ = "Autobotín de misión y oro", G_AUTOHIDE = "Ocultar puntos vacíos automáticamente", G_HOVER = "Aprender nodos al pasar por el minimapa", G_RANGE = "Alcance", BTN_FULLOPT = "Abrir opciones completas",
    CRAFTOPT = "Opciones de fabricación", MODE_TITLE = "Modo del plan", SRC_TITLE = "Fuentes de recetas", PRICE_TITLE = "Precios",
    OPT_AUTOTEXT = "Escalar el texto con el tamaño de la ventana", BTN_RESETSIZE = "Restablecer tamaño de ventana y texto",
    GO_TRAINER = "Buscar instructor", GO_VENDOR = "Buscar vendedor", FOOT_REQ = "Requiere: %s", FOOT_NOREQ = "No necesita herramienta ni estación", FOOT_HAVE = "tienes %d",
    BTN_CRAFT = "Crear", BTN_CRAFTALL = "Crear todo", MSG_CRAFT_OPEN = "Abriendo la ventana de profesión. Pulsa Crear de nuevo.", MSG_CRAFT_FAIL = "No se pudo iniciar la creación. Abre la ventana de profesión e inténtalo de nuevo.",
    MSG_NEAREST = "%s más cercano: %s en %s (%.1f, %.1f). Marcado en el mapa.", MSG_NOSPOT = "No se conoce la ubicación de esta receta.", FOOT_SELECT = "Haz clic en una receta para ver sus detalles aquí.",
    FOCUS = { Anvil = "Yunque", Forge = "Forja", Loom = "Telar", ["Cooking Fire"] = "Fuego de cocina", ["Alchemy Lab"] = "Laboratorio de alquimia", ["Tanning Rack"] = "Caballete de curtido", ["Spinning Wheel"] = "Rueca", ["Master Forge"] = "Forja maestra", ["Iron Oven"] = "Horno de hierro" },
    OPT_LOG = "Registrar un log de depuración de los intentos de creación", BTN_SHOWLOG = "Mostrar log (copiar con Ctrl+C)", BTN_CLEARLOG = "Borrar log",
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
    OPT_PROVIDER = "Fuente de precios", OPT_SKIN = "Aspecto", OPT_SCALE = "Escala de la ventana", OPT_ALPHA = "Opacidad de la ventana", OPT_AUTO = "Auto",
    OPT_AHCUT = "Restar el 5% de comisión de la casa de subastas al vender", OPT_VENDOR = "Solo vendedor",
    UNIT_MIN = "min", CRAFT_X = "%d creaciones", ORANGE = "naranja", YELLOW = "amarillo", GREEN = "verde", GREY = "gris",
    LEGEND = "Dificultad: naranja / amarillo / verde / gris",
    CLOSE = "Cerrar", TIP_ROW = "Elige una profesión a la izquierda, define el rango de nivel y lee el plan.",
    PROFS = { alchemy = "Alquimia", blacksmithing = "Herrería", cooking = "Cocina", enchanting = "Encantamiento", engineering = "Ingeniería", firstaid = "Primeros auxilios", leatherworking = "Peletería", mining = "Minería", tailoring = "Sastrería", herbalism = "Herboristería", skinning = "Desuello", fishing = "Pesca" },
    SKINS = { dark = "Oscuro", classic = "Clásico", slate = "Pizarra", forest = "Bosque" },
    NOTE_ESTIMATE = "Las probabilidades de subida son estimadas (naranja 100%, amarillo 75%, verde 25%). Los requisitos vienen de datos públicos; algunos son estimados.",
}
LOC.pt = {
    TAB_CRAFT = "Criação", TAB_GATHER = "Coleta", NORECIPES = "%s não tem receitas de criação. Use a aba Coleta para o guia e as opções.", SKILL = "Perícia",
    OPT_SHOWALL = "Mostrar na lista lateral as profissões que eu não tenho", KEY_USE = "Abrir esta janela com uma tecla (substitui a ação original dessa tecla)",
    KEY_NOTE = "A ação original continua em Shift + a mesma tecla.", KEY_PRESS = "Aperte uma tecla... (Esc cancela)", KEY_BTN = "Tecla: %s (clique para trocar)", BTN_BLIZZ = "Janela da Blizzard",
    GATHER_TITLE = "Guia de coleta", GATHER_INFO = "O Trailsmith aponta o minério e a erva mais próximos que você consegue coletar e desenha no minimapa e no mapa-múndi. Mais opções (recursos, exibição, filtros) estão nas opções completas.",
    G_ENABLED = "Guia de coleta ligado", G_MINE = "Rastrear minérios (Mineração)", G_HERB = "Rastrear ervas (Herborismo)", G_SEED = "Usar o banco de dados inicial", G_AUTOLOOT = "Autosaque de coleta",
    G_AUTOLOOTQ = "Autosaque de missão e ouro", G_AUTOHIDE = "Esconder pontos vazios automaticamente", G_HOVER = "Aprender pontos ao passar o mouse no minimapa", G_RANGE = "Alcance", BTN_FULLOPT = "Abrir opções completas",
    CRAFTOPT = "Opções de criação", MODE_TITLE = "Modo do plano", SRC_TITLE = "Fontes de receitas", PRICE_TITLE = "Preços",
    OPT_AUTOTEXT = "Escalar o texto com o tamanho da janela", BTN_RESETSIZE = "Restaurar tamanho da janela e do texto",
    GO_TRAINER = "Localizar treinador", GO_VENDOR = "Localizar vendedor", FOOT_REQ = "Requer: %s", FOOT_NOREQ = "Não precisa de ferramenta nem estação", FOOT_HAVE = "tem %d",
    BTN_CRAFT = "Criar", BTN_CRAFTALL = "Criar tudo", MSG_CRAFT_OPEN = "Abrindo a janela da profissão. Clique em Criar de novo.", MSG_CRAFT_FAIL = "Não foi possível iniciar a criação. Abra a janela da profissão e tente de novo.",
    MSG_NEAREST = "%s mais próximo: %s em %s (%.1f, %.1f). Marcado no mapa.", MSG_NOSPOT = "Local desta receita desconhecido.", FOOT_SELECT = "Clique numa receita para ver os detalhes aqui.",
    FOCUS = { Anvil = "Bigorna", Forge = "Forja", Loom = "Tear", ["Cooking Fire"] = "Fogueira de cozinha", ["Alchemy Lab"] = "Laboratório de alquimia", ["Tanning Rack"] = "Cavalete de curtimento", ["Spinning Wheel"] = "Roda de fiar", ["Master Forge"] = "Forja mestra", ["Iron Oven"] = "Forno de ferro" },
    OPT_LOG = "Gravar um log de depuração das tentativas de criação", BTN_SHOWLOG = "Mostrar log (copiar com Ctrl+C)", BTN_CLEARLOG = "Limpar log",
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
    OPT_PROVIDER = "Fonte de preços", OPT_SKIN = "Visual", OPT_SCALE = "Escala da janela", OPT_ALPHA = "Opacidade da janela", OPT_AUTO = "Auto",
    OPT_AHCUT = "Descontar os 5% da casa de leilões ao vender", OPT_VENDOR = "Só vendedor",
    UNIT_MIN = "min", CRAFT_X = "%d criações", ORANGE = "laranja", YELLOW = "amarelo", GREEN = "verde", GREY = "cinza",
    LEGEND = "Dificuldade: laranja / amarelo / verde / cinza",
    CLOSE = "Fechar", TIP_ROW = "Clique numa profissão à esquerda, defina a faixa de perícia e leia o plano.",
    PROFS = { alchemy = "Alquimia", blacksmithing = "Ferraria", cooking = "Culinária", enchanting = "Encantamento", engineering = "Engenharia", firstaid = "Primeiros Socorros", leatherworking = "Couraria", mining = "Mineração", tailoring = "Alfaiataria", herbalism = "Herborismo", skinning = "Esfolamento", fishing = "Pesca" },
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
    { key = "herbalism", gather = true, icon = "Interface\\Icons\\Trade_Herbalism" },
    { key = "skinning", gather = true, icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01" },
    { key = "fishing", gather = true, icon = "Interface\\Icons\\Trade_Fishing" },
}
local PROF_BY_KEY = {}
for _, p in ipairs(PROFS) do PROF_BY_KEY[p.key] = p end

local issecret = issecretvalue or function() return false end
local QMARK = "Interface\\Icons\\INV_Misc_QuestionMark"
local DEFAULTS = {
    sel = "mining", skin = "dark", scale = 1, alpha = 0.96, fontText = 1, fontNum = 1, key = "K", useKey = true, showAll = false, autoText = true, w = 980, h = 680, logOn = true, log = {}, provider = "auto", mode = "cheap",
    free = false, knownOnly = false, srcT = true, srcV = true, srcI = false, srcU = false, ahCut = true,
    range = {},
}
local P -- saved settings (GatherTrailDB.prof)

---------------------------------------------------------------- log de depuracao
-- Everything the craft code does is written to GatherTrailDB.prof.log (saved on /reload or logout),
-- so a problem can be diagnosed from the SavedVariables file. View it with /tsp log.
local LOGMAX = 500
local function Log(fmt, ...)
    if not P or P.logOn == false then return end
    local ok, msg = pcall(string.format, fmt, ...)
    if not ok then msg = tostring(fmt) end
    local t = (date and date("%H:%M:%S")) or "--:--:--"
    local log = P.log
    if type(log) ~= "table" then log = {} P.log = log end
    log[#log + 1] = t .. " " .. msg
    if #log > LOGMAX then table.remove(log, 1) end
end
local lastOpt = {}
-- logs an option change once per distinct value (sliders fire many events while dragging)
local function LogOpt(name, value)
    local v = tostring(value)
    if lastOpt[name] == v then return end
    lastOpt[name] = v
    Log("option %s = %s", tostring(name), v)
end
ns.Log = function(...) Log(...) end
ns.LogOpt = LogOpt
local function ErrHandler(e)
    local st = debugstack and debugstack(3, 8, 0) or ""
    return tostring(e) .. "\n" .. st
end
local function Safe(tag, fn)
    return function(...)
        local n = select("#", ...)
        local args = { ... }
        local ok, err = xpcall(function() return fn(unpack(args, 1, n)) end, ErrHandler)
        if not ok then
            Log("ERROR in %s: %s", tag, tostring(err))
            print("|cffff5050Trailsmith:|r error in " .. tag .. " (saved to the log, /tsp log)")
        end
    end
end
local function Env()
    local v, b = "?", "?"
    if GetBuildInfo then local a, bb = GetBuildInfo() v, b = tostring(a), tostring(bb) end
    Log("== session: game %s build %s locale %s", v, b, (GetLocale and GetLocale()) or "?")
    local names = { "GetNumTradeSkills", "DoTradeSkill", "GetTradeSkillInfo", "GetTradeSkillRecipeLink", "GetTradeSkillLine", "CastSpellByID",
        "OpenWorldMap", "RunBinding", "SetOverrideBindingClick", "InCombatLockdown" }
    local have = {}
    for _, n in ipairs(names) do have[#have + 1] = n .. "=" .. tostring(_G[n] ~= nil) end
    Log("globals: %s", table.concat(have, " "))
    local t = _G.C_TradeSkillUI
    if type(t) == "table" then
        local list = {}
        for k, val in pairs(t) do if type(val) == "function" then list[#list + 1] = k end end
        table.sort(list)
        Log("C_TradeSkillUI functions (%d): %s", #list, table.concat(list, ","))
    else
        Log("C_TradeSkillUI: nil")
    end
    for _, fname in ipairs({ "TradeSkillFrame", "ProfessionsFrame", "ProfessionsBookFrame", "CraftFrame", "SpellBookFrame", "SkillFrame" }) do
        local f = _G[fname]
        Log("frame %s: %s", fname, f and (f.IsShown and tostring(f:IsShown()) or "exists") or "nil")
    end
end

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
            local sp, rq, lo, hi, it, qt, src, si, rg, st = line:match("^(%d+)|(%d+)|(%d+)|(%d+)|(%d+)|(%d+)|(%a)|(%d+)|([%d:,]*)|?(%d*)$")
            if sp then
                local r = { spell = tonumber(sp), req = tonumber(rq), low = tonumber(lo), high = tonumber(hi), item = tonumber(it),
                    qty = tonumber(qt), src = src, srcItem = tonumber(si), set = tonumber(st) or 0, reag = {} }
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
        local n = p.spell and SpellName(p.spell)
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

---------------------------------------------------------------- interface (estilo padrao do WoW)
local UI = { tab = "plan", top = "craft", fonts = {}, syncs = {}, factor = 1 }
local DEFW, DEFH, MINW, MINH = 980, 680, 900, 600
local M, TOP, BOT, LEFTW, RIGHTW, GAP = 12, 64, 14, 200, 252, 8
local Locate -- defined further down
local FOOT = 96
local function FootH() return floor(FOOT * max(1, UI.factor or 1)) end
local TIP_BACKDROP = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14, insets = { left = 3, right = 3, top = 3, bottom = 3 },
}
local HILITE = "Interface\\QuestFrame\\UI-QuestTitleHighlight"
local PROVIDER_ORDER = { "auto", "auctionator", "tsm", "auctioneer", "vendor" }

local function TryCreate(kind, name, parent, templates)
    for _, t in ipairs(templates) do
        local ok, made = pcall(CreateFrame, kind, name, parent, t)
        if ok and made then return made end
    end
    return CreateFrame(kind, name, parent)
end

---- fonts: every fontstring scales with the text option and (optionally) with the window size
local function RegFont(obj, kind)
    if not obj or not obj.GetFont then return end
    local path, size, flags = obj:GetFont()
    if type(path) == "string" and type(size) == "number" then
        UI.fonts[#UI.fonts + 1] = { obj, path, size, flags, kind }
        UI.dirtyFonts = true
    end
end
local function Factor(kind)
    local f = UI.frame
    local auto = 1
    if f and P.autoText then auto = max(0.85, min(1.5, f:GetWidth() / DEFW)) end
    return (kind == "num" and (P.fontNum or 1) or (P.fontText or 1)) * auto
end
local lastFontKey
local function ApplyFonts(force)
    local key = ("%.2f|%.2f"):format(Factor("text"), Factor("num"))
    if key == lastFontKey and not force then return end
    lastFontKey = key
    UI.factor = Factor("text")
    for _, e in ipairs(UI.fonts) do
        e[1]:SetFont(e[2], max(6, floor(e[3] * Factor(e[5]) + 0.5)), e[4])
    end
    UI.dirtyFonts = false
end

local function Label(parent, text, font, kind)
    local fs = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    fs:SetJustifyH("LEFT")
    if text then fs:SetText(text) end
    RegFont(fs, kind)
    return fs
end

local function Panel(parent, alpha)
    local f = TryCreate("Frame", nil, parent, { "BackdropTemplate" })
    if f.SetBackdrop then
        f:SetBackdrop(TIP_BACKDROP)
        f:SetBackdropColor(0.03, 0.03, 0.05, alpha or 0.85)
        f:SetBackdropBorderColor(0.6, 0.55, 0.4, 1)
    end
    return f
end

local function Btn(parent, text, w, h, onClick)
    local b = TryCreate("Button", nil, parent, { "UIPanelButtonTemplate" })
    b:SetSize(w, h or 22)
    b:SetText(text or "")
    local fs = b.GetFontString and b:GetFontString()
    if fs then RegFont(fs) b.fs = fs end
    if onClick then
        local tag = "button " .. ((text and text ~= "") and text or "?")
        local safe = Safe(tag, onClick)
        b:SetScript("OnClick", function(self2, ...) Log("click: %s", tag) safe(self2, ...) end)
    end
    return b
end
local function SetSel(b, on)
    if on then b:LockHighlight() else b:UnlockHighlight() end
    if b.fs then if on then b.fs:SetTextColor(1, 1, 1) else b.fs:SetTextColor(1, 0.82, 0) end end
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

local function Check(parent, label, get, set, wrapW)
    local cb = TryCreate("CheckButton", nil, parent, { "UICheckButtonTemplate", "ChatConfigCheckButtonTemplate" })
    cb:SetSize(24, 24)
    local fs = Label(cb, label, "GameFontHighlightSmall")
    if wrapW then
        fs:SetPoint("TOPLEFT", cb, "TOPRIGHT", 2, -5)
        fs:SetWidth(wrapW)
        fs:SetWordWrap(true)
        fs:SetJustifyV("TOP")
    else
        fs:SetPoint("LEFT", cb, "RIGHT", 2, 0)
        fs:SetPoint("RIGHT", parent, "RIGHT", -8, 0)
        fs:SetJustifyV("MIDDLE")
    end
    cb.label = fs
    cb:SetScript("OnClick", Safe("checkbox " .. tostring(label), function(self)
        local v = self:GetChecked() and true or false
        Log("checkbox: %s = %s", tostring(label), tostring(v))
        set(v)
    end))
    cb.Sync = function() cb:SetChecked(get()) end
    UI.syncs[#UI.syncs + 1] = cb.Sync
    return cb
end

local sliderN = 0
local function Slider(parent, label, lo, hi, step, get, set, fmt)
    sliderN = sliderN + 1
    local name = "TrailsmithProfSlider" .. sliderN
    local box = CreateFrame("Frame", nil, parent)
    box:SetHeight(40)
    local cap = Label(box, label, "GameFontNormalSmall")
    cap:SetPoint("TOPLEFT", 0, 0)
    local val = Label(box, "", "GameFontHighlightSmall", "num")
    val:SetPoint("TOPRIGHT", 0, 0)
    val:SetJustifyH("RIGHT")
    local s = TryCreate("Slider", name, box, { "OptionsSliderTemplate", "MinimalSliderTemplate" })
    for _, suf in ipairs({ "Low", "High", "Text" }) do
        local extra = _G[name .. suf]
        if extra then extra:SetText("") extra:Hide() end
    end
    s:SetOrientation("HORIZONTAL")
    s:SetPoint("TOPLEFT", 4, -18)
    s:SetPoint("TOPRIGHT", -4, -18)
    s:SetHeight(16)
    s:SetMinMaxValues(lo, hi)
    s:SetValueStep(step)
    if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
    local function show(v) val:SetText(fmt and fmt(v) or ("%.2f"):format(v)) end
    s:SetScript("OnValueChanged", function(self, v)
        v = floor(v / step + 0.5) * step
        show(v)
        if self.syncing then return end
        LogOpt("slider " .. tostring(label), v)
        set(v)
    end)
    box.Sync = function()
        s.syncing = true
        local v = get()
        s:SetValue(v)
        s.syncing = false
        show(v)
    end
    UI.syncs[#UI.syncs + 1] = box.Sync
    return box
end

-- vertical stack of controls whose spacing follows the text size
local function NewStack(parent, x, y0, width)
    local st = { items = {}, parent = parent, x = x, y0 = y0, width = width }
    function st:Add(frame, h, dx, gap, stretch, hfn)
        self.items[#self.items + 1] = { f = frame, h = h, dx = dx or 0, gap = gap or 4, stretch = stretch, hfn = hfn }
        return frame
    end
    function st:Layout()
        local y = self.y0
        local fct = UI.factor or 1
        for _, it in ipairs(self.items) do
            y = y + (it.gapBefore or 0)
            it.f:ClearAllPoints()
            it.f:SetPoint("TOPLEFT", self.parent, "TOPLEFT", self.x + it.dx, -y)
            if it.stretch then it.f:SetPoint("TOPRIGHT", self.parent, "TOPRIGHT", -self.x, -y) end
            local hh = floor(it.h * fct + 0.5)
            if it.hfn then hh = max(hh, floor(it.hfn() + 6)) end
            y = y + hh + it.gap
        end
    end
    return st
end

---------------------------------------------------------------- listas virtuais
local function NewList(parent, topOff, heightFn, makeRow, fillRow, layoutRow, baseH)
    local list = { data = {}, offset = 0, rows = {}, n = 1 }
    local view = CreateFrame("Frame", nil, parent)
    view:SetPoint("TOPLEFT", 0, -topOff)
    view:SetPoint("BOTTOMRIGHT", -18, 0)
    view:EnableMouseWheel(true)
    local sb = TryCreate("Slider", nil, parent, { "BackdropTemplate" })
    sb:SetPoint("TOPRIGHT", 0, -topOff)
    sb:SetPoint("BOTTOMRIGHT", 0, 0)
    sb:SetWidth(14)
    if sb.SetBackdrop then
        sb:SetBackdrop(TIP_BACKDROP)
        sb:SetBackdropColor(0, 0, 0, 0.5)
        sb:SetBackdropBorderColor(0.5, 0.45, 0.3, 1)
    end
    sb:SetOrientation("VERTICAL")
    sb:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
    local th = sb:GetThumbTexture()
    if th then th:SetSize(18, 24) end
    sb:SetMinMaxValues(0, 1)
    sb:SetValueStep(1)
    sb:SetValue(0)
    function list:Layout()
        local h = heightFn() - topOff
        local rh = max(16, floor(baseH * (UI.factor or 1) + 0.5))
        local n = max(1, floor(h / rh))
        self.n, self.rh = n, rh
        for i = 1, n do
            local row = self.rows[i]
            if not row then row = makeRow(view) self.rows[i] = row end
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 0, -(i - 1) * rh)
            row:SetPoint("TOPRIGHT", 0, -(i - 1) * rh)
            row:SetHeight(rh - 1)
            if layoutRow then layoutRow(row, rh) end
        end
        for i = n + 1, #self.rows do self.rows[i]:Hide() end
    end
    function list:Update()
        local total = #self.data
        local maxOff = max(0, total - self.n)
        if self.offset > maxOff then self.offset = maxOff end
        self.syncing = true
        sb:SetMinMaxValues(0, max(1, maxOff))
        sb:SetValue(self.offset)
        self.syncing = false
        sb:SetShown(maxOff > 0)
        for i = 1, self.n do
            local d = self.data[self.offset + i]
            local row = self.rows[i]
            if row then
                if d then fillRow(row, d, self.offset + i) row:Show() else row:Hide() end
            end
        end
    end
    function list:SetData(d, keep)
        self.data = d
        if not keep then self.offset = 0 end
        self:Layout()
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

local function RowBase(parent)
    local row = CreateFrame("Button", nil, parent)
    row.bg = row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints()
    row.sep = row:CreateTexture(nil, "BORDER")
    row.sep:SetPoint("BOTTOMLEFT")
    row.sep:SetPoint("BOTTOMRIGHT")
    row.sep:SetHeight(1)
    if row.sep.SetColorTexture then row.sep:SetColorTexture(1, 1, 1, 0.08) else row.sep:SetTexture(1, 1, 1, 0.08) end
    row:SetHighlightTexture(HILITE, "ADD")
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetPoint("LEFT", 4, 0)
    row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    return row
end
local function Zebra(row, idx)
    local a = (idx % 2 == 0) and 0.14 or 0
    if row.bg.SetColorTexture then row.bg:SetColorTexture(1, 1, 1, a) else row.bg:SetTexture(1, 1, 1, a) end
end
local function IconSize(row, rh) local s = min(40, max(14, rh - 8)) row.icon:SetSize(s, s) end

---------------------------------------------------------------- dados da interface
local current
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
local function FormatTime(secs)
    local m = ceil(secs / 60)
    if m >= 60 then return ("%dh %02d%s"):format(floor(m / 60), m % 60, S.UNIT_MIN) end
    return ("%d %s"):format(m, S.UNIT_MIN)
end
local function ItemOrSpellTip(tt, r)
    if r.item and r.item > 0 then tt:SetHyperlink("item:" .. r.item) else tt:SetHyperlink("spell:" .. r.spell) end
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
local function Recompute()
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
        out[#out + 1] = { id = id, need = ceil(n - 0.0001), have = ItemCount(id), cost = c }
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

---------------------------------------------------------------- linhas
local function MakePlanRow(parent)
    local row = RowBase(parent)
    row.cost = Label(row, nil, "GameFontHighlight", "num")
    row.cost:SetPoint("TOPRIGHT", -8, -4)
    row.cost:SetJustifyH("RIGHT")
    row.sub = Label(row, nil, "GameFontHighlightSmall", "num")
    row.sub:SetPoint("BOTTOMRIGHT", -8, 4)
    row.sub:SetJustifyH("RIGHT")
    row.sub:SetTextColor(0.7, 0.7, 0.7)
    row.go = Btn(row, "", 130, 20, function(b) if row.rec then Locate(row.rec) end end)
    row.go:SetPoint("RIGHT", row.cost, "LEFT", -10, 0)
    row.go:Hide()
    row.t1 = Label(row, nil, "GameFontHighlight")
    row.t1:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 8, 0)
    row.t1:SetPoint("RIGHT", row.cost, "LEFT", -8, 0)
    row.t1:SetWordWrap(false)
    row.t2 = Label(row, nil, "GameFontHighlightSmall")
    row.t2:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 8, 0)
    row.t2:SetPoint("RIGHT", row.sub, "LEFT", -8, 0)
    row.t2:SetWordWrap(false)
    Tip(row, function(tt, self) if self.rec then ItemOrSpellTip(tt, self.rec) end end)
    row:SetScript("OnClick", function(self) if self.rec then UI:Select(self.rec, self.crafts) end end)
    return row
end
local function FillPlanRow(row, st, idx)
    Zebra(row, idx)
    if st.gap then
        row.rec = nil
        row.icon:SetTexture(QMARK)
        row.t1:SetText(("|cffff5050%d – %d|r"):format(st.from, st.to))
        row.t2:SetTextColor(1, 0.6, 0.5)
        row.t2:SetText(S.NOREC:format(st.from, st.to))
        row.cost:SetText("")
        row.sub:SetText("")
        row.go:Hide()
        row.t1:ClearAllPoints()
        row.t1:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 8, 0)
        row.t1:SetPoint("RIGHT", row.cost, "LEFT", -8, 0)
        row.t2:ClearAllPoints()
        row.t2:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 8, 0)
        row.t2:SetPoint("RIGHT", row.sub, "LEFT", -8, 0)
        return
    end
    local r = st.r
    row.rec = r
    row.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
    local col = BandColor(r, st.from)
    local name = SpellName(r.spell) or (r.item > 0 and ItemName(r.item)) or ("#" .. r.spell)
    row.t1:SetText(("|c%s%d – %d|r   %s"):format(col, st.from, st.to, name))
    row.t2:SetTextColor(0.7, 0.7, 0.7)
    row.t2:SetText(MatLine(r, st.crafts))
    row.cost:SetText(st.miss and ("|cffff8080" .. S.NOPRICE .. "|r") or Money(st.cost))
    row.sub:SetText(S.CRAFT_X:format(st.crafts))
    row.crafts = st.crafts
    local canLocate = (not st.known) and r.set and r.set > 0 and (r.src == "t" or r.src == "v")
    row.t1:ClearAllPoints()
    row.t1:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 8, 0)
    row.t2:ClearAllPoints()
    row.t2:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 8, 0)
    if canLocate then
        row.go:SetText(r.src == "v" and S.GO_VENDOR or S.GO_TRAINER)
        local w = row.go.fs and row.go.fs:GetStringWidth() or 100
        row.go:SetWidth(max(90, floor(w + 24)))
        row.go:Show()
        row.t1:SetPoint("RIGHT", row.go, "LEFT", -8, 0)
        row.t2:SetPoint("RIGHT", row.go, "LEFT", -8, 0)
    else
        row.go:Hide()
        row.t1:SetPoint("RIGHT", row.cost, "LEFT", -8, 0)
        row.t2:SetPoint("RIGHT", row.sub, "LEFT", -8, 0)
    end
    if UI.sel and UI.sel.r == r then
        if row.bg.SetColorTexture then row.bg:SetColorTexture(1, 0.8, 0.2, 0.16) else row.bg:SetTexture(1, 0.8, 0.2, 0.16) end
    end
end
local function LayoutPlanRow(row, rh) IconSize(row, rh) end

-- columns anchored from the right edge; widths follow the text size
local function MatCols(o, rh)
    local f = UI.factor or 1
    o.total:SetWidth(floor(104 * f))
    o.miss:SetWidth(floor(58 * f))
    o.have:SetWidth(floor(58 * f))
    o.need:SetWidth(floor(58 * f))
end
local function MakeMatCols(row, font, kind, anchorIcon)
    row.total = Label(row, nil, font, kind)
    row.total:SetPoint("RIGHT", -8, 0)
    row.total:SetJustifyH("RIGHT")
    row.miss = Label(row, nil, font, kind)
    row.miss:SetPoint("RIGHT", row.total, "LEFT", -4, 0)
    row.have = Label(row, nil, font, kind)
    row.have:SetPoint("RIGHT", row.miss, "LEFT", -4, 0)
    row.need = Label(row, nil, font, kind)
    row.need:SetPoint("RIGHT", row.have, "LEFT", -4, 0)
    row.need:SetJustifyH("RIGHT")
    row.have:SetJustifyH("RIGHT")
    row.miss:SetJustifyH("RIGHT")
    row.name = Label(row, nil, font == "GameFontNormalSmall" and font or "GameFontHighlight")
    row.name:SetPoint("LEFT", anchorIcon or row, anchorIcon and "RIGHT" or "LEFT", anchorIcon and 8 or 8, 0)
    row.name:SetPoint("RIGHT", row.need, "LEFT", -6, 0)
    row.name:SetWordWrap(false)
end
local function MakeMatRow(parent)
    local row = RowBase(parent)
    MakeMatCols(row, "GameFontHighlight", "num", row.icon)
    Tip(row, function(tt, self) if self.id then tt:SetHyperlink("item:" .. self.id) end end)
    return row
end
local function FillMatRow(row, m, idx)
    Zebra(row, idx)
    row.id = m.id
    row.icon:SetTexture(ItemIcon(m.id))
    row.name:SetText(ItemName(m.id) or ("#" .. m.id))
    row.need:SetText(tostring(m.need))
    row.have:SetText(tostring(m.have))
    local miss = max(0, m.need - m.have)
    row.miss:SetText(miss > 0 and ("|cffff8080" .. miss .. "|r") or "|cff40c040OK|r")
    row.total:SetText(m.cost and Money(m.cost * miss) or ("|cffff8080" .. S.NOPRICE .. "|r"))
end
local function LayoutMatRow(row, rh) IconSize(row, rh) MatCols(row, rh) end

local function RecCols(o)
    local f = UI.factor or 1
    o.cost:SetWidth(floor(104 * f))
    o.src:SetWidth(floor(122 * f))
    o.bands:SetWidth(floor(132 * f))
end
local function MakeRecRow(parent)
    local row = RowBase(parent)
    row.cost = Label(row, nil, "GameFontHighlightSmall", "num")
    row.cost:SetPoint("RIGHT", -8, 0)
    row.cost:SetJustifyH("RIGHT")
    row.src = Label(row, nil, "GameFontHighlightSmall")
    row.src:SetPoint("RIGHT", row.cost, "LEFT", -4, 0)
    row.src:SetWordWrap(false)
    row.bands = Label(row, nil, "GameFontHighlightSmall", "num")
    row.bands:SetPoint("RIGHT", row.src, "LEFT", -4, 0)
    row.name = Label(row, nil, "GameFontHighlight")
    row.name:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
    row.name:SetPoint("RIGHT", row.bands, "LEFT", -6, 0)
    row.name:SetWordWrap(false)
    Tip(row, function(tt, self) if self.rec then ItemOrSpellTip(tt, self.rec) end end)
    row:SetScript("OnClick", function(self) if self.rec then UI:Select(self.rec, 1) end end)
    return row
end
local function FillRecRow(row, d, idx)
    Zebra(row, idx)
    local r = d.r
    row.rec = r
    row.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
    local name = SpellName(r.spell) or (r.item > 0 and ItemName(r.item)) or ("#" .. r.spell)
    row.name:SetText((d.known and "|cff40c040" or "") .. name .. (d.known and "|r" or ""))
    if UI.sel and UI.sel.r == r then
        if row.bg.SetColorTexture then row.bg:SetColorTexture(1, 0.8, 0.2, 0.16) else row.bg:SetTexture(1, 0.8, 0.2, 0.16) end
    end
    local mid = floor((r.low + r.high) / 2)
    row.bands:SetText(("|cffff8040%d|r |cffffff00%d|r |cff40c040%d|r |cff808080%d|r"):format(r.req, r.low, mid, r.high))
    row.src:SetText(d.known and S.KNOWN or SrcLabel(r))
    row.cost:SetText(d.miss and ("|cffff8080" .. S.NOPRICE .. "|r") or Money(d.cost))
end
local function LayoutRecRow(row, rh) IconSize(row, rh) RecCols(row) end

---------------------------------------------------------------- busca global
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
    local box = TryCreate("EditBox", nil, f, { "InputBoxTemplate" })
    box:SetSize(250, 20)
    box:SetPoint("TOPRIGHT", f, "TOPRIGHT", -M - 6, -36)
    box:SetAutoFocus(false)
    box:SetTextInsets(6, 6, 0, 0)
    RegFont(box)
    self.topBox = box
    local ph = Label(box, S.SEARCH_TOP, "GameFontHighlightSmall")
    ph:SetPoint("LEFT", 8, 0)
    ph:SetTextColor(0.5, 0.5, 0.5)
    local dd = Panel(f, 0.97)
    dd:SetPoint("TOPRIGHT", box, "BOTTOMRIGHT", 0, -2)
    dd:SetSize(360, 10)
    dd:SetFrameStrata("DIALOG")
    dd:Hide()
    self.dropdown = dd
    dd.rows = {}
    local N = 9
    for i = 1, N do
        local b = CreateFrame("Button", nil, dd)
        b:SetPoint("TOPLEFT", 6, -6 - (i - 1) * 24)
        b:SetPoint("TOPRIGHT", -6, -6 - (i - 1) * 24)
        b:SetHeight(23)
        b:SetHighlightTexture(HILITE, "ADD")
        local ic = b:CreateTexture(nil, "ARTWORK")
        ic:SetSize(20, 20)
        ic:SetPoint("LEFT", 2, 0)
        ic:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        b.icon = ic
        b.prof = Label(b, nil, "GameFontNormalSmall")
        b.prof:SetPoint("RIGHT", -4, 0)
        b.prof:SetJustifyH("RIGHT")
        b.name = Label(b, nil, "GameFontHighlightSmall")
        b.name:SetPoint("LEFT", ic, "RIGHT", 6, 0)
        b.name:SetPoint("RIGHT", b.prof, "LEFT", -6, 0)
        b.name:SetWordWrap(false)
        b:SetScript("OnClick", function(self2)
            local e = self2.entry
            if type(e) ~= "table" then return end
            Log("search result chosen: %s (%s)", tostring(e.name), tostring(e.key))
            P.sel = e.key
            UI.top, UI.tab = "craft", "recipes"
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
            local r1 = dd.rows[1]
            r1.entry = nil
            r1.icon:SetTexture(QMARK)
            r1.name:SetText(S.RESULT_NONE)
            r1.prof:SetText("")
            r1:Show()
            for i = 2, N do dd.rows[i]:Hide() end
            n = 1
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
        dd:SetHeight(12 + n * 24)
        dd:Show()
    end
    box:SetScript("OnTextChanged", function(self2, user)
        if user then LogOpt("search text", self2:GetText() or "") end
        Update()
    end)
    box:SetScript("OnEscapePressed", function(s2) s2:SetText("") s2:ClearFocus() dd:Hide() end)
    box:SetScript("OnEnterPressed", function()
        local first = dd.rows[1]
        if first and first:IsShown() and type(first.entry) == "table" then first:Click() end
    end)
end

---------------------------------------------------------------- localizar treinador / vendedor
local spotCache = {}
local function Spot(idx)
    local c = spotCache[idx]
    if c then return c end
    local line = ns.Spots and ns.Spots[idx]
    if not line then return nil end
    local name, fac, ui, x, y = line:match("^(.-)|(%d)|(%d+)|(%d+)|(%d+)$")
    if not name then return nil end
    c = { name = name, fac = tonumber(fac), ui = tonumber(ui), x = tonumber(x) / 10000, y = tonumber(y) / 10000 }
    spotCache[idx] = c
    return c
end

local function WorldOf(ui, x, y)
    if C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D then
        local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, ui, CreateVector2D(x, y))
        if ok and cont and type(pos) == "table" and pos.GetXY then
            local wx, wy = pos:GetXY()
            return cont, wx, wy
        end
    end
end

local function NearestSpot(setId)
    local list = ns.SpotSets and ns.SpotSets[setId]
    if not list then return nil end
    local faction = UnitFactionGroup and UnitFactionGroup("player")
    local myMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local mx, my
    if myMap and C_Map.GetPlayerMapPosition then
        local pos = C_Map.GetPlayerMapPosition(myMap, "player")
        if pos and pos.GetXY then mx, my = pos:GetXY() end
    end
    local pc, pwx, pwy
    if myMap and mx then pc, pwx, pwy = WorldOf(myMap, mx, my) end
    local best, bestD
    for id in list:gmatch("%d+") do
        local sp = Spot(tonumber(id))
        if sp then
            local ok = sp.fac == 0 or (faction == "Alliance" and sp.fac == 1) or (faction == "Horde" and sp.fac == 2) or not faction
            if ok then
                local d = 1e12
                if pc then
                    local c, wx, wy = WorldOf(sp.ui, sp.x, sp.y)
                    if c == pc and wx then d = ((wx - pwx) ^ 2 + (wy - pwy) ^ 2) ^ 0.5
                    elseif c then d = 1e9 end
                elseif myMap and sp.ui == myMap and mx then
                    d = ((sp.x - mx) ^ 2 + (sp.y - my) ^ 2) ^ 0.5 * 1000
                end
                if not bestD or d < bestD then best, bestD = sp, d end
            end
        end
    end
    return best
end

local pin
local function UpdatePin()
    if not pin or not pin.spot then return end
    local wm = _G.WorldMapFrame
    if not wm or not wm:IsShown() then pin:Hide() return end
    local mapID = wm.GetMapID and wm:GetMapID()
    local parent = pin:GetParent()
    if mapID ~= pin.spot.ui or not parent or not parent.GetWidth then pin:Hide() return end
    pin:ClearAllPoints()
    pin:SetPoint("CENTER", parent, "TOPLEFT", pin.spot.x * parent:GetWidth(), -pin.spot.y * parent:GetHeight())
    pin:Show()
end
local function PlacePin(sp)
    local wm = _G.WorldMapFrame
    if not wm then return end
    local parent = (wm.GetCanvas and wm:GetCanvas()) or (wm.ScrollContainer and wm.ScrollContainer.Child) or wm
    if not pin then
        pin = CreateFrame("Frame", nil, parent)
        pin:SetSize(30, 30)
        pin:SetFrameStrata("TOOLTIP")
        local t = pin:CreateTexture(nil, "OVERLAY")
        t:SetAllPoints()
        t:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon")
        pin:EnableMouse(true)
        pin:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(self.spot and self.spot.name or "", 1, 0.82, 0)
            GameTooltip:Show()
        end)
        pin:SetScript("OnLeave", function() GameTooltip:Hide() end)
        pcall(hooksecurefunc, wm, "OnMapChanged", UpdatePin)
        wm:HookScript("OnShow", UpdatePin)
    end
    pin:SetParent(parent)
    pin.spot = sp
    UpdatePin()
end

Locate = function(r)
    Log("locate requested: spell %s set %s src %s", tostring(r and r.spell), tostring(r and r.set), tostring(r and r.src))
    local sp = r and r.set and r.set > 0 and NearestSpot(r.set)
    Log("  nearest: %s", sp and (sp.name .. " ui " .. sp.ui .. " " .. sp.x .. "," .. sp.y) or "none")
    if not sp then print("|cffffd100Trailsmith:|r " .. S.MSG_NOSPOT) return end
    local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(sp.ui)
    local zone = info and info.name or tostring(sp.ui)
    print("|cffffd100Trailsmith:|r " .. S.MSG_NEAREST:format(r.src == "v" and S.SRC_V or S.SRC_T, sp.name, zone, sp.x * 100, sp.y * 100))
    pcall(function()
        if OpenWorldMap then OpenWorldMap(sp.ui)
        elseif _G.WorldMapFrame then
            if ShowUIPanel then ShowUIPanel(_G.WorldMapFrame) else _G.WorldMapFrame:Show() end
            _G.WorldMapFrame:SetMapID(sp.ui)
        end
    end)
    pcall(function()
        if C_Map and C_Map.CanSetUserWaypointOnMap and C_Map.CanSetUserWaypointOnMap(sp.ui) and UiMapPoint then
            C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(sp.ui, sp.x, sp.y))
            if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then C_SuperTrack.SetSuperTrackedUserWaypoint(true) end
        end
    end)
    pcall(function()
        local tt = _G.TomTom
        if tt and tt.AddWaypoint then tt:AddWaypoint(sp.ui, sp.x, sp.y, { title = sp.name, persistent = false, minimap = true, world = true }) end
    end)
    pcall(PlacePin, sp)
end
ns.Prof.Locate = Locate
ns.Prof.NearestSpot = NearestSpot

local function FocusLabel(spell)
    local id = ns.RecipeFocus and ns.RecipeFocus[spell]
    if not id then return nil end
    local en = ns.FocusNames and ns.FocusNames[id]
    if not en then return nil end
    local t = LOC[lang].FOCUS
    return (t and t[en]) or en
end

-- best-effort crafting through whichever trade skill API the client has
local function CraftProbe(r)
    local name = SpellName(r.spell)
    Log("craft probe: spell %d (%s) item %d known=%s sel=%s", r.spell, tostring(name), r.item or 0, tostring(SpellKnown(r.spell)), tostring(P and P.sel))
    for _, rg in ipairs(r.reag) do
        Log("  reagent %d x%d (%s) have %d", rg[1], rg[2], tostring(ItemName(rg[1])), (GetItemCount and GetItemCount(rg[1])) or -1)
    end
    for _, fname in ipairs({ "TradeSkillFrame", "ProfessionsFrame", "CraftFrame" }) do
        local f = _G[fname]
        if f and f.IsShown then Log("  frame %s shown=%s", fname, tostring(f:IsShown())) end
    end
    local T = _G.C_TradeSkillUI
    if type(T) == "table" then
        for _, fn in ipairs({ "IsTradeSkillReady", "IsTradeSkillLinked", "IsNPCCrafting", "GetTradeSkillLine" }) do
            if T[fn] then local ok, a, b2 = pcall(T[fn]) Log("  C_TradeSkillUI.%s -> ok=%s %s %s", fn, tostring(ok), tostring(a), tostring(b2)) end
        end
        if T.GetBaseProfessionInfo then
            local ok, info = pcall(T.GetBaseProfessionInfo)
            if ok and type(info) == "table" then
                local parts = {}
                for k, v in pairs(info) do parts[#parts + 1] = tostring(k) .. "=" .. tostring(v) end
                Log("  base profession info: %s", table.concat(parts, " "))
            else Log("  GetBaseProfessionInfo -> ok=%s %s", tostring(ok), tostring(info)) end
        end
        if T.GetRecipeInfo then
            local ok, info = pcall(T.GetRecipeInfo, r.spell)
            if ok and type(info) == "table" then
                local parts = {}
                for k, v in pairs(info) do if type(v) ~= "table" then parts[#parts + 1] = tostring(k) .. "=" .. tostring(v) end end
                table.sort(parts)
                Log("  recipe info: %s", table.concat(parts, " "))
            else Log("  GetRecipeInfo(%d) -> ok=%s %s", r.spell, tostring(ok), tostring(info)) end
        end
        if T.GetAllRecipeIDs then
            local ok, ids = pcall(T.GetAllRecipeIDs)
            if ok and type(ids) == "table" then
                local found = false
                for _, id in ipairs(ids) do if id == r.spell then found = true break end end
                Log("  GetAllRecipeIDs: %d ids, contains this spell: %s", #ids, tostring(found))
            end
        end
    end
    if GetNumTradeSkills then
        local n = GetNumTradeSkills()
        Log("  GetNumTradeSkills = %s", tostring(n))
    end
end

local function TryCraft(r, count)
    Log("---- craft requested: spell %d x%d", r.spell, count)
    pcall(CraftProbe, r)
    local T = _G.C_TradeSkillUI
    if T and T.CraftRecipe then
        local ok, err = pcall(T.CraftRecipe, r.spell, count)
        Log("C_TradeSkillUI.CraftRecipe(%d, %d) -> ok=%s err=%s", r.spell, count, tostring(ok), tostring(err))
        if ok then return true end
    else
        Log("C_TradeSkillUI.CraftRecipe not available")
    end
    if GetNumTradeSkills and DoTradeSkill and GetTradeSkillInfo then
        local total = GetNumTradeSkills() or 0
        Log("classic path: scanning %d trade skill entries", total)
        for i = 1, total do
            local name, kind = GetTradeSkillInfo(i)
            if kind ~= "header" then
                local link = GetTradeSkillRecipeLink and GetTradeSkillRecipeLink(i)
                local id = link and tonumber(link:match("enchant:(%d+)") or link:match("spell:(%d+)"))
                if i <= 5 then Log("  entry %d: %s kind=%s link=%s id=%s", i, tostring(name), tostring(kind), tostring(link), tostring(id)) end
                if id == r.spell then
                    local ok, err = pcall(DoTradeSkill, i, count)
                    Log("DoTradeSkill(%d, %d) -> ok=%s err=%s", i, count, tostring(ok), tostring(err))
                    return ok
                end
            end
        end
        Log("classic path: recipe not found in the open trade skill list")
    else
        Log("classic trade skill API not available")
    end
    return false
end
local function CanMake(r)
    local n
    for _, rg in ipairs(r.reag) do
        local m = floor((GetItemCount and GetItemCount(rg[1]) or 0) / rg[2])
        if not n or m < n then n = m end
    end
    return n or 0
end

---------------------------------------------------------------- tecla de atalho
local keyOwner, toggleBtn
local function ApplyKey()
    if InCombatLockdown and InCombatLockdown() then UI.keyPending = true return end
    UI.keyPending = false
    if not P or not SetOverrideBindingClick then Log("ApplyKey: override binding API missing") return end
    Log("ApplyKey: key=%s use=%s", tostring(P.key), tostring(P.useKey))
    if not keyOwner then
        keyOwner = CreateFrame("Frame")
        toggleBtn = CreateFrame("Button", "TrailsmithProfToggle", UIParent)
        toggleBtn:RegisterForClicks("AnyUp")
        toggleBtn:SetScript("OnClick", function() ns.OpenProf() end)
    end
    if ClearOverrideBindings then ClearOverrideBindings(keyOwner) end
    if P.useKey and P.key and P.key ~= "" then
        if GetBindingAction and SetOverrideBinding and not P.key:find("-", 1, true) then
            local orig = GetBindingAction(P.key)
            if orig and orig ~= "" then UI.origAction = orig end
            local alt = "SHIFT-" .. P.key
            if orig and orig ~= "" and not orig:find("TrailsmithProfToggle", 1, true) and (GetBindingAction(alt) or "") == "" then
                SetOverrideBinding(keyOwner, false, alt, orig)
            end
        end
        SetOverrideBindingClick(keyOwner, false, P.key, "TrailsmithProfToggle")
    end
end
ns.ApplyProfKey = ApplyKey
function ns.OpenBlizzProf()
    local a = UI.origAction
    if a and a ~= "" and RunBinding then RunBinding(a) end
end

local capture
local function StartCapture(onDone)
    if not capture then
        capture = CreateFrame("Frame", nil, UIParent)
        capture:SetFrameStrata("TOOLTIP")
        capture:SetScript("OnKeyDown", function(self2, k)
            if k == "LSHIFT" or k == "RSHIFT" or k == "LCTRL" or k == "RCTRL" or k == "LALT" or k == "RALT" then return end
            self2:EnableKeyboard(false)
            if k ~= "ESCAPE" then
                local pre = ""
                if IsAltKeyDown() then pre = pre .. "ALT-" end
                if IsControlKeyDown() then pre = pre .. "CTRL-" end
                if IsShiftKeyDown() then pre = pre .. "SHIFT-" end
                P.key = pre .. k
                Log("key binding captured: %s", P.key)
            end
            if capture.done then capture.done() end
        end)
    end
    capture.done = onDone
    capture:EnableKeyboard(true)
    if capture.SetPropagateKeyboardInput then capture:SetPropagateKeyboardInput(false) end
end

---------------------------------------------------------------- Refresh
local function Close() if UI.frame then UI.frame:Hide() end end
local function Heading(parent, text) return Label(parent, text, "GameFontNormal") end

function UI:LayoutCraft()
    local f = self.frame
    if not f or not self.cards then return end
    local cw = f:GetWidth() - 2 * M - LEFTW - RIGHTW - 2 * GAP
    local w = floor((cw - 4 * 6) / 5)
    local ch = floor(46 * max(1, UI.factor or 1))
    for i, key in ipairs({ "points", "crafts", "cost", "time", "net" }) do
        local c = self.cards[key]
        c:ClearAllPoints()
        c:SetPoint("TOPLEFT", self.craftPane, "TOPLEFT", (i - 1) * (w + 6), -32)
        c:SetSize(w, ch)
    end
    self.subY = 32 + ch + 8
    for i, b in ipairs(self.tabBtns) do
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", self.craftPane, "TOPLEFT", (i - 1) * 114, -self.subY)
    end
    self.listTop = self.subY + 28
    for _, p in ipairs({ self.planPane, self.matPane, self.recPane }) do
        p:ClearAllPoints()
        p:SetPoint("TOPLEFT", self.craftPane, "TOPLEFT", 0, -self.listTop)
        p:SetPoint("BOTTOMRIGHT", self.craftPane, "BOTTOMRIGHT", 0, FootH() + 8)
    end
    self.foot:SetHeight(FootH())
    self.matHeader:ClearAllPoints()
    self.matHeader:SetPoint("TOPLEFT", self.matPane, "TOPLEFT", 0, 0)
    self.matHeader:SetPoint("TOPRIGHT", self.matPane, "TOPRIGHT", -18, 0)
    self.matHeader:SetHeight(20)
    MatCols(self.matHeader)
end
local function ListHeight() return (UI.frame:GetHeight() - TOP - BOT) - (UI.listTop or 120) - FootH() - 8 end

function UI:Refresh()
    if not self.frame or not self.frame:IsShown() then return end
    ReadSkills()
    ApplyFonts(UI.dirtyFonts)
    local key = P.sel
    local def = PROF_BY_KEY[key]
    local sk = skills[key]
    local craft = self.top == "craft"
    for _, b in ipairs(self.topBtns) do SetSel(b, b.top == self.top) end
    self.leftPanel:SetShown(craft)
    self.rightPanel:SetShown(craft)
    self.craftPane:SetShown(craft)
    self.gatherPane:SetShown(self.top == "gather")
    self.setPane:SetShown(self.top == "settings")
    if self.top == "gather" then
        self.gatherStack:Layout()
        local m, h = skills.mining, skills.herbalism
        self.gatherSkill:SetText(("%s: %s     %s: %s"):format(ProfLabel("mining"), m and (m.rank .. "/" .. m.max) or "—",
            ProfLabel("herbalism"), h and (h.rank .. "/" .. h.max) or "—"))
    elseif self.top == "settings" then
        self.setStack:Layout()
    end
    for _, s in ipairs(self.syncs) do s() end
    if not craft then return end

    -- profession list
    local fct = UI.factor or 1
    local rh = floor(40 * fct + 0.5)
    local n = 0
    for _, b in ipairs(self.profBtns) do
        local s = skills[b.key]
        local show = s or P.showAll or b.key == key
        if show then
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", self.leftPanel, "TOPLEFT", 6, -6 - n * rh)
            b:SetPoint("TOPRIGHT", self.leftPanel, "TOPRIGHT", -6, -6 - n * rh)
            b:SetHeight(rh - 2)
            local isz = min(rh - 8, 36)
            b.icon:SetSize(isz, isz)
            b:Show()
            n = n + 1
        else
            b:Hide()
        end
        b.sel:SetShown(b.key == key)
        b.rank:SetText(s and ("%d / %d"):format(s.rank, s.max) or "|cff808080—|r")
        if b.icon.SetDesaturated then b.icon:SetDesaturated(not s) end
        b.icon:SetAlpha(s and 1 or 0.5)
    end
    -- right panel
    self.optStack:Layout()
    for _, b in ipairs(self.modeBtns) do SetSel(b, b.mode == P.mode) end

    local crafting = not (def and def.gather)
    self.craftBody:SetShown(crafting)
    self.noRec:SetShown(not crafting)
    if not crafting then
        self.noRec:SetText(S.NORECIPES:format(ProfLabel(key)) .. "\n\n" .. S.SKILL .. ": " .. (sk and ("%d / %d"):format(sk.rank, sk.max) or "—"))
        return
    end
    Recompute()
    self:LayoutCraft()
    local rg = P.range[key]
    self.fromBox:SetText(tostring(rg.from))
    self.toBox:SetText(tostring(rg.to))
    for _, b in ipairs(self.tabBtns) do SetSel(b, b.tab == self.tab) end
    local p = current
    self.cards.points.v:SetText(tostring(p.points))
    self.cards.crafts.v:SetText(tostring(p.crafts))
    self.cards.cost.v:SetText(p.missing and (Money(p.cost) .. " |cffff8080+?|r") or Money(p.cost))
    self.cards.time.v:SetText(FormatTime(p.secs))
    self.cards.net.v:SetText(Money(p.net))
    self.priceLine:SetText(p.provider and S.PRICES:format(p.provider) or S.PRICES_NONE)
    self.noProf:SetText(sk and "" or S.NOPROF)
    self:RefreshFoot()
    self.planPane:SetShown(self.tab == "plan")
    self.matPane:SetShown(self.tab == "mats")
    self.recPane:SetShown(self.tab == "recipes")
    if self.tab == "plan" then self.planList:SetData(p.steps, true)
    elseif self.tab == "mats" then self.matList:SetData(BuildMatList(p), true)
    else self.recList:SetData(BuildRecList(key, self.search:GetText()), true) end
    ApplyFonts(UI.dirtyFonts)
end

---------------------------------------------------------------- construcao
function UI:Select(r, crafts)
    Log("recipe selected: spell %s (%s) crafts %s", tostring(r and r.spell), tostring(r and SpellName(r.spell)), tostring(crafts))
    self.sel = { r = r, crafts = crafts or 1, key = P.sel }
    self:Refresh()
end

function UI:RefreshFoot()
    local ft = self.foot
    local sel = self.sel
    if not sel or sel.key ~= P.sel then
        -- default: the first real step of the plan
        sel = nil
        if current then
            for _, st in ipairs(current.steps) do
                if st.r then sel = { r = st.r, crafts = st.crafts, key = P.sel } break end
            end
        end
        self.sel = sel
    end
    if not sel then
        ft.name:SetText(S.FOOT_SELECT)
        ft.req:SetText("")
        ft.mats:SetText("")
        ft.icon:SetTexture(QMARK)
        ft.locate:Hide()
        ft.one:Disable() ft.all:Disable() ft.qty:Hide()
        return
    end
    local r = sel.r
    ft.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
    local isKnown = known[r.spell] or SpellKnown(r.spell) or r.src == "a"
    local name = SpellName(r.spell) or (r.item > 0 and ItemName(r.item)) or ("#" .. r.spell)
    ft.name:SetText(name .. (isKnown and "" or "  |cff66ccff[" .. SrcLabel(r) .. "]|r"))
    local focus = FocusLabel(r.spell)
    ft.req:SetText(focus and ("|cffffd100" .. S.FOOT_REQ:format(focus) .. "|r") or ("|cff909090" .. S.FOOT_NOREQ .. "|r"))
    local parts = {}
    for _, rg in ipairs(r.reag) do
        local have = GetItemCount and GetItemCount(rg[1]) or 0
        local col = have >= rg[2] and "|cff40c040" or "|cffff8080"
        parts[#parts + 1] = ("%d× %s %s(%s)|r"):format(rg[2], ItemName(rg[1]) or ("#" .. rg[1]), col, S.FOOT_HAVE:format(have))
    end
    ft.mats:SetText(table.concat(parts, ",  "))
    if (not isKnown) and r.set and r.set > 0 and (r.src == "t" or r.src == "v") then
        ft.locate:SetText(r.src == "v" and S.GO_VENDOR or S.GO_TRAINER)
        ft.locate:Show()
    else
        ft.locate:Hide()
    end
    ft.qty:Show()
    if isKnown then ft.one:Enable() ft.all:Enable() else ft.one:Disable() ft.all:Disable() end
end

function UI:BuildFoot(body)
    local ft = Panel(body, 0.8)
    ft:SetPoint("BOTTOMLEFT", 0, 0)
    ft:SetPoint("BOTTOMRIGHT", 0, 0)
    ft:SetHeight(FOOT)
    self.foot = ft
    ft.icon = ft:CreateTexture(nil, "ARTWORK")
    ft.icon:SetSize(40, 40)
    ft.icon:SetPoint("TOPLEFT", 10, -10)
    ft.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    ft.all = Btn(ft, S.BTN_CRAFTALL, 100, 24, function()
        local sel = UI.sel
        if not sel then return end
        local n = CanMake(sel.r)
        if n < 1 then print("|cffffd100Trailsmith:|r " .. S.MISSING) return end
        if not TryCraft(sel.r, n) then
            local p = PROF_BY_KEY[P.sel]
            if p and p.spell and CastSpellByID then pcall(CastSpellByID, p.spell) print("|cffffd100Trailsmith:|r " .. S.MSG_CRAFT_OPEN)
            else print("|cffffd100Trailsmith:|r " .. S.MSG_CRAFT_FAIL) end
        end
    end)
    ft.all:SetPoint("BOTTOMRIGHT", -10, 10)
    ft.one = Btn(ft, S.BTN_CRAFT, 80, 24, function()
        local sel = UI.sel
        if not sel then return end
        local q = tonumber(ft.qty:GetText()) or 1
        if not TryCraft(sel.r, max(1, q)) then
            local p = PROF_BY_KEY[P.sel]
            if p and p.spell and CastSpellByID then pcall(CastSpellByID, p.spell) print("|cffffd100Trailsmith:|r " .. S.MSG_CRAFT_OPEN)
            else print("|cffffd100Trailsmith:|r " .. S.MSG_CRAFT_FAIL) end
        end
    end)
    ft.one:SetPoint("RIGHT", ft.all, "LEFT", -6, 0)
    ft.qty = TryCreate("EditBox", nil, ft, { "InputBoxTemplate" })
    ft.qty:SetSize(36, 20)
    ft.qty:SetPoint("RIGHT", ft.one, "LEFT", -10, 0)
    ft.qty:SetAutoFocus(false)
    ft.qty:SetNumeric(true)
    ft.qty:SetMaxLetters(3)
    ft.qty:SetText("1")
    RegFont(ft.qty, "num")
    ft.qty:SetScript("OnEscapePressed", function(s2) s2:ClearFocus() end)
    ft.qty:SetScript("OnEnterPressed", function(s2) s2:ClearFocus() end)
    ft.locate = Btn(ft, "", 150, 22, function() if UI.sel then Locate(UI.sel.r) end end)
    ft.locate:SetPoint("TOPRIGHT", -10, -10)
    ft.locate:Hide()
    ft.name = Label(ft, "", "GameFontNormal")
    ft.name:SetPoint("TOPLEFT", ft.icon, "TOPRIGHT", 10, 0)
    ft.name:SetPoint("RIGHT", ft.locate, "LEFT", -8, 0)
    ft.name:SetWordWrap(false)
    ft.req = Label(ft, "", "GameFontHighlightSmall")
    ft.req:SetPoint("TOPLEFT", ft.name, "BOTTOMLEFT", 0, -3)
    ft.req:SetPoint("RIGHT", ft.locate, "LEFT", -8, 0)
    ft.req:SetWordWrap(false)
    ft.mats = Label(ft, "", "GameFontHighlightSmall")
    ft.mats:SetPoint("TOPLEFT", ft.req, "BOTTOMLEFT", 0, -4)
    ft.mats:SetPoint("RIGHT", ft.qty, "LEFT", -12, 0)
    ft.mats:SetPoint("BOTTOM", ft, "BOTTOM", 0, 8)
    ft.mats:SetWordWrap(true)
    ft.mats:SetJustifyV("TOP")
end

function UI:BuildCraft(f)
    local lp = Panel(f, 0.7)
    lp:SetPoint("TOPLEFT", M, -TOP)
    lp:SetPoint("BOTTOMLEFT", M, BOT)
    lp:SetWidth(LEFTW)
    self.leftPanel = lp
    self.profBtns = {}
    for i, p in ipairs(PROFS) do
        local b = CreateFrame("Button", nil, lp)
        b:SetHighlightTexture(HILITE, "ADD")
        b.key = p.key
        b.sel = b:CreateTexture(nil, "BACKGROUND")
        b.sel:SetAllPoints()
        b.sel:SetTexture(HILITE)
        b.sel:SetBlendMode("ADD")
        b.icon = b:CreateTexture(nil, "ARTWORK")
        b.icon:SetPoint("LEFT", 4, 0)
        b.icon:SetTexture(p.icon)
        b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        b.name = Label(b, ProfLabel(p.key), "GameFontNormal")
        b.name:SetPoint("TOPLEFT", b.icon, "TOPRIGHT", 6, -1)
        b.name:SetPoint("RIGHT", -4, 0)
        b.name:SetWordWrap(false)
        b.rank = Label(b, "", "GameFontHighlightSmall", "num")
        b.rank:SetPoint("BOTTOMLEFT", b.icon, "BOTTOMRIGHT", 6, 1)
        b:SetScript("OnClick", Safe("profession " .. p.key, function() Log("profession selected: %s", p.key) P.sel = p.key UI:Refresh() end))
        Tip(b, function(tt)
            tt:AddLine(ProfLabel(p.key), 1, 0.82, 0)
            local sk2 = skills[p.key]
            if sk2 then tt:AddLine(("%d / %d"):format(sk2.rank, sk2.max), 1, 1, 1) end
        end)
        self.profBtns[i] = b
    end

    local rp = Panel(f, 0.7)
    rp:SetPoint("TOPRIGHT", -M, -TOP)
    rp:SetPoint("BOTTOMRIGHT", -M, BOT)
    rp:SetWidth(RIGHTW)
    self.rightPanel = rp
    local st = NewStack(rp, 10, 8, RIGHTW)
    self.optStack = st
    st:Add(Heading(rp, S.CRAFTOPT), 18, 0, 8)
    st:Add(Label(rp, S.MODE_TITLE, "GameFontNormalSmall"), 14, 0, 4)
    self.modeBtns = {}
    for _, m in ipairs({ { "cheap", S.MODE_CHEAP }, { "profit", S.MODE_PROFIT }, { "fast", S.MODE_FAST } }) do
        local b = Btn(rp, m[2], RIGHTW - 20, 22, function() P.mode = m[1] UI:Refresh() end)
        b.mode = m[1]
        st:Add(b, 22, 0, 4, true)
        self.modeBtns[#self.modeBtns + 1] = b
    end
    st:Add(Label(rp, S.SRC_TITLE, "GameFontNormalSmall"), 14, 0, 4, false, nil)
    st.items[#st.items].gapBefore = 8
    local function Chk(label, key)
        local cb = Check(rp, label, function() return P[key] end, function(v) P[key] = v UI:Refresh() end, RIGHTW - 54)
        st:Add(cb, 24, 0, 2, false, function() return cb.label:GetStringHeight() end)
    end
    Chk(S.OPT_KNOWN, "knownOnly")
    Chk(S.OPT_SRC_T, "srcT")
    Chk(S.OPT_SRC_V, "srcV")
    Chk(S.OPT_SRC_I, "srcI")
    Chk(S.OPT_SRC_U, "srcU")
    st:Add(Label(rp, S.PRICE_TITLE, "GameFontNormalSmall"), 14, 0, 4)
    Chk(S.OPT_GATHER, "free")
    Chk(S.OPT_AHCUT, "ahCut")
    self.provBtn = Btn(rp, "", RIGHTW - 20, 22, function()
        local i = 1
        for n, k in ipairs(PROVIDER_ORDER) do if k == P.provider then i = n end end
        P.provider = PROVIDER_ORDER[i % #PROVIDER_ORDER + 1]
        UI:Refresh()
    end)
    st:Add(self.provBtn, 22, 0, 8, true)
    st:Add(Btn(rp, S.BTN_BLIZZ, RIGHTW - 20, 22, function() if ns.OpenBlizzProf then ns.OpenBlizzProf() end end), 22, 0, 0, true)
    self.syncs[#self.syncs + 1] = function()
        local pv = P.provider
        local name = pv == "auto" and S.OPT_AUTO or pv == "vendor" and S.OPT_VENDOR or pv
        for _, pr in ipairs(PROVIDERS) do if pr.key == pv then name = pr.name .. (pr.ok() and "" or " (-)") end end
        if pv == "auto" then
            local a = ActiveProvider()
            name = S.OPT_AUTO .. (a and (": " .. a.name) or "")
        end
        self.provBtn:SetText(name)
    end

    -- center
    local cp = CreateFrame("Frame", nil, f)
    cp:SetPoint("TOPLEFT", M + LEFTW + GAP, -TOP)
    cp:SetPoint("BOTTOMRIGHT", -(M + RIGHTW + GAP), BOT)
    self.craftPane = cp
    self.noRec = Label(cp, "", "GameFontHighlight")
    self.noRec:SetPoint("TOPLEFT", 8, -20)
    self.noRec:SetWidth(500)
    self.noRec:SetJustifyV("TOP")
    local body = CreateFrame("Frame", nil, cp)
    body:SetAllPoints()
    self.craftBody = body
    self:BuildFoot(body)

    local function Box(label, after, dx)
        local cap = Label(body, label, "GameFontNormal")
        if after then cap:SetPoint("LEFT", after, "RIGHT", dx or 14, 0) else cap:SetPoint("TOPLEFT", 4, -6) end
        local eb = TryCreate("EditBox", nil, body, { "InputBoxTemplate" })
        eb:SetSize(46, 20)
        eb:SetPoint("LEFT", cap, "RIGHT", 10, 0)
        eb:SetAutoFocus(false)
        eb:SetNumeric(true)
        eb:SetMaxLetters(3)
        RegFont(eb, "num")
        return eb
    end
    self.fromBox = Box(S.FROM)
    self.toBox = Box(S.TO, self.fromBox, 16)
    local function Commit()
        local rg = P.range[P.sel] or RangeFor(P.sel)
        local a, b = tonumber(UI.fromBox:GetText()), tonumber(UI.toBox:GetText())
        if a then rg.from = max(1, min(374, a)) end
        if b then rg.to = max(rg.from + 1, min(375, b)) end
        LogOpt("range " .. tostring(P.sel), rg.from .. "-" .. rg.to)
        UI:Refresh()
    end
    for _, eb in ipairs({ self.fromBox, self.toBox }) do
        eb:SetScript("OnEnterPressed", function(s2) s2:ClearFocus() Commit() end)
        eb:SetScript("OnEscapePressed", function(s2) s2:ClearFocus() end)
        eb:SetScript("OnEditFocusLost", function() Commit() end)
    end
    local mine = Btn(body, S.MYSKILL, 110, 22, function()
        local sk = skills[P.sel]
        local rg = RangeFor(P.sel)
        if sk then rg.from = max(1, sk.rank) end
        UI:Refresh()
    end)
    mine:SetPoint("LEFT", self.toBox, "RIGHT", 14, 0)
    local maxb = Btn(body, S.MAXSKILL, 70, 22, function()
        local sk = skills[P.sel]
        local rg = RangeFor(P.sel)
        rg.to = sk and sk.max or 300
        if rg.to <= rg.from then rg.to = min(375, rg.from + 25) end
        UI:Refresh()
    end)
    maxb:SetPoint("LEFT", mine, "RIGHT", 6, 0)
    self.priceLine = Label(body, "", "GameFontHighlightSmall")
    self.priceLine:SetPoint("TOPRIGHT", -4, -9)
    self.priceLine:SetJustifyH("RIGHT")
    self.priceLine:SetTextColor(0.7, 0.7, 0.7)
    self.noProf = Label(body, "", "GameFontHighlightSmall")
    self.noProf:SetPoint("TOPLEFT", 4, -9)
    self.noProf:SetPoint("TOPLEFT", maxb, "TOPRIGHT", 12, -3)
    self.noProf:SetTextColor(1, 0.6, 0.3)

    self.cards = {}
    local defs = { { "points", S.CARD_POINTS }, { "crafts", S.CARD_CRAFTS }, { "cost", S.CARD_COST }, { "time", S.CARD_TIME }, { "net", S.CARD_NET } }
    for _, c in ipairs(defs) do
        local card = Panel(body, 0.7)
        local cap = Label(card, c[2], "GameFontNormalSmall")
        cap:SetPoint("TOPLEFT", 8, -7)
        cap:SetPoint("RIGHT", -6, 0)
        cap:SetWordWrap(false)
        local v = Label(card, "", "GameFontHighlight", "num")
        v:SetPoint("BOTTOMLEFT", 8, 7)
        v:SetPoint("RIGHT", -4, 0)
        v:SetWordWrap(false)
        card.v = v
        self.cards[c[1]] = card
    end

    self.tabBtns = {}
    for _, t in ipairs({ { "plan", S.PLAN }, { "mats", S.MATS }, { "recipes", S.RECIPES } }) do
        local b = Btn(body, t[2], 110, 24, function() UI.tab = t[1] UI:Refresh() end)
        b.tab = t[1]
        self.tabBtns[#self.tabBtns + 1] = b
    end
    local function SubPane()
        local p = CreateFrame("Frame", nil, body)
        p:Hide()
        return p
    end
    self.planPane, self.matPane, self.recPane = SubPane(), SubPane(), SubPane()
    self.planList = NewList(self.planPane, 0, ListHeight, MakePlanRow, FillPlanRow, LayoutPlanRow, 46)

    local mh = CreateFrame("Frame", nil, self.matPane)
    mh.icon = nil
    MakeMatCols(mh, "GameFontNormalSmall", nil, nil)
    mh.name:SetText(S.MATSHDR)
    mh.need:SetText(S.NEED)
    mh.have:SetText(S.HAVE)
    mh.miss:SetText(S.MISSING)
    mh.total:SetText(S.TOTAL)
    for _, k in ipairs({ "need", "have", "miss", "total" }) do mh[k]:SetJustifyH("RIGHT") end
    self.matHeader = mh
    self.matList = NewList(self.matPane, 22, ListHeight, MakeMatRow, FillMatRow, LayoutMatRow, 30)

    local sl = Label(self.recPane, S.SEARCH, "GameFontNormalSmall")
    sl:SetPoint("TOPLEFT", 6, -6)
    self.search = TryCreate("EditBox", nil, self.recPane, { "InputBoxTemplate" })
    self.search:SetSize(200, 20)
    self.search:SetPoint("LEFT", sl, "RIGHT", 10, 0)
    self.search:SetAutoFocus(false)
    RegFont(self.search)
    self.search:SetScript("OnTextChanged", function() UI:Refresh() end)
    self.search:SetScript("OnEscapePressed", function(s2) s2:ClearFocus() end)
    local legend = Label(self.recPane, S.LEGEND, "GameFontHighlightSmall")
    legend:SetPoint("TOPRIGHT", -24, -8)
    legend:SetTextColor(0.7, 0.7, 0.7)
    self.recList = NewList(self.recPane, 30, ListHeight, MakeRecRow, FillRecRow, LayoutRecRow, 30)
end

function UI:BuildGather(pane)
    local st = NewStack(pane, 12, 10, 600)
    self.gatherStack = st
    st:Add(Label(pane, S.GATHER_TITLE, "GameFontNormalLarge"), 22, 0, 4)
    local info = Label(pane, S.GATHER_INFO, "GameFontHighlightSmall")
    info:SetTextColor(0.75, 0.75, 0.75)
    info:SetJustifyV("TOP")
    st:Add(info, 44, 0, 4, true)
    self.gatherSkill = Label(pane, "", "GameFontHighlight", "num")
    st:Add(self.gatherSkill, 18, 0, 10)
    local function Chk(label, key)
        local cb = Check(pane, label, function() local g = _G.GatherTrailDB return g and g[key] end,
            function(v) local g = _G.GatherTrailDB if g then g[key] = v end Log("gathering option %s = %s", key, tostring(v)) if ns.GatherDirty then ns.GatherDirty() end end)
        st:Add(cb, 26, 0, 0)
    end
    Chk(S.G_ENABLED, "enabled")
    Chk(S.G_MINE, "trackMine")
    Chk(S.G_HERB, "trackHerb")
    Chk(S.G_SEED, "useSeed")
    Chk(S.G_AUTOLOOT, "autoLoot")
    Chk(S.G_AUTOLOOTQ, "autoLootQuest")
    Chk(S.G_AUTOHIDE, "autoHide")
    Chk(S.G_HOVER, "hoverLearn")
    local rg = Slider(pane, S.G_RANGE, 50, 2000, 50, function() local g = _G.GatherTrailDB return g and g.range or 600 end,
        function(v) local g = _G.GatherTrailDB if g then g.range = v end Log("gathering option range = %s", tostring(v)) if ns.GatherDirty then ns.GatherDirty() end end,
        function(v) return v .. " yd" end)
    st:Add(rg, 40, 0, 12)
    st:Add(Btn(pane, S.BTN_FULLOPT, 220, 24, function() if ns.ToggleOptions then ns.ToggleOptions() end end), 24, 0, 0)
    rg:SetWidth(360)
end

function UI:BuildSettings(pane)
    local st = NewStack(pane, 12, 10, 600)
    self.setStack = st
    st:Add(Label(pane, S.SETTINGS, "GameFontNormalLarge"), 22, 0, 6)
    st:Add(Check(pane, S.OPT_SHOWALL, function() return P.showAll end, function(v) P.showAll = v UI:Refresh() end), 26, 0, 0)
    st:Add(Check(pane, S.KEY_USE, function() return P.useKey end, function(v) P.useKey = v ApplyKey() UI:Refresh() end), 26, 0, 6)
    self.keyBtn = Btn(pane, "", 260, 22, function(b)
        b:SetText(S.KEY_PRESS)
        StartCapture(function() ApplyKey() UI:Refresh() end)
    end)
    st:Add(self.keyBtn, 22, 0, 2)
    local kn = Label(pane, S.KEY_NOTE, "GameFontHighlightSmall")
    kn:SetTextColor(0.7, 0.7, 0.7)
    st:Add(kn, 16, 4, 10)
    local function Sl(label, lo, hi, step, key, apply)
        local s = Slider(pane, label, lo, hi, step, function() return P[key] end, function(v) P[key] = v apply() end)
        s:SetWidth(360)
        st:Add(s, 40, 0, 8)
    end
    Sl(S.OPT_SCALE, 0.7, 1.5, 0.05, "scale", function() UI.frame:SetScale(P.scale) end)
    Sl(S.OPT_ALPHA, 0.5, 1, 0.02, "alpha", function() UI.frame:SetAlpha(P.alpha) end)
    Sl(S.OPT_FONT_TEXT, 0.8, 1.4, 0.05, "fontText", function() ApplyFonts() UI:Refresh() end)
    Sl(S.OPT_FONT_NUM, 0.8, 1.5, 0.05, "fontNum", function() ApplyFonts() UI:Refresh() end)
    st:Add(Check(pane, S.OPT_AUTOTEXT, function() return P.autoText end, function(v) P.autoText = v ApplyFonts() UI:Refresh() end), 26, 0, 4)
    st:Add(Btn(pane, S.BTN_RESETSIZE, 220, 22, function()
        P.w, P.h, P.scale, P.fontText, P.fontNum = DEFW, DEFH, 1, 1, 1
        UI.frame:SetSize(DEFW, DEFH)
        UI.frame:SetScale(1)
        ApplyFonts() UI:Refresh()
    end), 22, 0, 8)
    st:Add(Check(pane, S.OPT_LOG, function() return P.logOn ~= false end, function(v) P.logOn = v end), 26, 0, 4)
    local lb = Btn(pane, S.BTN_SHOWLOG, 200, 22, function() ns.ShowProfLog() end)
    st:Add(lb, 22, 0, 4)
    local lc = Btn(pane, S.BTN_CLEARLOG, 200, 22, function() P.log = {} print("|cffffd100Trailsmith:|r log cleared") end)
    st:Add(lc, 22, 0, 8)
    local note = Label(pane, S.NOTE_ESTIMATE, "GameFontHighlightSmall")
    note:SetTextColor(0.65, 0.65, 0.65)
    note:SetJustifyV("TOP")
    st:Add(note, 40, 0, 0, true)
    self.syncs[#self.syncs + 1] = function() self.keyBtn:SetText(S.KEY_BTN:format(P.key or "-")) end
end

function UI:Build()
    local f = TryCreate("Frame", "TrailsmithProfFrame", UIParent, { "BasicFrameTemplateWithInset", "DialogBoxFrame" })
    local w, h = P.w or DEFW, P.h or DEFH
    f:SetSize(max(MINW, w), max(MINH, h))
    f:SetPoint("CENTER")
    f:SetFrameStrata("HIGH")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:SetResizable(true)
    if f.SetResizeBounds then f:SetResizeBounds(MINW, MINH, 1500, 1000)
    elseif f.SetMinResize then f:SetMinResize(MINW, MINH) end
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, "TrailsmithProfFrame") end
    self.frame = f

    local title = f.TitleText
    if type(title) ~= "table" then title = type(f.TitleContainer) == "table" and f.TitleContainer.TitleText or nil end
    if type(title) == "table" then title:SetText(S.TITLE)
    else
        title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", 0, -8)
        title:SetText(S.TITLE)
    end

    -- window size buttons (scale)
    local function Scale(delta)
        P.scale = max(0.7, min(1.5, floor((P.scale + delta) * 20 + 0.5) / 20))
        Log("window scale = %s", tostring(P.scale))
        f:SetScale(P.scale)
        UI:Refresh()
    end
    local plus = Btn(f, "+", 22, 18, function() Scale(0.1) end)
    plus:SetPoint("TOPRIGHT", -34, -3)
    local minus = Btn(f, "-", 22, 18, function() Scale(-0.1) end)
    minus:SetPoint("RIGHT", plus, "LEFT", -2, 0)
    Tip(plus, function(tt) tt:SetText(S.OPT_SCALE) end)
    Tip(minus, function(tt) tt:SetText(S.OPT_SCALE) end)

    -- top tabs
    self.topBtns = {}
    for i, t in ipairs({ { "craft", S.TAB_CRAFT }, { "gather", S.TAB_GATHER }, { "settings", S.SETTINGS } }) do
        local b = Btn(f, t[2], 118, 24, function() UI.top = t[1] UI:Refresh() end)
        b:SetPoint("TOPLEFT", M + (i - 1) * 122, -34)
        b.top = t[1]
        self.topBtns[i] = b
    end

    self:BuildCraft(f)
    local function Pane()
        local p = Panel(f, 0.7)
        p:SetPoint("TOPLEFT", M, -TOP)
        p:SetPoint("BOTTOMRIGHT", -M, BOT)
        p:Hide()
        return p
    end
    self.gatherPane, self.setPane = Pane(), Pane()
    self:BuildGather(self.gatherPane)
    self:BuildSettings(self.setPane)
    self:BuildSearch()

    -- resize grip
    local grip = CreateFrame("Button", nil, f)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", -3, 3)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetFrameLevel(f:GetFrameLevel() + 10)
    grip:SetScript("OnMouseDown", function() f:StartSizing("BOTTOMRIGHT") end)
    grip:SetScript("OnMouseUp", function()
        f:StopMovingOrSizing()
        P.w, P.h = floor(f:GetWidth()), floor(f:GetHeight())
        Log("window resized to %dx%d", P.w, P.h)
        UI.sizeDirty = 0
    end)
    f:SetScript("OnSizeChanged", function() UI.sizeDirty = 0 end)
    f:SetScript("OnUpdate", function(_, elapsed)
        if UI.sizeDirty then
            UI.sizeDirty = UI.sizeDirty + (elapsed or 0)
            if UI.sizeDirty > 0.08 then
                UI.sizeDirty = nil
                local ok, err = pcall(function() ApplyFonts() UI:Refresh() end)
                if not ok then Log("ERROR in resize: %s", tostring(err)) end
            end
        end
    end)
    f:SetScript("OnShow", Safe("window show", function() UI:Refresh() end))
    f:SetScript("OnHide", function() Log("window hidden") if GameTooltip then GameTooltip:Hide() end end)
    f:SetScale(P.scale or 1)
    f:SetAlpha(P.alpha or 1)
    UI.built = true
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

function ns.OpenProf(arg)
    if not P and not Setup() then return end
    Log("open/toggle window arg=%s", tostring(arg))
    if not UI.frame then UI:Build() end
    arg = arg and arg:lower() or ""
    if arg ~= "" then
        for _, p in ipairs(PROFS) do
            if p.key:find(arg, 1, true) or ProfLabel(p.key):lower():find(arg, 1, true) then P.sel = p.key UI.top = "craft" break end
        end
    end
    if UI.frame:IsShown() and arg == "" then UI.frame:Hide() else UI.frame:Show() UI:Refresh() end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:RegisterEvent("TRADE_SKILL_SHOW")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
local pending = false
ev:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        if Setup() then
            Log("== login")
            pcall(Env)
            ApplyKey()
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if UI.keyPending then ApplyKey() end
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
            Log("trade skill window opened: %s -> %s", tostring(n), tostring(k))
            if k then P.sel = k end
        end
    end
end)

-- what the game itself says while crafting
local lev = CreateFrame("Frame")
for _, e in ipairs({ "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_SUCCEEDED", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_INTERRUPTED",
    "UI_ERROR_MESSAGE", "ADDON_ACTION_BLOCKED", "ADDON_ACTION_FORBIDDEN", "TRADE_SKILL_SHOW", "TRADE_SKILL_CLOSE" }) do
    pcall(lev.RegisterEvent, lev, e)
end
lev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
    if not P then return end
    if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
        if a1 ~= "player" then return end
        local id = (event ~= "UNIT_SPELLCAST_START" and type(a3) == "number") and a3 or a3
        local sp = tonumber(a3) or tonumber(a4)
        Log("event %s spell=%s (%s)", event, tostring(sp), tostring(sp and SpellName(sp)))
    elseif event == "UI_ERROR_MESSAGE" then
        Log("event UI_ERROR_MESSAGE: %s %s", tostring(a1), tostring(a2))
    elseif event == "ADDON_ACTION_BLOCKED" or event == "ADDON_ACTION_FORBIDDEN" then
        Log("event %s: addon=%s function=%s", event, tostring(a1), tostring(a2))
    else
        Log("event %s", event)
    end
end)

local logFrame
local function ShowLog()
    if not P and not Setup() then return end
    if not logFrame then
        local f = TryCreate("Frame", "TrailsmithProfLog", UIParent, { "BasicFrameTemplateWithInset", "DialogBoxFrame" })
        f:SetSize(680, 440)
        f:SetPoint("CENTER")
        f:SetFrameStrata("DIALOG")
        f:SetMovable(true)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)
        local title = f.TitleText
        if type(title) == "table" then title:SetText("Trailsmith log")
        else
            local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            t:SetPoint("TOP", 0, -8)
            t:SetText("Trailsmith log")
        end
        local scroll = TryCreate("ScrollFrame", "TrailsmithProfLogScroll", f, { "UIPanelScrollFrameTemplate" })
        scroll:SetPoint("TOPLEFT", 14, -32)
        scroll:SetPoint("BOTTOMRIGHT", -34, 14)
        local eb = CreateFrame("EditBox", nil, scroll)
        eb:SetMultiLine(true)
        eb:SetFontObject("ChatFontNormal")
        eb:SetWidth(610)
        eb:SetAutoFocus(false)
        eb:SetScript("OnEscapePressed", function(s2) s2:ClearFocus() end)
        scroll:SetScrollChild(eb)
        f.edit = eb
        if UISpecialFrames then table.insert(UISpecialFrames, "TrailsmithProfLog") end
        logFrame = f
    end
    local lines = P.log or {}
    logFrame.edit:SetText(table.concat(lines, "\n"))
    logFrame:Show()
end
ns.ShowProfLog = ShowLog

SLASH_TRAILSMITHPROF1 = "/tsp"
SLASH_TRAILSMITHPROF2 = "/professions"
SlashCmdList.TRAILSMITHPROF = Safe("slash", function(msg)
    local m = (msg or ""):lower()
    if m:match("^log") then
        if m:match("^log%s+clear") then
            if P or Setup() then P.log = {} end
            print("|cffffd100Trailsmith:|r log cleared")
        else
            ShowLog()
        end
        return
    end
    ns.OpenProf(msg)
end)
