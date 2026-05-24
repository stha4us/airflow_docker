-- models/staging/stg_iris.sql
-- Cleans and validates raw Iris seed data
-- Adds a surrogate key and train/test split flag

{{
  config(
    materialized = 'view',
    description  = 'Cleaned Iris dataset with train/test split'
  )
}}

with source as (

    select * from {{ ref('iris') }}

),

cleaned as (

    select
        -- Surrogate key using row number (BigQuery compatible)
        row_number() over (order by sepal_length, sepal_width, petal_length, petal_width) as iris_id,

        -- Features (cast to FLOAT64 explicitly for BQML)
        cast(sepal_length as float64) as sepal_length,
        cast(sepal_width  as float64) as sepal_width,
        cast(petal_length as float64) as petal_length,
        cast(petal_width  as float64) as petal_width,

        -- Label (target for classification)
        lower(trim(species)) as species,

        -- Deterministic 80/20 train-test split
        case
            when mod(row_number() over (order by sepal_length, sepal_width, petal_length, petal_width), 5) = 0
            then 'test'
            else 'train'
        end as split

    from source

    where sepal_length is not null
      and sepal_width  is not null
      and petal_length is not null
      and petal_width  is not null
      and species      is not null

)

select * from cleaned
