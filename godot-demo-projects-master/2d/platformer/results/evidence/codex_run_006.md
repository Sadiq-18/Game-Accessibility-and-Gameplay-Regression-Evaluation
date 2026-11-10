# Codex run 006 — GODOT-PLAT-06

Implemented monochrome P1/P2 text badges as children of each split-screen player, keyed by the existing action suffix. The badge is high contrast and follows the player node. Existing collision masks, input suffixes, and viewport dimensions remain unchanged.

Environment: Windows; Godot 4.7.2 stable; headless. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Check: `agent_run_check.gd` instantiates the split-screen scene and checks badge visibility/labels, both collision masks, and both viewport sizes. Seven assertions passed. Godot exited with code 0. It reported ObjectDB/resource cleanup warnings on exit; these are retained in the test log and should be investigated separately.

Limitations: Automated scene checks verify badge configuration and structural regressions, not visual legibility across all displays or user testing.
