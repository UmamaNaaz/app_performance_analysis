USE project;


-- 1) what is the total amount each customer spent on app?
SELECT 
    s.userid, 
    SUM(p.price) AS total_amount_spent
FROM 
    product p
INNER JOIN 
    sales s 
    ON p.product_id = s.product_id
GROUP BY 
    s.userid;


-- 2) how many days each customer visited app
SELECT 
    userid, 
    COUNT(DISTINCT created_date) AS distinct_days
FROM 
    sales
GROUP BY 
    userid;


-- 3) first product purchase by the customer
SELECT 
    *
FROM (
    SELECT 
        *,
        RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rn 
    FROM 
        sales
) a
WHERE 
    rn = 1;


-- 4) what is the most purchased item on the menu 
SELECT 
    product_id AS most_purchased_product_id
FROM 
    sales
GROUP BY 
    product_id
ORDER BY 
    COUNT(product_id) DESC
LIMIT 1;


-- 5) How many times was it purchased by all customers?
SELECT 
    userid, 
    COUNT(product_id) AS cnt 
FROM 
    sales
WHERE 
    product_id = (
        SELECT 
            product_id
        FROM 
            sales
        GROUP BY 
            product_id
        ORDER BY 
            COUNT(product_id) DESC
        LIMIT 1
    )
GROUP BY 
    userid;


-- 6) most popular item for each of the customer
SELECT 
    * 
FROM (
    SELECT 
        *, 
        RANK() OVER (PARTITION BY userid ORDER BY cnt DESC) AS rnk 
    FROM (
        SELECT 
            userid, 
            product_id, 
            COUNT(product_id) AS cnt 
        FROM 
            sales 
        GROUP BY 
            userid, 
            product_id
    ) a
) b
WHERE 
    rnk = 1;


-- 7) which product was purchased first by the customer after becoming the prime member
WITH FirstPurchaseAfter AS (
    SELECT 
        g.userid, 
        s.product_id, 
        RANK() OVER (PARTITION BY g.userid ORDER BY s.created_date ASC) AS rnk
    FROM 
        goldusers_signup g 
    INNER JOIN 
        sales s 
        ON g.userid = s.userid
    WHERE 
        s.created_date > g.gold_signup_date
)
SELECT 
    * 
FROM 
    FirstPurchaseAfter
WHERE 
    rnk = 1;


-- 8) which product was purchased last by the customer before becoming the prime member
WITH LastPurchaseBefore AS (
    SELECT 
        g.userid, 
        s.product_id, 
        RANK() OVER (PARTITION BY g.userid ORDER BY s.created_date DESC) AS rnk
    FROM 
        goldusers_signup g 
    INNER JOIN 
        sales s 
        ON g.userid = s.userid
    WHERE 
        s.created_date < g.gold_signup_date
)
SELECT 
    * 
FROM 
    LastPurchaseBefore
WHERE 
    rnk = 1;


-- 9) what is the total orders and amount spent for each member before they became a member?
WITH TotalAmntSpend AS (
    SELECT 
        s.userid, 
        p.product_id, 
        p.price, 
        s.created_date 
    FROM 
        product p
    INNER JOIN 
        sales s 
        ON p.product_id = s.product_id
    INNER JOIN 
        goldusers_signup g 
        ON s.userid = g.userid
    WHERE 
        s.created_date < g.gold_signup_date
)
SELECT 
    userid, 
    COUNT(created_date) AS total_no_of_order, 
    SUM(price) AS total_amount 
FROM 
    TotalAmntSpend 
GROUP BY 
    userid 
ORDER BY 
    SUM(price) DESC;


-- 10) calculate points collected by each customers and for which product most points have been given till now 

/* if buying each product generates point.for eg rs5 = 2 points and each product have different purchasing points 
for eg p1 5rs= 1points , for p2 10rs = 5 points and for p3 5rs = 1 point */

WITH SalesWithPrice AS (
    SELECT 
        s.*, 
        p.price 
    FROM 
        sales s 
    INNER JOIN 
        product p 
        ON s.product_id = p.product_id
),

UserProductAmount AS (
    SELECT 
        userid, 
        product_id, 
        SUM(price) AS amt
    FROM 
        SalesWithPrice
    GROUP BY 
        userid, 
        product_id
),

UserProductPoints AS (
    SELECT 
        userid, 
        product_id, 
        ROUND(
            CASE 
                WHEN product_id = 1 THEN amt / 5 
                WHEN product_id = 2 THEN amt / 2 
                WHEN product_id = 3 THEN amt / 5 
                ELSE 0 
            END, 1
        ) AS pnts
    FROM 
        UserProductAmount
)

SELECT 
    userid, 
    SUM(pnts) * 2.5 AS total_money_earned
FROM 
    UserProductPoints
GROUP BY 
    userid;


-- 11) for which product most points have been given till now
WITH SalesWithPrice AS (
    SELECT 
        s.*, 
        p.price 
    FROM 
        sales s 
    INNER JOIN 
        product p 
        ON s.product_id = p.product_id
),

UserProductAmount AS (
    SELECT 
        userid, 
        product_id, 
        SUM(price) AS amt 
    FROM 
        SalesWithPrice 
    GROUP BY 
        userid, 
        product_id
),

UserProductPoints AS (
    SELECT 
        userid, 
        product_id, 
        ROUND(
            CASE 
                WHEN product_id = 1 THEN amt / 5 
                WHEN product_id = 2 THEN amt / 2 
                WHEN product_id = 3 THEN amt / 5 
                ELSE 0 
            END, 1
        ) AS pnts
    FROM 
        UserProductAmount
),

TotalPointsPerProduct AS (
    SELECT 
        product_id, 
        SUM(pnts) AS total_points_earned
    FROM 
        UserProductPoints
    GROUP BY 
        product_id
),

RankedProducts AS (
    SELECT 
        *, 
        RANK() OVER (ORDER BY total_points_earned DESC) AS rnk
    FROM 
        TotalPointsPerProduct
)

SELECT 
    *
FROM 
    RankedProducts
WHERE 
    rnk = 1;
    
    
    