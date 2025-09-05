{# Macro that stores snapshots that are created in production external to prod db#}
{% macro generate_prod_snapshot_database_name() %}
  {% if target.database == 'PROD' %}
    {{'PROD_SNAPSHOTS'}}
  {% else if target.database == 'TEST' %}
    {{'TEST_SNAPSHOTS'}}
  {% else %}
    {{target.database}}
  {% endif %}
{% endmacro %}