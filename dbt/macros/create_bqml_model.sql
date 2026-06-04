-- Runs the BigQuery ML CREATE OR REPLACE MODEL statement.
-- This is separated into a macro because BQML DDL (CREATE MODEL) cannot be
-- used inside a standard dbt SELECT model — it must run as an operation.
-- Usage:
--   dbt run-operation create_iris_model
-- This should be run BEFORE `dbt run --select iris_classifier`

{% macro create_iris_model() %}

    {% set model_sql %}
        CREATE OR REPLACE MODEL
            `{{ var('gcp_project') }}.{{ target.dataset }}_ml.iris_species_classifier`

        OPTIONS (
            -- Model type: LOGISTIC_REG supports multiclass via auto_class_weights
            model_type              = 'LOGISTIC_REG',
            multi_class             = TRUE,
            auto_class_weights      = TRUE,     
            max_iterations          = 50,
            l1_reg                  = 0.0,
            l2_reg                  = 0.01,     
            learn_rate_strategy     = 'LINE_SEARCH',
            input_label_cols        = ['species'],
            data_split_method       = 'NO_SPLIT',  
            enable_global_explain   = TRUE      -- Enables feature importance
        )

        AS (
            -- Reference the dbt training mart
            SELECT
                sepal_length,
                sepal_width,
                petal_length,
                petal_width,
                species
            FROM `{{ var('gcp_project') }}.{{ target.dataset }}_marts.iris_training_data`
        )
    {% endset %}

    {% do run_query(model_sql) %}
    {% do log("BigQuery ML model 'iris_species_classifier' created successfully.", info=True) %}

{% endmacro %}
