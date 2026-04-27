select
    payment_id,
    payment_amount,
    payment_status
from {{ ref('stg_txn__payments') }}
where payment_status = 'completed'
  and payment_amount < 0