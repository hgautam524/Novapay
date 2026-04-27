select
    account_id,
    account_status,
    closing_date
from {{ ref('stg_txn__accounts') }}
where account_status = 'closed'
  and closing_date is null