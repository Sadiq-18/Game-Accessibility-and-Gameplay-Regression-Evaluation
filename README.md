# GAB-36: Accessibility and Gameplay Regression Evaluation

**Assignment 2 implementation** for the proposal *Evaluating AI Coding Agents for Game Accessibility Enhancement and Gameplay Regression Prevention*.

**Authors:** Shaik Mohammad Sadiq (24BTRCL182) and Seethaka Umesh Reddy (24BTRCL181)  
**Department:** Computer Science and Engineering, Jain (Deemed-to-be University)

## What this repository implements

The research model is a reproducible, rule-based dual-outcome evaluator. For each completed coding-agent task it takes two explicitly recorded results:

- **A:** all scripted accessibility acceptance checks passed.
- **G:** the scripted checks for existing gameplay behavior passed after the change.

It classifies each run as joint success (`A=1,G=1`), accessibility success with a regression (`A=1,G=0`), accessibility failure without a regression (`A=0,G=1`), or total failure (`A=0,G=0`). It then reports accessibility success `RA`, gameplay preservation `RG`, joint success `RJ`, and detected regression `RR`. This is the proposed evaluation model; it is not a trained reinforcement-learning agent or a learned neural network.

## Current measured results

The repository contains **30 observed, task-level Codex runs** on clean worktrees pinned to Godot demo revision `b761b4cd5718a7118f2c95eb55f181d0a5f004f1`:

| Candidate project | Measured runs |
|---|---:|
| 2D Platformer | 12 / 12 |
| Dodge the Creeps | 12 / 12 |
| Role Playing Game | 6 / 12 |
| **Total** | **30 / 36** |

The default report currently records `N=30`, `RA=96.7%`, `RG=100.0%`, `RJ=96.7%`, and `RR=0.0%`. RPG task 04 is recorded as an accessibility failure because the upstream RPG project had no audio players or audio assets; bus and slider configuration alone did not prove audible categories. RPG tasks 07–12 have not been run and are not counted. The six missing task runs must not be represented as successes.

The 30 records use captured Godot 4.7.2 headless runs and scripted checks. They represent one agent/model setup and do not establish results for other agents, unrun tasks, visual usability on a display, or accessibility for human participants. See each run's evidence note and raw log in `godot-demo-projects-master/2d/platformer/results/evidence/`.

## Quick start: reproduce the evaluation report

Requirements: Python 3.10 or later. The evaluator uses only the Python standard library.

```bash
cd godot-demo-projects-master/2d/platformer
python run_evaluation.py
```

The command reads `dataset/tasks_36.json` and `dataset/agent_runs.json`, validates run records, and writes `results/benchmark_results.json` and `results/evaluation_report.md`.

The synthetic classifier examples are stored separately and are excluded from the empirical report. To inspect them independently:

```bash
python run_evaluation.py --runs dataset/demo_runs.json
```

## Reproduce a Godot task run

Requirements: Git and Godot 4.7.2 stable. Each archived patch is based on the clean upstream revision above and includes that task's implementation and `tests/agent_run_check.gd`. Use a fresh checkout for each run because the patches edit overlapping demo files.

Example for run 001:

```bash
git clone https://github.com/godotengine/godot-demo-projects.git upstream-run
cd upstream-run
git checkout b761b4cd5718a7118f2c95eb55f181d0a5f004f1
git apply --check /path/to/GAB36-Assignment2/godot-demo-projects-master/2d/platformer/results/evidence/codex_run_001.patch
git apply /path/to/GAB36-Assignment2/godot-demo-projects-master/2d/platformer/results/evidence/codex_run_001.patch
godot --headless --editor --path 2d/platformer --quit
godot --headless --path 2d/platformer --script res://tests/agent_run_check.gd
```

Choose the project path using the task prefix: `2d/platformer`, `2d/dodge_the_creeps`, or `2d/role_playing_game`. The run index maps to its task and test command in `dataset/agent_runs.json`; each `codex_run_NNN.md` names the task and summarizes scope. The archived `codex_run_NNN_test.log` is the output observed when the original run was executed. Reproduction may vary by OS, display/audio device, or engine build.

The checked-in demo projects are included under `godot-demo-projects-master/2d/` so the implementations can also be inspected and opened directly in Godot. The source demo repository's license and attribution are retained in that directory.

## Repository layout

```text
.
├── README.md
├── THIRD_PARTY_NOTICES.md
└── godot-demo-projects-master/
    ├── LICENSE.md
    └── 2d/
        ├── platformer/        # Evaluation code, dataset, results, evidence, and game
        ├── dodge_the_creeps/  # Candidate game with measured implementations
        └── role_playing_game/ # Candidate game with measured implementations through task 06
```

Inside the Platformer project:

- `dataset/tasks_36.json` and `dataset/tasks_table.csv`: authored benchmark task specifications.
- `dataset/agent_runs.json`: observed run records and provenance.
- `dataset/demo_runs.json`: synthetic examples kept separate from measured records.
- `src/evaluator.py`, `run_evaluation.py`: evaluation model and CLI.
- `src/dataset_generator.py`: deterministic task-table generation.
- `DATASET_DOCUMENTATION.md`: data collection, screening, annotation, and run-record process.
- `results/evidence/`: per-run patch, test script, raw Godot output, and human-readable scope note.

## Final package smoke check

After assembly, the included latest task smoke test was run in each of the three game folders after Godot editor import: Platformer (10 checks), Dodge the Creeps (10 checks), and RPG (10 checks) all exited successfully. The first two logs include a resource-cleanup warning at shutdown; see `results/package_validation/`. These checks validate that the packaged sources and current test scripts load together. They are packaging checks, not new task records, so the benchmark remains N=30.
## Dataset creation and research scope

GAB-36 is a set of 36 authored task specifications across three official Godot demo projects. It is not a participant dataset and contains no personal data. The documentation describes source selection, revision pinning, candidate screening, task annotation, preprocessing, and the distinction between candidate tasks and completed runs. No human accessibility study or multi-agent comparison was performed.

## Current submission status

The dual-outcome model is runnable and the 30 recorded results reproduce through the CLI. The current package is complete for those 30 runs; it does not claim full 36-task experimental coverage. Before claiming all 36 tasks are implemented and evaluated, run and document RPG-07 through RPG-12 with fresh-baseline patches and captured output.

