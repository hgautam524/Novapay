{{ config(materialized='table', schema='DIMENSIONAL') }}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2020-01-01' as date)",
        end_date="cast('2026-12-31' as date)"
    ) }}
)
select
    date_day as DATE_ACTUAL,
    extract(year from date_day) as YEAR,
    extract(month from date_day) as MONTH,
    extract(quarter from date_day) as QUARTER,
    case 
        when extract(month from date_day) between 4 and 6 then 1
        when extract(month from date_day) between 7 and 9 then 2
        when extract(month from date_day) between 10 and 12 then 3
        else 4
    end as FISCAL_QUARTER,
    case 
        when dayname(date_day) in ('Sat', 'Sun') then true 
        else false 
    end as IS_WEEKEND
from date_spine