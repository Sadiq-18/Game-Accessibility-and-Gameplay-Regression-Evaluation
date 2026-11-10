# Codex run 012 — GODOT-PLAT-12

Added controller button capture and rebinding for Jump and Shoot. The handler replaces only Joypad Button events, preserving keyboard bindings, and updates the menu to show the selected button number.

Environment: Windows; Godot 4.7.2 stable; headless. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Ten assertions passed: existing gamepad and keyboard mappings, capture state, remapping Jump to button index 2 and Shoot to index 3, UI labels, simulated mapped input activating Jump, and preserved player collision mask. Godot exited code 0 with ObjectDB/resource cleanup warnings.

Limitations: The test simulates controller events; no physical gamepad model or platform-specific button labeling was tested.
