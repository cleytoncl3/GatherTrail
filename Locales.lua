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

    SCAN_BTN = "Scan",
    SCAN_TIP1 = "Scan",
    SCAN_TIP2 = "Refreshes now and prints in chat what is there",
    SCAN_TIP3 = "of ore, herbs and corpses within range.",

    SKIN_PREFIX = "Skin: %s",
    CREATURE = "creature",
    REQ_SKILL = "Required skill: %d (yours: %d)",
    MINED_AGO = "Gathered %d min ago",

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

    OPT_TITLE = "GatherTrail - Gathering Guide",
    OPT_TEST = "TEST MODE: show arrow and Scan to move them",
    OPT_ENABLED = "Enable addon",
    OPT_MINE = "Track Mining",
    OPT_HERB = "Track Herbalism",
    OPT_SKIN = "Track Skinning (corpses)",
    OPT_SEED = "Use starter location database (GatherTrailData)",
    OPT_HOVER = "Learn nodes by hovering the minimap",
    OPT_ARROW = "Directional arrow on screen",
    OPT_SCANBTN = "Always show Scan button",
    OPT_MMBTN = "Show minimap button",
    OPT_LINE = "Minimap line to the node",
    OPT_MMPINS = "Minimap icons",
    OPT_MAPPINS = "World map icons (M)",
    OPT_RED = "Show red nodes (skill too low)",
    OPT_ARROWRED = "Arrow also points to red nodes if there is no yellow",
    OPT_RANGE = "Detection range",
    OPT_HIDE = "Hide gathered node for (respawn)",
    OPT_SCALE = "Arrow size",
    OPT_PINSIZE = "Icon size (map and minimap)",
    OPT_TRANSP = "Transparency (rarer nodes stay visible)",
    OPT_AUTOLOOT = "Autoloot gathering only (ore, herbs, skinning)",
    OPT_LOCK = "Arrow locked (uncheck to drag)",
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
    MM_MIDDLE = "Middle click: scan",
    MM_DRAG = "Drag: move the icon",
    MM_ON = "State: ENABLED",
    MM_OFF = "State: DISABLED",
    MSG_ENABLED = "enabled.",
    MSG_DISABLED = "disabled.",
    MSG_DISABLED_MM = "disabled (right click the icon to enable).",

    MSG_RANGE = "range: %d yards",
    MSG_LOCKED = "arrow locked",
    MSG_UNLOCKED = "arrow unlocked: drag it to move",
    MSG_TEST_ON = "test mode on: drag the arrow or the buttons. /gt test turns it off.",
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

    SCAN_BTN = "Escanear",
    SCAN_TIP1 = "Escanear",
    SCAN_TIP2 = "Actualiza ahora y muestra en el chat lo que hay",
    SCAN_TIP3 = "de minerales, hierbas y cadáveres en el alcance.",

    SKIN_PREFIX = "Desollar: %s",
    CREATURE = "criatura",
    REQ_SKILL = "Habilidad necesaria: %d (la tuya: %d)",
    MINED_AGO = "Recolectado hace %d min",

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

    OPT_TITLE = "GatherTrail - Guía de Recolección",
    OPT_TEST = "MODO DE PRUEBA: mostrar flecha y Escanear para moverlos",
    OPT_ENABLED = "Activar addon",
    OPT_MINE = "Rastrear Minería",
    OPT_HERB = "Rastrear Herboristería",
    OPT_SKIN = "Rastrear Desuello (cadáveres)",
    OPT_SEED = "Usar base de ubicaciones inicial (GatherTrailData)",
    OPT_HOVER = "Aprender nodos pasando el ratón por el minimapa",
    OPT_ARROW = "Flecha direccional en pantalla",
    OPT_SCANBTN = "Mostrar siempre el botón Escanear",
    OPT_MMBTN = "Mostrar botón en el minimapa",
    OPT_LINE = "Línea en el minimapa hasta el nodo",
    OPT_MMPINS = "Iconos en el minimapa",
    OPT_MAPPINS = "Iconos en el mapa del mundo (M)",
    OPT_RED = "Mostrar nodos rojos (habilidad insuficiente)",
    OPT_ARROWRED = "La flecha también apunta a rojos si no hay amarillos",
    OPT_RANGE = "Alcance de detección",
    OPT_HIDE = "Ocultar nodo recolectado durante (reaparición)",
    OPT_SCALE = "Tamaño de la flecha",
    OPT_PINSIZE = "Tamaño de los iconos (mapa y minimapa)",
    OPT_TRANSP = "Transparencia (los raros se ven más)",
    OPT_AUTOLOOT = "Botín automático solo de recolección (mineral, hierbas, desuello)",
    OPT_LOCK = "Flecha bloqueada (desmarca para arrastrar)",
    UNIT_YD = " yd",
    UNIT_S = " s",

    BTN_CLEAR = "Borrar nodos guardados",
    BTN_UNSKIP = "Limpiar puntos saltados",
    MSG_CLEARED = "nodos borrados.",
    MSG_UNSKIPPED = "los puntos saltados volverán a aparecer.",

    INFO = "Puntos guardados: %d\nMinería: %s | Herboristería: %s | Desuello: %s",
    HAS_SKILL = "habilidad %d",
    NO_SKILL = "no tiene",

    MM_LEFT = "Clic izquierdo: opciones",
    MM_RIGHT = "Clic derecho: activar/desactivar",
    MM_MIDDLE = "Clic central: escanear",
    MM_DRAG = "Arrastrar: mover el icono",
    MM_ON = "Estado: ACTIVADO",
    MM_OFF = "Estado: DESACTIVADO",
    MSG_ENABLED = "activado.",
    MSG_DISABLED = "desactivado.",
    MSG_DISABLED_MM = "desactivado (clic derecho en el icono para activar).",

    MSG_RANGE = "alcance: %d yardas",
    MSG_LOCKED = "flecha bloqueada",
    MSG_UNLOCKED = "flecha desbloqueada: arrástrala para mover",
    MSG_TEST_ON = "modo de prueba activado: arrastra la flecha o los botones. /gt test lo desactiva.",
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

    SCAN_BTN = "Scan",
    SCAN_TIP1 = "Scan",
    SCAN_TIP2 = "Atualiza agora e mostra no chat o que há",
    SCAN_TIP3 = "de minérios, ervas e cadáveres no alcance.",

    SKIN_PREFIX = "Esfolar: %s",
    CREATURE = "criatura",
    REQ_SKILL = "Skill necessária: %d (a sua: %d)",
    MINED_AGO = "Coletado há %d min",

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

    OPT_TITLE = "GatherTrail - Guia de Coleta",
    OPT_TEST = "MODO DE TESTE: mostrar seta e Scan para mover",
    OPT_ENABLED = "Ativar addon",
    OPT_MINE = "Rastrear Mineração",
    OPT_HERB = "Rastrear Herbalismo",
    OPT_SKIN = "Rastrear Esfolamento (cadáveres)",
    OPT_SEED = "Usar banco inicial de locais (GatherTrailData)",
    OPT_HOVER = "Aprender veios passando o mouse no minimapa",
    OPT_ARROW = "Seta direcional na tela",
    OPT_SCANBTN = "Botão Scan sempre visível",
    OPT_MMBTN = "Mostrar botão no minimapa",
    OPT_LINE = "Linha no minimapa até o veio",
    OPT_MMPINS = "Ícones no minimapa",
    OPT_MAPPINS = "Ícones no mapa-múndi (M)",
    OPT_RED = "Mostrar veios vermelhos (skill insuficiente)",
    OPT_ARROWRED = "Seta também para vermelhos se não houver amarelo",
    OPT_RANGE = "Alcance de detecção",
    OPT_HIDE = "Esconder veio minerado por (respawn)",
    OPT_SCALE = "Tamanho da seta",
    OPT_PINSIZE = "Tamanho dos ícones (mapa e minimapa)",
    OPT_TRANSP = "Transparência (raros ficam mais visíveis)",
    OPT_AUTOLOOT = "Autoloot só de coleta (minério, ervas, esfolamento)",
    OPT_LOCK = "Seta travada (desmarque para arrastar)",
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
    MM_MIDDLE = "Clique do meio: scan",
    MM_DRAG = "Arraste: mover o ícone",
    MM_ON = "Estado: ATIVADO",
    MM_OFF = "Estado: DESATIVADO",
    MSG_ENABLED = "ativado.",
    MSG_DISABLED = "desativado.",
    MSG_DISABLED_MM = "desativado (clique direito no ícone para ativar).",

    MSG_RANGE = "alcance: %d jardas",
    MSG_LOCKED = "seta travada",
    MSG_UNLOCKED = "seta destravada: arraste para mover",
    MSG_TEST_ON = "modo de teste ligado: arraste a seta ou os botões. /gt test desliga.",
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
