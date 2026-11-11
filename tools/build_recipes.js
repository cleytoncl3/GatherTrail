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
    lines.push(`    "${r.spell}|${r.req}|${r.low}|${r.high}|${r.item}|${r.qty}|${r.src}|${r.srcItem}|${rg}",`);
  }
  lines.push("  } },");
}
lines.push("}");
// item meta: sell price, vendor buy price (only when a vendor sells it without limit)
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
