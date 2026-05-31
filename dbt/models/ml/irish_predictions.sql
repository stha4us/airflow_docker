-- Joins back to ground truth for accuracy evaluation
{{
  config(
    materialized = 'table',
    description  = 'Predictions from BQML Iris classifier on the hold-out test set'
  )
}}

with predictions as (

    select *
    from ml.PREDICT(
        model => `{{ var('gcp_project') }}.{{ target.dataset }}_ml.iris_species_classifier`,
        table  => (
            select
                iris_id,
                sepal_length,
                sepal_width,
                petal_length,
                petal_width
            from {{ ref('iris_test_data') }}
        )
    )

),

test_with_truth as (

    select
        iris_id,
        species as actual_species
    from {{ ref('iris_test_data') }}

)

select
    p.iris_id,
    t.actual_species,
    p.predicted_species,

    -- Confidence scores for each class (BQML returns these as STRUCT array)
    (select prob.prob from unnest(p.predicted_species_probs) as prob where prob.label = 'setosa')     as prob_setosa,
    (select prob.prob from unnest(p.predicted_species_probs) as prob where prob.label = 'versicolor') as prob_versicolor,
    (select prob.prob from unnest(p.predicted_species_probs) as prob where prob.label = 'virginica')  as prob_virginica,

    -- Label the prediction correctness
    case when p.predicted_species = t.actual_species then true else false end as is_correct,

    current_timestamp() as predicted_at

from predictions p
inner join test_with_truth t using (iris_id)
