SELECT Warehouse_ID, Processing_Time_Min FROM Warehouses
ORDER BY Processing_Time_Min DESC
LIMIT 3;

SELECT Warehouse_ID, COUNT(*) AS Total_Shipments,
SUM(CASE 
        WHEN Actual_Delivery_Date > Expected_Delivery_Date 
        THEN 1 ELSE 0 
END) AS Delayed_Shipments
FROM Orders
GROUP BY Warehouse_ID;

WITH warehouse_processing AS (
    SELECT Warehouse_ID, AVG(DATEDIFF(Actual_Delivery_Date, Order_Date)) AS Avg_Processing_Time
    FROM Orders
    GROUP BY Warehouse_ID
)
SELECT * FROM warehouse_processing
WHERE Avg_Processing_Time >(
	SELECT AVG(Avg_Processing_Time)
    FROM warehouse_processing
);


SELECT Warehouse_ID, COUNT(*) AS Total_Shipments,
    SUM(CASE 
        WHEN Actual_Delivery_Date <= Expected_Delivery_Date
        THEN 1 ELSE 0 
	END) AS On_Time_Deliveries,

    (SUM(CASE 
        WHEN Actual_Delivery_Date <= Expected_Delivery_Date
        THEN 1 ELSE 0 
	END) / COUNT(*)) * 100 AS On_Time_Percentage,
    RANK() OVER (ORDER BY 
        (SUM(CASE 
            WHEN Actual_Delivery_Date <= Expected_Delivery_Date
            THEN 1 ELSE 0 
		END) / COUNT(*)) DESC) AS Warehouse_Rank
FROM Orders
GROUP BY Warehouse_ID;
