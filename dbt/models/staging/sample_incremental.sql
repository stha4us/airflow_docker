{{ config(
    materialized='incremental', 
    unique_key = 'id',
    incremental_strategy = 'merge') }}

with source_data as (

    select * from 
    {{ ref('lup_wo_seed_src')}}}

)

select *
from source_data
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where cdts >= (select coalesce(max(cdts), '1900-01-01') from {{ this }})

{% endif %}