select route_id, avg(DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date)) AS Delay_Days from orders
group by route_id
order by route_id;

select route_id, avg(traffic_delay_min) as avg_traffic_delay from routes
group by route_id
order by avg_traffic_delay;

select route_id, round(distance_km/Average_Travel_Time_Min,2) as efficiency_ratio from routes;

select route_id, round(distance_km/Average_Travel_Time_Min,2) as efficiency_ratio from routes
order by efficiency_ratio desc
limit 3;


SELECT Route_ID, COUNT(*) AS Total_Shipments,
SUM(CASE 
        WHEN Delivery_Status = 'Delayed' 
        THEN 1 ELSE 0 
END) AS Delayed_Shipments,
    
(SUM(CASE 
        WHEN Delivery_Status = 'Delayed'
        THEN 1 ELSE 0 
END) * 100.0 / COUNT(*)) AS Delay_Percentage
FROM Orders
GROUP BY Route_ID
HAVING Delay_Percentage > 20
order by delayed_shipments;
