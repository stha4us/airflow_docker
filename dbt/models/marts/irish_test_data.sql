-- test data for evaluating the Iris classifier
{{
  config(
    materialized = 'table',
    description  = 'Split test data for Iris classifier evaluation'
  )
}}

select
    iris_id,
    sepal_length,
    sepal_width,
    petal_length,
    petal_width,
    species   -- Ground truth label for evaluation
from {{ ref('stg_iris') }}
where split = 'test'