"""
Dataset Generation Script for:
Evaluating AI Coding Agents for Game Accessibility Enhancement and Gameplay Regression Prevention
Shaik Mohammad Sadiq (24BTRCL182) & Seethaka Umesh Reddy (24BTRCL181)
Department of Computer Science and Engineering, Jain (Deemed-to-be University)
"""

import json
import csv
import os
from collections import Counter

TASKS = [
    # ==========================================
    # 2D Platformer (12 Tasks: GODOT-PLAT-01 to 12)
    # Focus: Movement, Input, and Visual-Interface
    # ==========================================
    {
        "task_id": "GODOT-PLAT-01",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Adjustable text size",
        "task_instruction": "Add an adjustable text size selector in the pause menu supporting Normal (default) and Large (~1.5x) text sizes with immediate runtime application.",
        "expected_behaviour": "Pause menu text size toggles between Normal and Large font sizes without clipping or button overflow, persisting across pause toggles.",
        "screening_status": "Plausible",
        "screening_notes": "Pause menu uses Theme font and standard VBoxContainer, making font size overrides straightforward.",
        "baseline_checks": [
            "Player can run, jump, double jump, and shoot",
            "Bullets destroy patrol enemies",
            "Coins can be collected",
            "Pause and unpause halts and resumes game tree"
        ],
        "accessibility_acceptance_criteria": [
            "Normal and Large options selectable in PauseMenu",
            "Font size applies immediately upon selection",
            "No text clipping, overlap, or screen boundary overflow",
            "Selection persists across session instances"
        ],
        "regression_checks": [
            "Player jump and movement velocity remain identical",
            "Shooting cooldown and bullet collisions remain operational",
            "Singleplayer and splitscreen scene transitions work without error"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd"]
    },
    {
        "task_id": "GODOT-PLAT-02",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Keyboard control remapping",
        "task_instruction": "Implement an in-game keyboard remapping interface in the pause menu allowing custom key assignment for move_left, move_right, jump, and shoot.",
        "expected_behaviour": "Players can rebind primary action keys and immediately control the player with the new keys.",
        "screening_status": "Plausible",
        "screening_notes": "InputMap API in Godot 4 supports dynamic runtime action event addition and removal.",
        "baseline_checks": [
            "Default controls work as expected before remapping",
            "Physics and player kinematics function properly"
        ],
        "accessibility_acceptance_criteria": [
            "Remap options visible for left, right, jump, shoot",
            "New key press successfully registers to the action",
            "Remapped keys trigger corresponding gameplay action"
        ],
        "regression_checks": [
            "Escape key pause menu toggle is not unbound",
            "Double-jump mechanics remain intact with new jump key"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd"]
    },
    {
        "task_id": "GODOT-PLAT-03",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Separate audio controls",
        "task_instruction": "Configure dedicated AudioServer buses for Music and SFX and add volume sliders in the pause menu.",
        "expected_behaviour": "Master, Music, and SFX volumes can be adjusted independently via sliders in the pause menu.",
        "screening_status": "Plausible",
        "screening_notes": "Requires adding Music and SFX buses to default_bus_layout.tres and routing AudioStreamPlayers.",
        "baseline_checks": [
            "Background music loops continuously",
            "Jump, shoot, and coin pickup audio effects play"
        ],
        "accessibility_acceptance_criteria": [
            "Independent sliders for Master, Music, and SFX in pause menu",
            "Adjusting Music slider does not affect SFX volume",
            "Volume levels persist across scene transitions"
        ],
        "regression_checks": [
            "Audio continues to play when unpaused",
            "Pitch scaling on double jump remains audible"
        ],
        "target_files": ["default_bus_layout.tres", "gui/pause_menu.tscn", "gui/pause_menu.gd"]
    },
    {
        "task_id": "GODOT-PLAT-04",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Mute and audio feedback controls",
        "task_instruction": "Add audio mute toggles for Master, Music, and SFX in the pause menu.",
        "expected_behaviour": "Audio buses can be completely silenced with a single click/toggle.",
        "screening_status": "Plausible",
        "screening_notes": "AudioServer.set_bus_mute() provides direct engine-level support.",
        "baseline_checks": [
            "All sounds play when unmuted",
            "Game runs without audio exceptions"
        ],
        "accessibility_acceptance_criteria": [
            "Mute checkboxes visible in settings",
            "Muting silences target bus without error",
            "Unmuting restores previous volume level"
        ],
        "regression_checks": [
            "Gameplay speed is not affected by muted audio",
            "Audio state persists during pause/resume"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd"]
    },
    {
        "task_id": "GODOT-PLAT-05",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "High-contrast mode",
        "task_instruction": "Add a high-contrast mode toggle for UI buttons and borders in the pause menu.",
        "expected_behaviour": "UI elements switch to high-contrast monochrome/high-luminance borders and text for enhanced visibility.",
        "screening_status": "Plausible",
        "screening_notes": "Can override StyleBoxFlat border colors and text colors on theme.",
        "baseline_checks": [
            "Standard pause menu buttons are clickable and readable",
            "Menu buttons maintain focus navigation"
        ],
        "accessibility_acceptance_criteria": [
            "High-contrast toggle in menu",
            "Button borders and text contrast ratio exceeds 4.5:1",
            "Focus outlines remain distinctly visible"
        ],
        "regression_checks": [
            "Button click signals remain connected",
            "Resume and Quit actions continue to function"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd"]
    },
    {
        "task_id": "GODOT-PLAT-06",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Colour-independent visual indicators",
        "task_instruction": "Add shape-based or icon glyph indicators to the player to differentiate Player 1 and Player 2 in split-screen, rather than color modulate alone.",
        "expected_behaviour": "Visual indicators (e.g., 'P1' / 'P2' badges) distinguish players independently of tint.",
        "screening_status": "Conditional",
        "screening_notes": "Conditional on inspecting sprite modulate vs node badge parenting in SubViewport.",
        "baseline_checks": [
            "Both players spawn and move independently in split-screen",
            "Split-screen viewports render world geometry correctly"
        ],
        "accessibility_acceptance_criteria": [
            "Distinct non-color icons or badges appear over players",
            "Badges follow player positions during movement and jumping",
            "Badges are distinguishable in greyscale"
        ],
        "regression_checks": [
            "Player collision masks and movement are unaffected",
            "Viewport split remains intact"
        ],
        "target_files": ["player/player.tscn", "player/player.gd"]
    },
    {
        "task_id": "GODOT-PLAT-07",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Reduced motion and camera shake",
        "task_instruction": "Add a reduced motion toggle to disable background parallax layer motion scrolling.",
        "expected_behaviour": "ParallaxBackground scroll scale is set to zero or static when reduced motion is enabled.",
        "screening_status": "Plausible",
        "screening_notes": "ParallaxBackground node allows adjusting scroll_base_scale.",
        "baseline_checks": [
            "Camera follows player smoothly within level boundaries",
            "Background clouds and sky scroll at parallax rates"
        ],
        "accessibility_acceptance_criteria": [
            "Reduced motion toggle available in pause menu",
            "Parallax layers stop independent motion when active",
            "Camera tracking of player remains smooth"
        ],
        "regression_checks": [
            "Camera limits left/right/top/bottom are preserved",
            "Level geometry collision remains aligned"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd", "level/background/parallax_background.tscn"]
    },
    {
        "task_id": "GODOT-PLAT-08",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "User-interface scaling",
        "task_instruction": "Implement dynamic UI scale adjustments (100%, 125%, 150%) for the InterfaceLayer canvas.",
        "expected_behaviour": "CanvasLayer or root UI scale scales up without clipping screen boundaries.",
        "screening_status": "Plausible",
        "screening_notes": "Can be applied via CanvasLayer scale or root viewport stretch factors.",
        "baseline_checks": [
            "CoinsCounter displays in top-left corner",
            "PauseMenu centers on screen"
        ],
        "accessibility_acceptance_criteria": [
            "Multiple scaling percentages selectable",
            "UI expands proportionally from center",
            "No elements clip beyond 800x480 resolution"
        ],
        "regression_checks": [
            "Buttons receive click events at scaled positions",
            "Game rendering viewport resolution remains unaffected"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd"]
    },
    {
        "task_id": "GODOT-PLAT-09",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Difficulty adjustment",
        "task_instruction": "Add an Assist Mode setting offering reduced gravity and slower enemy walk speed.",
        "expected_behaviour": "Players can toggle an Assist Mode to make platforming timing less punishing.",
        "screening_status": "Plausible",
        "screening_notes": "Enemy WALK_SPEED and player gravity parameters can be modified via settings.",
        "baseline_checks": [
            "Enemies patrol platforms at 22 px/s",
            "Player gravity accelerates at 2100 px/s^2"
        ],
        "accessibility_acceptance_criteria": [
            "Assist Mode toggle present in PauseMenu",
            "Enemy speed reduces by 30-50% when enabled",
            "Player air-time is increased predictably"
        ],
        "regression_checks": [
            "Enemy collision layer and bullet destruction remain functional",
            "Coin collection still operates normally"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd", "enemy/enemy.gd", "player/player.gd"]
    },
    {
        "task_id": "GODOT-PLAT-10",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Alternative input support",
        "task_instruction": "Implement single-action / auto-fire alternative input options for shooting.",
        "expected_behaviour": "Holding the shoot action or toggling auto-fire fires bullets continuously at cooldown rate without rapid button tapping.",
        "screening_status": "Plausible",
        "screening_notes": "Can change Input.is_action_just_pressed to is_action_pressed when auto-fire is active.",
        "baseline_checks": [
            "Shooting fires single bullets on press",
            "Gun cooldown limits rate of fire"
        ],
        "accessibility_acceptance_criteria": [
            "Auto-fire toggle in pause menu",
            "Holding shoot continuously fires bullets at timer rate",
            "Release stops shooting immediately"
        ],
        "regression_checks": [
            "Player walk and jump can occur simultaneously while shooting",
            "Bullet physics and velocity remain standard"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd", "player/player.gd"]
    },
    {
        "task_id": "GODOT-PLAT-11",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Subtitles or caption presentation",
        "task_instruction": "Add visual caption toasts for important sound events (Jump, Shoot, Enemy Explode, Coin Pickup).",
        "expected_behaviour": "On-screen text labels appear briefly when audio effects trigger.",
        "screening_status": "Conditional",
        "screening_notes": "Conditional because base demo has no dialogue/speech; sound effect captions must be clearly scoped.",
        "baseline_checks": [
            "Audio effects trigger on actions",
            "No on-screen caption UI exists by default"
        ],
        "accessibility_acceptance_criteria": [
            "Visual text cues appear near event locations or on HUD",
            "Captions fade out after 1-2 seconds",
            "Caption option can be toggled in menu"
        ],
        "regression_checks": [
            "Sound streams still play normally",
            "Gameplay framerate and physics remain smooth"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd", "level/level.tscn"]
    },
    {
        "task_id": "GODOT-PLAT-12",
        "candidate_project": "2D Platformer",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer",
        "project_version": "Godot 4.x",
        "feature_category": "Controller button remapping",
        "task_instruction": "Allow gamepad button rebinding for Joypad Button indices for jump and shoot actions.",
        "expected_behaviour": "Players can swap controller face buttons (e.g. A and X) for jumping and shooting.",
        "screening_status": "Conditional",
        "screening_notes": "Conditional due to needing physical gamepad connected or virtual event simulation.",
        "baseline_checks": [
            "Gamepad buttons 0 (A) and 2 (X) jump and shoot",
            "Gamepad D-pad / analog stick controls movement"
        ],
        "accessibility_acceptance_criteria": [
            "Gamepad remapping options displayed",
            "InputEventJoypadButton successfully updates in InputMap",
            "Rebound gamepad buttons control actions"
        ],
        "regression_checks": [
            "Keyboard input continues to work simultaneously",
            "Splitscreen player 1 / player 2 device mappings do not cross"
        ],
        "target_files": ["gui/pause_menu.tscn", "gui/pause_menu.gd"]
    },

    # ==========================================
    # Dodge the Creeps (12 Tasks: GODOT-DTC-01 to 12)
    # Focus: Input, Feedback, and Difficulty
    # ==========================================
    {
        "task_id": "GODOT-DTC-01",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Difficulty adjustment",
        "task_instruction": "Add game speed / mob spawn rate difficulty options (Easy, Normal, Hard) to the main start screen.",
        "expected_behaviour": "Selecting Easy reduces mob speed and increases spawn timer intervals.",
        "screening_status": "Plausible",
        "screening_notes": "MobTimer wait_time and min/max mob speeds are easily parameterized.",
        "baseline_checks": [
            "Mobs spawn along path and fly across screen",
            "Player dies on collision with mob"
        ],
        "accessibility_acceptance_criteria": [
            "Difficulty selector available on Start HUD",
            "Easy mode visibly slows mob velocities by at least 30%",
            "Score counter increments appropriately"
        ],
        "regression_checks": [
            "Game over sequence triggers properly on contact",
            "Start button resets score and clears existing mobs"
        ],
        "target_files": ["main.gd", "hud.tscn", "hud.gd"]
    },
    {
        "task_id": "GODOT-DTC-02",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Colour-vision-friendly palette",
        "task_instruction": "Implement a color-blind friendly palette mode for player, mobs, and background.",
        "expected_behaviour": "High-visibility color schemes applied to distinguish mobs from background.",
        "screening_status": "Plausible",
        "screening_notes": "Can adjust AnimatedSprite2D modulates or canvas shader.",
        "baseline_checks": [
            "Player and mob sprite animations play correctly",
            "Background color displays ColorRect"
        ],
        "accessibility_acceptance_criteria": [
            "Palette toggle selectable in options",
            "Mob sprites contrast strongly with background under deuteranopia/protanopia simulation",
            "All animation frames preserve contrast"
        ],
        "regression_checks": [
            "Mob movement trajectory remains unaffected",
            "Collision detection Area2D remains intact"
        ],
        "target_files": ["main.gd", "mob.gd", "player.gd"]
    },
    {
        "task_id": "GODOT-DTC-03",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Separate audio controls",
        "task_instruction": "Add volume controls for Music (bgm) and SFX (death sound, button press) in HUD.",
        "expected_behaviour": "Independent audio volume control sliders for background audio and gameplay sounds.",
        "screening_status": "Plausible",
        "screening_notes": "Music and DeathSound nodes can be routed to separate audio buses.",
        "baseline_checks": [
            "Music starts on game start",
            "Death sound plays on game over"
        ],
        "accessibility_acceptance_criteria": [
            "Separate sliders for Music and SFX",
            "Setting Music to zero leaves death sound audible",
            "Settings persist across game restarts"
        ],
        "regression_checks": [
            "Audio triggers do not delay game over scene logic",
            "Score timer keeps ticking at 1s intervals"
        ],
        "target_files": ["main.tscn", "main.gd", "hud.tscn"]
    },
    {
        "task_id": "GODOT-DTC-04",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Keyboard control remapping",
        "task_instruction": "Add key remapping for directional movement actions (move_up, move_down, move_left, move_right).",
        "expected_behaviour": "Player movement responds to remapped keys.",
        "screening_status": "Plausible",
        "screening_notes": "Four directional actions defined in project settings can be rebound.",
        "baseline_checks": [
            "Arrow keys and WASD move player across screen",
            "Player clamped within screen boundaries"
        ],
        "accessibility_acceptance_criteria": [
            "Key remapping menu accessible from start/pause",
            "Rebinding a direction moves player in that direction",
            "Diagonal movement normalizes velocity properly"
        ],
        "regression_checks": [
            "Player speed constant (400 px/s) remains unchanged",
            "Animation flips (up/walk) match movement direction"
        ],
        "target_files": ["hud.tscn", "hud.gd", "player.gd"]
    },
    {
        "task_id": "GODOT-DTC-05",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "High-contrast mode",
        "task_instruction": "Implement a high-contrast toggle outlining the player and mobs with thick high-visibility borders.",
        "expected_behaviour": "High-contrast outline shaders or border frames encircle all moving entities.",
        "screening_status": "Plausible",
        "screening_notes": "ShaderMaterial with outline shader can be toggled on sprites.",
        "baseline_checks": [
            "Mobs and player render sprite animations",
            "Game runs without visual artifacting"
        ],
        "accessibility_acceptance_criteria": [
            "High contrast toggle in settings",
            "Outlines clearly distinguish mobs against all backgrounds",
            "Outlines scale accurately with sprite frames"
        ],
        "regression_checks": [
            "Hitbox extents are not altered by visual outlines",
            "Mob rotation towards player velocity remains accurate"
        ],
        "target_files": ["mob.tscn", "player.tscn", "hud.gd"]
    },
    {
        "task_id": "GODOT-DTC-06",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Mute and audio feedback controls",
        "task_instruction": "Provide one-click audio mute toggles on the main HUD.",
        "expected_behaviour": "Mute toggle silences all game audio instantly.",
        "screening_status": "Plausible",
        "screening_notes": "AudioServer master bus mute toggle.",
        "baseline_checks": [
            "Audio streams play at standard levels",
            "Game restart plays background music"
        ],
        "accessibility_acceptance_criteria": [
            "Mute button on HUD",
            "Audio output immediately halts when enabled",
            "Mute state persists across new rounds"
        ],
        "regression_checks": [
            "Gameplay loop (start, dodge, death, restart) works identically",
            "Score counts up during round"
        ],
        "target_files": ["hud.tscn", "hud.gd"]
    },
    {
        "task_id": "GODOT-DTC-07",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Adjustable text size",
        "task_instruction": "Add adjustable text size options for HUD score and message labels.",
        "expected_behaviour": "Score label and game over message labels scale between Normal and Large.",
        "screening_status": "Plausible",
        "screening_notes": "Theme override font size on ScoreLabel and MessageLabel.",
        "baseline_checks": [
            "Score label displays top-center",
            "Message label shows 'Dodge the Creeps!' and 'Game Over'"
        ],
        "accessibility_acceptance_criteria": [
            "Text size option selectable in settings",
            "Labels enlarge by ~1.5x",
            "Score stays centered without wrapping or clipping"
        ],
        "regression_checks": [
            "MessageTimer countdown and transitions function properly",
            "StartButton remains accessible and clickable"
        ],
        "target_files": ["hud.tscn", "hud.gd"]
    },
    {
        "task_id": "GODOT-DTC-08",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "User-interface scaling",
        "task_instruction": "Add full HUD canvas scaling option for smaller or larger screens.",
        "expected_behaviour": "Entire HUD layer scales proportionally.",
        "screening_status": "Plausible",
        "screening_notes": "HUD is a CanvasLayer, scale property can be adjusted.",
        "baseline_checks": [
            "UI elements render at native 480x720 aspect",
            "Start button click registers"
        ],
        "accessibility_acceptance_criteria": [
            "UI scale selector (1.0x, 1.25x)",
            "Buttons and score scale without screen cut-off",
            "Click hitboxes match scaled button visuals"
        ],
        "regression_checks": [
            "Start button press triggers game start signal",
            "Player controls respond immediately"
        ],
        "target_files": ["hud.tscn", "hud.gd"]
    },
    {
        "task_id": "GODOT-DTC-09",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Colour-independent visual indicators",
        "task_instruction": "Add warning trajectory lines or directional arrows indicating incoming mob paths.",
        "expected_behaviour": "Visual indicator arrows flash along screen borders before mobs enter.",
        "screening_status": "Conditional",
        "screening_notes": "Requires adding predictive trajectory calculation nodes.",
        "baseline_checks": [
            "Mobs spawn randomly along Path2D PathFollow2D",
            "Mobs travel inward across viewport"
        ],
        "accessibility_acceptance_criteria": [
            "Indicators appear at spawn coordinates 0.5s before entry",
            "Indicators communicate direction using geometric arrows",
            "Feature can be toggled on/off in options"
        ],
        "regression_checks": [
            "Mob spawn positions and angles remain random",
            "Player movement speed is unchanged"
        ],
        "target_files": ["main.tscn", "main.gd"]
    },
    {
        "task_id": "GODOT-DTC-10",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Alternative input support",
        "task_instruction": "Implement mouse/touch follow-pointer movement as an alternative to keyboard buttons.",
        "expected_behaviour": "Player moves toward the mouse cursor position smoothly.",
        "screening_status": "Conditional",
        "screening_notes": "Player script currently reads Input.get_vector(move_left, ...).",
        "baseline_checks": [
            "Keyboard directional controls function correctly",
            "Collision with mobs causes player hit signal"
        ],
        "accessibility_acceptance_criteria": [
            "Toggle between Keyboard and Mouse-Follow mode",
            "Player moves toward cursor without exceeding maximum speed",
            "Reaching cursor position halts movement without jitter"
        ],
        "regression_checks": [
            "Screen boundary clamping remains active",
            "Game over hit detection triggers on contact"
        ],
        "target_files": ["player.gd", "hud.tscn"]
    },
    {
        "task_id": "GODOT-DTC-11",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Reduced motion and camera shake",
        "task_instruction": "Ensure no full-screen flashes or rapid flickering occur upon player death.",
        "expected_behaviour": "Optional gentle fade on death instead of abrupt visual transitions.",
        "screening_status": "Conditional",
        "screening_notes": "DTC does not have intense screen shake natively, so task is verification-focused.",
        "baseline_checks": [
            "Player stops and hides on hit",
            "MessageLabel shows Game Over"
        ],
        "accessibility_acceptance_criteria": [
            "Death transition provides soft fade option",
            "No high-frequency visual flashes",
            "Motion options configurable in HUD"
        ],
        "regression_checks": [
            "Game over timer and restart timing preserved",
            "Mobs queue_free after exiting visible on-screen notifier"
        ],
        "target_files": ["main.gd", "hud.gd"]
    },
    {
        "task_id": "GODOT-DTC-12",
        "candidate_project": "Dodge the Creeps",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps",
        "project_version": "Godot 4.x",
        "feature_category": "Subtitles or caption presentation",
        "task_instruction": "Display visual captions when audio events trigger (Music Start, Death Sound, New Score).",
        "expected_behaviour": "Captions pop up in HUD when audio cues play.",
        "screening_status": "Conditional",
        "screening_notes": "Conditional due to lack of speech; targets audio event captions.",
        "baseline_checks": [
            "Sound effects and music play at standard trigger points",
            "Score updates every second"
        ],
        "accessibility_acceptance_criteria": [
            "Caption box shows '[Death Sound]' or '[Music]' when played",
            "Captions disappear automatically after 1.5s",
            "Captions do not obscure the player or incoming mobs"
        ],
        "regression_checks": [
            "Audio playback is unaffected",
            "Score count remains accurate"
        ],
        "target_files": ["hud.tscn", "hud.gd", "main.gd"]
    },

    # ==========================================
    # Role Playing Game (12 Tasks: GODOT-RPG-01 to 12)
    # Focus: Dialogue, Battle Systems, Interface, and Text
    # ==========================================
    {
        "task_id": "GODOT-RPG-01",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Adjustable text size",
        "task_instruction": "Implement selectable text sizing (Normal, Large) for dialogue windows and battle menus.",
        "expected_behaviour": "Dialogue text and combat command choices expand to larger readable fonts.",
        "screening_status": "Plausible",
        "screening_notes": "RichTextLabel and Dialogue boxes support dynamic theme font size changes.",
        "baseline_checks": [
            "Dialogue advances on action press",
            "Combat menu displays Attack, Skill, Item commands"
        ],
        "accessibility_acceptance_criteria": [
            "Text size option in pause/game settings",
            "Dialogue text renders at larger size without line truncation",
            "Menu buttons expand to prevent text clipping"
        ],
        "regression_checks": [
            "Dialogue progression signals trigger correctly",
            "Combat command selections execute target actions"
        ],
        "target_files": ["dialogue/dialogue_box.tscn", "dialogue/dialogue_box.gd"]
    },
    {
        "task_id": "GODOT-RPG-02",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Subtitle or dialogue customization",
        "task_instruction": "Add dialogue background opacity and text color customization options.",
        "expected_behaviour": "Players can adjust dialogue window background tint to high-contrast opaque black.",
        "screening_status": "Plausible",
        "screening_notes": "Dialogue panel stylebox background color/alpha can be configured.",
        "baseline_checks": [
            "Dialogue window opens over map view",
            "Character portrait and text align inside frame"
        ],
        "accessibility_acceptance_criteria": [
            "Background opacity slider (0.5 to 1.0) in settings",
            "Opaque background enhances text readability against map background",
            "Text color choice persists during playthrough"
        ],
        "regression_checks": [
            "Dialogue scrolling/pagination functions normally",
            "Map player movement remains paused during dialogue"
        ],
        "target_files": ["dialogue/dialogue_box.tscn", "dialogue/dialogue_box.gd"]
    },
    {
        "task_id": "GODOT-RPG-03",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Keyboard control remapping",
        "task_instruction": "Implement control remapping for exploration movement and menu confirm/cancel actions.",
        "expected_behaviour": "Players can remap grid movement keys and interaction keys.",
        "screening_status": "Plausible",
        "screening_notes": "InputMap handles ui_accept, ui_cancel, and directional movement.",
        "baseline_checks": [
            "Player moves on grid between tiles",
            "Enter/Space interacts with NPCs and objects"
        ],
        "accessibility_acceptance_criteria": [
            "Remapping options for Move Up, Down, Left, Right, Interact, Cancel",
            "New keys immediately allow character movement",
            "Rebound interact key triggers NPC conversations"
        ],
        "regression_checks": [
            "Turn-based tile step collision remains solid",
            "Menu navigation keys stay functional"
        ],
        "target_files": ["menus/options_menu.tscn", "menus/options_menu.gd"]
    },
    {
        "task_id": "GODOT-RPG-04",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Separate audio controls",
        "task_instruction": "Add separate volume sliders for Background Music, Battle Audio, and Interface SFX.",
        "expected_behaviour": "Players can independently adjust town music, battle music, and UI sound effects.",
        "screening_status": "Plausible",
        "screening_notes": "Requires audio bus configuration in default_bus_layout.tres.",
        "baseline_checks": [
            "Town music plays during exploration",
            "Battle transition plays combat track",
            "UI sounds click on menu selection"
        ],
        "accessibility_acceptance_criteria": [
            "Separate sliders for Master, Music, Battle, and UI SFX",
            "Adjusting UI SFX does not alter background music",
            "Audio levels persist across scene transitions"
        ],
        "regression_checks": [
            "Scene transitions smoothly cross-fade or switch audio",
            "No audio stuttering during battle load"
        ],
        "target_files": ["default_bus_layout.tres", "menus/options_menu.tscn"]
    },
    {
        "task_id": "GODOT-RPG-05",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Colour-independent visual indicators",
        "task_instruction": "Add textual status indicators (e.g., 'Weak', 'Strong', 'Poison') alongside color health bars.",
        "expected_behaviour": "Health and combat states display numbers and icons instead of relying solely on red/green bar fills.",
        "screening_status": "Plausible",
        "screening_notes": "Combat UI health bars can have overlay labels with numeric HP (e.g. 85/100).",
        "baseline_checks": [
            "HP bar drains when taking damage in battle",
            "Player and enemy health tracked accurately"
        ],
        "accessibility_acceptance_criteria": [
            "Numeric HP displayed on health bar",
            "Status effects indicated by distinct icon shapes and text names",
            "Information is clearly legible in monochrome"
        ],
        "regression_checks": [
            "Damage calculations and turn resolution are unchanged",
            "Defeated entities trigger death animations and victory state"
        ],
        "target_files": ["combat/combat_ui.tscn", "combat/combat_ui.gd"]
    },
    {
        "task_id": "GODOT-RPG-06",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "High-contrast mode",
        "task_instruction": "Implement a high-contrast mode for battle menus and text boxes.",
        "expected_behaviour": "Menu backgrounds become solid black with high-luminance white text and borders.",
        "screening_status": "Plausible",
        "screening_notes": "Theme styles can be overridden for combat menus and inventory.",
        "baseline_checks": [
            "Battle menus render with theme textures",
            "Command list scrolls through available spells"
        ],
        "accessibility_acceptance_criteria": [
            "High contrast option in settings",
            "Active menu selection indicated by high-contrast outline",
            "All text achieves high contrast ratio against backgrounds"
        ],
        "regression_checks": [
            "Command confirmation executes selected combat skill",
            "Menu focus traversal behaves properly"
        ],
        "target_files": ["menus/options_menu.tscn", "combat/combat_ui.tscn"]
    },
    {
        "task_id": "GODOT-RPG-07",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Alternative input support",
        "task_instruction": "Add mouse-click point-and-click movement and menu selection for exploration.",
        "expected_behaviour": "Clicking a map tile routes player movement to that tile.",
        "screening_status": "Conditional",
        "screening_notes": "Conditional on inspecting grid movement scripts and A* navigation availability.",
        "baseline_checks": [
            "Grid step movement handles collisions with obstacles",
            "Random encounters or triggers operate on destination"
        ],
        "accessibility_acceptance_criteria": [
            "Clicking an accessible tile initiates path walk",
            "Clicking an NPC navigates and triggers interaction",
            "Keyboard movement remains simultaneously active"
        ],
        "regression_checks": [
            "Player cannot walk through solid wall tiles",
            "Turn counters and battle transitions operate normally"
        ],
        "target_files": ["map/player.gd", "map/grid.gd"]
    },
    {
        "task_id": "GODOT-RPG-08",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Difficulty adjustment",
        "task_instruction": "Add combat difficulty scaling options (Story Mode, Normal, Hard).",
        "expected_behaviour": "Story mode reduces enemy damage and increases player defense.",
        "screening_status": "Plausible",
        "screening_notes": "Damage calculation formulas in combat script can scale by difficulty multiplier.",
        "baseline_checks": [
            "Standard combat deals balanced damage to player and enemies",
            "Player can win or lose battles"
        ],
        "accessibility_acceptance_criteria": [
            "Difficulty selector in options menu",
            "Story Mode applies 0.5x damage taken multiplier",
            "XP and reward progression remains intact"
        ],
        "regression_checks": [
            "Combat turn order and action queues operate without desync",
            "Victory and defeat conditions trigger accurately"
        ],
        "target_files": ["combat/combat.gd", "menus/options_menu.tscn"]
    },
    {
        "task_id": "GODOT-RPG-09",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Mute and audio feedback controls",
        "task_instruction": "Provide audio mute toggles in the options menu.",
        "expected_behaviour": "Mute checkboxes silence individual or all audio channels.",
        "screening_status": "Plausible",
        "screening_notes": "AudioServer.set_bus_mute() integration.",
        "baseline_checks": [
            "Audio streams play during game states",
            "Audio returns when unmuted"
        ],
        "accessibility_acceptance_criteria": [
            "Mute options in options menu",
            "Muting turns off sound output immediately",
            "Unmuting restores exact prior volume"
        ],
        "regression_checks": [
            "Combat animations and message timing do not wait for muted audio",
            "Scene transitions function normally"
        ],
        "target_files": ["menus/options_menu.tscn", "menus/options_menu.gd"]
    },
    {
        "task_id": "GODOT-RPG-10",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "User-interface scaling",
        "task_instruction": "Implement UI scaling for combat HUD and inventory screens.",
        "expected_behaviour": "Inventory and battle command frames scale up for easier reading.",
        "screening_status": "Plausible",
        "screening_notes": "CanvasLayer or Control root scale adjustments.",
        "baseline_checks": [
            "Combat HUD fits inside native window",
            "Item list displays item names and quantities"
        ],
        "accessibility_acceptance_criteria": [
            "UI scale selector (100%, 125%)",
            "Panels scale cleanly without overflowing window bounds",
            "Mouse hitboxes align with scaled buttons"
        ],
        "regression_checks": [
            "Item selection and usage in combat still functions",
            "Cancel button dismisses inventory"
        ],
        "target_files": ["combat/combat_ui.tscn", "menus/options_menu.tscn"]
    },
    {
        "task_id": "GODOT-RPG-11",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Reduced motion and camera shake",
        "task_instruction": "Add a setting to disable screen shake effects during critical hits or magic spell animations.",
        "expected_behaviour": "Camera remains steady during high-impact combat attacks.",
        "screening_status": "Conditional",
        "screening_notes": "Conditional on inspecting combat animation camera offset tweens.",
        "baseline_checks": [
            "Critical attacks execute battle animations",
            "Camera recovers to neutral position"
        ],
        "accessibility_acceptance_criteria": [
            "Camera shake toggle in options",
            "With shake disabled, combat attacks deal damage without moving the camera",
            "Combat damage numbers still appear"
        ],
        "regression_checks": [
            "Attack timings and turn progression are preserved",
            "Combat end screen appears normally"
        ],
        "target_files": ["combat/combat.gd", "combat/combat_camera.gd"]
    },
    {
        "task_id": "GODOT-RPG-12",
        "candidate_project": "Role Playing Game",
        "source_repository": "https://github.com/godotengine/godot-demo-projects/tree/master/2d/role_playing_game",
        "project_version": "Godot 4.x",
        "feature_category": "Subtitles or caption presentation",
        "task_instruction": "Provide on-screen sound effect captions for combat audio (e.g. '[Slash]', '[Magic Cast]', '[Heal]').",
        "expected_behaviour": "Descriptive text badges appear alongside sound effects in battle.",
        "screening_status": "Conditional",
        "screening_notes": "Conditional because base RPG uses text dialogue; captions apply to audio SFX cues.",
        "baseline_checks": [
            "Combat sound effects play on attack",
            "Damage text numbers pop up over targets"
        ],
        "accessibility_acceptance_criteria": [
            "Captions toggle in settings",
            "Combat audio displays textual description",
            "Captions clear after action animation finishes"
        ],
        "regression_checks": [
            "Turn flow is not blocked by caption displays",
            "Sound effects continue to output to audio device"
        ],
        "target_files": ["combat/combat_ui.tscn", "combat/combat.gd"]
    }
]


def generate_dataset_files(output_dir="dataset"):
    os.makedirs(output_dir, exist_ok=True)
    json_path = os.path.join(output_dir, "tasks_36.json")
    csv_path = os.path.join(output_dir, "tasks_table.csv")

    # Write JSON
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(TASKS, f, indent=2)
    print(f"Generated {len(TASKS)} task specifications in: {json_path}")

    # Write CSV
    headers = [
        "task_id", "candidate_project", "feature_category", "screening_status",
        "task_instruction", "expected_behaviour", "target_files"
    ]
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=headers, extrasaction="ignore")
        writer.writeheader()
        for t in TASKS:
            row = dict(t)
            row["target_files"] = ", ".join(t.get("target_files", []))
            writer.writerow(row)
    print(f"Generated tabular CSV view in: {csv_path}")

    # Verification counts
    plausible = sum(1 for t in TASKS if t["screening_status"] == "Plausible")
    conditional = sum(1 for t in TASKS if t["screening_status"] == "Conditional")
    project_counts = Counter(t["candidate_project"] for t in TASKS)
    category_count = len({t["feature_category"] for t in TASKS})
    unique_task_ids = len({t["task_id"] for t in TASKS})
    print(f"Summary: {len(TASKS)} tasks total ({plausible} Plausible, {conditional} Conditional).")
    assert len(TASKS) == 36, "Task count must equal exactly 36!"
    assert plausible == 26, "Plausible task count must equal 26 per research paper!"
    assert conditional == 10, "Conditional task count must equal 10 per research paper!"
    assert project_counts == {"2D Platformer": 12, "Dodge the Creeps": 12, "Role Playing Game": 12}, "Each project must have 12 candidate tasks!"
    assert category_count == 14, "The task set must cover the 14 proposal feature categories!"
    assert unique_task_ids == len(TASKS), "Task IDs must be unique!"
    print("Verification passed: 12 tasks per project, 14 feature categories, 26 plausible and 10 conditional candidates.")


if __name__ == "__main__":
    generate_dataset_files()
