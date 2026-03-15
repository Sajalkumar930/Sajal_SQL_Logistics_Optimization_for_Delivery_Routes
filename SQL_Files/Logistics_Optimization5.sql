SELECT Order_ID, Checkpoint, Checkpoint_Time
FROM (
    SELECT Order_ID, Checkpoint, Checkpoint_Time,
        ROW_NUMBER() OVER(PARTITION BY Order_ID ORDER BY Checkpoint_Time DESC) AS row_num
	FROM Shipment_Tracking
) tab1
WHERE row_num = 1;

SELECT Delay_Reason, COUNT(*) AS Occurrences FROM Shipment_Tracking
WHERE Delay_Reason IS NOT NULL
AND Delay_Reason <> 'None'
GROUP BY Delay_Reason
ORDER BY Occurrences DESC;

SELECT Order_ID, COUNT(*) AS Delayed_Checkpoints FROM Shipment_Tracking
WHERE Delay_Reason IS NOT NULL
AND Delay_Reason <> 'None'
GROUP BY Order_ID
HAVING COUNT(*) > 2;