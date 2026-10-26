/*
=============================================================
Project: Superstore Sales & Profitability Analysis
=============================================================

Business Objective:
Analyze Superstore's sales and profitability to identify
underperforming products and subcategories, evaluate regional
and customer segment performance, investigate the relationship
between discounting and profitability, and examine order return
patterns.

The goal is to uncover actionable insights and provide
data-driven recommendations to improve profitability and
support better business decisions.

=============================================================
*/




-- Sales versus profitability -- 
-- Which subcategories generate substantial sales but disproportionately little profit?
SELECT
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(
        100.0 * SUM(Profit) / NULLIF(SUM(Sales), 0)
        AS DECIMAL(10, 2)
    ) AS Profit_Margin_Pct
FROM dbo.orders
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;
GO
------------------
-- Why does Tables generate substantial revenue but produce a loss?
------------------

-- Which customer segments contribute most to total profit?
SELECT
    Segment,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit_per_Segment,
    SUM(SUM(Profit)) OVER () AS Grand_Total_Profit,
    CAST(
        SUM(Profit) * 100.0 / NULLIF(
            SUM(SUM(Profit)) OVER (), 0
        )
        AS DECIMAL(10, 2)
    ) AS Profit_Contribution_Pct
FROM dbo.orders
GROUP BY Segment
ORDER BY Total_Profit_per_Segment DESC;
GO

---------------------
-- Consumer is the most significant segment in terms of absolute profit contribution
-- I think it's because of its size not necessarily it has the most profit margin 
---------------------


-- Product and geographic performance --
-- Which product categories and subcategories perform poorly in particular regions?
SELECT
    Region,
    Category,
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0)
        AS DECIMAL(10, 2)
    ) AS Profit_Margin_Pct
FROM dbo.orders
GROUP BY
    Region,
    Category,
    Sub_Category
ORDER BY
    Region,
    Profit_Margin_Pct ASC;
GO

----------------------------
-- Sub_Categories don't perform the same in the different regions for instance : 
-- Furniture-->Furnishings in Central Region is very poor but the other regions performs great
-- But others like tables the region doesn't affect that much. 
----------------------------



-- Discounting and profitability --
-- Are high discounts associated with lower profit or losses?
SELECT
    Discount,
    COUNT(*) AS Order_Lines,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit) AS Avg_Profit_Per_Line,
    CAST(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0)
        AS DECIMAL(10, 2)
    ) AS Profit_Margin_Pct
FROM dbo.orders
GROUP BY Discount
ORDER BY Discount DESC;
GO
----------------------------------
-- There is a strong association between higher discount rates and lower profitability or Losses.
-- The displayed discount levels of 30% and above all have negative total profit.
-- The 20% and 10% groups have positive total profit.
-- LOOK AT 20% => Substantial Profit 
-- AGAIN IT's relation not causation 
----------------------------------


-- Which subcategories have low profit margins, and how do their AVG discounts compare?
SELECT
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0)
        AS DECIMAL(10, 2)
    ) AS Profit_Margin_Pct,
    AVG(Discount) AS Avg_Discount,
    COUNT(*) AS Order_Lines
FROM dbo.orders
GROUP BY Sub_Category
ORDER BY Profit_Margin_Pct ASC;
GO

-----------------------------------------
-- High discounts may be contributing to weak profitability, but they don't explain every loss.
-----------------------------------------

-- Returns --
-- What percentage of distinct orders were returned?
WITH TotalOrders AS
(
    SELECT COUNT(DISTINCT Order_ID) AS Total_Order_Count
    FROM dbo.orders
),
ReturnedOrders AS
(
    SELECT COUNT(DISTINCT Order_ID) AS Returned_Order_Count
    FROM dbo.returns
)
SELECT
    T.Total_Order_Count,
    R.Returned_Order_Count,
    CAST(
        R.Returned_Order_Count * 100.0 /
        NULLIF(T.Total_Order_Count, 0)
        AS DECIMAL(10, 2)
    ) AS Return_Rate_Pct
FROM TotalOrders T
CROSS JOIN ReturnedOrders R;
GO

--------------------------------------------
-- Approximately 5.79% of distinct orders were returned
-- This is order level rate cuz for each order there might be like 10 products and 7 pieces each
--------------------------------------------


-- Are returns concentrated in particular regions, product categories, or customer segments?
WITH ReturnAnalysis AS
(
    SELECT
        'Region' AS Dimension,
        o.Region AS Dimension_Value,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders,
        COUNT(DISTINCT r.Order_ID) AS Total_Returns 
    FROM dbo.orders o
    LEFT JOIN dbo.returns r
        ON o.Order_ID = r.Order_ID
    GROUP BY o.Region 

    UNION ALL

    SELECT
        'Category',
        o.Category,
        COUNT(DISTINCT o.Order_ID),
        COUNT(DISTINCT r.Order_ID)
    FROM dbo.orders o
    LEFT JOIN dbo.returns r
        ON o.Order_ID = r.Order_ID
    GROUP BY o.Category

    UNION ALL

    SELECT
        'Customer Segment',
        o.Segment,
        COUNT(DISTINCT o.Order_ID),
        COUNT(DISTINCT r.Order_ID)
    FROM dbo.orders o
    LEFT JOIN dbo.returns r
        ON o.Order_ID = r.Order_ID
    GROUP BY o.Segment
)
SELECT
    Dimension,
    Dimension_Value,
    Total_Orders,
    Total_Returns,
    CAST(
        Total_Returns * 100.0 /
        NULLIF(Total_Orders, 0)
        AS DECIMAL(10, 2)
    ) AS Return_Rate_Pct
FROM ReturnAnalysis
ORDER BY Dimension, Return_Rate_Pct DESC;
GO

----------------------------------------------
-- The West's return rate is substaintially higher than the others. This deserves further investigation.
----------------------------------------------


/* 
=============================================================
Our EDA Is Complete
=============================================================
*/  
