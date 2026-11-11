-- GatherTrail localization. The language is picked from the game client (GetLocale()):
--   esES / esMX -> Spanish, ptBR -> Portuguese, anything else -> English.
-- Missing keys always fall back to English.

local _, ns = ...

local en = {
    KIND_mine = "Mining",
    KIND_herb = "Herbalism",
    KIND_skin = "Skinning",

    BINDING_SKIP = "Skip current point",

    SKIP_BTN = "Skip",
    SKIP_TIP1 = "Skip this point",
    SKIP_TIP2 = "Shows the next closest one.",
    SKIP_TIP3 = "Shift+click: never show this point again.",
    SKIP_TIP4 = "Shift+drag the arrow: move it.",

    SKIN_PREFIX = "Skin: %s",
    CREATURE = "creature",
    REQ_SKILL = "Required skill: %d (yours: %d)",
    MINED_AGO = "Gathered %d min ago",
    CONFIRMED = "Confirmed spawn point",

    SCAN_PART = "%s %d (%d you can gather)",
    SCAN_NONE = "scan (%d yards): nothing known nearby. Increase the range in /gt.",
    SCAN_RESULT = "scan (%d yards): %s.",
    SCAN_NEAREST = "closest you can gather: %s at %d yards.",
    POS_UNAVAILABLE = "position unavailable right now.",

    SKIPPED_FOREVER = "point removed forever (/gt unskip undoes it).",
    SKIPPED_TEMP = "point skipped for a while.",

    ARROW_TEXT = "%s - %d yards",
    TEST_TEXT = "TEST MODE: drag me",
    DRAG_TEXT = "Drag to move",

    ERR_TICK = "internal error (Tick): %s",
    ERR_EVENT = "internal error (%s): %s",

    OPT_TITLE = "Trailsmith",
    TAB_GENERAL = "General",
    TAB_DISPLAY = "Display",
    TAB_NODES = "Resources",

    OPT_ENABLED = "Enable addon",
    OPT_AUTOLOOT = "Autoloot for gathering",
    OPT_AUTOLOOTQ = "Smart autoloot (quest items + gold)",
    OPT_MINE = "Track mining",
    OPT_HERB = "Track herbalism",
    OPT_SEED = "Use location database",
    OPT_HOVER = "Learn nodes from minimap hover",
    OPT_TEST = "Test mode (move the arrow)",
    OPT_RANGE = "Detection range",
    OPT_HIDE = "Hide gathered node for",
    OPT_AUTOHIDE = "Hide empty points (hover on minimap)",
    OPT_EMPTYSECS = "Keep empty points hidden for",

    OPT_ARROW = "Directional arrow",
    OPT_LOCK = "Lock arrow position",
    OPT_MMBTN = "Minimap button",
    OPT_MMPINS = "Minimap icons",
    OPT_MAPPINS = "World map icons",
    OPT_LINE = "Line to confirmed nodes",
    OPT_RED = "Show nodes above my skill (red)",
    OPT_ARROWRED = "Arrow also to red nodes",
    OPT_CONFONLY = "Only confirmed points",
    OPT_PINSIZE = "Icon size",
    OPT_TRANSP = "Transparency (rarer = more visible)",
    OPT_SCALE = "Arrow size",

    OPT_LOWGAP = "Hide nodes far below my skill",
    OFF = "off",
    NODES_HINT = "Untick a resource to hide it. Prices: Auctionator last scan.",
    BTN_BEST = "Best value only",
    SORT_SKILL = "Sort: skill",
    SORT_PRICE = "Sort: price",
    COL_SKILL = "Skill",
    COL_PRICE = "Price",
    PRICE_AH = "Auction price",
    NO_AUCTIONATOR = "Auctionator not found: no prices.",
    BTN_ALL = "Select all",
    BTN_NONE = "Select none",
    UNIT_YD = " yd",
    UNIT_S = " s",

    BTN_CLEAR = "Delete saved nodes",
    BTN_UNSKIP = "Clear skipped points",
    MSG_CLEARED = "nodes deleted.",
    MSG_UNSKIPPED = "skipped points will show again.",

    INFO = "Saved points: %d\nMining: %s | Herbalism: %s | Skinning: %s",
    HAS_SKILL = "skill %d",
    NO_SKILL = "none",

    MM_LEFT = "Left click: options",
    MM_RIGHT = "Right click: enable/disable",
    MM_DRAG = "Drag: move the icon",
    MM_ON = "State: ENABLED",
    MM_OFF = "State: DISABLED",
    MSG_ENABLED = "enabled.",
    MSG_DISABLED = "disabled.",
    MSG_DISABLED_MM = "disabled (right click the icon to enable).",

    NO_DATA = "starter database not found. Install GatherTrailData (CurseForge, or github.com/cleytoncl3/GatherTrailData) to see known locations.",
    MSG_RANGE = "range: %d yards",
    MSG_LOCKED = "arrow locked",
    MSG_UNLOCKED = "arrow unlocked: drag it to move",
    MSG_TEST_ON = "test mode on: drag the arrow or the Skip button. /gt test turns it off.",
    MSG_TEST_OFF = "test mode off.",
}

local es = {
    KIND_mine = "Minería",
    KIND_herb = "Herboristería",
    KIND_skin = "Desuello",

    BINDING_SKIP = "Saltar el punto actual",

    SKIP_BTN = "Saltar",
    SKIP_TIP1 = "Saltar este punto",
    SKIP_TIP2 = "Muestra el siguiente más cercano.",
    SKIP_TIP3 = "Mayús+clic: no volver a mostrar este punto.",
    SKIP_TIP4 = "Mayús+arrastrar la flecha: moverla.",

    SKIN_PREFIX = "Desollar: %s",
    CREATURE = "criatura",
    REQ_SKILL = "Habilidad necesaria: %d (la tuya: %d)",
    MINED_AGO = "Recolectado hace %d min",
    CONFIRMED = "Punto de aparición confirmado",

    SCAN_PART = "%s %d (%d que puedes recoger)",
    SCAN_NONE = "escaneo (%d yardas): no se conoce nada cerca. Aumenta el alcance en /gt.",
    SCAN_RESULT = "escaneo (%d yardas): %s.",
    SCAN_NEAREST = "el más cercano que puedes recoger: %s a %d yardas.",
    POS_UNAVAILABLE = "posición no disponible ahora.",

    SKIPPED_FOREVER = "punto eliminado para siempre (/gt unskip lo deshace).",
    SKIPPED_TEMP = "punto saltado por un tiempo.",

    ARROW_TEXT = "%s - %d yardas",
    TEST_TEXT = "MODO DE PRUEBA: arrástrame",
    DRAG_TEXT = "Arrastra para mover",

    ERR_TICK = "error interno (Tick): %s",
    ERR_EVENT = "error interno (%s): %s",

    OPT_TITLE = "Trailsmith",
    TAB_GENERAL = "General",
    TAB_DISPLAY = "Pantalla",
    TAB_NODES = "Recursos",

    OPT_ENABLED = "Activar addon",
    OPT_AUTOLOOT = "Botín auto. solo de recolección",
    OPT_AUTOLOOTQ = "Botín auto. inteligente (misión + oro)",
    OPT_MINE = "Rastrear minería",
    OPT_HERB = "Rastrear herboristería",
    OPT_SEED = "Usar base de ubicaciones",
    OPT_HOVER = "Aprender nodos con el ratón",
    OPT_TEST = "Modo de prueba (mover la flecha)",
    OPT_RANGE = "Alcance de detección",
    OPT_HIDE = "Ocultar nodo recolectado durante",
    OPT_AUTOHIDE = "Ocultar puntos vacíos (ratón en minimapa)",
    OPT_EMPTYSECS = "Mantener puntos vacíos ocultos",

    OPT_ARROW = "Flecha direccional",
    OPT_LOCK = "Bloquear posición de la flecha",
    OPT_MMBTN = "Botón del minimapa",
    OPT_MMPINS = "Iconos en el minimapa",
    OPT_MAPPINS = "Iconos en el mapa del mundo",
    OPT_LINE = "Línea a nodos confirmados",
    OPT_RED = "Mostrar nodos sobre mi nivel (rojo)",
    OPT_ARROWRED = "Flecha también a nodos rojos",
    OPT_CONFONLY = "Solo puntos confirmados",
    OPT_PINSIZE = "Tamaño de iconos",
    OPT_TRANSP = "Transparencia (raros se ven más)",
    OPT_SCALE = "Tamaño de la flecha",

    OPT_LOWGAP = "Ocultar nodos muy bajos para mi nivel",
    OFF = "no",
    NODES_HINT = "Desmarca un recurso para ocultarlo. Precios: último escaneo de Auctionator.",
    BTN_BEST = "Solo los más valiosos",
    SORT_SKILL = "Orden: nivel",
    SORT_PRICE = "Orden: precio",
    COL_SKILL = "Nivel",
    COL_PRICE = "Precio",
    PRICE_AH = "Precio en la casa de subastas",
    NO_AUCTIONATOR = "Auctionator no encontrado: sin precios.",
    BTN_ALL = "Marcar todos",
    BTN_NONE = "Desmarcar todos",
    UNIT_YD = " yd",
    UNIT_S = " s",

    BTN_CLEAR = "Borrar nodos guardados",
    BTN_UNSKIP = "Limpiar puntos saltados",
    MSG_CLEARED = "nodos borrados.",
    MSG_UNSKIPPED = "los puntos saltados volverán a aparecer.",

    INFO = "Puntos guardados: %d\nMinería: %s | Herboristería: %s | Desuello: %s",
    HAS_SKILL = "nivel %d",
    NO_SKILL = "no tiene",

    MM_LEFT = "Clic izquierdo: opciones",
    MM_RIGHT = "Clic derecho: activar/desactivar",
    MM_DRAG = "Arrastrar: mover el icono",
    MM_ON = "Estado: ACTIVADO",
    MM_OFF = "Estado: DESACTIVADO",
    MSG_ENABLED = "activado.",
    MSG_DISABLED = "desactivado.",
    MSG_DISABLED_MM = "desactivado (clic derecho en el icono para activar).",

    NO_DATA = "no se encontró la base inicial. Instala GatherTrailData (CurseForge, o github.com/cleytoncl3/GatherTrailData) para ver ubicaciones conocidas.",
    MSG_RANGE = "alcance: %d yardas",
    MSG_LOCKED = "flecha bloqueada",
    MSG_UNLOCKED = "flecha desbloqueada: arrástrala para mover",
    MSG_TEST_ON = "modo de prueba activado: arrastra la flecha o el botón Saltar. /gt test lo desactiva.",
    MSG_TEST_OFF = "modo de prueba desactivado.",
}

local pt = {
    KIND_mine = "Mineração",
    KIND_herb = "Herbalismo",
    KIND_skin = "Esfolamento",

    BINDING_SKIP = "Pular ponto atual",

    SKIP_BTN = "Pular",
    SKIP_TIP1 = "Pular este ponto",
    SKIP_TIP2 = "Mostra o próximo mais perto.",
    SKIP_TIP3 = "Shift+clique: nunca mais mostrar este ponto.",
    SKIP_TIP4 = "Shift+arrastar a seta: mover.",

    SKIN_PREFIX = "Esfolar: %s",
    CREATURE = "criatura",
    REQ_SKILL = "Skill necessária: %d (a sua: %d)",
    MINED_AGO = "Coletado há %d min",
    CONFIRMED = "Ponto de spawn confirmado",

    SCAN_PART = "%s %d (%d que você pode pegar)",
    SCAN_NONE = "scan (%d jardas): nada conhecido por perto. Aumente o alcance em /gt.",
    SCAN_RESULT = "scan (%d jardas): %s.",
    SCAN_NEAREST = "mais perto que você pode pegar: %s a %d jardas.",
    POS_UNAVAILABLE = "posição indisponível agora.",

    SKIPPED_FOREVER = "ponto removido para sempre (/gt unskip desfaz).",
    SKIPPED_TEMP = "ponto pulado por um tempo.",

    ARROW_TEXT = "%s - %d jardas",
    TEST_TEXT = "MODO DE TESTE: arraste",
    DRAG_TEXT = "Arraste para mover",

    ERR_TICK = "erro interno (Tick): %s",
    ERR_EVENT = "erro interno (%s): %s",

    OPT_TITLE = "Trailsmith",
    TAB_GENERAL = "Geral",
    TAB_DISPLAY = "Exibição",
    TAB_NODES = "Recursos",

    OPT_ENABLED = "Ativar addon",
    OPT_AUTOLOOT = "Autoloot de coleta",
    OPT_AUTOLOOTQ = "Autoloot inteligente (missão + ouro)",
    OPT_MINE = "Rastrear mineração",
    OPT_HERB = "Rastrear herbalismo",
    OPT_SEED = "Usar banco de locais",
    OPT_HOVER = "Aprender veios pelo mouse",
    OPT_TEST = "Modo de teste (mover a seta)",
    OPT_RANGE = "Alcance de detecção",
    OPT_HIDE = "Esconder veio coletado por",
    OPT_AUTOHIDE = "Esconder pontos vazios (mouse no minimapa)",
    OPT_EMPTYSECS = "Manter pontos vazios escondidos por",

    OPT_ARROW = "Seta direcional",
    OPT_LOCK = "Travar posição da seta",
    OPT_MMBTN = "Botão no minimapa",
    OPT_MMPINS = "Ícones no minimapa",
    OPT_MAPPINS = "Ícones no mapa-múndi",
    OPT_LINE = "Linha até veios confirmados",
    OPT_RED = "Mostrar veios acima da skill (vermelho)",
    OPT_ARROWRED = "Seta também para vermelhos",
    OPT_CONFONLY = "Só pontos confirmados",
    OPT_PINSIZE = "Tamanho dos ícones",
    OPT_TRANSP = "Transparência (raros ficam mais visíveis)",
    OPT_SCALE = "Tamanho da seta",

    OPT_LOWGAP = "Esconder veios muito abaixo da skill",
    OFF = "off",
    NODES_HINT = "Desmarque para esconder. Preços: último scan do Auctionator.",
    BTN_BEST = "Só os mais valiosos",
    SORT_SKILL = "Ordem: skill",
    SORT_PRICE = "Ordem: preço",
    COL_SKILL = "Skill",
    COL_PRICE = "Preço",
    PRICE_AH = "Preço no leilão",
    NO_AUCTIONATOR = "Auctionator não encontrado: sem preços.",
    BTN_ALL = "Marcar todos",
    BTN_NONE = "Desmarcar todos",
    UNIT_YD = " jd",
    UNIT_S = " s",

    BTN_CLEAR = "Apagar veios salvos",
    BTN_UNSKIP = "Limpar pontos pulados",
    MSG_CLEARED = "veios apagados.",
    MSG_UNSKIPPED = "pontos pulados voltaram a aparecer.",

    INFO = "Pontos memorizados: %d\nMineração: %s | Herbalismo: %s | Esfolamento: %s",
    HAS_SKILL = "skill %d",
    NO_SKILL = "não tem",

    MM_LEFT = "Clique esquerdo: opções",
    MM_RIGHT = "Clique direito: ativar/desativar",
    MM_DRAG = "Arraste: mover o ícone",
    MM_ON = "Estado: ATIVADO",
    MM_OFF = "Estado: DESATIVADO",
    MSG_ENABLED = "ativado.",
    MSG_DISABLED = "desativado.",
    MSG_DISABLED_MM = "desativado (clique direito no ícone para ativar).",

    NO_DATA = "banco inicial não encontrado. Instale o GatherTrailData (CurseForge, ou github.com/cleytoncl3/GatherTrailData) para ver os locais conhecidos.",
    MSG_RANGE = "alcance: %d jardas",
    MSG_LOCKED = "seta travada",
    MSG_UNLOCKED = "seta destravada: arraste para mover",
    MSG_TEST_ON = "modo de teste ligado: arraste a seta ou o botão Pular. /gt test desliga.",
    MSG_TEST_OFF = "modo de teste desligado.",
}

local loc = GetLocale and GetLocale() or "enUS"
local active
if loc == "esES" or loc == "esMX" then
    active = es
elseif loc == "ptBR" then
    active = pt
end

local L = {}
if active then
    for k, v in pairs(active) do L[k] = v end
end
setmetatable(L, { __index = function(_, k) return en[k] or k end })
ns.L = L
