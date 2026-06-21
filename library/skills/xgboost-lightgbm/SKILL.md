---
name: xgboost-lightgbm
description: Use when the user works with tabular machine learning using XGBoost, LightGBM, gradient boosting decision trees, feature importance, hyperparameter tuning, model validation, leakage checks, or structured-data prediction tasks.
---

# XGBoost and LightGBM

## Purpose

Use this skill for practical tabular machine learning workflows centered on XGBoost and LightGBM. The current folder is a standard skill entry point; add datasets, notebooks, scripts, or references later as needed.

## When To Use

- The user has CSV, Excel, parquet, or database-exported tabular data and wants a predictive model.
- The user asks about XGBoost, LightGBM, GBDT, ranking, classification, regression, feature importance, SHAP, or hyperparameter tuning.
- The user wants to compare boosted-tree models against linear models, random forests, neural nets, or baseline heuristics.

## Workflow

1. Identify target column, prediction type, unit of analysis, time split needs, and leakage risks.
2. Inspect the dataset schema and missingness before modeling.
3. Establish a simple baseline metric before tuning.
4. Use cross-validation or a time-aware split that matches the real deployment setting.
5. Train a conservative first model, then tune only the parameters that matter for the observed failure mode.
6. Report metrics, feature importance, leakage concerns, and next experiments.

## Quick Defaults

| Task | Default metric |
| --- | --- |
| Binary classification | ROC-AUC plus precision/recall at an operating threshold |
| Multi-class classification | macro F1 plus confusion matrix |
| Regression | MAE plus RMSE |
| Imbalanced labels | PR-AUC plus class-specific recall |
| Time-dependent data | backtest or forward-chaining validation |

## Common Mistakes

- Random split on time-dependent or user-level repeated data.
- Tuning before establishing a baseline.
- Reporting feature importance without checking leakage.
- Treating high validation score as enough without error analysis.
- Using SHAP explanations without confirming the split and preprocessing are valid.

## Local Resources

Place reusable notebooks in `notebooks/`, scripts in `scripts/`, and modeling references in `references/` if this skill grows.

