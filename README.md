# Game Accessibility and Gameplay Regression Evaluation

A reproducible evaluation project for measuring whether game accessibility improvements preserve existing gameplay behavior.

## Project highlights

- Evaluates accessibility and gameplay preservation together using a dual-outcome model.
- Includes three Godot game projects: Platformer, Dodge the Creeps, and Role Playing Game.
- Provides a 36-task benchmark, dataset-generation code, scripted checks, and run-by-run evidence.
- Includes installation, evaluation, and reproduction instructions.
- Keeps measured runs separate from synthetic examples.

## Current results

We have evaluated **30 of the 36 benchmark tasks** using Godot 4.7.2 and scripted checks:

| Project | Evaluated |
|---|---:|
| Platformer | 12 / 12 |
| Dodge the Creeps | 12 / 12 |
| Role Playing Game | 6 / 12 |
| **Total** | **30 / 36** |

For the 30 evaluated runs, the current report records:

- Accessibility success (RA): **96.7%**
- Gameplay preservation (RG): **100.0%**
- Joint success (RJ): **96.7%**
- Detected regression (RR): **0.0%**

The remaining six RPG tasks, **RPG-07–12**, are in progress and are not included in these metrics. Each requires a clean project baseline, implementation, and scripted validation, so completing and documenting them takes additional time.

RPG-04 is recorded as an accessibility failure because the original RPG project did not contain audio streams or assets; configuring audio buses and sliders alone did not demonstrate audible output.

## How the evaluation works

For each completed task, the evaluator records two outcomes:

- **A:** Whether the scripted accessibility checks passed.
- **G:** Whether the scripted checks for existing gameplay behavior passed.

It classifies each run by both outcomes and calculates RA, RG, RJ, and RR. This repository implements a reproducible, rule-based evaluator. It does not claim to be a trained reinforcement-learning agent or neural network.

The 30 results represent one agent and model setup. They do not establish performance across other agents, unrun tasks, visual testing with users, or a human accessibility study.

## Repository contents

```text
.
├── README.md
├── THIRD_PARTY_NOTICES.md
└── godot-demo-projects-master/
    ├── LICENSE.md
    └── 2d/
        ├── platformer/
        │   ├── src/              # Evaluation model and dataset generator
        │   ├── dataset/          # Task definitions and observed run records
        │   ├── results/          # Metrics, report, run evidence, and smoke checks
        │   ├── tests/
        │   ├── DATASET_DOCUMENTATION.md
        │   ├── requirements.txt
        │   └── run_evaluation.py
        ├── dodge_the_creeps/
        └── role_playing_game/
```

Synthetic classifier examples are stored in `dataset/demo_runs.json` and are excluded from the measured results.

## Install and run the evaluator

Requirements: Python 3.10 or later. The evaluator uses only the Python standard library.

```bash
cd godot-demo-projects-master/2d/platformer
python run_evaluation.py
```

This reads `dataset/tasks_36.json` and `dataset/agent_runs.json`, then writes the benchmark results and evaluation report under `results/`.

To inspect the synthetic examples separately:

```bash
python run_evaluation.py --runs dataset/demo_runs.json
```

## Reproduce a Godot task run

Requirements: Git and Godot 4.7.2 stable. The archived patches use the pinned Godot demo revision shown in the run records. Use a fresh checkout for each task because patches can modify overlapping project files.

Each run’s patch, test script, raw log, and summary note are available in:

```text
godot-demo-projects-master/2d/platformer/results/evidence/
```

The run records map each task to its project and test command. Results may vary with operating system, engine version, or available display and audio devices.

## Dataset and scope

The benchmark contains 36 authored task specifications across the three Godot demo projects. It is a benchmark task set, not a participant dataset, and contains no personal data. `DATASET_DOCUMENTATION.md` describes task selection, screening, annotation, preprocessing, and run-record creation.

The included Godot demo projects retain their upstream license and attribution. See `THIRD_PARTY_NOTICES.md`.

