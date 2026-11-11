# Text for the CurseForge project page (copy and paste)

**Summary (one line):** Gathering guide, profession leveling planner, smart autoloot and an optional combat tutor.

---

# Trailsmith

Trailsmith is a toolkit for **gathering and crafting**: a gathering guide for **Mining** and **Herbalism**, a **profession leveling planner**, a smart autoloot, and an optional **Combat Tutor**. It points you to the nearest node you can actually gather, draws icons on the minimap and the world map, and keeps the screen clean with filters. It also includes an autoloot made for gatherers.

> Trailsmith only **shows information**. It never moves, targets, casts or clicks for your character.

## What you get

- **Directional arrow** to the nearest node your skill can gather, with its name and distance. Move it with Shift+drag. A **Skip** button hides a node that turned out to be empty (Shift+click removes it for good).
- **Minimap and world map icons**, round and clean:
  - green ring = your skill is high enough, red ring (grey icon) = your skill is too low;
  - ores use the icon of the smelted bar, so Tin and Gold are easy to tell apart;
  - **transparency scales with rarity**: common nodes (Copper, Tin) fade out, rare ones (Mithril, Thorium, ...) stay visible. You choose the base transparency and the icon size.
- **Line on the minimap** to the closest node, drawn only when the node is confirmed.
- **Adjustable range**, 50 to 2000 yards. Only nodes inside the circle around you are shown.
- **Resources tab** with every ore and herb: tick or untick each one, see the skill it needs, and see its **current Auctionator price** (from your last Auctionator scan). Sort by price, or press **Best value only** to keep just the 5 most expensive nodes your skill can gather. A slider can also hide nodes far below your skill.
- **Smart autoloot**:
  - *Gathering autoloot*: after mining, picking herbs or skinning, loots everything from that gather automatically (works with the game autoloot turned off);
  - *Quest and gold autoloot*: on mobs and containers, takes only **money and quest items** and leaves the rest in the loot window.
- **Languages**: English, Espanol and Portugues, picked automatically from your game client.

## Profession planner (on by default)

Open it with `/tsp`, `/gt prof`, **Shift + click on the minimap button**, or the button in the General tab.

- Choose a profession: Alchemy, Blacksmithing, Cooking, Enchanting, Engineering, First Aid, Leatherworking, Mining (smelting) or Tailoring.
- Set **from** and **to** skill (one click fills in your current skill and your max) and read a step-by-step plan: which recipe to craft at each skill range, how many crafts, which materials, and what it costs.
- Three modes: **Cheapest**, **Best profit** (counts what the crafted items sell for) and **Fewest crafts**.
- **Materials** tab: a shopping list of raw materials with how many you already own. **Recipes** tab: every recipe with its difficulty bands (orange / yellow / green / grey), where you learn it, and its cost.
- **Prices** come from Auctionator, TradeSkillMaster or Auctioneer (picked automatically, or choose in Settings). Without one of them it falls back to vendor values. Tick *I gather raw materials myself* to count ores, herbs and leather as free.
- Recipes you already know are used first. You choose which other sources are allowed: trainer, vendor-sold recipes, recipe items (drops and quests), or unknown source.
- Four window skins, plus scale and opacity sliders. Works in English, Spanish and Portuguese.
- The recipe database (about 2,500 recipes) is built from public data (see Credits). Skill-up odds are estimates, and a few recipe requirements are estimated too.

## Combat Tutor (optional module, off by default)

Trailsmith also bundles **Combat Tutor** (formerly the MVAT addon). Turn it on in the **Combat** tab of the options.

- One floating icon shows the ability to use **right now**, with your key binding: emergency, interrupt, dispel, heal, taunt, procs and combos, AoE and missing buffs, for all 9 Classic classes.
- Extra panels: what the enemy is casting, boss warnings, group debuffs you can remove, and the next abilities in the queue.
- It only suggests abilities you already know, and (by default) only ones on your action bars.
- It is **purely informational**: it never casts, targets or clicks for you.
- Nothing from this module runs until you enable it. Its own windows (opened with `/mvat` or `/tutor`) are currently in Portuguese.

## How it finds nodes (read this)

The game draws the nodes of *Find Minerals* / *Find Herbs* on the minimap itself and **does not give their positions to addons**. No addon can read them, so Trailsmith works from known locations:

1. **Starter database** (optional, recommended): install **GatherTrailData**, which carries node locations from GatherMate2 data.
2. **What you gather**: when you gather a node, its exact location is saved as *confirmed*.
3. **Minimap hover**: with tracking on, hovering a node on the minimap shows its name; Trailsmith learns it and snaps it to the nearest known location.
4. **Auto-hide empty points**: if you rest the mouse on a Trailsmith icon on the minimap with tracking on and the game shows nothing there, the point is hidden for a while (you choose how long).

So the icons show **where nodes can be**, and the game's own tracking shows what is up *right now*. Use both together.

## Setup

1. Install Trailsmith and **GatherTrailData** (optional dependency; without it only points you learn yourself are shown).
2. Learn *Find Minerals* / *Find Herbs* tracking if your class has it (optional but useful).
3. Open the options with `/gt` or by clicking the minimap button.

## Options

- **General**: enable, autoloot types, which gathering professions to track, starter database, learning from minimap hover, auto-hide empty points, test mode (shows the arrow so you can move it), detection range, respawn hide time.
- **Display**: arrow, lock arrow position, minimap button, minimap icons, world map icons, line to confirmed nodes, red nodes, only confirmed points, icon size, transparency, arrow size.
- **Resources**: per-resource list with skill and Auctionator price, hide nodes far below your skill, sort and best-value buttons.
- **Combat**: turn the Combat Tutor module on or off and open its options.

The options window can be resized from its bottom-right corner.

## Commands

`/gt` or `/gathertrail` opens the options.

- `/gt range <50-2000>`: set the detection range
- `/gt test`: toggle test mode (show the arrow so you can drag it)
- `/gt lock`: lock or unlock the arrow
- `/gt skip` / `/gt skip always`: skip the current node for a while / forever
- `/gt unskip`: bring skipped nodes back
- `/gt toggle`: enable or disable the addon
- `/gt scan`: print what is known around you
- `/gt clear`: delete saved nodes
- `/gt debug`, `/gt map`, `/gt probe`: diagnostics

Minimap button: **left click** opens the options, **right click** enables or disables the addon, **drag** moves the button. There is also a key binding for *Skip current point* under Key Bindings > AddOns.

## FAQ

**Does it show nodes that are spawned right now?** No. The game does not expose that to addons. It shows known locations; use the game tracking for live spawns.

**Is it safe to use?** Yes. It only reads public API data and draws information. It does not automate anything.

**Prices are missing.** Prices come from the last Auctionator scan. Install Auctionator and scan the auction house.

**Does it need GatherTrailData?** Not to run, but without it only the points you learn yourself are shown.

## Credits and license

- Starter locations: GatherMate2 data by kagaro, Xinhuan and Nevcairiel (GPL), shipped separately as GatherTrailData.
- Optional prices: Auctionator.
- Trailsmith itself is MIT licensed.

## Project setup notes (for the author, not for the page)

On the project page, under *Relations*, add **GatherTrailData** as an **optional** dependency.
