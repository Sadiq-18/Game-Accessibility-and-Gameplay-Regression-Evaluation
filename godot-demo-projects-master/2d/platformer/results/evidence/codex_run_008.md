# Codex run 008 — GODOT-PLAT-08

Added a 100%, 125%, and 150% UI scale selector. It applies a centered transform to the game's InterfaceLayer CanvasLayer, so the pause interface and overlay scale together and remain centered in the viewport.

Environment: Windows; Godot 4.7.2 stable; headless. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Eight assertions passed: all choices exist, 100% default, both axes scale at 125%, centered transform offsets, 150% scale, restore to 100%, and player collision mask preservation. Godot exited code 0 with ObjectDB/resource cleanup warnings.

Limitations: This automated check validates transform state, not screenshots or visual clipping on multiple screen sizes. The scaling mechanism centers the full canvas but should receive a visual check in the editor before release.
