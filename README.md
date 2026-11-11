# Trailsmith

A toolkit for gatherers and more: a gathering guide for **Mining** and **Herbalism** (WoW Classic / WoW Forever): a directional arrow, a minimap line and minimap / world map icons for the nearest nodes your skill can gather, per-resource filters with Auctionator prices, and an autoloot made for gatherers. It only shows information; it never acts for your character.

The full feature description, FAQ and commands are in [CURSEFORGE.md](CURSEFORGE.md) (the text used on the CurseForge page).

## Install

- **CurseForge:** install **Trailsmith** and **GatherTrailData** (optional starter database).
- **Manually:** copy the `Trailsmith` folder to `Interface/AddOns`. For the starter database also copy [GatherTrailData](https://github.com/cleytoncl3/GatherTrailData) next to it.
- **Update without git:** run `Update.bat` in the addon folder (it downloads the latest version of this repository).

Languages: English, Spanish and Portuguese, chosen from the game language.

## Combat Tutor module

The former MVAT addon is included as an optional module (off by default). Enable it in the **Combat** tab. It only draws information and never acts for your character. See [CURSEFORGE.md](CURSEFORGE.md#combat-tutor-optional-module-off-by-default). If you still have the standalone `MVAT` folder, delete it so the two do not clash.

## How nodes are found

The client does not expose the minimap tracking blips to addons, so Trailsmith combines: the optional starter database (GatherMate2 data), the spots you gather (saved as confirmed), and nodes learned by hovering the minimap with tracking on. See [CURSEFORGE.md](CURSEFORGE.md#how-it-finds-nodes-read-this).

## Community confirmations (optional)

Spots you confirm are saved as compact keys (`map:item:x:y`). Run `Contribute.bat` after a `/reload` to open a prefilled GitHub issue with only those numbers; you review it and press Submit. A workflow (`workflow-template/confirm.yml`, to be moved to `.github/workflows/`) marks a point as confirmed in `ConfirmedData.lua` only when 3 different accounts confirm it. The addon ignores keys that are not in the player's own starter database, so invented keys have no effect.

## Releasing

Tag a version (for example `v1.1.0`) and push the tag: the packaging workflow (`workflow-template/release.yml`) builds the zip with `.pkgmeta` and uploads it to CurseForge. It needs the `CF_API_KEY` repository secret and the project ID in the TOC as `## X-Curse-Project-ID`.

## Credits and license

MIT, see [LICENSE](LICENSE). Starter locations come from GatherMate2 data (GPL) and live in the separate [GatherTrailData](https://github.com/cleytoncl3/GatherTrailData) addon.
