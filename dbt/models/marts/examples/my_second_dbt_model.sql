{{ 
    config(
        materialized='table', 
        meta={
            'run_started_at': run_started_at.strftime('%Y-%m-%d %H:%M:%S')
        }) 
}}

-- Use the `ref` function to select from other models

select *
from {{ ref('my_first_dbt_model') }}
where id = 1
