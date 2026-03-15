SELECT da.Agent_ID, da.Route_ID, COUNT(o.Order_ID) AS Total_Deliveries,
SUM(CASE 
        WHEN o.Actual_Delivery_Date <= o.Expected_Delivery_Date
        THEN 1 ELSE 0 
END) AS On_Time_Deliveries,
(SUM(CASE 
        WHEN o.Actual_Delivery_Date <= o.Expected_Delivery_Date
        THEN 1 ELSE 0 
END) / COUNT(o.Order_ID)) * 100 AS On_Time_Percentage,
RANK() OVER(PARTITION BY da.Route_ID ORDER BY (SUM(CASE 
            WHEN o.Actual_Delivery_Date <= o.Expected_Delivery_Date
            THEN 1 ELSE 0 
        END) / COUNT(o.Order_ID)) DESC
) AS Agent_Rank

FROM DeliveryAgents da
JOIN Orders o
ON da.Route_ID = o.Route_ID
GROUP BY da.Agent_ID, da.Route_ID;


SELECT *FROM (SELECT da.Agent_ID,
(SUM(CASE 
		WHEN o.Actual_Delivery_Date <= o.Expected_Delivery_Date
		THEN 1 ELSE 0 
END) / COUNT(o.Order_ID)) * 100 AS On_Time_Percentage
FROM DeliveryAgents da
JOIN Orders o
ON da.Route_ID = o.Route_ID
GROUP BY da.Agent_ID
) agent_perf
WHERE On_Time_Percentage < 80;



SELECT 'Top 5 Agents' AS Category,AVG(Avg_Speed_KM_HR) AS Avg_Speed FROM DeliveryAgents
WHERE Agent_ID IN (
    SELECT Agent_ID FROM (SELECT da.Agent_ID,
		SUM(o.Actual_Delivery_Date <= o.Expected_Delivery_Date)/COUNT(*) AS On_Time_Percentage
        FROM DeliveryAgents da
        JOIN Orders o
        ON da.Route_ID = o.Route_ID
        GROUP BY da.Agent_ID
        ORDER BY On_Time_Percentage DESC
        LIMIT 5
    ) tab1
)
UNION
SELECT 'Bottom 5 Agents', AVG(Avg_Speed_KM_HR)FROM DeliveryAgents
WHERE Agent_ID IN (SELECT Agent_ID FROM (SELECT da.Agent_ID,
        SUM(o.Actual_Delivery_Date <= o.Expected_Delivery_Date)/COUNT(*) AS On_Time_Percentage
        FROM DeliveryAgents da
        JOIN Orders o
        ON da.Route_ID = o.Route_ID
        GROUP BY da.Agent_ID
        ORDER BY On_Time_Percentage ASC
        LIMIT 5
    ) tab2
);
