# Codex run 013 — GODOT-DTC-01

Added a start-screen difficulty selector for Easy, Normal, and Hard. Easy sets a 1.0 s spawn interval and 0.7 mob-speed multiplier; Normal preserves the 0.5 s interval and original speed range; Hard uses a 0.3 s interval and 1.3 multiplier.

Environment: Windows; Godot 4.7.2 stable; headless. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Ten assertions passed for selector choices/default, easy and hard configuration, actual easy/normal spawned mob velocities, timer settings, and player scene preservation. No runtime warnings were emitted.

Limitations: Spawn counts and difficulty balance over a full play session were not evaluated with human players.
