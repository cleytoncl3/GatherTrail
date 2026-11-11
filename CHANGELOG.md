# Trailsmith

## 1.3.3
- Debug log: every click, option change, profession/recipe selection, craft attempt (APIs tried and their results), trainer lookup, key binding and Lua error in the Professions window and in the main options is recorded. Game events during crafting (spell cast start/fail/success, UI error messages, blocked actions) are recorded too. View it with `/tsp log` (copy with Ctrl+C), clear with `/tsp log clear`, switch it off in Settings. It is saved in the SavedVariables file.

## 1.3.2
- Recipes you still have to learn now have a **Find trainer / Find vendor** button. It picks the nearest one for your faction, opens the world map on the right zone, marks it with a pin (and a map waypoint or TomTom arrow when available) and prints the name and coordinates in chat.
- New footer in the Crafting tab, like the default crafting window: selected recipe, required station (forge, anvil, loom, cooking fire...), materials with how many you have, and Craft / Craft all buttons.
- Layout fixes: the crafting options panel no longer overlaps (long labels wrap and spacing follows the text size), smaller numbers in the summary cards, wider profession list so names such as First Aid are not cut.
- The recipe database now includes about 280 trainer and vendor locations (converted to world-map coordinates) and the station each recipe needs.

## 1.3.1
- Profession window redesigned in the standard WoW style (same frame and red buttons as the Trailsmith options). Profession list with names on the left, crafting options (mode, recipe sources, prices) in a panel on the right, plan/materials/recipes in the middle.
- The window can be resized by dragging the bottom-right corner, and the text scales with the window size. + / - buttons on the title bar change the window scale; sliders for text and number size in Settings.

## 1.3.0
- The window now works like a character-panel tab: it opens with the **K** key (changeable, can be turned off; the old action stays on Shift+K), with a square icon per profession down the left side and tabs along the top: **Crafting**, **Gathering** and **Settings**.
- New **Gathering** tab: the gathering guide switches (ore, herbs, autoloot, auto-hide, range) without leaving the window. Herbalism, Skinning and Fishing now show in the side list.
- A button to open Blizzard's own window for the same key.

## 1.2.1
- Profession planner: search bar at the top (recipes, crafted items and materials across all professions), separate text-size and number-size sliders in Settings, wider window, shorter card titles and labels so nothing overlaps.

## 1.2.0
- New **Profession planner** (on by default). Open it with `/tsp`, `/gt prof`, Shift-click on the minimap button, or the button in the General tab.
- Pick a profession (Alchemy, Blacksmithing, Cooking, Enchanting, Engineering, First Aid, Leatherworking, Mining/Smelting, Tailoring), set a skill range and get a step-by-step leveling plan with crafts, materials and cost.
- Three plan modes: cheapest, best profit, fewest crafts. Shopping list with what you already own, a full recipe browser with difficulty bands, and a settings tab.
- Prices from Auctionator, TradeSkillMaster or Auctioneer (automatic), vendor prices as a fallback. Option to count raw materials as free if you gather them yourself.
- Recipe database (about 2,500 recipes) generated from public data, see `tools/build_recipes.js` and the README.
- Four window skins, scale and opacity options. English, Spanish and Portuguese, chosen from the game language.

## 1.1.1
- The addon folder is now `Trailsmith` (was `GatherTrail`); saved data moves to the new name. If you update from 1.1.0, delete the old `GatherTrail` folder.

## 1.1.0
- New **Combat** tab: the Combat Tutor (formerly MVAT) is now a module inside Trailsmith, off by default. Enable it to get the floating ability icon, enemy cast panel, boss warnings and group dispel panel.
- Saved data for the tutor lives in `MVAT_DB`; `/mvat` and `/tutor` still work (they point to the Combat tab while the module is off).

## 1.0.0
- Directional arrow, minimap line and minimap / world map icons for ore and herbs (green ring = skill is enough, red = too low).
- Ore icons use the smelted bar; icon transparency scales with node rarity; icon size and transparency are adjustable.
- Resources tab: per-resource filter, skill requirement, Auctionator price, sort by price, best value only, hide nodes far below your skill.
- Gathering autoloot and smart autoloot (gold and quest items only).
- Learns confirmed spawns when you gather or hover nodes on the minimap; optional auto-hide of empty points.
- Optional starter database through the separate GatherTrailData addon.
- Resizable, tabbed options window; English, Spanish and Portuguese picked from the game language.
