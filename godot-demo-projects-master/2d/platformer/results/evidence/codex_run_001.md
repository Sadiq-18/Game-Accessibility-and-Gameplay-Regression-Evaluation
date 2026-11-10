# Codex Run 001: GODOT-PLAT-01

## Run identity

- **Agent/model:** OpenAI Codex, GPT-6
- **Task:** `GODOT-PLAT-01` — implement Normal/Large text sizing in the 2D Platformer pause menu.
- **Clean starting revision:** `godotengine/godot-demo-projects` commit `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`.
- **Environment:** Windows; Godot 4.7.2 stable (`ed1daf0bf`); headless; project viewport 800x480.
- **Recorded outcome:** Accessibility `A=1`; gameplay preservation `G=1`; joint success.

## Evidence files

- `codex_run_001.patch` is the exact implementation and test patch applied to the clean starting revision.
- `codex_run_001_test.gd` is the test script included in that patch.
- `codex_run_001_test.log` is the captured output after applying the patch to a fresh clone at the pinned revision. Godot exited with code 0 and all 28 assertions passed.

The assertions cover Normal as the default; both selector options; immediate font overrides; viewport bounds; label/button minimum sizes; non-overlapping menu rows; persistence into a new pause-menu instance; movement, first jump, and double jump; shooting and cooldown; physical bullet/enemy collision; physical coin pickup; pause/resume; and transitions to and from splitscreen.

## Reproduction

From a fresh clone of the official Godot demo repository:

```bash
git checkout b761b4cd5718a7118f2c95eb55f181d0a5f004f1
git apply /path/to/codex_run_001.patch
godot --headless --path 2d/platformer --editor --quit
godot --headless --path 2d/platformer --script res://tests/agent_run_check.gd
```

The editor/import step is required once so Godot registers the project’s global script classes.

## Scope and limits

This is one observed agent run on one task. It demonstrates that the implementation and evaluator work; it does not establish performance across all 36 tasks, multiple agents, or a statistically representative sample. The gameplay checks are automated regression checks, not a human playtest.
