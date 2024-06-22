select *
from {{ source('external_tables', 'pivot_target') }}

