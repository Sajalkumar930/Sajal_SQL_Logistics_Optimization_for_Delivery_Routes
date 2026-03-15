use logistics_optimization;

alter table orders
modify column order_date date,
modify column expected_delivery_date date,
modify column actual_delivery_date date;

alter table shipment_tracking
modify column checkpoint_time date;

alter table warehouses
modify column dispatch_time time;

select order_id, count(*) as duplicate_ids from orders
group by order_id
having count(*)>1;

select count(distinct(order_id)) as distinct_count from orders;
select count(order_id) as normal_count from orders;

DELETE FROM Orders
WHERE Order_ID NOT IN (
SELECT MIN(Order_ID)
FROM Orders
GROUP BY Order_ID
);

select * from routes
where Traffic_Delay_Min is null;

update routes r
set Traffic_Delay_Min = ( select avg(Traffic_Delay_Min) from routes where route_id = r.route_id )
where Traffic_Delay_Min is null;

select * from orders
where order_date > actual_delivery_date;
