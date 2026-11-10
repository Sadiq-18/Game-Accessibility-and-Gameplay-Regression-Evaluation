# Codex run 017 — GODOT-DTC-05

Added a HUD high-contrast toggle and a 2 px bright yellow outline shader to player and mob sprites. The toggle updates existing entities, and newly created entities read the active setting.

Environment: Windows; Godot 4.7.2 stable; headless; 480x720 base viewport. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Nine assertions passed for toggle presence/state, shader outline parameters, shader neighborhood sampling, player and new-mob setup, turning the effect off, and player speed. Godot exited successfully.

Limitations: The shader compiled and its runtime parameters were checked, but this headless test did not verify rendered border pixels or assess visual accessibility with users. Please visually inspect the outline in the editor before submission.
