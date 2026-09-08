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
    page_group AS {{ ref('dim_flower_data') }} PRIMARY KEY (species_id),
)

RELATIONSHIPS (
    views_to_species AS
        page_views(species_id) REFERENCES page_group(species_id),
)

FACTS (
    page_group.is_setosa AS (CASE WHEN is_versica = 0 AND is_roseta = 0 THEN 1 ELSE 0 END),
)


DIMENSIONS (
    -- page_views dimensions
    page_group.cast_gene AS COALESCE(genes, 'Hybrid'),
    page_views.rec_month AS DATE_TRUNC('month', rec_date),
    -- sessions_fact dimensions

    -- new dimensions

    -- total dimensions

    -- dimension tables
)

METRICS (
     --direct metrics
    page_views.total_setosa AS SUM(is_setosa)
        COMMENT = 'Total number of setosa groups, including unknown species.',
    ,  

    --derived metircs
    page_group.other_species AS (total_setosa + total_others)
        COMMENT = 'The amount of actual species (setosa species and other species).'  
)

COMMENT = 'This semantic view is snowflake native.'