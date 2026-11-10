# Codex run 016 — GODOT-DTC-04

Added keyboard remapping controls for Up, Down, Left, and Right. The handler replaces keyboard events only, leaving other event types intact; Escape cancels an in-progress capture.

Environment: Windows; Godot 4.7.2 stable; headless; 480x720 base viewport. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Twelve assertions passed: four controls/actions exist, Left is rebound to Q and activates the movement action via a parsed input event, all four bindings update, start-game action remains present, and player speed is unchanged. No runtime warnings were emitted.

Limitations: The test uses simulated keyboard events; no physical keyboard or remapping usability study was performed.
