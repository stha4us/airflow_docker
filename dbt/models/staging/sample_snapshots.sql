-- noqa: disable=all
{% snapshot source_weekly_snapshot %}

-- source_id 

{{
    config(
      unique_key='id',
      target_schema='snapshots',
      strategy='timestamp',
      updated_at='updated_date',
    )
}}

-- do not take snapshot untill the reporting week finishes
select * from {{ ref('lup_wo_seed_src') }}
where 1 = 1 

    -- Take napshots only on monday 
    and updated_date = date_trunc('DAY', current_timestamp())::date 

{% endsnapshot %}