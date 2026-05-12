{{
    config(
        materialized = 'semantic_view',
        tags = ['sample_models', 'metrics']
    )
}}

TABLES (
    --fact tables
    page_views AS {{ ref('fact_irish_data') }},

    --dimension tables
    page_group AS {{ ref('dim_irish_data') }} PRIMARY KEY (group_skey),
)

RELATIONSHIPS (
    views_to_species AS
        page_views(group_skey) REFERENCES page_group(group_skey),
)

DIMENSIONS (
    -- page_views dimensions

    -- sessions_fact dimensions

    -- new dimensions

    -- total dimensions

    -- dimension tables
)

METRICS (
    --@TODO: Add metrics definitions
)

COMMENT = 'This semantic view is snowflake native.'