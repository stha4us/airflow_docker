{{ 
    config(
        materialized='view', 
        meta={
            'run_started_at': run_started_at.strftime('%Y-%m-%d %H:%M:%S')
        }) 
}}

with final as (
    select * from {{ref('iris')}}
)

select * from final
