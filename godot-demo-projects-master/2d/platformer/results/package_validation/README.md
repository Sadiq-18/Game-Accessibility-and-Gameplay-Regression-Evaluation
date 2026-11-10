# Final package smoke checks

These checks were performed after assembling the repository. They run the currently checked-in `tests/agent_run_check.gd` script once in each included game project after a headless Godot editor import.

| Project | Checked-in script scope | Result |
|---|---|---|
| Platformer | Latest included candidate run, GODOT-PLAT-12 (controller remapping) | Godot exit 0; 10 assertions passed; 3 resources reported still in use at exit |
| Dodge the Creeps | Latest included candidate run, GODOT-DTC-12 (sound captions) | Godot exit 0; 10 assertions passed; 3 resources reported still in use at exit |
| RPG | Latest included candidate run, GODOT-RPG-06 (high contrast) | Godot exit 0; 10 assertions passed; no exit cleanup warning in captured output |

This is a packaging sanity check, not three additional benchmark runs. It does not add records to `dataset/agent_runs.json` or change the N=30 metrics. The full captured logs are in this directory. The task-by-task original logs remain in `results/evidence/`.
