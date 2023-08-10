
Q.1  Provide the list of markets in which customer "Atliq Exclusive" operates its
business in the APAC region.

select  DISTINCT market from dim_customer
where customer = 'Atliq Exclusive' and region='APAC';

Q.2 In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity,
Quarter
total_sold_quantity

SELECT quarter(DATE) QUARTER,SUM(sold_quantity) QUANTITY FROM (SELECT * FROM fact_sales_monthly
HAVING YEAR(DATE)=2020) AS T1
group by QUARTER
ORDER BY QUANTITY DESC

Q.3 Provide a report with all the unique product counts for each segment and
sort them in descending order of product counts. The final output contains
2 fields,
segment
product_count

SELECT SEGMENT,COUNT(DISTINCT PRODUCT) 'UNIQUE PRODUCT COUNT' FROM dim_product
group by SEGMENT
ORDER BY "UNIQUE PRODUCT COUNT" DESC;

Q.4 Follow-up: Which segment had the most increase in unique products in
2021 vs 2020? The final output contains these fields,
segment
product_count_2020
product_count_2021

 with t1 as(select distinct segment,product,fiscal_year from dim_product dp
join fact_sales_monthly sm on sm.product_code=dp.product_code)
select segment,fiscal_year,count(product) products from t1
group by segment,fiscal_year;

Q.5 Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields,
product_code
product
manufacturing_cost

select mc.product_code,product,manufacturing_cost from dim_product dp
join fact_manufacturing_cost mc on mc.product_code=dp.product_code
order by manufacturing_cost desc
limit 3;

select mc.product_code,product,manufacturing_cost from dim_product dp
join fact_manufacturing_cost mc on mc.product_code=dp.product_code
order by manufacturing_cost 
limit 3;

Q.6  . Get the complete report of the Gross sales amount for the customer “Atliq
Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions.
The final report contains these columns:
Month
Year
Gross sales Amount

WITH T1 AS (SELECT * FROM fact_sales_monthly
WHERE  customer_code IN(SELECT customer_code FROM dim_customer WHERE customer='Atliq Exclusive'))
,T2 AS (SELECT monthname(DATE) MONTH,year(DATE) YEAR,round((SOLD_QUANTITY*manufacturing_cost),2) SALE FROM T1 JOIN 
fact_manufacturing_cost MC ON MC.cost_year=T1.FISCAL_YEAR AND T1.PRODUCT_CODE=MC.product_code)
SELECT MONTH,YEAR,SUM(SALE) 'GROSS SALE' FROM T2
group by MONTH,YEAR
ORDER BY MONTH,YEAR

Q.7In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity,
Quarter
total_sold_quantity

SELECT quarter(DATE) QUARTER,SUM(sold_quantity) QUANTITY FROM (SELECT * FROM fact_sales_monthly
HAVING YEAR(DATE)=2020) AS T1
group by QUARTER
ORDER BY QUANTITY DESC

Q.7 What is the percentage of unique product increase in 2021 vs. 2020? The
final output contains these fields,
unique_products_2020
unique_products_2021
percentage_chg

WITH T1 AS(SELECT DP.product,SM.fiscal_year FROM dim_product DP 
JOIN fact_sales_monthly SM ON SM.product_code=DP.product_code)
,T2 AS(SELECT COUNT( DISTINCT PRODUCT) PT,FISCAL_YEAR FROM T1
group by FISCAL_YEAR)
SELECT
 ((SELECT PT FROM T2 WHERE FISCAL_YEAR=2021)-(SELECT PT FROM T2 WHERE FISCAL_YEAR=2020))
 /((SELECT PT FROM T2 WHERE FISCAL_YEAR=2020)
) *100 AS '%CHANGE',(SELECT PT FROM T2 WHERE FISCAL_YEAR=2021) '2021 PRODUCT COUNT'
,(SELECT PT FROM T2 WHERE FISCAL_YEAR=2020) '2020 PRODUCT COUNT' FROM T2
LIMIT 1;


Q.8 10. Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these
fields,
division
product_code
product
total_sold_quantity

WITH T1 AS (SELECT product_code,sum(sold_quantity) QUANTITY FROM fact_sales_monthly
WHERE fiscal_year=2021
group by product_code)
SELECT T1.product_CODE,dim_product.DIVISION,T1.QUANTITY,dim_product.product FROM T1
JOIN  dim_product ON T1.PRODUCT_CODE=dim_product.product_code
ORDER BY QUANTITY DESC
LIMIT 3





