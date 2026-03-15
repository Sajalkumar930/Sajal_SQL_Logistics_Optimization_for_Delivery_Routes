select *, datediff(actual_delivery_date,expected_delivery_date) as delay_days from orders;

select route_id , avg(datediff(actual_delivery_date,expected_delivery_date)) as delay_days from orders
group by route_id
order by delay_days desc
limit 10;

SELECT Order_ID, Warehouse_ID, Route_ID, DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) AS Delay_Days,
dense_rank() over (partition by warehouse_id order by DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) desc) as delay_rank
from orders;

