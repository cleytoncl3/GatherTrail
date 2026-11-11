// Builds RecipeData.lua for Trailsmith from public data:
//  - wago.tools DB2 exports of the WoW Forever build (SkillLineAbility, SpellReagents, SpellEffect, SpellName, ItemSparse)
//  - cmangos classic-db (trainer skill requirements, recipe items, vendor lists)
const fs = require("fs");
const P = require("./sqlparse.js");
const D = "C:/Users/Cleyton/AppData/Local/Temp/claude/ffba5859012f6237/18c57d67-60c0-4a16-9371-29b84dd83aae/scratchpad/wago/";
const OUT = process.argv[2];

function csv(f) {
  const t = fs.readFileSync(D + f, "utf8");
  const rows = []; let i = 0, row = [], cur = "", q = false;
  for (; i < t.length; i++) {
    const c = t[i];
    if (q) { if (c == '"') { if (t[i + 1] == '"') { cur += '"'; i++; } else q = false; } else cur += c; }
    else if (c == '"') q = true;
    else if (c == ',') { row.push(cur); cur = ""; }
    else if (c == '\n') { row.push(cur.replace(/\r$/, "")); rows.push(row); row = []; cur = ""; }
    else cur += c;
  }
  if (cur || row.length) { row.push(cur); rows.push(row); }
  const h = rows.shift();
  return rows.map(r => { const o = {}; h.forEach((k, j) => o[k] = r[j]); return o; });
}

const PROF = [
  { id: 171, key: "alchemy" }, { id: 164, key: "blacksmithing" }, { id: 185, key: "cooking" },
  { id: 333, key: "enchanting" }, { id: 202, key: "engineering" }, { id: 129, key: "firstaid" },
  { id: 165, key: "leatherworking" }, { id: 186, key: "mining" }, { id: 197, key: "tailoring" },
];
const profById = {}; PROF.forEach(p => profById[p.id] = p);
const MAXSKILL = 375;

// ---- spells
const names = {}; for (const r of csv("SpellName.csv")) names[r.ID] = r.Name_lang;
const eff = {};
for (const e of csv("SpellEffect.csv")) (eff[e.SpellID] = eff[e.SpellID] || []).push(e);
const reag = {};
for (const r of csv("SpellReagents.csv")) {
  const l = [];
  for (let k = 0; k < 8; k++) if (+r["Reagent_" + k] > 0 && +r["ReagentCount_" + k] > 0) l.push([+r["Reagent_" + k], +r["ReagentCount_" + k]]);
  reag[r.SpellID] = l;
}
const sparse = {};
for (const r of csv("ItemSparse.csv")) sparse[r.ID] = { sell: +r.SellPrice, buy: +r.BuyPrice, q: +r.OverallQualityID, stack: +r.Stackable };

// ---- classic-db: trainers, recipe items, vendors
// effect 36 = learn spell: map teaching spell -> learned spell(s)
const teach = {};
for (const sp in eff) for (const e of eff[sp]) if (+e.Effect === 36 && +e.EffectTriggerSpell > 0) teach[sp] = +e.EffectTriggerSpell;
// the vanilla (Classic Era) client data keeps the original teaching-spell ids used by the cmangos tables
for (const e of csv("era_SpellEffect.csv")) if (+e.Effect === 36 && +e.EffectTriggerSpell > 0 && !teach[e.SpellID]) teach[e.SpellID] = +e.EffectTriggerSpell;
const trainer = {};
for (const tn of ["npc_trainer", "npc_trainer_template"])
  for (const [entry, spell, reqskill, val] of P.rows(tn, ["entry", "spell", "reqskill", "reqskillvalue"])) {
    const s = teach[+spell] || +spell, v = +val;
    if (trainer[s] === undefined || v < trainer[s]) trainer[s] = v;
  }
const recipeItem = {}; // learned spell -> {item, skill, rank}
for (const [entry, cls, skill, rank, sp1] of P.rows("item_template", ["entry", "class", "RequiredSkill", "RequiredSkillRank", "spellid_1"])) {
  if (+cls !== 9) continue;
  const learned = teach[sp1];
  if (!learned) continue;
  if (!recipeItem[learned] || +rank < recipeItem[learned].rank) recipeItem[learned] = { item: +entry, rank: +rank };
}
const vendor = {};
for (const tn of ["npc_vendor", "npc_vendor_template"])
  for (const [item, maxc] of P.rows(tn, ["item", "maxcount"])) if (+maxc === 0) vendor[+item] = true;

// ---- build recipes
const sla = csv("SkillLineAbility.csv");
// The Forever client data lost the difficulty range of some recipes (yellow == grey). The Classic Anniversary
// build still has the original ranges, so we use it to fill those in.
const ann = {};
for (const a of csv("ann_SLA.csv")) {
  const v = { low: +a.TrivialSkillLineRankLow, high: +a.TrivialSkillLineRankHigh };
  if (!ann[a.Spell] || v.high - v.low > ann[a.Spell].high - ann[a.Spell].low) ann[a.Spell] = v;
}
let patched = 0;
const seen = {};
const recipes = {}; PROF.forEach(p => recipes[p.key] = []);
let stats = { total: 0, trainer: 0, item: 0, unknown: 0 };
const itemsUsed = {};
for (const a of sla) {
  const p = profById[+a.SkillLine];
  if (!p) continue;
  let low = +a.TrivialSkillLineRankLow, high = +a.TrivialSkillLineRankHigh;
  const min = +a.MinSkillLineRank;
  if (high > 0 && low >= high && ann[a.Spell] && ann[a.Spell].high > ann[a.Spell].low) { low = ann[a.Spell].low; high = ann[a.Spell].high; patched++; }
  if (high <= 0 || low >= MAXSKILL) continue;
  if (seen[a.Spell]) continue;
  const es = eff[a.Spell] || [];
  const create = es.find(e => +e.Effect === 24 && +e.EffectItemType > 0);
  const ench = es.find(e => +e.Effect === 53 || +e.Effect === 54);
  if (!create && !ench) continue;
  const rg = reag[a.Spell] || [];
  if (rg.length === 0) continue; // "free" recipes (profession windows etc.) are not craftable leveling
  seen[a.Spell] = true;
  const item = create ? +create.EffectItemType : 0;
  const qty = create ? Math.max(1, Math.round(+create.EffectBasePointsF || 1)) : 1;
  let req, src = "u", srcItem = 0;
  if (+a.AcquireMethod === 1) { src = "a"; req = 1; stats.auto = (stats.auto || 0) + 1; }
  else if (recipeItem[a.Spell]) { srcItem = recipeItem[a.Spell].item; src = vendor[srcItem] ? "v" : "i"; req = Math.max(min, recipeItem[a.Spell].rank); stats.item++; }
  else if (trainer[a.Spell] !== undefined) { src = "t"; req = Math.max(min, trainer[a.Spell]); stats.trainer++; }
  else { req = Math.max(1, min, low - 10); stats.unknown++; }
  if (req > low) req = low; // never ask for more than the yellow threshold
  stats.total++;
  recipes[p.key].push({ spell: +a.Spell, req, low, high, item, qty, src, srcItem, reag: rg });
  if (item) itemsUsed[item] = true;
  for (const [id] of rg) itemsUsed[id] = true;
  if (srcItem) itemsUsed[srcItem] = true;
}
console.log(stats, "difficulty ranges filled from Anniversary data:", patched);

// ---- NPC locations (trainers and recipe vendors) converted to world map coordinates
const ftpl = {};
for (const r of csv("FactionTemplate.csv")) ftpl[r.ID] = r;
function facOf(id) { // 1 alliance only, 2 horde only, 0 both
  const f = ftpl[id]; if (!f) return 0;
  const g = +f.FactionGroup, fr = +f.FriendGroup;
  const a = (g & 2) || (fr & 2), h = (g & 4) || (fr & 4);
  return a && !h ? 1 : h && !a ? 2 : 0;
}
const NOT_ZONE = new Set(["1414", "1415", "1463", "1464", "947"]);
const assigns = [];
for (const r of csv("UiMapAssignment.csv")) {
  if (NOT_ZONE.has(r.UiMapID)) continue;
  const a = { ui: +r.UiMapID, map: +r.MapID, minX: +r.Region_0, minY: +r.Region_1, maxX: +r.Region_3, maxY: +r.Region_4 };
  a.area = (a.maxX - a.minX) * (a.maxY - a.minY);
  assigns.push(a);
}
function toMap(map, X, Y) {
  let best;
  for (const a of assigns) {
    if (a.map !== map || X < a.minX || X > a.maxX || Y < a.minY || Y > a.maxY) continue;
    if (!best || a.area < best.area) best = a;
  }
  if (!best) return null;
  return { ui: best.ui, x: (best.maxY - Y) / (best.maxY - best.minY), y: (best.maxX - X) / (best.maxX - best.minX) };
}
const cT = {};
for (const r of P.rows("creature_template", ["Entry", "Name", "Faction", "NpcFlags", "TrainerTemplateId", "VendorTemplateId"]))
  cT[r[0]] = { name: r[1], faction: +r[2], ttpl: +r[4], vtpl: +r[5] };
const spawns = {};
for (const [id, map, x, y] of P.rows("creature", ["id", "map", "position_x", "position_y"]))
  if (map === "0" || map === "1") (spawns[id] = spawns[id] || []).push([+map, +x, +y]);
// trainer -> craft spells
const trainSpells = {}; // npc entry -> Set(spell)
function addT(npc, spell) { (trainSpells[npc] = trainSpells[npc] || new Set()).add(spell); }
for (const [entry, spell] of P.rows("npc_trainer", ["entry", "spell"])) addT(entry, teach[+spell] || +spell);
const tplSpells = {};
for (const [entry, spell] of P.rows("npc_trainer_template", ["entry", "spell"])) (tplSpells[entry] = tplSpells[entry] || new Set()).add(teach[+spell] || +spell);
for (const id in cT) if (cT[id].ttpl && tplSpells[cT[id].ttpl]) for (const sp of tplSpells[cT[id].ttpl]) addT(id, sp);
// vendors: item -> npc entries
const vendItems = {};
function addV(item, npc) { (vendItems[item] = vendItems[item] || new Set()).add(npc); }
for (const [entry, item] of P.rows("npc_vendor", ["entry", "item"])) addV(+item, entry);
const vtplItems = {};
for (const [entry, item] of P.rows("npc_vendor_template", ["entry", "item"])) (vtplItems[entry] = vtplItems[entry] || new Set()).add(+item);
for (const id in cT) if (cT[id].vtpl && vtplItems[cT[id].vtpl]) for (const it of vtplItems[cT[id].vtpl]) addV(it, id);

const spots = []; const spotIdx = {}; const npcSpots = {};
function spotsOf(npc) {
  if (npcSpots[npc]) return npcSpots[npc];
  const out = []; const seen = [];
  for (const [map, X, Y] of spawns[npc] || []) {
    const m = toMap(map, X, Y);
    if (!m) continue;
    if (seen.some(q => q.ui === m.ui && Math.hypot(q.x - m.x, q.y - m.y) < 0.012)) continue;
    seen.push(m);
    const x = Math.round(m.x * 10000), y = Math.round(m.y * 10000);
    const name = (cT[npc] ? cT[npc].name : "?").replace(/[|"\\]/g, "");
    const fac = cT[npc] ? facOf(cT[npc].faction) : 0;
    const key = name + "|" + fac + "|" + m.ui + "|" + x + "|" + y;
    if (spotIdx[key] === undefined) { spots.push(key); spotIdx[key] = spots.length; }
    out.push(spotIdx[key]);
  }
  npcSpots[npc] = out;
  return out;
}
const sets = []; const setIdx = {}; let withSet = 0, withoutSet = 0;
for (const p of PROF) for (const r of recipes[p.key]) {
  let npcs = [];
  if (r.src === "t") for (const n in trainSpells) { if (trainSpells[n].has(r.spell)) npcs.push(n); }
  else if (r.src === "v" && vendItems[r.srcItem]) npcs = [...vendItems[r.srcItem]];
  const ids = new Set();
  for (const n of npcs) for (const i of spotsOf(n)) ids.add(i);
  if (ids.size === 0) { r.set = 0; if (r.src === "t" || r.src === "v") withoutSet++; continue; }
  const k = [...ids].sort((a, b) => a - b).join(",");
  if (!setIdx[k]) { sets.push(k); setIdx[k] = sets.length; }
  r.set = setIdx[k]; withSet++;
}
console.log("recipes with NPC locations:", withSet, "without:", withoutSet, "spots:", spots.length, "sets:", sets.length);

// ---- tools / focus objects (forge, anvil, cooking fire...)
const focusNames = {}; for (const r of csv("SpellFocusObject.csv")) focusNames[r.ID] = r.Name_lang;
const focusBySpell = {};
for (const r of csv("SpellCastingRequirements.csv")) if (+r.RequiresSpellFocus > 0) focusBySpell[r.SpellID] = +r.RequiresSpellFocus;
const recFocus = {}; const usedFocus = {};
for (const p of PROF) for (const r of recipes[p.key]) if (focusBySpell[r.spell]) { recFocus[r.spell] = focusBySpell[r.spell]; usedFocus[focusBySpell[r.spell]] = true; }
console.log("focus objects used:", Object.keys(usedFocus).map(i => i + "=" + focusNames[i]).join(", "));

// ---- emit
const lines = [];
lines.push("-- GENERATED FILE (tools/build_recipes.js). Do not edit by hand.");
lines.push("-- Sources: wago.tools DB2 exports (WoW Forever build 1.60.1.70888: SkillLineAbility, SpellReagents,");
lines.push("-- SpellEffect, SpellName, ItemSparse) and the cmangos classic-db project (GPL-2.0): trainer skill");
lines.push("-- requirements, recipe items and vendor lists.");
lines.push("local _, ns = ...");
lines.push("ns.RecipeData = {");
for (const p of PROF) {
  lines.push(`  ${p.key} = { skill = ${p.id}, recipes = {`);
  recipes[p.key].sort((a, b) => a.low - b.low || a.spell - b.spell);
  for (const r of recipes[p.key]) {
    const rg = r.reag.map(([i, n]) => i + ":" + n).join(",");
    // spell|req|low|high|item|qty|src|srcItem|reagents
    lines.push(`    "${r.spell}|${r.req}|${r.low}|${r.high}|${r.item}|${r.qty}|${r.src}|${r.srcItem}|${rg}|${r.set || ""}",`);
  }
  lines.push("  } },");
}
lines.push("}");
// item meta: sell price, vendor buy price (only when a vendor sells it without limit)
lines.push("-- NPC spots: name|faction(0 both,1 alliance,2 horde)|uiMapID|x*10000|y*10000");
lines.push("ns.Spots = {");
spots.forEach((sp, i) => lines.push("  " + JSON.stringify(sp) + ", -- " + (i + 1)));
lines.push("}");
lines.push("ns.SpotSets = {");
sets.forEach((st, i) => lines.push("  " + JSON.stringify(st) + ", -- " + (i + 1)));
lines.push("}");
lines.push("-- recipe spell -> required nearby object (forge, anvil...)");
lines.push("ns.RecipeFocus = {");
for (const sp in recFocus) lines.push("  [" + sp + "] = " + recFocus[sp] + ",");
lines.push("}");
lines.push("ns.FocusNames = {");
for (const id in usedFocus) lines.push("  [" + id + "] = " + JSON.stringify(focusNames[id]) + ",");
lines.push("}");
lines.push("-- itemId = \"sellPrice|vendorBuyPrice\" (vendorBuyPrice 0 = not sold by vendors)");
lines.push("ns.ItemData = {");
const ids = Object.keys(itemsUsed).map(Number).sort((a, b) => a - b);
for (const id of ids) {
  const s = sparse[id] || {};
  const sell = s.sell || 0;
  const buy = vendor[id] ? (s.buy || 0) : 0;
  if (sell || buy) lines.push(`  [${id}] = "${sell}|${buy}",`);
}
lines.push("}");
fs.writeFileSync(OUT, lines.join("\n") + "\n");
console.log("items", ids.length, "bytes", fs.statSync(OUT).size);
for (const p of PROF) console.log(p.key, recipes[p.key].length);
