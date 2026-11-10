# Codex run 010 — GODOT-PLAT-10

Added a Hold to auto-fire option. When enabled, player shooting checks the held action each physics tick and the existing Gun cooldown limits the actual firing rate. With the option disabled, the original just-pressed behavior remains.

Environment: Windows; Godot 4.7.2 stable; headless. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Six assertions passed. A one-second held-input trial spawned four bullets, confirming repeated shots under the existing cooldown; the check also verified enable/disable state, input release, and unchanged collision mask. Godot exited code 0 with ObjectDB/resource cleanup warnings.

Limitations: This automated test uses simulated input, not a physical keyboard or accessibility user trial.
