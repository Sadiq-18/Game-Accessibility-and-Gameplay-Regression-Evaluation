# Codex run 007 — GODOT-PLAT-07

Implemented a Reduced motion toggle in the pause menu. Enabling it sets the ParallaxBackground base scale and each ParallaxLayer motion scale to zero; disabling it restores the captured defaults.

Environment: Windows; Godot 4.7.2 stable; headless. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Seven assertions passed: option exists; background and layers freeze; original base scale restores; state resets correctly; player collision mask remains the baseline value. Godot exited code 0 and printed ObjectDB/resource cleanup warnings at shutdown.

Limitations: This automated check verifies node properties and selected gameplay state, but does not measure motion-sickness outcomes with human participants.
