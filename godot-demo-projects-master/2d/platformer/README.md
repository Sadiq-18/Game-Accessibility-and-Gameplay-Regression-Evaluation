# Game Accessibility and Gameplay Regression Evaluation: Platformer Package

This directory contains the Python evaluation model, 36 candidate-task specifications, 30 observed task-run records, and the Godot 2D Platformer project. For complete installation and reproduction instructions, see the repository-root `README.md`.

## Run the metrics

From this directory, use Python 3.10 or later (standard library only):

```bash
python run_evaluation.py
```

This validates `dataset/agent_runs.json` and writes `results/benchmark_results.json` and `results/evaluation_report.md`. The current checked-in snapshot has N=30 runs: RA=96.7%, RG=100.0%, RJ=96.7%, RR=0.0%. RPG-07 through RPG-12 are not run and are excluded; RPG-04 is an observed accessibility failure because no sound assets or audio players were present in the upstream RPG project.

The methodology is a rule-based dual-outcome evaluation model, not a trained RL agent. All included evidence is from one Codex model setup and automated Godot checks; it is not a human accessibility study or a multi-agent comparison. The 36 benchmark entries are task specifications, not 36 successful results.

## Contents

- `dataset/tasks_36.json`: the complete 36-task benchmark specifications.
- `dataset/agent_runs.json`: measured run outcomes and provenance.
- `dataset/demo_runs.json`: synthetic examples used only to demonstrate the classifier.
- `src/evaluator.py` and `run_evaluation.py`: evaluator and CLI.
- `results/evidence/`: each recorded run's patch, test script, captured Godot output, and evidence note.
- `DATASET_DOCUMENTATION.md`: dataset authoring, screening, annotation, limitations, and run schema.
