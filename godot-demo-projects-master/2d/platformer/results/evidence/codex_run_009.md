# Codex run 009 — GODOT-PLAT-09

Added Assist Mode to the pause menu. When enabled, player gravity is multiplied by 0.7 and patrol enemy walk speed by 0.5; disabling it restores baseline behavior. The setting is shared through Engine metadata for the active game session.

Environment: Windows; Godot 4.7.2 stable; headless. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Eight assertions passed: baseline values, menu setting state, reduced gravity, slower enemy speed, restored defaults, and player collision mask. Godot exited code 0 with ObjectDB/resource cleanup warnings.

Limitations: No player study or difficulty-completion experiment was performed; the check verifies the implemented parameter changes and selected regression state.
