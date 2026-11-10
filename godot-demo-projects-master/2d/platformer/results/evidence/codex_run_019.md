# Codex run 019 — GODOT-DTC-07

Added Normal/Large HUD text sizing for both score and message labels. Large text uses an 84 px override; Normal explicitly restores the baseline 60 px. The preference persists across HUD instances during the session.

Environment: Windows; Godot 4.7.2 stable; headless; 480x720 base viewport. Source baseline: `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.

Ten assertions passed: both choices and default, score/message font sizes, a large message fitting the 480 px viewport width, persistence to another HUD instance, restoration to Normal, and player speed. No runtime warnings were emitted.

Limitations: The check measures label minimum width; it does not inspect actual rendered glyph clipping or accessibility outcomes with users.
