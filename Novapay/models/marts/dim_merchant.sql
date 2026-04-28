{{ config(materialized='table', schema='DIMENSIONAL') }}

select * from {{ ref('stg_txn__merchants') }}