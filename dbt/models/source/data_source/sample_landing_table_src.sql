{{ config(
    materialized = 'view',
    tags = ['source_tables']
) }}
select 
*
from {{ source('LANDING_DB', 'sample_landing_table') }} 