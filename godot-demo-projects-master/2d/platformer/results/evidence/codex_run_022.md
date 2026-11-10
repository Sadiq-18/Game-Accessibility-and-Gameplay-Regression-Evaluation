# Codex run 022 — GODOT-DTC-10

Added an optional Follow pointer control. When enabled, the player moves at the existing speed toward the mouse position; keyboard movement continues unchanged when the option is off. Position remains clamped to the viewport.

Environment: Windows; Godot 4.7.2 stable; headless; 480x720 base viewport. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Eight assertions passed. The test warped the mouse, measured the player’s distance to the reported pointer position before/after movement, checked keyboard behavior with the option off, viewport clamping, and collision shape presence.

Limitations: Simulated mouse coordinates in headless mode map unusually (`(-125.7, 0)` in this run); the check proves movement toward Godot’s reported pointer target but should be followed by a GUI run on a real display.
