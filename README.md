A sample project to run dags using airflow on docker

>> install docker on your machine
>> at root dir
>> docker-compose up airflow-init
>> docker-compose up -d
>> check docker ps
>> visit site "localhost:8080" on your browser

### Linting 

Setup dbt profile with `dev`, in root directory: ~/.dbt
Install sqlfliff 
- pip install sqlfluff sqlfluff-templater-dbt
- sqlfluff lint <path to model>
- sqlfluff fix <path to model>

## BigQuery ML part
### Prerequisites

1. **GCP Project** with BigQuery API enabled
2. **BigQuery ML API** enabled
3. **dbt-bigquery** adapter installed:
   ```bash
   pip install dbt-bigquery
   ```
4. GCP authentication set up:
   ```bash
   gcloud auth application-default login
   ```

---

### Setup

### 1. Configure your project

In `dbt_project.yml`, add your GCP project ID under `vars`:

```yaml
vars:
  gcp_project: "your-gcp-project-id"
```

### 2. Set up your profile

Copy `profiles.yml.sample` contents to `~/.dbt/profiles.yml` and update:
- `project:` → GCP project ID
- `dataset:` → desired BigQuery dataset prefix (e.g. `iris`)
- `location:` → your BigQuery region (e.g. `australia-southeast1`)

## Running the Pipeline

Execute in this order:

```bash
# Step 1 : Validate connection
dbt debug

# Step 2 : Load the Iris CSV into BigQuery
dbt seed

# Step 3 : Run tests on source data
dbt test --select stg_iris

# Step 4 : Build staging + mart layers
dbt run --select staging marts

# Step 5 : Train the BigQuery ML model (runs as a DDL operation)
dbt run-operation create_iris_model

# Step 6 : Build ML layer (predictions, evaluation, feature importance)
dbt run --select ml

# Step 7 : Run all tests
dbt test

# Step 8 : Generate and serve documentation
dbt docs generate && dbt docs serve
```

### Run everything in one command
```bash
dbt seed && dbt run && dbt run-operation create_iris_model && dbt run --select ml && dbt test
```

## Model Details

### BigQuery ML Model Options

| Option | Value | Reason |
|---|---|---|
| `model_type` | `LOGISTIC_REG` | Standard baseline for multiclass |
| `multi_class` | `TRUE` | Enables one-vs-rest multiclass |
| `auto_class_weights` | `TRUE` | Handles class imbalance |
| `max_iterations` | `50` | Sufficient for Iris convergence |
| `l2_reg` | `0.01` | Light regularisation |
| `learn_rate_strategy` | `LINE_SEARCH` | Adaptive learning rate |
| `enable_global_explain` | `TRUE` | Feature importance via SHAP |
| `data_split_method` | `NO_SPLIT` | dbt manages train/test split |


## Key BQML Functions Used

| Function | Model | Purpose |
|---|---|---|
| `ML.PREDICT` | `iris_predictions` | Run inference on test set |
| `ML.EVALUATE` | `iris_evaluation` | Precision, recall, F1, AUC |
| `ML.GLOBAL_EXPLAIN` | `iris_feature_importance` | SHAP-based feature importance |
| `ML.TRAINING_INFO` | `iris_classifier` | Training iteration loss curves |


## Data Lineage

```
iris_raw.csv (seed)
    └── stg_iris (view)
            ├── iris_training_data (table) ──► CREATE MODEL (macro)
            │                                        │
            └── iris_test_data (table) ──────────────┤
                                                     ▼
                                             iris_predictions (table)
                                             iris_evaluation (table)
                                             iris_feature_importance (table)
                                             iris_classifier (table)
```

## Extending This Project

- **Swap model type**: Change `model_type = 'BOOSTED_TREE_CLASSIFIER'` in the macro for a tree-based model
- **Add cross-validation**: Change `data_split_method = 'RANDOM'` and `data_split_eval_fraction = 0.2`
- **Add new features**: Extend `stg_iris.sql` with engineered features (ratios, polynomial terms)
- **Deploy to Vertex AI**: Use `ML.EXPORT_MODEL` to export the trained model