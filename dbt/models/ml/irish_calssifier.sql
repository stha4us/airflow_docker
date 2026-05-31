-- Trains a multiclass logistic regression model using BigQuery ML
{{
  config(
    materialized  = 'table',
    description   = 'BigQuery ML multiclass logistic regression classifier for Iris species'
  )
}}
-- NOTE: BigQuery ML CREATE MODEL statements cannot be used as standard dbt SELECT models.
-- Run `dbt run-operation create_iris_model` first, then `dbt run --select iris_classifier`

select
    -- Pull training iteration metrics from BQML information schema
    training_run,
    iteration,
    loss,
    eval_loss,
    learning_rate,
    duration_ms,
    current_timestamp() as run_at

from
    ml.TRAINING_INFO(
        model => `{{ var('gcp_project') }}.{{ target.dataset }}_ml.iris_species_classifier`
    )
