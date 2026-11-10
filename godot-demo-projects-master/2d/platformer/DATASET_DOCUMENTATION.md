# Dataset Documentation: Godot Game Accessibility Benchmark
---

## 1. Overview and Purpose

The **Godot Game Accessibility Benchmark (GAB-36)** is a task-based dataset specifically designed to evaluate whether AI coding agents can implement accessibility improvements in existing open-source game projects without causing regressions in previously working gameplay.

While existing benchmarks (e.g., *GameDevBench*, *SWE-Game*) focus on general tutorial tasks or bug repairs, GAB-36 focuses on:
1. **Accessibility Compliance**: Verification against explicit, observable acceptance criteria derived from the **Xbox Accessibility Guidelines (XAG)**.
2. **Gameplay Preservation**: Explicit regression testing to confirm that the game's core interactive mechanics remain fully intact.

---

## 2. Dataset Size and Scope

- **Total Tasks**: 36 structured task specifications.
- **Candidate Projects**: 3 representative open-source Godot 4 games from the official Godot Engine demo repository:
  1. **2D Platformer** (12 tasks): Fast-paced physics platformer focused on movement kinematics, jumping, shooting, coin pickups, and visual interface scaling.
  2. **Dodge the Creeps** (12 tasks): Arcade survival game focused on input responsiveness, mob speed scaling, feedback indicators, and HUD scaling.
  3. **Role Playing Game (RPG)** (12 tasks): Grid-exploration and turn-based combat game focused on text readability, dialogue customization, inventory scaling, and status indicators.
- **Accessibility Feature Coverage**: 14 distinct feature categories based on XAG.
- **Screening Summary**:
  - **Plausible (26 tasks)**: Initially judged suitable for source inspection and runtime verification.
  - **Conditional (10 tasks)**: Candidate tasks dependent on engine components (e.g. physical gamepad connectivity, audio captioning for games without voice acting, or navigation mesh inspection).

These labels are screening annotations, not task-completion labels or measurements of any AI coding agent. Project-feature pairs still need to be checked against the exact local project revision before use.

---

## 3. Dataset Creation Process

### 3.1 Data Collection
- **Source Selection**: Candidate game projects were selected from the official [Godot Engine Demo Projects](https://github.com/godotengine/godot-demo-projects) repository.
- **Inclusion Criteria**:
  - Maintained for Godot 4.x.
  - Free from external proprietary dependencies.
  - Baseline gameplay can be checked after cloning and opening the candidate project.
  - Diverse interaction models: physics platforming, continuous evasion, and menu/turn-based dialogue.

### 3.2 Preprocessing and Filtering
- Each project was inspected to extract:
  - Input mappings (`project.godot` `[input]` section).
  - Scene tree hierarchies (`.tscn` scenes).
  - Script architecture (`.gd` scripts and autoloads).
  - Existing audio bus layouts (`default_bus_layout.tres`).
- Irrelevant files (e.g. engine export presets, editor caches) were excluded to focus strictly on game scripts and GUI scenes.
- No player-participant data or agent execution logs are part of GAB-36. The dataset consists of authored candidate task specifications and screening annotations.

### 3.3 Task Specification and Annotation
Each task in the dataset was authored and annotated according to the schema defined in Section 4.4 of the research paper:

```json
{
  "task_id": "Unique identifier (e.g. GODOT-PLAT-01)",
  "candidate_project": "Candidate game name",
  "source_repository": "Upstream source URL",
  "project_version": "Godot engine target version",
  "feature_category": "One of 14 XAG accessibility categories",
  "task_instruction": "Precise instruction provided to the coding agent",
  "expected_behaviour": "Functional description of the expected change",
  "screening_status": "Plausible | Conditional",
  "screening_notes": "Technical justification for screening status",
  "baseline_checks": ["Array of baseline gameplay features to verify pre-modification"],
  "accessibility_acceptance_criteria": ["Observable criteria determining A = 1"],
  "regression_checks": ["Array of regression tests determining G = 1"],
  "target_files": ["Expected files to be modified"]
}
```

---

## 4. Feature Taxonomy (14 Categories)

| # | Accessibility Category | Primary Target Game | Example Acceptance Criteria |
| :- | :--- | :--- | :--- |
| 1 | **Adjustable text size** | 2D Platformer / RPG | Font size scales by ~1.5x without text truncation or button clipping. |
| 2 | **Keyboard control remapping** | All 3 games | Rebinding directional/action keys in menu updates player control. |
| 3 | **Controller button remapping** | 2D Platformer | Face buttons can be remapped for jump/shoot actions. |
| 4 | **Separate audio controls** | All 3 games | Independent volume sliders for Master, Music, and SFX buses. |
| 5 | **Mute & feedback controls** | All 3 games | One-click mute instantly silences audio without halting gameplay loop. |
| 6 | **High-contrast mode** | All 3 games | High-contrast borders/shading exceed 4.5:1 contrast ratio. |
| 7 | **Colour-independent indicators**| 2D Platformer / RPG | Badges/icons differentiate players/status without reliance on color tint. |
| 8 | **Colour-vision-friendly palette**| Dodge the Creeps | Palette adjustments ensure contrast under simulated protanopia/deuteranopia. |
| 9 | **User-interface scaling** | All 3 games | Full UI canvas can scale up (100% to 150%) without boundary overflow. |
| 10 | **Difficulty adjustment** | Dodge the Creeps / Platformer | Assist mode slows mob speeds or reduces gravity timing pressures. |
| 11 | **Reduced motion** | 2D Platformer / RPG | Disables background parallax scrolling or battle screen-shake. |
| 12 | **Alternative input support** | Dodge the Creeps / Platformer | Auto-fire or mouse pointer follow alternative to keyboard tapping. |
| 13 | **Subtitles & audio captions** | All 3 games | Visual caption toasts pop up for significant gameplay sound cues. |
| 14 | **Subtitle/dialogue customization**| RPG | Dialogue box background opacity slider (0.5 to 1.0) and text color options. |

---

## 5. Dataset Files Included

1. `dataset/tasks_36.json`: Complete, machine-readable JSON dataset containing all 36 task records with full arrays for acceptance criteria and regression checks.
2. `dataset/tasks_table.csv`: Convenient tabular CSV representation for quick inspection and reporting.
3. `src/dataset_generator.py`: Reproducible generator script to build, validate, and assert dataset consistency.

The generated task content is deterministic. The dataset does not establish that all 36 feature-project combinations have been executed or that an AI agent has completed them.

## 6. Recording Real Agent Runs

`dataset/agent_runs.json` currently contains 30 observed Codex task runs: 12 Platformer tasks, 12 Dodge the Creeps tasks, and RPG tasks 01–06. Each was run from a clean worktree at official Godot demo revision `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`, with a task-specific implementation patch, Godot check script, captured output log, and evidence note in `results/evidence/`. The default runner evaluates this file. These results are task-level evidence from one coding-agent/model setup; they do not establish performance across the six unrun RPG tasks, other agents, or human accessibility outcomes.

The evaluation snapshot at repository preparation time is N=30, RA=96.7%, RG=100.0%, RJ=96.7%, and RR=0.0%. RPG task 04 has `accessibility_checks_passed: false`: the upstream RPG project had no audio stream players or audio assets, so adding audio buses and sliders did not demonstrate actual separately audible categories. The six unrun tasks (RPG-07 through RPG-12) are absent from the measured run file and excluded from all denominators. Re-run `python run_evaluation.py` to regenerate the metrics from the checked-in records.

`dataset/demo_runs.json` remains available as synthetic input solely to demonstrate the outcome classifier. Its rows are excluded from empirical metrics. To add more observed runs, append records to `dataset/agent_runs.json` using the following schema:

```json
[
  {
    "run_id": "agent-run-001",
    "run_type": "agent_run",
    "task_id": "GODOT-PLAT-01",
    "accessibility_checks_passed": true,
    "gameplay_checks_passed": true,
    "agent": "Agent name",
    "model": "Model and version",
    "project_revision": "Git commit or release",
    "environment": "OS and Godot version",
    "evidence": "Path or description of recorded check evidence",
    "changed_files": ["gui/pause_menu.gd"],
    "notes": "Observed outcomes and relevant details"
  }
]
```

Both outcome fields must be booleans based on completed checks, not guesses from source code. Record evidence for the accessibility acceptance checks and baseline gameplay checks. The runner requires agent/model, project revision, environment, and evidence for every `agent_run`; demonstration metrics are reported separately.

If a task's baseline cannot be verified, record it as a blocked run instead of entering guessed pass/fail values:

```json
{
  "run_id": "blocked-001",
  "run_type": "blocked_run",
  "task_id": "GODOT-PLAT-01",
  "blocking_reason": "Baseline movement could not be verified in the available environment."
}
```

Blocked runs appear in the report but are excluded from RA, RG, RJ, and RR denominators.

Run the evidence-backed result with:

```bash
python run_evaluation.py
```

To view synthetic examples separately, run:

```bash
python run_evaluation.py --runs dataset/demo_runs.json
```

Do not copy synthetic example values into the real-run file. If baseline behavior could not be verified, record a `blocked_run` or revise the task and state why in the research notes.

### 6.1 Reproducing a Codex task run

The run is pinned to official source revision `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`. From a fresh clone of the official demo repository, apply the archived patch and run the included Godot test:

```bash
git checkout b761b4cd5718a7118f2c95eb55f181d0a5f004f1
git apply /path/to/codex_run_001.patch
godot --headless --path 2d/platformer --editor --quit
godot --headless --path 2d/platformer --script res://tests/agent_run_check.gd
```

The one-time editor/import command registers Godot global script classes before the test script runs. Use a fresh clone or reset to the pinned revision for each task because patches can change overlapping files. Select the patch by its evidence index and determine the project path from the task prefix (`2d/platformer`, `2d/dodge_the_creeps`, or `2d/role_playing_game`). `results/evidence/codex_run_NNN.md` documents each run's scope and interpretation; its matching patch, test script, and captured output are archived alongside it.

---

## 7. How to Reproduce Dataset Generation

From the assignment project folder (`godot-demo-projects-master/2d/platformer`), run:
```bash
python src/dataset_generator.py
```
Expected output:
```
Generated 36 task specifications in: dataset/tasks_36.json
Generated tabular CSV view in: dataset/tasks_table.csv
Summary: 36 tasks total (26 Plausible, 10 Conditional).
Verification passed: 12 tasks per project, 14 feature categories, 26 plausible and 10 conditional candidates.
```
