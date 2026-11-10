# Codex run 018 — GODOT-DTC-06

Added a one-click HUD mute toggle that mutes/unmutes the Master audio bus, covering both the music and death sound.

Environment: Windows; Godot 4.7.2 stable; headless; 480x720 base viewport. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Seven assertions passed for control availability, immediate master mute state, both audio routes, restore behavior, and player scene preservation. Godot exited successfully.

Limitations: Bus mute state was verified in the engine; physical audio output was unavailable in the headless run.
