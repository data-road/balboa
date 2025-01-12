with credits_by_month as (
    select
        date_trunc(month, start_time) as month_n,
        sum(credits_used) as monthly_credits
    from {{ ref('int_warehouse_metering_history') }}
    where
        datediff(month, start_time, current_date) >= 1
    group by month_n
    order by month_n asc
)

select
    month_n,
    sum(monthly_credits) over(order by month_n asc rows between unbounded preceding and current row) as cumulative_sum
from
    credits_by_month
order by month_n asc
