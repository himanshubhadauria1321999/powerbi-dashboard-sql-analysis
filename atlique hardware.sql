select  DISTINCT market from dim_customer
where customer = 'Atliq Exclusive' and region='APAC';

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


SELECT SEGMENT,COUNT(DISTINCT PRODUCT) 'UNIQUE PRODUCT COUNT' FROM dim_product
group by SEGMENT
ORDER BY "UNIQUE PRODUCT COUNT" DESC;

 with t1 as(select distinct segment,product,fiscal_year from dim_product dp
join fact_sales_monthly sm on sm.product_code=dp.product_code)
select segment,fiscal_year,count(product) products from t1
group by segment,fiscal_year;


select mc.product_code,product,manufacturing_cost from dim_product dp
join fact_manufacturing_cost mc on mc.product_code=dp.product_code
order by manufacturing_cost desc
limit 3;

select mc.product_code,product,manufacturing_cost from dim_product dp
join fact_manufacturing_cost mc on mc.product_code=dp.product_code
order by manufacturing_cost 
limit 3;


with t1 as(SELECT sum(sold_quantity) quantity,fsm.customer_code from fact_sales_monthly fsm
where fiscal_year=2020
group by customer_code
order by quantity desc)
select dc.channel,t1.quantity,t1.customer_code,dc.market from dim_customer dc
join t1 on t1.customer_code=dc.customer_code
order by quantity desc
limit 5;


with t1 as(SELECT sum(sold_quantity) quantity,fsm.customer_code from fact_sales_monthly fsm
where fiscal_year=2021
group by customer_code
order by quantity desc)
select dc.channel,t1.quantity,t1.customer_code,dc.market from dim_customer dc
join t1 on t1.customer_code=dc.customer_code
order by quantity desc
limit 5;


with cte as (select product_code,sum(sold_quantity) quant from fact_sales_monthly 
group by product_code),
t2 as (select * from fact_sales_monthly)
select * from dim_product dp
join cte on dp.product_code=cte.product_code
order by cte.quant desc;


select id.customer_code,id.pre_invoice_discount_pct,sm.sold_quantity,gp.gross_price,gp.product_code,gp.fiscal_year
 from fact_pre_invoice_deductions id
join fact_sales_monthly sm on sm.customer_code=id.customer_code
join fact_gross_price gp on gp.product_code=sm.product_code;


select DISTINCT market from dim_customer
WHERE customer='Atliq Exclusive' and region='APAC';

WITH T1 AS(SELECT SUM(sold_quantity) 'UNIQUE_2020',product_code FROM fact_sales_monthly 
WHERE fiscal_year=2020
group by product_code),
T2 AS (SELECT SUM(sold_quantity) 'UNIQUE_2021',product_code FROM fact_sales_monthly 
WHERE fiscal_year=2021
group by product_code)
SELECT  *,(T2.UNIQUE_2021-T1.UNIQUE_2020)/T1.UNIQUE_2020*100 AS INCREASE FROM T2
JOIN T1 ON T1.product_code=T2.product_code;

SELECT COUNT(*) PRODUCT_COUNT ,SEGMENT FROM dim_product
group by SEGMENT
ORDER BY PRODUCT_COUNT DESC;


WITH T1 AS(SELECT SUM(sold_quantity) 'UNIQUE_2020',product_code FROM fact_sales_monthly 
WHERE fiscal_year=2020
group by product_code),
T2 AS (SELECT SUM(sold_quantity) 'UNIQUE_2021',product_code FROM fact_sales_monthly 
WHERE fiscal_year=2021
group by product_code)
SELECT  T1.UNIQUE_2020,dp.segment,T2.UNIQUE_2021,(T2.UNIQUE_2021-T1.UNIQUE_2020)/T1.UNIQUE_2020*100 AS INCREASE FROM T2
JOIN T1 ON T1.product_code=T2.product_code
JOIN dim_product DP ON DP.product_code=T1.product_code;


(select dp.product,mc.product_code,mc.manufacturing_cost from fact_manufacturing_cost mc
join dim_product dp on dp.product_code=mc.product_code
order by mc.manufacturing_cost
limit 1)
union(
select dm.product,mt.product_code,mt.manufacturing_cost from fact_manufacturing_cost mt
join dim_product dm on dm.product_code=mt.product_code
order by mt.manufacturing_cost desc
limit 1);


select id.customer_code,dc.customer,id.pre_invoice_discount_pct from fact_pre_invoice_deductions id
join dim_customer dc on dc.customer_code=id.customer_code
where market='India' and fiscal_year='2021';




















