-- Returns precision, recall, F1, accuracy, log-loss, ROC-AUC per class

{{
  config(
    materialized = 'table',
    description  = 'BQML evaluation metrics for the Iris classifier on the test set'
  )
}}

with bqml_eval as (

    -- ML.EVALUATE runs the model against provided test data and returns metrics
    select *
    from ml.EVALUATE(
        model => `{{ var('gcp_project') }}.{{ target.dataset }}_ml.iris_species_classifier`,
        table  => (
            select
                sepal_length,
                sepal_width,
                petal_length,
                petal_width,
                species   -- Ground truth label required for evaluation
            from {{ ref('iris_test_data') }}
        )
    )
),

manual_accuracy as (

    -- Compute overall accuracy manually from predictions table
    select
        countif(is_correct) as correct_predictions,
        count(*)            as total_predictions,
        round(
            countif(is_correct) / count(*) * 100, 2
        )                   as accuracy_pct
    from {{ ref('iris_predictions') }}

)

select
    -- BQML native metrics
    e.precision,
    e.recall,
    e.accuracy,
    e.f1_score,
    e.log_loss,
    e.roc_auc,

    -- Manual cross-check
    m.correct_predictions,
    m.total_predictions,
    m.accuracy_pct as manual_accuracy_pct,

    current_timestamp() as evaluated_at

from bqml_eval e
cross join manual_accuracy m
