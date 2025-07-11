config({{ tag = ['manual_lookups']}})

SELECT * FROM 
{{ref('lup_wo_seed_src')}}