"""
Evaluation Framework Module for:
Evaluating AI Coding Agents for Game Accessibility Enhancement and Gameplay Regression Prevention
Shaik Mohammad Sadiq (24BTRCL182) & Seethaka Umesh Reddy (24BTRCL181)
Department of Computer Science and Engineering, Jain (Deemed-to-be University)
"""

import json
import os
from typing import Dict, List, Any


class AccessibilityEvaluator:
    """
    Implements the dual-outcome evaluation methodology:
    - Accessibility Requirement Verification (A in {0, 1})
    - Baseline Gameplay Regression Testing (G in {0, 1})
    - Joint Outcome Classification and Metric Aggregation (RA, RG, RJ, RR)
    """

    OUTCOME_ALL_SUCCESS = "Joint Success (All Success)"
    OUTCOME_SUCCESS_WITH_REGRESSION = "Accessibility Success with Regression"
    OUTCOME_FAILURE_WITHOUT_REGRESSION = "Accessibility Failure without Regression"
    OUTCOME_TOTAL_FAILURE = "Total Failure"

    def __init__(self, dataset_path: str = "dataset/tasks_36.json"):
        self.dataset_path = dataset_path
        self.tasks: List[Dict[str, Any]] = []
        self.load_dataset()

    def load_dataset(self) -> None:
        if not os.path.exists(self.dataset_path):
            raise FileNotFoundError(f"Dataset file not found at: {self.dataset_path}")
        with open(self.dataset_path, "r", encoding="utf-8") as f:
            self.tasks = json.load(f)
        if not isinstance(self.tasks, list):
            raise ValueError("Dataset must be a JSON array of task records.")
        task_ids = [task.get("task_id") for task in self.tasks]
        if any(not isinstance(task_id, str) for task_id in task_ids):
            raise ValueError("Every dataset task must have a string task_id.")
        if len(task_ids) != len(set(task_ids)):
            raise ValueError("Dataset contains duplicate task_id values.")

    def evaluate_task(
        self,
        task_id: str,
        accessibility_checks_passed: bool,
        gameplay_checks_passed: bool,
        notes: str = "",
        changed_files: List[str] = None
    ) -> Dict[str, Any]:
        """
        Evaluates a single task record based on test check results.
        A: 1 if accessibility criteria met, else 0
        G: 1 if baseline gameplay preserved, else 0
        """
        if type(accessibility_checks_passed) is not bool or type(gameplay_checks_passed) is not bool:
            raise ValueError("Accessibility and gameplay results must be explicit booleans.")
        task = next((t for t in self.tasks if t["task_id"] == task_id), None)
        if not task:
            raise KeyError(f"Task ID '{task_id}' not found in dataset.")

        A = 1 if accessibility_checks_passed else 0
        G = 1 if gameplay_checks_passed else 0

        # Outcome classification according to Table 1 of paper
        if A == 1 and G == 1:
            classification = self.OUTCOME_ALL_SUCCESS
            interpretation = "The feature works and no regression is found."
        elif A == 1 and G == 0:
            classification = self.OUTCOME_SUCCESS_WITH_REGRESSION
            interpretation = "The feature works, but some baseline tests fail."
        elif A == 0 and G == 1:
            classification = self.OUTCOME_FAILURE_WITHOUT_REGRESSION
            interpretation = "The feature fails its criteria while baseline checks pass."
        else:
            classification = self.OUTCOME_TOTAL_FAILURE
            interpretation = "Both objectives fail: criteria failed and regressions found."

        result_record = {
            "task_id": task_id,
            "candidate_project": task["candidate_project"],
            "feature_category": task["feature_category"],
            "accessibility_passed (A)": A,
            "gameplay_preserved (G)": G,
            "joint_success (A*G)": A * G,
            "classification": classification,
            "interpretation": interpretation,
            "changed_files": task.get("target_files", []) if changed_files is None else changed_files,
            "evaluation_notes": notes
        }
        return result_record

    @staticmethod
    def calculate_metrics(evaluations: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Calculates aggregate metrics per equations (1) & (2) from research paper:
        RA = sum(Ai) / N
        RG = sum(Gi) / N
        RJ = sum(Ai * Gi) / N
        RR = sum(1 - Gi) / N
        """
        N = len(evaluations)
        if N == 0:
            return {
                "evaluated_tasks_count (N)": 0,
                "accessibility_success_rate (RA)": None,
                "gameplay_preservation_rate (RG)": None,
                "joint_success_rate (RJ)": None,
                "regression_rate (RR)": None,
            }

        sum_A = sum(e["accessibility_passed (A)"] for e in evaluations)
        sum_G = sum(e["gameplay_preserved (G)"] for e in evaluations)
        sum_AG = sum(e["joint_success (A*G)"] for e in evaluations)
        sum_1_minus_G = sum(1 - e["gameplay_preserved (G)"] for e in evaluations)

        return {
            "evaluated_tasks_count (N)": N,
            "accessibility_success_rate (RA)": round(sum_A / N, 4),
            "gameplay_preservation_rate (RG)": round(sum_G / N, 4),
            "joint_success_rate (RJ)": round(sum_AG / N, 4),
            "regression_rate (RR)": round(sum_1_minus_G / N, 4),
        }
