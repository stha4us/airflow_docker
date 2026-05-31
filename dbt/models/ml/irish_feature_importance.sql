-- Requires enable_global_explain = TRUE in model OPTIONS (set in macro)
{{
  config(
    materialized = 'table',
    description  = 'Feature importance scores from the trained Iris classifier'
  )
}}

select
    feature,
    attribution as importance_score,
    -- Rank features by attribution (higher = more important)
    rank() over (order by attribution desc) as importance_rank
from ml.GLOBAL_EXPLAIN(
    model => `{{ var('gcp_project') }}.{{ target.dataset }}_ml.iris_species_classifier`
)
order by importance_rank