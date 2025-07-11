config({{ tag = ['manual_lookups'], materialized = 'ephemeral'}})

SELECT * FROM 
{{target.database}}.{{target.schema}}.lookup_table_v1