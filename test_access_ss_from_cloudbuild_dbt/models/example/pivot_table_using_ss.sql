select *
from {{ ref('external_tables.pivot_target') }}

