# Codex run 021 — GODOT-DTC-09

Added a flashing directional indicator on the nearest screen edge before each mob spawn. Mob creation is delayed by 0.3 seconds; the warning hides when the mob appears or the game ends.

Environment: Windows; Godot 4.7.2 stable; headless; 480x720 base viewport. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Ten assertions passed for arrow direction/border placement, visible flashing timer, delay before spawn, mob appearing after the delay, warning dismissal, baseline mob velocity, and player speed.

Limitations: This automated run checks indicator state and placement, but does not assess visual salience or timing with players.
