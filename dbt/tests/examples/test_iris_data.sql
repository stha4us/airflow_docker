-- check if any label field in the data are missing

select
count(1) as counts
from {{ ref('iris_data') }}
where
class is null
having count(*) > 1