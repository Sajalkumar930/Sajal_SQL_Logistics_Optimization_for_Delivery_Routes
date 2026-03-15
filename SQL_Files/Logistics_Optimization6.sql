SELECT r.Start_Location AS Region, AVG(DATEDIFF(o.Actual_Delivery_Date, o.Expected_Delivery_Date)) AS Avg_Delivery_Delay_days
FROM Orders o
JOIN Routes r
ON o.Route_ID = r.Route_ID
GROUP BY r.Start_Location
ORDER BY Avg_Delivery_Delay_days DESC;


SELECT ROUND(
    (SUM(CASE 
        WHEN Actual_Delivery_Date <= Expected_Delivery_Date 
        THEN 1 ELSE 0 
	END) / COUNT(*)) * 100
) AS On_Time_Delivery_Percentage
FROM Orders;

SELECT Route_ID, AVG(Traffic_Delay_Min) AS Avg_Traffic_Delay_Minutes FROM Routes
GROUP BY Route_ID
ORDER BY Avg_Traffic_Delay_Minutes DESC;