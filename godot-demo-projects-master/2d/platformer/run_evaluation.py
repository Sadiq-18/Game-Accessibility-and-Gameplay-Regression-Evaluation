#!/usr/bin/env python3
"""Classify recorded accessibility/gameplay checks and report proposal metrics."""

import argparse
import json
from pathlib import Path
from typing import Any

from src.evaluator import AccessibilityEvaluator


def read_runs(path: Path) -> list[dict[str, Any]]:
    try:
        records = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"Could not read run records from {path}: {exc}") from exc
    if not isinstance(records, list):
        raise ValueError("Run file must contain a JSON array of records.")
    return records


def validate_record(record: Any, index: int) -> dict[str, Any]:
    if not isinstance(record, dict):
        raise ValueError(f"Run record {index} must be a JSON object.")
    required = ("run_id", "run_type", "task_id")
    missing = [key for key in required if key not in record]
    if missing:
        raise ValueError(f"Run record {index} is missing: {', '.join(missing)}")
    if record["run_type"] not in ("synthetic_demo", "agent_run", "blocked_run"):
        raise ValueError(f"Run record {index} run_type must be synthetic_demo, agent_run, or blocked_run.")
    if record["run_type"] == "blocked_run":
        if not str(record.get("blocking_reason", "")).strip():
            raise ValueError(f"Blocked run {record['run_id']} needs a blocking_reason.")
        return record
    missing_checks = [key for key in ("accessibility_checks_passed", "gameplay_checks_passed") if key not in record]
    if missing_checks:
        raise ValueError(f"Run record {index} is missing: {', '.join(missing_checks)}")
    if type(record["accessibility_checks_passed"]) is not bool or type(record["gameplay_checks_passed"]) is not bool:
        raise ValueError(f"Run record {index} check results must be true/false booleans.")
    if record["run_type"] == "agent_run":
        required_evidence = ("agent", "model", "project_revision", "environment", "evidence")
        missing_evidence = [key for key in required_evidence if not str(record.get(key, "")).strip()]
        if missing_evidence:
            raise ValueError(f"Agent run {record['run_id']} needs reproducibility evidence: {', '.join(missing_evidence)}")
    return record


def report_metrics(metrics: dict[str, Any]) -> list[str]:
    count = metrics["evaluated_tasks_count (N)"]
    lines = [f"Evaluated tasks (N): {count}"]
    labels = (
        ("Accessibility pass rate (RA)", "accessibility_success_rate (RA)"),
        ("Gameplay preservation rate (RG)", "gameplay_preservation_rate (RG)"),
        ("Joint success rate (RJ)", "joint_success_rate (RJ)"),
        ("Detected regression rate (RR)", "regression_rate (RR)"),
    )
    for label, key in labels:
        value = metrics[key]
        lines.append(f"{label}: {'n/a (no eligible runs)' if value is None else f'{value * 100:.1f}%'}")
    return lines


def render_report(agent_metrics: dict[str, Any], demo_metrics: dict[str, Any], evaluations: list[dict[str, Any]], blocked_runs: list[dict[str, Any]]) -> str:
    lines = [
        "# Godot Game Accessibility Benchmark: Run Report", "",
        "## Empirical AI-agent results", "",
        *report_metrics(agent_metrics), "",
        f"Blocked runs excluded from metrics: {len(blocked_runs)}", "",
    ]
    if agent_metrics["evaluated_tasks_count (N)"] == 0:
        lines += [
            "No verified AI-agent runs are included in this report. Synthetic examples below demonstrate the evaluator only and are excluded from empirical metrics.",
            "",
        ]
    lines += ["## Synthetic demonstration examples (not research findings)", "", *report_metrics(demo_metrics), ""]
    lines += [
        "| Run | Type | Task | A | G | Joint | Outcome |",
        "|---|---|---|---:|---:|---:|---|",
    ]
    for item in evaluations:
        a = item["accessibility_passed (A)"]
        g = item["gameplay_preserved (G)"]
        lines.append(
            f"| {item['run_id']} | {item['run_type']} | {item['task_id']} | {a} | {g} | {a * g} | {item['classification']} |"
        )
    for item in blocked_runs:
        lines.append(f"| {item['run_id']} | blocked_run | {item['task_id']} | n/a | n/a | n/a | Blocked: {item['blocking_reason']} |")
    lines.append("")
    if any(item["run_type"] == "synthetic_demo" for item in evaluations):
        lines.append("Synthetic rows are teaching fixtures and are excluded from empirical agent metrics.")
    else:
        agent_count = agent_metrics["evaluated_tasks_count (N)"]
        lines.append(
            f"This report contains {agent_count} task-level run(s) from one coding-agent/model setup. "
            "Do not generalize these scripted checks to unrun benchmark tasks, other agents, or human accessibility outcomes."
        )
    lines.append("")
    return "\n".join(lines)


def run_benchmark(runs_path: Path) -> None:
    task_path = Path("dataset/tasks_36.json")
    evaluator = AccessibilityEvaluator(str(task_path))
    records = [validate_record(record, index) for index, record in enumerate(read_runs(runs_path), start=1)]
    run_ids = [record["run_id"] for record in records]
    if len(run_ids) != len(set(run_ids)):
        raise ValueError("Run file contains duplicate run_id values.")

    evaluations = []
    blocked_runs = []
    for record in records:
        if record["run_type"] == "blocked_run":
            blocked_runs.append({
                "run_id": record["run_id"],
                "run_type": record["run_type"],
                "task_id": record["task_id"],
                "blocking_reason": record["blocking_reason"],
            })
            continue
        result = evaluator.evaluate_task(
            task_id=record["task_id"],
            accessibility_checks_passed=record["accessibility_checks_passed"],
            gameplay_checks_passed=record["gameplay_checks_passed"],
            notes=record.get("notes", ""),
            changed_files=record.get("changed_files", []),
        )
        result.update({key: record.get(key, "") for key in ("run_id", "run_type", "agent", "model", "project_revision", "environment", "evidence")})
        evaluations.append(result)

    agent_evaluations = [item for item in evaluations if item["run_type"] == "agent_run"]
    demo_evaluations = [item for item in evaluations if item["run_type"] == "synthetic_demo"]
    agent_metrics = evaluator.calculate_metrics(agent_evaluations)
    demo_metrics = evaluator.calculate_metrics(demo_evaluations)

    output_dir = Path("results")
    output_dir.mkdir(exist_ok=True)
    output_payload = {
        "benchmark_metadata": {
            "dataset_name": "Game Accessibility and Gameplay Regression Evaluation",
            "evaluation_engine": "Dual-Outcome Regression & Accessibility Evaluator v1.1",
            "run_records_file": str(runs_path),
            "empirical_agent_runs_only": "agent_run records with required provenance fields",
            "synthetic_examples_are_excluded_from_empirical_metrics": True,
        },
        "empirical_agent_metrics": agent_metrics,
        "synthetic_demonstration_metrics": demo_metrics,
        "blocked_runs": blocked_runs,
        "task_evaluations": evaluations,
    }
    (output_dir / "benchmark_results.json").write_text(json.dumps(output_payload, indent=2) + "\n", encoding="utf-8")
    (output_dir / "evaluation_report.md").write_text(render_report(agent_metrics, demo_metrics, evaluations, blocked_runs), encoding="utf-8")

    print("GAME ACCESSIBILITY AND GAMEPLAY REGRESSION EVALUATION")
    print(f"Loaded {len(evaluator.tasks)} task specifications and {len(records)} run records.")
    print(f"Blocked runs excluded from metrics: {len(blocked_runs)}")
    print("\nEMPIRICAL AI-AGENT RESULTS")
    print("\n".join(report_metrics(agent_metrics)))
    print("\nSYNTHETIC DEMONSTRATION ONLY (not research findings)")
    print("\n".join(report_metrics(demo_metrics)))
    print("\nResults written to results/benchmark_results.json and results/evaluation_report.md")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--runs",
        type=Path,
        default=Path("dataset/agent_runs.json"),
        help="JSON array of recorded runs (default: evidence-backed agent run)",
    )
    args = parser.parse_args()
    try:
        run_benchmark(args.runs)
    except (ValueError, KeyError, OSError) as exc:
        parser.error(str(exc))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
