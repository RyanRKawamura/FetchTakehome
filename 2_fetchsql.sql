USE fetchtakehome;

### Closed-ended question
### What are the top 5 brands by receipts scanned among users 21 and over
SELECT 		brand, 
		count(brand) as count_receipt_scanned
FROM 		users as u
RIGHT JOIN 	transactions as t
ON		u.id = t.user_id
LEFT JOIN 	products as p
ON		p.barcode = t.barcode
WHERE 		DATEDIFF(CURDATE(), BIRTH_DATE) / 365 >= 21
GROUP BY 	BRAND 
ORDER BY 	count(brand) desc, brand asc  #For ties
LIMIT 5;

### Closed-ended question
### What are the top 5 brands by sales among users that have had their account for at least six months
SELECT 		p.brand, 
		sum(t.FINAL_SALE) as total_sale
FROM 		users as u
RIGHT JOIN 	transactions as t
ON		u.id = t.user_id
LEFT JOIN 	products as p
ON		p.barcode = t.barcode
WHERE 		DATEDIFF(CURDATE(), BIRTH_DATE) >= 180 # assuming average days of 6 months is 180
		and p.brand is not null
GROUP BY 	p.brand
ORDER BY 	sum(t.FINAL_SALE) desc, brand asc # incase of tie
LIMIT 5;

### Closed-ended question
### What is the percentage of sales in the Health and Wellness category by generation
### Assumption: Silent Generation (1928-1948), Baby Boomers (1946-1964), Gen X (1965-1980), Millenials (1981-1996), Gen Z (1997-2012), Gen Alpha (2013-Now)

SELECT 		sum(IF(YEAR(BIRTH_DATE) BETWEEN 1928 and 1945, t.final_sale, 0))/sum(t.final_sale)*100 as Silent_Generation,
		sum(IF(YEAR(BIRTH_DATE) BETWEEN 1946 and 1964, t.final_sale, 0))/sum(t.final_sale)*100 as Baby_Boomers,
		sum(IF(YEAR(BIRTH_DATE) BETWEEN 1965 and 1980, t.final_sale, 0))/sum(t.final_sale)*100 as Generation_X,
		sum(IF(YEAR(BIRTH_DATE) BETWEEN 1981 and 1996, t.final_sale, 0))/sum(t.final_sale)*100 as Milennials,
		sum(IF(YEAR(BIRTH_DATE) BETWEEN 1997 and 2012, t.final_sale, 0))/sum(t.final_sale)*100 as Generation_Z,
		sum(IF(YEAR(BIRTH_DATE) BETWEEN 2013 and YEAR(CURDATE()), t.final_sale, 0))/sum(t.final_sale)*100 as Gen_Alpha
FROM 		users as u
RIGHT JOIN 	transactions as t
ON		u.id = t.user_id
LEFT JOIN 	products as p
ON		p.barcode = t.barcode
WHERE 		p.category_1 = 'Health & Wellness'
    		AND u.BIRTH_DATE IS NOT NULL; # assuming we are excluding null birthdays
    		
### Open-ended questions
### Who are Fetch's power users?

WITH SpendingCTE AS (
    SELECT 		t.user_id,
        		SUM(t.final_sale) AS total_spent,
        		NTILE(10) OVER (order by SUM(t.final_sale) desc) AS percentile_spent
    FROM 		transactions AS t
    GROUP BY 	t.user_id
),
ScanningCTE AS (
    SELECT 		user_id,
        		COUNT(scan_date) AS number_of_scans,
        		NTILE(10) OVER (order by COUNT(scan_date) desc) AS percentile_scans
    FROM 		transactions
    GROUP BY 	user_id
) 
SELECT 		s.user_id,
    		s.total_spent,
    		sc.number_of_scans
FROM 		SpendingCTE AS s
JOIN 		ScanningCTE AS sc ON s.user_id = sc.user_id
WHERE		s.percentile_spent = 1 OR sc.percentile_scans = 1
ORDER BY 	number_of_scans desc, total_spent desc;
