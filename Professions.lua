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
    OPT_SHOWALL = "Show professions I do not have in the side list", KEY_USE = "Open the simulator with a key (off by default; K keeps opening the game's crafting window)",
    KEY_NOTE = "If you pick a key that already does something, the old action moves to Shift + that key.", KEY_PRESS = "Press a key... (Esc cancels)", KEY_BTN = "Key: %s (click to change)", BTN_BLIZZ = "Blizzard's window",
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
    TAB_LEVEL = "Profession leveling", TAB_SIM = "Simulator", NEEDLEARN = "learn first", CARD_BUY = "To buy", CARD_SELL = "Sells for", PROFIT = "Profit", LOSS = "Loss",
    SIM_QTY = "Quantity", SIM_USEOWNED = "Use what I already have in my bags", SIM_STEPS = "Step by step", SIM_BUY = "Shopping list (market price)", SIM_NOBUY = "Nothing to buy: you already have everything.",
    SIM_USES = "uses: %s", SIM_FINAL = "final item", SIM_PICK = "Pick a recipe on the left to simulate it.", BTN_PIN = "Pin to screen", BTN_UNPIN = "Remove from screen",
    BTN_CRAFTWIN = "Open crafting window", MSG_SELECT_MANUAL = "Crafting window opened. Look for %s in the list.", TRACK_DONE = "ready!", TRACK_CRAFT = "craft", SIM_BTN = "Simulation",
    MATS_TOTAL = "Total materials for the whole plan", TRACK_OPEN = "Open crafting", OPT_MM = "Show the simulator icon on the minimap",
    MM_TIP = "Click: open the crafting simulator. Drag: move.",
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
    OPT_SHOWALL = "Mostrar en la lista lateral las profesiones que no tengo", KEY_USE = "Abrir el simulador con una tecla (desactivado por defecto; K sigue abriendo la ventana de creación del juego)",
    KEY_NOTE = "Si eliges una tecla que ya hace algo, la acción original pasa a Mayús + esa tecla.", KEY_PRESS = "Pulsa una tecla... (Esc cancela)", KEY_BTN = "Tecla: %s (clic para cambiar)", BTN_BLIZZ = "Ventana de Blizzard",
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
    TAB_LEVEL = "Subir profesión", TAB_SIM = "Simulador", NEEDLEARN = "aprender primero", CARD_BUY = "A comprar", CARD_SELL = "Se vende por", PROFIT = "Beneficio", LOSS = "Pérdida",
    SIM_QTY = "Cantidad", SIM_USEOWNED = "Usar lo que ya tengo en las bolsas", SIM_STEPS = "Paso a paso", SIM_BUY = "Lista de compra (precio de mercado)", SIM_NOBUY = "Nada que comprar: ya tienes todo.",
    SIM_USES = "usa: %s", SIM_FINAL = "objeto final", SIM_PICK = "Elige una receta a la izquierda para simularla.", BTN_PIN = "Fijar en pantalla", BTN_UNPIN = "Quitar de la pantalla",
    BTN_CRAFTWIN = "Abrir ventana de creación", MSG_SELECT_MANUAL = "Ventana de creación abierta. Busca %s en la lista.", TRACK_DONE = "¡listo!", TRACK_CRAFT = "crear", SIM_BTN = "Simulación",
    MATS_TOTAL = "Materiales totales de todo el plan", TRACK_OPEN = "Abrir creación", OPT_MM = "Mostrar el icono del simulador en el minimapa",
    MM_TIP = "Clic: abrir el simulador de creación. Arrastrar: mover.",
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
    OPT_SHOWALL = "Mostrar na lista lateral as profissões que eu não tenho", KEY_USE = "Abrir o simulador com uma tecla (desligado por padrão; o K continua abrindo a janela de criação do jogo)",
    KEY_NOTE = "Se você escolher uma tecla que já faz algo, a ação original passa para Shift + essa tecla.", KEY_PRESS = "Aperte uma tecla... (Esc cancela)", KEY_BTN = "Tecla: %s (clique para trocar)", BTN_BLIZZ = "Janela da Blizzard",
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
    TAB_LEVEL = "Subir profissão", TAB_SIM = "Simulador", NEEDLEARN = "aprender antes", CARD_BUY = "Comprar", CARD_SELL = "Vende por", PROFIT = "Lucro", LOSS = "Prejuízo",
    SIM_QTY = "Quantidade", SIM_USEOWNED = "Usar o que eu já tenho nas bolsas", SIM_STEPS = "Passo a passo", SIM_BUY = "Lista de compras (preço de mercado)", SIM_NOBUY = "Nada para comprar: você já tem tudo.",
    SIM_USES = "usa: %s", SIM_FINAL = "item final", SIM_PICK = "Escolha uma receita à esquerda para simular.", BTN_PIN = "Fixar na tela", BTN_UNPIN = "Remover da tela",
    BTN_CRAFTWIN = "Abrir janela de criação", MSG_SELECT_MANUAL = "Janela de criação aberta. Procure %s na lista.", TRACK_DONE = "pronto!", TRACK_CRAFT = "criar", SIM_BTN = "Simulação",
    MATS_TOTAL = "Total de materiais de todo o plano", TRACK_OPEN = "Abrir criação", OPT_MM = "Mostrar o ícone do simulador no minimapa",
    MM_TIP = "Clique: abrir o simulador de crafting. Arraste: mover.",
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
    { key = "mining", spell = 2575, craftSpell = 2656, icon = "Interface\\Icons\\Trade_Mining" },
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
    sel = "mining", skin = "dark", scale = 1, alpha = 0.96, fontText = 1, fontNum = 1, key = "", useKey = false, keyVersion = 2, showAll = false, simOwned = true, autoText = false, w = 980, h = 680, logOn = true, log = {}, provider = "auto", mode = "cheap",
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
local skills = {}
local curProd, curRecipes, curKey
-- intermediate items (bars, cured leather...) can be made by recipes of any profession the player has
local allProd
local function MergedProducers()
    if allProd then return allProd end
    allProd = {}
    for _, p in ipairs(PROFS) do
        if not p.gather then
            local _, prod = Decode(p.key)
            for item, list in pairs(prod) do
                local t = allProd[item]
                if not t then t = {} allProd[item] = t end
                for _, r in ipairs(list) do r.key = p.key t[#t + 1] = r end
            end
        end
    end
    return allProd
end
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
    if r.key and curKey and r.key ~= curKey and not (skills[r.key] or SpellKnown(r.spell)) then return false end
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
    curProd, curRecipes, curKey = MergedProducers(), recipes, key
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
local function ReadSkills()
    if not nameToKey then BuildNameMap() end
    for k in pairs(skills) do skills[k] = nil end
    if GetNumSkillLines and GetSkillLineInfo then
        for i = 1, GetNumSkillLines() do
            local n, header, _, rank, _, _, maxRank = GetSkillLineInfo(i)
            if n and not header and not issecret(n) then
                local key = nameToKey[n:lower()]
                if key then skills[key] = { rank = rank or 0, max = (maxRank and maxRank > 0) and maxRank or 300, name = n } end
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
                if key and not skills[key] then skills[key] = { rank = rank or 0, max = maxRank or 300, name = n } end
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
-- compact base sizes (the game's defaults are larger than this window needs)
local BASE = { GameFontNormal = 11, GameFontHighlight = 11, GameFontNormalSmall = 10, GameFontHighlightSmall = 10,
    GameFontNormalLarge = 13, GameFontHighlightLarge = 13 }
local function RegFont(obj, kind, name)
    if not obj or not obj.GetFont then return end
    local path, size, flags = obj:GetFont()
    if type(path) == "string" and type(size) == "number" then
        local base = (name and BASE[name]) or floor(size * 0.9 + 0.5)
        UI.fonts[#UI.fonts + 1] = { obj, path, base, flags, kind }
        UI.dirtyFonts = true
    end
end
local function Factor(kind)
    return (kind == "num" and (P.fontNum or 1) or (P.fontText or 1))
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
    RegFont(fs, kind, font or "GameFontHighlight")
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
    if fs then RegFont(fs, nil, "GameFontNormal") b.fs = fs end
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
    list.view = view
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
    curProd, curKey = MergedProducers(), key
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
    row.cost:SetPoint("TOPRIGHT", -8, -6)
    row.cost:SetJustifyH("RIGHT")
    row.sub = Label(row, nil, "GameFontHighlightSmall", "num")
    row.sub:SetPoint("TOPRIGHT", row.cost, "BOTTOMRIGHT", 0, -2)
    row.sub:SetJustifyH("RIGHT")
    row.sub:SetTextColor(0.7, 0.7, 0.7)
    row.go = Btn(row, "", 130, 20, function() if row.rec then Locate(row.rec) end end)
    row.go:SetPoint("BOTTOMRIGHT", -8, 6)
    row.go:Hide()
    row.t1 = Label(row, nil, "GameFontHighlight")
    row.t1:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 8, 0)
    row.t1:SetPoint("RIGHT", row.cost, "LEFT", -8, 0)
    row.t1:SetWordWrap(false)
    row.t2 = Label(row, nil, "GameFontHighlightSmall")
    row.t2:SetPoint("TOPLEFT", row.t1, "BOTTOMLEFT", 0, -3)
    row.t2:SetPoint("RIGHT", row, "RIGHT", -150, 0)
    row.t2:SetPoint("BOTTOM", row, "BOTTOM", 0, 4)
    row.t2:SetWordWrap(true)
    row.t2:SetJustifyV("TOP")
    Tip(row, function(tt, self) if self.rec then ItemOrSpellTip(tt, self.rec) end end)
    row:SetScript("OnClick", Safe("plan row", function(self) if self.rec then UI:OpenSim(self.rec, self.crafts) end end))
    return row
end
local function FillPlanRow(row, st, idx)
    Zebra(row, idx)
    row.t2:ClearAllPoints()
    row.t2:SetPoint("TOPLEFT", row.t1, "BOTTOMLEFT", 0, -3)
    row.t2:SetPoint("BOTTOM", row, "BOTTOM", 0, 4)
    if st.gap then
        row.rec = nil
        row.icon:SetTexture(QMARK)
        row.t1:SetText(("|cffff5050%d – %d|r"):format(st.from, st.to))
        row.t2:SetTextColor(1, 0.6, 0.5)
        row.t2:SetText(S.NOREC:format(st.from, st.to))
        row.t2:SetPoint("RIGHT", row, "RIGHT", -10, 0)
        row.cost:SetText("")
        row.sub:SetText("")
        row.go:Hide()
        return
    end
    local r = st.r
    row.rec = r
    row.crafts = st.crafts
    row.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
    local col = BandColor(r, st.from)
    local name = SpellName(r.spell) or (r.item > 0 and ItemName(r.item)) or ("#" .. r.spell)
    local tag = st.known and "" or ("  |cffff9933[" .. S.NEEDLEARN .. "]|r")
    row.t1:SetText(("|c%s%d – %d|r   %s  |cffffffff×%d|r%s"):format(col, st.from, st.to, name, st.crafts, tag))
    row.t2:SetTextColor(0.75, 0.75, 0.75)
    row.t2:SetText(MatLine(r, st.crafts))
    row.cost:SetText(st.miss and ("|cffff8080" .. S.NOPRICE .. "|r") or Money(st.cost))
    row.sub:SetText(S.CRAFT_X:format(st.crafts))
    local canLocate = (not st.known) and r.set and r.set > 0 and (r.src == "t" or r.src == "v")
    if canLocate then
        row.go:SetText(r.src == "v" and S.GO_VENDOR or S.GO_TRAINER)
        local w = row.go.fs and row.go.fs:GetStringWidth() or 100
        local gw = max(110, floor(w + 24))
        row.go:SetWidth(gw)
        row.go:Show()
        row.t2:SetPoint("RIGHT", row, "RIGHT", -(gw + 18), 0)
    else
        row.go:Hide()
        row.t2:SetPoint("RIGHT", row, "RIGHT", -130, 0)
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
            box:SetText("")
            box:ClearFocus()
            dd:Hide()
            UI.simSearch:SetText("")
            UI:OpenSim(e.r, 1)
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

---------------------------------------------------------------- simulacao
local function Close() if UI.frame then UI.frame:Hide() end end
local function Heading(parent, text) return Label(parent, text, "GameFontNormal") end

local function Have(id) return (GetItemCount and GetItemCount(id)) or 0 end

-- full material tree for crafting `count` of recipe r (using what is in the bags first)
local function SimBuild(key, r, count, useOwned)
    ClearCaches()
    Decode(key)
    curProd, curKey = MergedProducers(), key
    local owned = {}
    local lines, steps, buy = {}, {}, {}
    local function Need(id, qty, depth)
        local have = Have(id)
        local avail = 0
        if useOwned then
            avail = owned[id]
            if avail == nil then avail = have end
        end
        local use = min(avail, qty)
        if useOwned then owned[id] = avail - use end
        local remaining = qty - use
        local _, _, prod = ItemCost(id, 0)
        local line = { id = id, need = qty, have = have, depth = depth, remaining = remaining }
        lines[#lines + 1] = line
        if remaining > 0 then
            if prod and depth < 3 then
                local crafts = ceil(remaining / prod.qty)
                line.prod, line.crafts = prod, crafts
                for _, rg in ipairs(prod.reag) do Need(rg[1], rg[2] * crafts, depth + 1) end
                steps[#steps + 1] = { r = prod, crafts = crafts, item = id }
            else
                buy[id] = (buy[id] or 0) + remaining
                line.buy = remaining
            end
        end
    end
    for _, rg in ipairs(r.reag) do Need(rg[1], rg[2] * count, 0) end
    steps[#steps + 1] = { r = r, crafts = count, final = true }
    local cost, missing = 0, false
    local list = {}
    for id, n in pairs(buy) do
        local c = ItemCost(id, 0)
        local total = c and c * n or nil
        if total then cost = cost + total else missing = true end
        list[#list + 1] = { id = id, n = n, unit = c, total = total, have = Have(id) }
    end
    table.sort(list, function(a, b)
        if (a.total or 0) ~= (b.total or 0) then return (a.total or 0) > (b.total or 0) end
        return a.id < b.id
    end)
    local sell = 0
    if r.item > 0 then sell = SellValue(r.item) * r.qty * count end
    return { lines = lines, steps = steps, buy = list, cost = cost, missing = missing, sell = sell, profit = sell - cost, r = r, count = count, key = key }
end
ns.Prof.SimBuild = SimBuild

local recBySpell = {}
local function RecipeOf(key, spell)
    local m = recBySpell[key]
    if not m then
        m = {}
        for _, r in ipairs(Decode(key)) do m[r.spell] = r end
        recBySpell[key] = m
    end
    return m[spell]
end

---------------------------------------------------------------- janela de criacao do jogo
local SKILLLINE = { alchemy = 171, blacksmithing = 164, cooking = 185, enchanting = 333, engineering = 202, firstaid = 129,
    leatherworking = 165, mining = 186, tailoring = 197 }

local function FitBtn(b, minW)
    if b.fs and b.fs.GetStringWidth then b:SetWidth(max(minW or 0, floor(b.fs:GetStringWidth() + 26))) end
end

local function SelectInGame(r, count)
    if not r then return end
    Log("SelectInGame: spell %s count %s", tostring(r.spell), tostring(count))
    local done = false
    local T = _G.C_TradeSkillUI
    if T and T.OpenRecipe then
        local ok, err = pcall(T.OpenRecipe, r.spell)
        Log("C_TradeSkillUI.OpenRecipe(%d) -> ok=%s err=%s", r.spell, tostring(ok), tostring(err))
        done = ok
    end
    if GetNumTradeSkills and GetTradeSkillInfo then
        local total = GetNumTradeSkills() or 0
        Log("classic list: %d entries", total)
        for i = 1, total do
            local _, kind = GetTradeSkillInfo(i)
            if kind ~= "header" then
                local link = GetTradeSkillRecipeLink and GetTradeSkillRecipeLink(i)
                local id = link and tonumber(link:match("enchant:(%d+)") or link:match("spell:(%d+)"))
                if id == r.spell then
                    local ok, err = pcall(function()
                        if TradeSkillFrame_SetSelection then TradeSkillFrame_SetSelection(i) elseif SelectTradeSkill then SelectTradeSkill(i) end
                    end)
                    Log("selected entry %d -> ok=%s err=%s", i, tostring(ok), tostring(err))
                    if count and _G.TradeSkillInputBox then pcall(function() _G.TradeSkillInputBox:SetNumber(count) end) end
                    done = true
                    break
                end
            end
        end
    end
    if not done then
        print("|cffffd100Trailsmith:|r " .. S.MSG_SELECT_MANUAL:format(SpellName(r.spell) or "?"))
    end
end

local createBtns = {}
-- name of the spell that opens a profession's crafting window (Smelting for Mining)
local function ProfCastName(key)
    local p = PROF_BY_KEY[key]
    local n = p and p.craftSpell and SpellName(p.craftSpell)
    if not n and p and p.spell then n = SpellName(p.spell) end
    if not n and skills[key] and skills[key].name then n = skills[key].name end
    return n
end
local function ApplyCreateTarget(b)
    local tg = b.target
    if not tg then return end
    if InCombatLockdown and InCombatLockdown() then b.pendingAttr = true return end
    b.pendingAttr = false
    local name = ProfCastName(tg.key)
    b:SetAttribute("type", "spell")
    b:SetAttribute("spell", name)
    if b.lastLogged ~= tostring(name) then
        b.lastLogged = tostring(name)
        Log("create target: profession %s cast name=%s recipe=%s", tostring(tg.key), tostring(name), tostring(tg.r and tg.r.spell))
    end
end
local function ProfFramesShown()
    local shown = {}
    for _, fname in ipairs({ "TradeSkillFrame", "ProfessionsFrame", "CraftFrame" }) do
        local fr = _G[fname]
        if fr and fr.IsShown and fr:IsShown() then shown[#shown + 1] = fname end
    end
    return shown
end
local function MakeCreateButton(parent, text, w, h)
    local b = TryCreate("Button", nil, parent, { "SecureActionButtonTemplate,UIPanelButtonTemplate", "SecureActionButtonTemplate" })
    b:SetSize(w, h or 22)
    b:SetText(text or "")
    local fs = b.GetFontString and b:GetFontString()
    if fs then RegFont(fs, nil, "GameFontNormal") b.fs = fs end
    b:RegisterForClicks("AnyDown", "AnyUp")
    b:SetAttribute("useOnKeyDown", false)
    b:SetAttribute("type", "spell")
    b:HookScript("PostClick", function(self2)
        Log("open-crafting button clicked: spell attr=%s", tostring(self2:GetAttribute("spell")))
        local tg = self2.target
        C_Timer.After(0.6, function()
            local ok, err = pcall(function()
                local shown = ProfFramesShown()
                Log("after click: profession frames shown: %s", #shown > 0 and table.concat(shown, ",") or "none")
                if #shown == 0 and tg then
                    local T = _G.C_TradeSkillUI
                    local id = SKILLLINE[tg.key]
                    if T and T.OpenTradeSkill and id then
                        local ok2, err2 = pcall(T.OpenTradeSkill, id)
                        Log("fallback C_TradeSkillUI.OpenTradeSkill(%d) -> ok=%s err=%s", id, tostring(ok2), tostring(err2))
                    else
                        Log("no fallback to open the profession window")
                    end
                end
                if tg and tg.r then SelectInGame(tg.r, tg.count) end
            end)
            if not ok then Log("ERROR after click: %s", tostring(err)) end
        end)
    end)
    createBtns[#createBtns + 1] = b
    return b
end
local function SetCreateTarget(b, key, r, count)
    b.target = { key = key, r = r, count = count }
    ApplyCreateTarget(b)
end
local function FlushCreateTargets()
    for _, b in ipairs(createBtns) do if b.pendingAttr then ApplyCreateTarget(b) end end
end

---------------------------------------------------------------- janelinha fixa (rastreador)
local Tracker = {}
local TRACK_LINES = 22
function Tracker:Build()
    if self.frame then return end
    local f = Panel(UIParent, 0.88)
    f:SetSize(310, 120)
    f:SetFrameStrata("MEDIUM")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(s2)
        s2:StopMovingOrSizing()
        local p, _, rp, x, y = s2:GetPoint()
        if P then P.trackPos = { p, rp, x, y } end
    end)
    local pos = P and P.trackPos
    if pos then f:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4]) else f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -240, -300) end
    f.title = Label(f, "", "GameFontNormal")
    f.title:SetPoint("TOPLEFT", 12, -10)
    f.title:SetPoint("RIGHT", -30, 0)
    f.title:SetWordWrap(false)
    f.close = Btn(f, "x", 18, 18, function() if P then P.track = nil end Tracker:Refresh() end)
    f.close:SetPoint("TOPRIGHT", -6, -6)
    f.rows = {}
    for i = 1, TRACK_LINES do
        local fs = Label(f, "", "GameFontHighlightSmall")
        fs:SetPoint("RIGHT", -12, 0)
        fs:SetWordWrap(false)
        f.rows[i] = fs
    end
    f.create = MakeCreateButton(f, S.TRACK_OPEN, 130, 22)
    f.create:SetPoint("BOTTOMLEFT", 10, 10)
    f.sim = Btn(f, S.TAB_SIM, 90, 22, function()
        local t = P and P.track
        if not t then return end
        P.sel = t.key
        local r = RecipeOf(t.key, t.spell)
        ns.OpenProf(nil, "sim")
        if r then UI:OpenSim(r, t.count) end
    end)
    f.sim:SetPoint("BOTTOMRIGHT", -10, 10)
    self.frame = f
    ApplyFonts(true)
    FitBtn(f.create, 120)
    FitBtn(f.sim, 80)
end

function Tracker:Refresh()
    local t = P and P.track
    if not t or not t.spell then
        if self.frame then self.frame:Hide() end
        return
    end
    local r = RecipeOf(t.key, t.spell)
    if not r then if self.frame then self.frame:Hide() end return end
    self:Build()
    local f = self.frame
    local res = SimBuild(t.key, r, t.count or 1, true)
    local name = SpellName(r.spell) or ("#" .. r.spell)
    local allDone = true
    local n = 0
    local rh = floor(17 * (UI.factor or 1) + 0.5)
    for _, ln in ipairs(res.lines) do
        if n >= TRACK_LINES then break end
        n = n + 1
        local done = ln.have >= ln.need
        if ln.depth == 0 and not done then allDone = false end
        local indent = string.rep("    ", ln.depth)
        local col = done and "|cff40ff40" or (ln.depth == 0 and "|cffffffff" or "|cffc0c0c0")
        local tag = (ln.prod and not done) and ("  |cffffd100(" .. S.TRACK_CRAFT .. ")|r") or ""
        local row = f.rows[n]
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 14, -34 - (n - 1) * rh)
        row:SetPoint("RIGHT", -12, 0)
        row:SetText(("%s%s%s|r  %d/%d%s"):format(indent, col, ItemName(ln.id) or ("#" .. ln.id), ln.have, ln.need, tag))
        row:Show()
    end
    for i = n + 1, TRACK_LINES do f.rows[i]:Hide() end
    f.title:SetText((allDone and "|cff40ff40" or "") .. name .. " ×" .. (t.count or 1) .. (allDone and ("  " .. S.TRACK_DONE .. "|r") or ""))
    f:SetHeight(34 + n * rh + 46)
    SetCreateTarget(f.create, t.key, r, t.count)
    f:Show()
end
ns.Prof.Tracker = Tracker

local function PinRecipe(key, r, count)
    if not P then return end
    if P.track and P.track.spell == r.spell and P.track.count == count then
        P.track = nil
        Log("tracker removed")
    else
        P.track = { key = key, spell = r.spell, count = count }
        Log("tracker set: %s x%d", tostring(SpellName(r.spell)), count)
    end
    Tracker:Refresh()
end

---------------------------------------------------------------- layout e Refresh
local function FootH() return floor(150 * max(0.9, UI.factor or 1) + 0.5) end

function UI:LayoutCraft()
    local f = self.frame
    if not f or not self.cards then return end
    local cw = f:GetWidth() - 2 * M - LEFTW - RIGHTW - 2 * GAP
    local w = floor((cw - 4 * 6) / 5)
    local ch = floor(44 * max(1, UI.factor or 1))
    self.cardY = 54
    for i, key in ipairs({ "points", "crafts", "cost", "sell", "net" }) do
        local c = self.cards[key]
        c:ClearAllPoints()
        c:SetPoint("TOPLEFT", self.craftPane, "TOPLEFT", (i - 1) * (w + 6), -self.cardY)
        c:SetSize(w, ch)
    end
    self.listTop = self.cardY + ch + 10
    self.planPane:ClearAllPoints()
    self.planPane:SetPoint("TOPLEFT", self.craftPane, "TOPLEFT", 0, -self.listTop)
    self.planPane:SetPoint("BOTTOMRIGHT", self.craftPane, "BOTTOMRIGHT", 0, FootH() + 8)
    self.planFoot:SetHeight(FootH())
    MatCols(self.matHeader)
end
local function ListHeight() return (UI.frame:GetHeight() - TOP - BOT) - (UI.listTop or 120) - FootH() - 8 end

local function MoneySigned(c)
    if not c then return "?" end
    if c < 0 then return "|cffff6060-" .. Money(-c) .. "|r" end
    return "|cff40ff40+" .. Money(c) .. "|r"
end

function UI:LayoutSim()
    if not self.simDetail then return end
    local f = self.frame
    local dpw = f:GetWidth() - 2 * M - LEFTW - RIGHTW - 2 * GAP - self.simLeftW - GAP
    local w = floor((dpw - 20 - 12) / 3)
    local ch = floor(42 * max(1, UI.factor or 1))
    self.simCardY = 124
    for i, key in ipairs({ "cost", "sell", "net" }) do
        local c = self.simCards[key]
        c:ClearAllPoints()
        c:SetPoint("TOPLEFT", self.simDetail, "TOPLEFT", 10 + (i - 1) * (w + 6), -self.simCardY)
        c:SetSize(w, ch)
    end
    self.simListTop = self.simCardY + ch + 10
    self.simSteps.view:ClearAllPoints()
    self.simSteps.view:SetPoint("TOPLEFT", self.simDetail, "TOPLEFT", 4, -self.simListTop)
    self.simSteps.view:SetPoint("BOTTOMRIGHT", self.simDetail, "BOTTOMRIGHT", -22, 46)
end

function UI:RefreshSim()
    local key = P.sel
    local def = PROF_BY_KEY[key]
    local crafting = not (def and def.gather)
    self.simDetail:SetShown(crafting)
    self.simLeft:SetShown(crafting)
    self.simNote:SetShown(not crafting)
    if not crafting then
        self.simNote:SetText(S.NORECIPES:format(ProfLabel(key)))
        return
    end
    self:LayoutSim()
    local list = BuildRecList(key, self.simSearch:GetText())
    self.simList:SetData(list, true)
    local r = self.simSel
    if r and RecipeOf(key, r.spell) ~= r then r = nil self.simSel = nil end
    local d = self.simDetail
    if not r then
        d.name:SetText(S.SIM_PICK)
        d.info1:SetText("")
        d.info2:SetText("")
        d.icon:SetTexture(QMARK)
        d.locate:Hide()
        for _, c in pairs(self.simCards) do c.v:SetText("") end
        self.simSteps:SetData({}, true)
        d.pin:Disable()
        d.create:Hide()
        return
    end
    d.pin:Enable()
    d.create:Show()
    local qty = max(1, min(999, self.simQty or 1))
    self.simQty = qty
    if not d.qty:HasFocus() then d.qty:SetText(tostring(qty)) end
    local res = SimBuild(key, r, qty, P.simOwned ~= false)
    local isKnown = known[r.spell] or SpellKnown(r.spell) or r.src == "a"
    d.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
    local name = SpellName(r.spell) or (r.item > 0 and ItemName(r.item)) or ("#" .. r.spell)
    d.name:SetText(name)
    local focus = FocusLabel(r.spell)
    local mid = floor((r.low + r.high) / 2)
    d.info1:SetText(("|cffff8040%d|r  |cffffff00%d|r  |cff40c040%d|r  |cff808080%d|r     %s"):format(r.req, r.low, mid, r.high,
        isKnown and ("|cff40c040" .. S.KNOWN .. "|r") or ("|cffff9933" .. S.NEEDLEARN .. " (" .. SrcLabel(r) .. ")|r")))
    d.info2:SetText(focus and ("|cffffd100" .. S.FOOT_REQ:format(focus) .. "|r") or ("|cff909090" .. S.FOOT_NOREQ .. "|r"))
    if (not isKnown) and r.set and r.set > 0 and (r.src == "t" or r.src == "v") then
        d.locate:SetText(r.src == "v" and S.GO_VENDOR or S.GO_TRAINER)
        FitBtn(d.locate, 120)
        d.locate:Show()
    else
        d.locate:Hide()
    end
    self.simCards.cost.v:SetText(res.missing and (Money(res.cost) .. " |cffff8080+?|r") or Money(res.cost))
    self.simCards.sell.v:SetText(Money(res.sell))
    self.simCards.net.v:SetText(MoneySigned(res.profit))
    self.simCards.net.cap:SetText(res.profit >= 0 and S.PROFIT or S.LOSS)
    local items = {}
    items[#items + 1] = { kind = "head", text = S.SIM_STEPS }
    for i, st in ipairs(res.steps) do items[#items + 1] = { kind = "step", i = i, st = st } end
    items[#items + 1] = { kind = "head", text = S.SIM_BUY }
    if #res.buy == 0 then items[#items + 1] = { kind = "note", text = S.SIM_NOBUY } end
    for _, b in ipairs(res.buy) do items[#items + 1] = { kind = "buy", b = b } end
    self.simSteps:SetData(items, true)
    d.pin:SetText((P.track and P.track.spell == r.spell and P.track.count == qty) and S.BTN_UNPIN or S.BTN_PIN)
    FitBtn(d.pin, 150)
    SetCreateTarget(d.create, key, r, qty)
    self.simRes = res
end

function UI:OpenSim(r, count)
    Log("open simulator: spell %s count %s", tostring(r and r.spell), tostring(count))
    self.top = "sim"
    self.simSel = r
    self.simQty = max(1, count or 1)
    self:Refresh()
end

function UI:Refresh()
    if not self.frame or not self.frame:IsShown() then return end
    ReadSkills()
    ApplyFonts(UI.dirtyFonts)
    local key = P.sel
    local def = PROF_BY_KEY[key]
    local sk = skills[key]
    local top = self.top
    local sidebar = (top == "craft" or top == "sim")
    for _, b in ipairs(self.topBtns) do SetSel(b, b.top == top) end
    self.leftPanel:SetShown(sidebar)
    self.rightPanel:SetShown(sidebar)
    self.craftPane:SetShown(top == "craft")
    self.simPane:SetShown(top == "sim")
    self.gatherPane:SetShown(top == "gather")
    self.setPane:SetShown(top == "settings")
    if top == "gather" then
        self.gatherStack:Layout()
        local m, h = skills.mining, skills.herbalism
        self.gatherSkill:SetText(("%s: %s     %s: %s"):format(ProfLabel("mining"), m and (m.rank .. "/" .. m.max) or "—",
            ProfLabel("herbalism"), h and (h.rank .. "/" .. h.max) or "—"))
    elseif top == "settings" then
        self.setStack:Layout()
    end
    for _, s in ipairs(self.syncs) do s() end
    if not sidebar then return end

    local fct = UI.factor or 1
    local rh = floor(38 * fct + 0.5)
    local n = 0
    for _, b in ipairs(self.profBtns) do
        local s = skills[b.key]
        local show = s or P.showAll or b.key == key
        if show then
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", self.leftPanel, "TOPLEFT", 6, -6 - n * rh)
            b:SetPoint("TOPRIGHT", self.leftPanel, "TOPRIGHT", -6, -6 - n * rh)
            b:SetHeight(rh - 2)
            local isz = min(rh - 8, 30)
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
    self.optStack:Layout()
    for _, b in ipairs(self.modeBtns) do SetSel(b, b.mode == P.mode) end
    SetCreateTarget(self.openCraft, key, nil, nil)

    local crafting = not (def and def.gather)
    if top == "sim" then
        Recompute()
        self:RefreshSim()
        return
    end
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
    local p = current
    self.cards.points.v:SetText(tostring(p.points))
    self.cards.crafts.v:SetText(tostring(p.crafts))
    self.cards.cost.v:SetText(p.missing and (Money(p.cost) .. " |cffff8080+?|r") or Money(p.cost))
    self.cards.sell.v:SetText(Money(p.net + p.cost))
    self.cards.net.v:SetText(MoneySigned(p.net))
    self.cards.net.cap:SetText(p.net >= 0 and S.PROFIT or S.LOSS)
    self.priceLine:SetText(p.provider and S.PRICES:format(p.provider) or S.PRICES_NONE)
    self.noProf:SetText(sk and "" or S.NOPROF)
    self.planList:SetData(p.steps, true)
    self.footCost:SetText(S.CARD_BUY .. ": " .. (p.missing and (Money(p.cost) .. " |cffff8080+?|r") or Money(p.cost)))
    self.matList:SetData(BuildMatList(p), true)
    ApplyFonts(UI.dirtyFonts)
end

---------------------------------------------------------------- linhas do simulador
local function MakeSimRow(parent)
    local row = RowBase(parent)
    row.name = Label(row, nil, "GameFontHighlight")
    row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 6, 1)
    row.name:SetPoint("RIGHT", row, "RIGHT", -6, 0)
    row.name:SetWordWrap(false)
    row.tag = Label(row, nil, "GameFontHighlightSmall")
    row.tag:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 6, -1)
    row.tag:SetPoint("RIGHT", row, "RIGHT", -6, 0)
    row.tag:SetWordWrap(false)
    Tip(row, function(tt, self) if self.rec then ItemOrSpellTip(tt, self.rec) end end)
    row:SetScript("OnClick", Safe("simulator row", function(self)
        if self.rec then
            Log("simulator recipe picked: %s", tostring(SpellName(self.rec.spell)))
            UI.simSel = self.rec
            UI.simQty = UI.simQty or 1
            UI:Refresh()
        end
    end))
    return row
end
local function FillSimRow(row, d, idx)
    Zebra(row, idx)
    local r = d.r
    row.rec = r
    row.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
    local sk = skills[P.sel]
    local col = BandColor(r, sk and sk.rank or 1)
    local name = SpellName(r.spell) or (r.item > 0 and ItemName(r.item)) or ("#" .. r.spell)
    row.name:SetText(("|c%s%s|r"):format(col, name))
    row.tag:SetText(d.known and ("|cff40c040" .. S.KNOWN .. "|r") or ("|cff909090" .. SrcLabel(r) .. "|r"))
    if UI.simSel == r then
        if row.bg.SetColorTexture then row.bg:SetColorTexture(1, 0.8, 0.2, 0.18) else row.bg:SetTexture(1, 0.8, 0.2, 0.18) end
    end
end
local function LayoutSimRow(row, rh) IconSize(row, rh) end

local function MakeStepRow(parent)
    local row = RowBase(parent)
    row.right = Label(row, nil, "GameFontHighlight", "num")
    row.right:SetPoint("TOPRIGHT", -8, -6)
    row.right:SetJustifyH("RIGHT")
    row.t1 = Label(row, nil, "GameFontHighlight")
    row.t1:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 8, 1)
    row.t1:SetPoint("RIGHT", row.right, "LEFT", -8, 0)
    row.t1:SetWordWrap(false)
    row.t2 = Label(row, nil, "GameFontHighlightSmall")
    row.t2:SetPoint("TOPLEFT", row.t1, "BOTTOMLEFT", 0, -3)
    row.t2:SetPoint("RIGHT", row, "RIGHT", -8, 0)
    row.t2:SetPoint("BOTTOM", row, "BOTTOM", 0, 3)
    row.t2:SetWordWrap(true)
    row.t2:SetJustifyV("TOP")
    row.t2:SetTextColor(0.72, 0.72, 0.72)
    Tip(row, function(tt, self) if self.link then tt:SetHyperlink(self.link) end end)
    return row
end
local function FillStepRow(row, it, idx)
    row.link = nil
    row.right:SetText("")
    row.t2:SetText("")
    if it.kind == "head" then
        if row.bg.SetColorTexture then row.bg:SetColorTexture(1, 0.8, 0.2, 0.10) else row.bg:SetTexture(1, 0.8, 0.2, 0.10) end
        row.icon:Hide()
        row.t1:ClearAllPoints()
        row.t1:SetPoint("LEFT", 8, 0)
        row.t1:SetPoint("RIGHT", row, "RIGHT", -8, 0)
        row.t1:SetText("|cffffd100" .. it.text .. "|r")
        return
    end
    Zebra(row, idx)
    row.t1:ClearAllPoints()
    row.t1:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 8, 1)
    row.t1:SetPoint("RIGHT", row.right, "LEFT", -8, 0)
    if it.kind == "note" then
        row.icon:Hide()
        row.t1:ClearAllPoints()
        row.t1:SetPoint("LEFT", 8, 0)
        row.t1:SetPoint("RIGHT", row, "RIGHT", -8, 0)
        row.t1:SetText("|cff909090" .. it.text .. "|r")
        return
    end
    row.icon:Show()
    if it.kind == "step" then
        local st = it.st
        local r = st.r
        row.icon:SetTexture(r.item > 0 and ItemIcon(r.item) or SpellIcon(r.spell))
        row.link = r.item > 0 and ("item:" .. r.item) or ("spell:" .. r.spell)
        local name = SpellName(r.spell) or ("#" .. r.spell)
        row.t1:SetText(("|cffffd100%d)|r %s  |cffffffff×%d|r"):format(it.i, name, st.crafts))
        row.t2:SetText(S.SIM_USES:format(MatLine(r, st.crafts)))
        row.right:SetText(st.final and ("|cff40c040" .. S.SIM_FINAL .. "|r") or "")
    else
        local b = it.b
        row.icon:SetTexture(ItemIcon(b.id))
        row.link = "item:" .. b.id
        row.t1:SetText(("|cffffffff%d×|r %s"):format(b.n, ItemName(b.id) or ("#" .. b.id)))
        row.t2:SetText(("%s  ·  %s"):format(S.FOOT_HAVE:format(b.have), b.unit and (S.UNIT .. ": " .. Money(b.unit)) or S.NOPRICE))
        row.right:SetText(b.total and Money(b.total) or ("|cffff8080" .. S.NOPRICE .. "|r"))
    end
end
local function LayoutStepRow(row, rh) IconSize(row, rh) end

---------------------------------------------------------------- construcao
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
        b.name:SetPoint("TOPLEFT", b.icon, "TOPRIGHT", 6, 0)
        b.name:SetPoint("RIGHT", -4, 0)
        b.name:SetWordWrap(false)
        b.rank = Label(b, "", "GameFontHighlightSmall", "num")
        b.rank:SetPoint("BOTTOMLEFT", b.icon, "BOTTOMRIGHT", 6, 0)
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
    st:Add(Heading(rp, S.CRAFTOPT), 18, 0, 10)
    st:Add(Label(rp, S.MODE_TITLE, "GameFontNormalSmall"), 14, 0, 4)
    self.modeBtns = {}
    for _, m in ipairs({ { "cheap", S.MODE_CHEAP }, { "profit", S.MODE_PROFIT }, { "fast", S.MODE_FAST } }) do
        local b = Btn(rp, m[2], RIGHTW - 20, 22, function() P.mode = m[1] UI:Refresh() end)
        b.mode = m[1]
        st:Add(b, 22, 0, 5, true)
        self.modeBtns[#self.modeBtns + 1] = b
    end
    st:Add(Label(rp, S.SRC_TITLE, "GameFontNormalSmall"), 14, 0, 4)
    st.items[#st.items].gapBefore = 10
    local function Chk(label, key)
        local cb = Check(rp, label, function() return P[key] end, function(v) P[key] = v UI:Refresh() end, RIGHTW - 54)
        st:Add(cb, 24, 0, 4, false, function() return cb.label:GetStringHeight() end)
    end
    Chk(S.OPT_KNOWN, "knownOnly")
    Chk(S.OPT_SRC_T, "srcT")
    Chk(S.OPT_SRC_V, "srcV")
    Chk(S.OPT_SRC_I, "srcI")
    Chk(S.OPT_SRC_U, "srcU")
    st:Add(Label(rp, S.PRICE_TITLE, "GameFontNormalSmall"), 14, 0, 4)
    st.items[#st.items].gapBefore = 10
    Chk(S.OPT_GATHER, "free")
    Chk(S.OPT_AHCUT, "ahCut")
    self.provBtn = Btn(rp, "", RIGHTW - 20, 22, function()
        local i = 1
        for n, k in ipairs(PROVIDER_ORDER) do if k == P.provider then i = n end end
        P.provider = PROVIDER_ORDER[i % #PROVIDER_ORDER + 1]
        UI:Refresh()
    end)
    st:Add(self.provBtn, 22, 0, 12, true)
    self.openCraft = MakeCreateButton(rp, S.BTN_CRAFTWIN, RIGHTW - 20, 24)
    st:Add(self.openCraft, 24, 0, 0, true)
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

    -- leveling tab (center)
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

    local function Box(label, after, dx)
        local cap = Label(body, label, "GameFontNormal")
        if after then cap:SetPoint("LEFT", after, "RIGHT", dx or 14, 0) else cap:SetPoint("TOPLEFT", 4, -8) end
        local eb = TryCreate("EditBox", nil, body, { "InputBoxTemplate" })
        eb:SetSize(46, 20)
        eb:SetPoint("LEFT", cap, "RIGHT", 10, 0)
        eb:SetAutoFocus(false)
        eb:SetNumeric(true)
        eb:SetMaxLetters(3)
        RegFont(eb, "num", "GameFontHighlight")
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
    self.priceLine:SetPoint("TOPRIGHT", -4, -10)
    self.priceLine:SetJustifyH("RIGHT")
    self.priceLine:SetTextColor(0.7, 0.7, 0.7)
    self.noProf = Label(body, "", "GameFontHighlightSmall")
    self.noProf:SetPoint("TOPLEFT", 4, -34)
    self.noProf:SetPoint("RIGHT", -4, 0)
    self.noProf:SetWordWrap(false)
    self.noProf:SetTextColor(1, 0.6, 0.3)

    self.cards = {}
    local defs = { { "points", S.CARD_POINTS }, { "crafts", S.CARD_CRAFTS }, { "cost", S.CARD_BUY }, { "sell", S.CARD_SELL }, { "net", S.PROFIT } }
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
        card.v, card.cap = v, cap
        self.cards[c[1]] = card
    end

    self.planPane = CreateFrame("Frame", nil, body)
    self.planList = NewList(self.planPane, 0, ListHeight, MakePlanRow, FillPlanRow, LayoutPlanRow, 62)

    -- footer: every material needed for the whole plan
    local foot = Panel(body, 0.8)
    foot:SetPoint("BOTTOMLEFT", 0, 0)
    foot:SetPoint("BOTTOMRIGHT", 0, 0)
    self.planFoot = foot
    local ft = Label(foot, S.MATS_TOTAL, "GameFontNormal")
    ft:SetPoint("TOPLEFT", 10, -8)
    self.footCost = Label(foot, "", "GameFontHighlight", "num")
    self.footCost:SetPoint("TOPRIGHT", -12, -8)
    self.footCost:SetJustifyH("RIGHT")
    local mh = CreateFrame("Frame", nil, foot)
    mh:SetPoint("TOPLEFT", 6, -28)
    mh:SetPoint("TOPRIGHT", -24, -28)
    mh:SetHeight(16)
    MakeMatCols(mh, "GameFontNormalSmall", nil, nil)
    mh.name:SetText(S.MATSHDR)
    mh.need:SetText(S.NEED)
    mh.have:SetText(S.HAVE)
    mh.miss:SetText(S.MISSING)
    mh.total:SetText(S.TOTAL)
    for _, k in ipairs({ "need", "have", "miss", "total" }) do mh[k]:SetJustifyH("RIGHT") end
    self.matHeader = mh
    self.matList = NewList(foot, 46, FootH, MakeMatRow, FillMatRow, LayoutMatRow, 24)

    self:BuildSim(f)
end

function UI:BuildSim(f)
    local sp = CreateFrame("Frame", nil, f)
    sp:SetPoint("TOPLEFT", M + LEFTW + GAP, -TOP)
    sp:SetPoint("BOTTOMRIGHT", -(M + RIGHTW + GAP), BOT)
    sp:Hide()
    self.simPane = sp
    self.simLeftW = 250
    self.simQty = 1
    self.simNote = Label(sp, "", "GameFontHighlight")
    self.simNote:SetPoint("TOPLEFT", 8, -20)
    self.simNote:SetWidth(500)

    local lp = Panel(sp, 0.7)
    lp:SetPoint("TOPLEFT", 0, 0)
    lp:SetPoint("BOTTOMLEFT", 0, 0)
    lp:SetWidth(self.simLeftW)
    self.simLeft = lp
    local sl = Label(lp, S.SEARCH, "GameFontNormalSmall")
    sl:SetPoint("TOPLEFT", 10, -14)
    self.simSearch = TryCreate("EditBox", nil, lp, { "InputBoxTemplate" })
    self.simSearch:SetPoint("LEFT", sl, "RIGHT", 12, 0)
    self.simSearch:SetPoint("RIGHT", lp, "RIGHT", -14, 0)
    self.simSearch:SetHeight(20)
    self.simSearch:SetAutoFocus(false)
    RegFont(self.simSearch, nil, "GameFontHighlight")
    self.simSearch:SetScript("OnTextChanged", function(_, user) if user then UI:Refresh() end end)
    self.simSearch:SetScript("OnEscapePressed", function(s2) s2:ClearFocus() end)
    self.simList = NewList(lp, 40, function() return UI.frame:GetHeight() - TOP - BOT end, MakeSimRow, FillSimRow, LayoutSimRow, 38)

    local dp = Panel(sp, 0.7)
    dp:SetPoint("TOPLEFT", self.simLeftW + GAP, 0)
    dp:SetPoint("BOTTOMRIGHT", 0, 0)
    self.simDetail = dp
    dp.icon = dp:CreateTexture(nil, "ARTWORK")
    dp.icon:SetSize(40, 40)
    dp.icon:SetPoint("TOPLEFT", 12, -12)
    dp.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    dp.locate = Btn(dp, "", 150, 22, function() if UI.simSel then Locate(UI.simSel) end end)
    dp.locate:SetPoint("TOPRIGHT", -12, -12)
    dp.locate:Hide()
    dp.name = Label(dp, "", "GameFontNormalLarge")
    dp.name:SetPoint("TOPLEFT", dp.icon, "TOPRIGHT", 12, 0)
    dp.name:SetPoint("RIGHT", dp.locate, "LEFT", -8, 0)
    dp.name:SetWordWrap(false)
    dp.info1 = Label(dp, "", "GameFontHighlightSmall")
    dp.info1:SetPoint("TOPLEFT", dp.name, "BOTTOMLEFT", 0, -6)
    dp.info1:SetPoint("RIGHT", dp, "RIGHT", -12, 0)
    dp.info1:SetWordWrap(false)
    dp.info2 = Label(dp, "", "GameFontHighlightSmall")
    dp.info2:SetPoint("TOPLEFT", dp.info1, "BOTTOMLEFT", 0, -4)
    dp.info2:SetPoint("RIGHT", dp, "RIGHT", -12, 0)
    dp.info2:SetWordWrap(false)
    local ql = Label(dp, S.SIM_QTY, "GameFontNormal")
    ql:SetPoint("TOPLEFT", 14, -72)
    dp.qty = TryCreate("EditBox", nil, dp, { "InputBoxTemplate" })
    dp.qty:SetSize(54, 20)
    dp.qty:SetPoint("LEFT", ql, "RIGHT", 12, 0)
    dp.qty:SetAutoFocus(false)
    dp.qty:SetNumeric(true)
    dp.qty:SetMaxLetters(3)
    RegFont(dp.qty, "num", "GameFontHighlight")
    dp.qty:SetScript("OnTextChanged", function(self2, user)
        if not user then return end
        local n = tonumber(self2:GetText())
        if n and n >= 1 then LogOpt("simulator quantity", n) UI.simQty = n UI:Refresh() end
    end)
    dp.qty:SetScript("OnEnterPressed", function(s2) s2:ClearFocus() end)
    dp.qty:SetScript("OnEscapePressed", function(s2) s2:ClearFocus() end)
    dp.own = Check(dp, S.SIM_USEOWNED, function() return P.simOwned ~= false end, function(v) P.simOwned = v UI:Refresh() end, 420)
    dp.own:SetPoint("TOPLEFT", 8, -92)

    self.simCards = {}
    for _, c in ipairs({ { "cost", S.CARD_BUY }, { "sell", S.CARD_SELL }, { "net", S.PROFIT } }) do
        local card = Panel(dp, 0.7)
        local cap = Label(card, c[2], "GameFontNormalSmall")
        cap:SetPoint("TOPLEFT", 8, -7)
        cap:SetPoint("RIGHT", -6, 0)
        cap:SetWordWrap(false)
        local v = Label(card, "", "GameFontHighlight", "num")
        v:SetPoint("BOTTOMLEFT", 8, 7)
        v:SetPoint("RIGHT", -4, 0)
        v:SetWordWrap(false)
        card.v, card.cap = v, cap
        self.simCards[c[1]] = card
    end
    self.simSteps = NewList(dp, 170, function() return UI.frame:GetHeight() - TOP - BOT - 46 end, MakeStepRow, FillStepRow, LayoutStepRow, 52)
    dp.pin = Btn(dp, S.BTN_PIN, 160, 24, function()
        local r = UI.simSel
        if r then PinRecipe(P.sel, r, UI.simQty or 1) UI:Refresh() end
    end)
    dp.pin:SetPoint("BOTTOMLEFT", 12, 12)
    dp.create = MakeCreateButton(dp, S.BTN_CRAFTWIN, 240, 24)
    dp.create:SetPoint("BOTTOMRIGHT", -12, 12)
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
    st:Add(Label(pane, S.SETTINGS, "GameFontNormalLarge"), 22, 0, 8)
    st:Add(Check(pane, S.OPT_SHOWALL, function() return P.showAll end, function(v) P.showAll = v UI:Refresh() end), 24, 0, 4)
    st:Add(Check(pane, S.OPT_MM, function() return not P.mmHide end, function(v) P.mmHide = not v if ns.UpdateProfMinimap then ns.UpdateProfMinimap() end end), 24, 0, 12)
    local function Sl(label, lo, hi, step, key, apply)
        local s2 = Slider(pane, label, lo, hi, step, function() return P[key] end, function(v) P[key] = v apply() end)
        s2:SetWidth(360)
        st:Add(s2, 40, 0, 8)
    end
    Sl(S.OPT_SCALE, 0.7, 1.5, 0.05, "scale", function() UI.frame:SetScale(P.scale) end)
    Sl(S.OPT_ALPHA, 0.5, 1, 0.02, "alpha", function() UI.frame:SetAlpha(P.alpha) end)
    Sl(S.OPT_FONT_TEXT, 0.7, 1.4, 0.05, "fontText", function() ApplyFonts() UI:Refresh() end)
    Sl(S.OPT_FONT_NUM, 0.7, 1.4, 0.05, "fontNum", function() ApplyFonts() UI:Refresh() end)
    st:Add(Btn(pane, S.BTN_RESETSIZE, 240, 22, function()
        P.w, P.h, P.scale, P.fontText, P.fontNum = DEFW, DEFH, 1, 1, 1
        UI.frame:SetSize(DEFW, DEFH)
        UI.frame:SetScale(1)
        ApplyFonts(true) UI:Refresh()
    end), 22, 0, 12)
    st:Add(Check(pane, S.OPT_LOG, function() return P.logOn ~= false end, function(v) P.logOn = v end), 24, 0, 4)
    st:Add(Btn(pane, S.BTN_SHOWLOG, 220, 22, function() ns.ShowProfLog() end), 22, 0, 4)
    st:Add(Btn(pane, S.BTN_CLEARLOG, 220, 22, function() P.log = {} print("|cffffd100Trailsmith:|r log cleared") end), 22, 0, 12)
    local note = Label(pane, S.NOTE_ESTIMATE, "GameFontHighlightSmall")
    note:SetTextColor(0.65, 0.65, 0.65)
    note:SetJustifyV("TOP")
    st:Add(note, 40, 0, 0, true)
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
    for i, t in ipairs({ { "craft", S.TAB_LEVEL }, { "sim", S.TAB_SIM }, { "gather", S.TAB_GATHER }, { "settings", S.SETTINGS } }) do
        local b = Btn(f, t[2], 150, 24, function() UI.top = t[1] UI:Refresh() end)
        b:SetPoint("TOPLEFT", M + (i - 1) * 154, -34)
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
    -- the game's own K window must stay untouched: older versions took the key over, so switch that off once
    if P.keyVersion ~= 2 then
        P.keyVersion = 2
        P.useKey = false
        P.key = ""
        Log("migration: key takeover switched off")
    end
    return true
end

function ns.OpenProf(arg, top)
    if not P and not Setup() then return end
    Log("open/toggle window arg=%s top=%s", tostring(arg), tostring(top))
    if not UI.frame then UI:Build() end
    if top then
        UI.top = top
        UI.frame:Show()
        UI:Refresh()
        return
    end
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
ev:RegisterEvent("BAG_UPDATE_DELAYED")
local pending = false
local simBtn
local function EnsureSimButton()
    local parent = _G.TradeSkillFrame or _G.ProfessionsFrame or _G.CraftFrame
    if not parent then Log("simulation button: no profession frame found") return end
    if not simBtn then
        simBtn = TryCreate("Button", "TrailsmithSimButton", parent, { "UIPanelButtonTemplate" })
        simBtn:SetSize(120, 22)
        simBtn:SetText(S.SIM_BTN)
        simBtn:SetScript("OnClick", Safe("simulation button", function()
            Log("Simulation button clicked on the game's crafting window")
            ns.OpenProf(nil, "sim")
        end))
        Log("simulation button created on %s", tostring(parent.GetName and parent:GetName()))
    end
    simBtn:SetParent(parent)
    simBtn:ClearAllPoints()
    simBtn:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", -12, -4)
    simBtn:SetFrameStrata(parent:GetFrameStrata())
    simBtn:SetFrameLevel((parent:GetFrameLevel() or 1) + 10)
    simBtn:Show()
end
ev:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        if Setup() then
            Log("== login")
            pcall(Env)
            ApplyKey()
            Tracker:Refresh()
            pcall(ns.UpdateProfMinimap)
        end
    elseif event == "BAG_UPDATE_DELAYED" then
        if P and P.track then Tracker:Refresh() end
        if UI.frame and UI.frame:IsShown() and UI.top == "sim" and not pending then
            pending = true
            C_Timer.After(0.3, function() pending = false UI:Refresh() end)
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if UI.keyPending then ApplyKey() end
        FlushCreateTargets()
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
            pcall(EnsureSimButton)
        end
    end
end)

---------------------------------------------------------------- icone proprio no minimapa
local mm
local function PlaceMM()
    if not mm or not P or not Minimap then return end
    local a = math.rad(P.mmAngle or 215)
    mm:ClearAllPoints()
    mm:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * 80, math.sin(a) * 80)
end
local function BuildMM()
    if mm or not Minimap then return end
    local b = CreateFrame("Button", "TrailsmithProfMinimapButton", Minimap)
    b:SetSize(31, 31)
    b:SetFrameStrata("MEDIUM")
    b:SetFrameLevel(8)
    b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    b:RegisterForDrag("LeftButton")
    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(20, 20)
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    bg:SetPoint("TOPLEFT", 7, -5)
    local icon = b:CreateTexture(nil, "ARTWORK")
    icon:SetSize(17, 17)
    icon:SetTexture("Interface\\Icons\\Trade_Engineering")
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    icon:SetPoint("TOPLEFT", 7, -6)
    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetSize(53, 53)
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetPoint("TOPLEFT")
    b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    b:SetScript("OnClick", Safe("minimap button", function() ns.OpenProf() end))
    b:SetScript("OnDragStart", function(self2)
        self2:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local cx, cy = GetCursorPosition()
            local sc = Minimap:GetEffectiveScale()
            local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end
            P.mmAngle = math.deg(atan2(cy / sc - my, cx / sc - mx))
            PlaceMM()
        end)
    end)
    b:SetScript("OnDragStop", function(self2) self2:SetScript("OnUpdate", nil) end)
    b:SetScript("OnEnter", function(self2)
        GameTooltip:SetOwner(self2, "ANCHOR_LEFT")
        GameTooltip:SetText(S.TITLE, 1, 0.82, 0)
        GameTooltip:AddLine(S.MM_TIP, 1, 1, 1)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    mm = b
    PlaceMM()
end
function ns.UpdateProfMinimap()
    if not P then return end
    BuildMM()
    if mm then if P.mmHide then mm:Hide() else mm:Show() end end
end

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
    if m:match("^sim") then ns.OpenProf(nil, "sim") return end
    ns.OpenProf(msg)
end)
