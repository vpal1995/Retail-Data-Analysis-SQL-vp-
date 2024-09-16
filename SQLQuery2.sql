

Q1.
SELECT (SELECT COUNT(*) FROM Customer) AS CustCnt,
       (SELECT COUNT(*) FROM Transactions) AS TransCnt,     
       (SELECT COUNT(*) FROM prod_cat_info) AS ProdCnt

Q2.
select COUNT(*) AS custcnt 
from Transactions
where total_amt < 0

Q3
Select CONVERT(date,tran_date,105) tran_date from transactions

Q4. 
select tran_date ,MONTH(tran_date) as months,YEAR(tran_date) as years,DAY(tran_date) as "day" from Transactions

Q.5.
Select prod_cat,prod_subcat

from prod_cat_info
where prod_subcat='DIY'

                                 -----Data  Analysis-----------
Q1.
Select top 1 count( Store_type)as St,Store_type
from Transactions
group by Store_type
order by St desc
Q.2.


       SELECT COUNT(Gender) AS Total,Gender
	   FROM Customer
	   where Gender is not null
	   group by Gender


Q3.	   
Select top 1 count(City_code )as St,city_code
from Customer
group by city_code
order by St desc

Q4.
Select prod_cat ,count(prod_cat) as 'count'
from prod_cat_info
where prod_cat= 'Books'
group by prod_cat

Q5.
Select top 1  prod_cat , count(Qty) as 'count'
from Transactions as p
inner join prod_cat_info as t
on p.prod_subcat_code =t.prod_sub_cat_code
group by prod_cat
order by 'count' desc
  
Q6.
	Select   sum(total_amt) as  total_revenue 
	from transactions  as t
	inner join prod_cat_info as p
	on t.prod_subcat_code =p.prod_sub_cat_code
	and t.prod_cat_code=p.prod_cat_code
	where prod_cat in('Books',
	'electronics')
Q7.
select cust_id,COUNT(transaction_id) as total
from Transactions as t
inner join customer as c 
on t.cust_id=c.customer_Id
group by cust_id having count (transaction_id )> 10

Q8.
Select   sum(total_amt) as  total_revenue 
	from transactions  as t
	  join prod_cat_info as p
	on 
	 t.prod_cat_code=p.prod_cat_code
	 and t.prod_subcat_code=p.prod_sub_cat_code
	where prod_cat in('clothing',
	'electronics') and 	 Store_type= 'flagship store'

Q9.
SELECT prod_subcat, SUM(TOTAL_AMT) REVENUE
FROM TRANSACTIONS as t
LEFT JOIN CUSTOMER ON CUST_ID=CUSTOMER_ID
LEFT JOIN prod_cat_info as p ON prod_sub_cat_code = PROD_SUBCAT_CODE AND p.prod_cat_code = t.prod_cat_code
WHERE t.prod_cat_code= '3' AND GENDER = 'M'
GROUP BY  PROD_SUBCAT

Q10.
SELECT TOP 5 
PROD_SUBCAT, sum(case when qty> 0 then (total_amt) else null end)/(SELECT SUM(TOTAL_AMT) FROM TRANSACTIONS as T)*100 AS [% sales], 
sum(CASE WHEN QTY< 0 THEN  abs (total_amt) ELSE NULL END)/(select SUM(TOTAL_AMT) FROM TRANSACTIONS AS T)*100 AS PERCENTAGE_OF_RETURN
FROM TRANSACTIONS as t
INNER JOIN PROD_CAT_INFO as p ON P.PROD_CAT_CODE = T.PROD_CAT_CODE AND P.PROD_SUB_CAT_CODE= T.PROD_SUBCAT_CODE
GROUP BY PROD_SUBCAT
ORDER BY [% sales] desc,PERCENTAGE_OF_RETURN desc

Q11.
SELECT SUM(TOTAL_AMT) AS REVENUE 
from(
    select cust_id,t.tran_date,t.total_amt,
	datediff(year,dob,max(tran_date)) as age
	from transactions as t
	inner join customer as c
	on t.cust_id =c.customer_id
	group by cust_id,t.tran_date,t.total_amt,dob
	)as x
	where(age between 25 and 35)
	and tran_date >= (select dateadd(day,-30,max(tran_date)) from transactions)

--Q12.--

SELECT TOP 1 PROD_CAT, SUM(TOTAL_AMT) AS [VALUE] FROM TRANSACTIONS T1
INNER JOIN PROD_CAT_INFO T2 ON T1.PROD_CAT_CODE = T2.PROD_CAT_CODE AND 
										T1.PROD_SUBCAT_CODE = T2.PROD_SUB_CAT_CODE
WHERE TOTAL_AMT < 0 AND 
CONVERT(date, TRAN_DATE, 103) BETWEEN DATEADD(MONTH,-3,(SELECT MAX(CONVERT(DATE,TRAN_DATE,103)) FROM TRANSACTIONS)) 
	 AND (SELECT MAX(CONVERT(DATE,TRAN_DATE,103)) FROM TRANSACTIONS)
GROUP BY PROD_CAT
order by [value] asc 

Q13.

SELECT top 1 STORE_TYPE, sum(TOTAL_AMT) TOT_SALES, sum(QTY) TOT_QUAN
FROM TRANSACTIONS
where total_amt>0 and Qty>0
group by Store_type 
order by max(total_amt)desc


Q14.

SELECT PROD_CAT, AVG(TOTAL_AMT) AS AVERAGE
FROM TRANSACTIONS AS T
INNER JOIN PROD_CAT_INFO AS P ON P.PROD_CAT_CODE=T.PROD_CAT_CODE AND P.PROD_SUB_CAT_CODE=T.PROD_SUBCAT_CODE
GROUP BY PROD_CAT
HAVING AVG(TOTAL_AMT)> (SELECT AVG(TOTAL_AMT) FROM TRANSACTIONS) 

Q15.
SELECT prod_cat,PROD_SUBCAT, AVG(TOTAL_AMT) AS AVERAGE_REV, SUM(TOTAL_AMT) AS REVENUE
FROM TRANSACTIONS AS T
INNER JOIN PROD_CAT_INFO AS P ON P.PROD_CAT_CODE=T.PROD_CAT_CODE AND P.PROD_SUB_CAT_CODE=T.PROD_SUBCAT_CODE
WHERE PROD_CAT in
(
SELECT TOP 5 
PROD_CAT
FROM TRANSACTIONS as T 
INNER JOIN PROD_CAT_INFO AS P ON P.PROD_CAT_CODE= T.PROD_CAT_CODE AND P.PROD_SUB_CAT_CODE = T.PROD_SUBCAT_CODE
GROUP BY PROD_CAT
ORDER BY SUM(QTY) DESC
)
GROUP BY prod_cat,PROD_SUBCAT