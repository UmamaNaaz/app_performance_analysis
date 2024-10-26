# SQL Sales Analysis Project

## Project Overview
This project demonstrates the use of SQL for analyzing sales data and understanding user behavior through various queries. The project aims to showcase SQL skills, including creating databases, joining tables, performing aggregation, and using window functions for analysis. The analysis covers customer spending, product popularity, and purchasing behavior before and after becoming premium members.

## Dataset Overview
The project uses a simulated dataset consisting of four tables:

1. **goldusers_signup**: Contains data about users who have signed up for a premium membership.
   - `userid`: Unique identifier for the user.
   - `gold_signup_date`: Date the user signed up for premium membership.
   
2. **users**: Represents all users who have signed up for the app.
   - `userid`: Unique identifier for the user.
   - `signup_date`: Date the user signed up for the app.
   
3. **sales**: Contains records of each purchase made by users.
   - `userid`: Unique identifier for the user.
   - `created_date`: Date when the purchase was made.
   - `product_id`: Identifier of the purchased product.
   
4. **product**: Details of the products available for purchase.
   - `product_id`: Unique identifier for the product.
   - `product_name`: Name of the product.
   - `price`: Price of the product.

## Analysis
The analysis is performed using SQL queries to derive insights about customer behavior, product popularity, and purchase patterns. Below are the key questions explored through the analysis:

### Key Questions Explored
1. **What is the total amount each customer spent on the app?**
   - This query calculates the sum of all purchases made by each customer.

2. **How many days did each customer visit the app?**
   - This analysis counts the number of distinct days each customer made a purchase, indicating engagement frequency.

3. **What was the first product purchased by each customer?**
   - By using window functions, this query identifies the first product purchased by each user.

4. **What is the most purchased item on the menu?**
   - This query finds the product that has been bought the most times across all users.

5. **How many times was the most purchased item bought by all customers?**
   - This question focuses on counting how many times the most popular product was purchased by each customer.

6. **What is the most popular item for each customer?**
   - The query identifies which product is the most frequently purchased by each user.

7. **Which product was purchased first by each customer after becoming a premium member?**
   - This analysis helps understand purchasing behavior right after users upgraded to premium membership.

8. **Which product was purchased last by each customer before becoming a premium member?**
   - This provides insight into the users' last purchase before they upgraded to premium.

9. **What is the total number of orders and the amount spent by each member before they became a premium member?**
   - The query calculates the total orders and spending by each user before they transitioned to premium membership.

10. **Calculate points collected by each customer and determine the product with the most points earned so far.**
    - Using a points system based on product price, this analysis calculates the points collected by each customer for their purchases and identifies the product with the highest points.

11. **Which product has the highest points awarded overall?**
    - This final query determines which product has accumulated the most points across all users.

## Summary and Findings
- **Total Spending Analysis**: The analysis reveals how much each user has spent on the app, which can be useful for identifying high-value customers.
- **Engagement Patterns**: Users' visit frequency helps understand the retention and engagement level of different customers.
- **Popular Products**: Identifying the most popular products allows for better inventory management and marketing efforts.
- **Behavior Before and After Premium Membership**: The shift in purchasing behavior after users become premium members helps in understanding how premium membership impacts spending habits.
- **Points System Analysis**: This highlights how different products contribute to user points, which could be useful for designing loyalty programs.
