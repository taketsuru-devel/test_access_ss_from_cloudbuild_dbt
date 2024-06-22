{% set axes = dbt_utils.get_column_values(table=source('external_tables', 'pivot_target'), column='axis_data') %}

select 
  key_date,
  {{ dbt_utils.pivot(
    'axis_data',
    axes
  ) }}
from {{ source('external_tables', 'pivot_target') }}
group by key_date
