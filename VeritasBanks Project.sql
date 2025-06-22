SELECT *
FROM AccountInfo;

SELECT *
FROM CustomerInfo;

---Churn Rate - This would give us a baseline metric to gauge overall performance and 
---identify if churn is a real problem
SELECT 
    COUNT(*) AS TotalCustomers,
    SUM(CAST(Exited AS INT)) AS ChurnedCustomers,
    ROUND(100.0 * SUM(CAST(Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM AccountInfo;


---Churn Rate by Country- This Helps us identify underperforming regions
SELECT 
    c.Country,
    COUNT(*) AS TotalCustomers,
    SUM(CAST(a.Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(a.Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM CustomerInfo c
JOIN AccountInfo a ON c.CustomerId = a.CustomerId
GROUP BY c.Country
ORDER BY ChurnRatePercent DESC;


---Churn by Age Group- This helps us identify which age groups are most at risk
--- This is critical for designing relevant offers and communications.
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS AgeGroup,
    COUNT(*) AS Total,
    SUM(CAST(a.Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(a.Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM CustomerInfo c
JOIN AccountInfo a ON c.CustomerId = a.CustomerId
GROUP BY 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END
ORDER BY ChurnRatePercent DESC;


---Churn by Gender- Gender-specific marketing may reduce churn if one gender shows significantly higher risk.
SELECT 
    c.Gender,
    COUNT(*) AS Total,
    SUM(CAST(a.Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(a.Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM CustomerInfo c
JOIN AccountInfo a ON c.CustomerId = a.CustomerId
GROUP BY c.Gender;



---Churn by Number of Products - This tells us whether cross-sell is working. 
---Customers with more products usually have lower churn.
SELECT 
    Products,
    COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM AccountInfo
GROUP BY Products
ORDER BY Products;



---Churn by Credit Card Ownership - Credit card users tend to be more embedded. 
---If they’re still churning, that’s a red flag.
SELECT 
    CreditCard,
    COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM AccountInfo
GROUP BY CreditCard;



---Identify High-Risk Profiles - This gives us a target list of disengaged customers for proactive retention campaigns.
SELECT 
    a.CustomerId,
    c.Country,
    c.Age,
    a.CreditScore,
    a.Balance,
    a.Products,
    a.ActiveMember,
    a.Exited
FROM CustomerInfo c
JOIN AccountInfo a ON c.CustomerId = a.CustomerId
WHERE 
    a.CreditScore < 600 AND 
    a.Balance > 0 AND 
    a.Products = 1 AND 
    a.ActiveMember = 0;



---Churn by Activity (ActiveMember) - This reveals how much customer engagement impacts churn.
---It tells us whether passive users are leaving more, which justifies proactive engagement strategies.
SELECT 
    ActiveMember,
    COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM AccountInfo
GROUP BY ActiveMember;


----Churn by Credit Score Band - This Helps us understand how financial reliability relates to churn risk.
SELECT 
    CASE 
        WHEN CreditScore < 500 THEN 'Poor (<500)'
        WHEN CreditScore BETWEEN 500 AND 649 THEN 'Fair (500–649)'
        WHEN CreditScore BETWEEN 650 AND 749 THEN 'Good (650–749)'
        ELSE 'Excellent (750+)'
    END AS CreditBand,
    COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM AccountInfo
GROUP BY 
    CASE 
        WHEN CreditScore < 500 THEN 'Poor (<500)'
        WHEN CreditScore BETWEEN 500 AND 649 THEN 'Fair (500–649)'
        WHEN CreditScore BETWEEN 650 AND 749 THEN 'Good (650–749)'
        ELSE 'Excellent (750+)'
    END
ORDER BY ChurnRatePercent DESC;


---Churn by Balance Range - Customers with low or dormant balances may be more likely to leave.
SELECT 
    CASE 
        WHEN Balance = 0 THEN 'Zero Balance'
        WHEN Balance < 25000 THEN 'Low (<25K)'
        WHEN Balance BETWEEN 25000 AND 75000 THEN 'Mid (25K–75K)'
        ELSE 'High (75K+)'
    END AS BalanceRange,
    COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM AccountInfo
GROUP BY 
    CASE 
        WHEN Balance = 0 THEN 'Zero Balance'
        WHEN Balance < 25000 THEN 'Low (<25K)'
        WHEN Balance BETWEEN 25000 AND 75000 THEN 'Mid (25K–75K)'
        ELSE 'High (75K+)'
    END
ORDER BY ChurnRatePercent DESC;



---Churn by Tenure - This helps understand if new or long-time customers are more likely to leave.
SELECT 
    Tenure,
    COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Churned,
    ROUND(100.0 * SUM(CAST(Exited AS INT)) / COUNT(*), 2) AS ChurnRatePercent
FROM AccountInfo
GROUP BY Tenure
ORDER BY Tenure;



