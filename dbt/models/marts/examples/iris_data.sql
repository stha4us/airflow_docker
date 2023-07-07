{{ config(materialized='view') }}

with final as (
    select * from {{ref('iris')}}
)

select * from final
