# Codex run 020 — GODOT-DTC-08

Added 100%, 125%, and 150% HUD scale choices. The entire HUD CanvasLayer scales uniformly and applies a centered viewport offset.

Environment: Windows; Godot 4.7.2 stable; headless; 480x720 base viewport. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Nine assertions passed for scale choices/default, both axes at 125%, centered offset, 150%, restoring 100%, and unchanged player speed and mob timer.

Limitations: The test verifies the CanvasLayer transform, but does not inspect rendered HUD clipping or multiple screen sizes.
