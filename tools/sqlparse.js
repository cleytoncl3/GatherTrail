// Minimal parser for mysqldump INSERT statements of selected tables.
const fs = require("fs");
const D = "C:/Users/Cleyton/AppData/Local/Temp/claude/ffba5859012f6237/18c57d67-60c0-4a16-9371-29b84dd83aae/scratchpad/wago/";
const sql = fs.readFileSync(D + "classicdb.sql", "utf8");

function columns(tn) {
  const s = sql.indexOf("CREATE TABLE `" + tn + "`");
  if (s < 0) return null;
  const e = sql.indexOf(") ENGINE", s);
  const cols = [];
  for (const line of sql.slice(s, e).split("\n")) {
    const m = line.match(/^\s+`([^`]+)`\s/);
    if (m) cols.push(m[1]);
  }
  return cols;
}

function rows(tn, wanted) {
  const cols = columns(tn);
  if (!cols) return [];
  const idx = wanted.map(w => cols.indexOf(w));
  const out = [];
  let pos = 0;
  const marker = "INSERT INTO `" + tn + "`";
  for (;;) {
    const s = sql.indexOf(marker, pos);
    if (s < 0) break;
    let i = sql.indexOf("VALUES", s) + 6;
    // parse tuples until ';' outside of quotes
    for (;;) {
      while (sql[i] === " " || sql[i] === "\n" || sql[i] === ",") i++;
      if (sql[i] === ";") { i++; break; }
      if (sql[i] !== "(") { i++; continue; }
      i++;
      const vals = [];
      let cur = "", q = false, isStr = false;
      for (;; i++) {
        const c = sql[i];
        if (q) {
          if (c === "\\") { cur += sql[i + 1]; i++; }
          else if (c === "'") { if (sql[i + 1] === "'") { cur += "'"; i++; } else q = false; }
          else cur += c;
        } else if (c === "'") { q = true; isStr = true; }
        else if (c === ",") { vals.push(cur); cur = ""; isStr = false; }
        else if (c === ")") { vals.push(cur); i++; break; }
        else cur += c;
      }
      out.push(idx.map(k => (k >= 0 ? vals[k] : undefined)));
    }
    pos = i;
  }
  return out;
}
module.exports = { rows, columns };
