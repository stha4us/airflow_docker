-- Training data for Iris classifier
{{
  config(
    materialized = 'table',
    description  = 'Training data for BQML Iris classifier'
  )
}}

select
    iris_id,
    sepal_length,
    sepal_width,
    petal_length,
    petal_width,
    species   -- This is the label column model will train against
from {{ ref('stg_iris') }}
where split = 'train'