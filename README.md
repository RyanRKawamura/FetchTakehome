# Fetch - Data Analyst Takehome Assessment
#### Ryan Kawamura
#### RyanKawamura@g.ucla.edu

## **1 Explore the Data**
Review the unstructured csv files and answer the following questions with code that supports your conclusions:

### a) Are there any quality issues present?
### **Products** Table
**#1**: Many Null Values, especially in CATEGORY_4. This is an issue because that means we have incomplete data. 
- CATEGORY_1: 111 Null Values
- CATEGORY_2: 1,424 Null Values
- CATEGORY_3: 60,566 Null Values
- CATEGORY_4: 778,092 Null Values
- MANUFACTURER: 226,474 Null Values
- BARCODE: 4025 Null Values 

Null Values in the Barcode section are especially an issue because they are the primary key that is used in relation to the transactions table

<img width="591" alt="Screenshot 2025-02-01 at 5 20 26 PM" src="https://github.com/user-attachments/assets/fe7ab4e5-504c-4832-a07d-e39c8d45cae9" />

**#2**: There are duplicates in the BARCODE column which is an issue because it is a primary key.

There are two instances of duplicates:

a) Duplicate rows (ie the same data in the rows)

<img width="788" alt="Screenshot 2025-02-01 at 5 21 11 PM" src="https://github.com/user-attachments/assets/aae62872-18f0-44ed-bc4c-bb4010815b53" />

b) Same barcode, different product/data

<img width="774" alt="Screenshot 2025-02-01 at 5 21 29 PM" src="https://github.com/user-attachments/assets/6a03ae46-4d75-4004-9d2b-add4c092a616" />

### **Users** Table

**#1**: Null Values in the data indicating an incomplete dataset
- ID : 0 Null Values
- CREATED_DATE : 0 Null Values
- BIRTH_DATE : 3675 Null Values
- STATE : 4812 Null Values
- LANGUAGE : 30508 Null Values
- GENDER : 5892 Null Values

<img width="592" alt="Screenshot 2025-02-01 at 5 24 57 PM" src="https://github.com/user-attachments/assets/e7d8366e-0a1e-4fcf-9038-087428cabad1" />

**#2**: BIRTH_DATE has different levels of accuracy
- Some of the BIRTH_DATE data values are accurate to the second, to the hour, or to the day. This inconcistency in accuracy of data may cause issues later in analysis

### **Transactions** Table

**#1**: Null values for Barcode
- RECEIPT_ID : 0 Null Values
- PURCHASE_DATE : 0 Null Values
- SCAN_DATE : 0 Null Values
- STORE_NAME : 0 Null Values
- USER_ID : 0 Null Values
- BARCODE : 5762 Null Values
- FINAL_QUANTITY : 0 Null Values
- FINAL_SALE : 0 Null Values

**#2**: There is inconsistent data type for the FINAL_QUANTITY column, with 0 being a string type while the other values are decimal values of float type. This makes the data type inconsistent. 

**#3**: Duplicate Rows 
This indicates a data quality issue because there are multiple of the same column. The receipt_id being the same makes sense because in a receipt you can purchase multiple items, but instead of there only being one row for an item and a quantity of that product, there are times where there are multiple duplicate rows where the one final_sale row has a value and the first one is blank. This could be a result of a sale or buy 1 get 1 free, so this is a question I would like to inquire about, but for now I will determine it as a data quality issue
<img width="1183" alt="Screenshot 2025-02-01 at 5 26 33 PM" src="https://github.com/user-attachments/assets/01e64a54-d133-4b9e-ab97-5b71e1372adb" />

### b) Are there any fields that are challenging to understand?

**User**: No, I believe all of the data fields in the User dataframe are easily understandable. One suggestion, however, could be to change the data field "ID" to "USER_ID" to maintain consistency of column names between the different dataframes because it is referred to as USER_ID in the transaction table.

**Transaction**: Yes
- **FINAL_QUANTITY** is hard to understand because it is not clear what is being referred to as 'quantity.' When first looking at the column name, I thought it referred to how many items were purchased. However, there are decimal values in the column, indicating that 'quantity' is not referring to the number of items purchased because one cannot purchase a 0.47 of an item (for instance). Also, there are values of 0 even though it is in the transactions dataframe, indicating that a transaction was made. Thus, the "Final Quantity" data field is hard to understand. 

**Products**: No, I believe the data fields are easily understandable. It could be made clearer that category 1-4 increases in how specific it describes the item, but I do not think this is completely necessary. 

## **2 Provide SQL Queries**
### Closed-ended question
What are the top 5 brands by receipts scanned among users 21 and over

```sh
SELECT 		brand, 
          count(brand) as count_receipt_scanned
FROM 		users as u
RIGHT JOIN 	transactions as t
ON			u.id = t.user_id
LEFT JOIN 	products as p
ON			p.barcode = t.barcode
WHERE 		DATEDIFF(CURDATE(), BIRTH_DATE) / 365 >= 21
GROUP BY 	BRAND 
ORDER BY 	count(brand) desc, brand asc  #For ties
LIMIT 5;
```
<img width="361" alt="Screenshot 2025-02-03 at 10 30 55 AM" src="https://github.com/user-attachments/assets/2f8ea643-1245-4e90-9e03-bb28d5f8cfdc" />

What are the top 5 brands by sales among users that have had their account for at least six months

```sh
SELECT 		p.brand, 
			sum(t.FINAL_SALE) as total_sale
FROM 		users as u
RIGHT JOIN 	transactions as t
ON			u.id = t.user_id
LEFT JOIN 	products as p
ON			p.barcode = t.barcode
WHERE 		DATEDIFF(CURDATE(), BIRTH_DATE) >= 180 # assuming average days of 6 months is 180
			and p.brand is not null
GROUP BY 	p.brand
ORDER BY 	sum(t.FINAL_SALE) desc, brand asc # incase of tie
LIMIT 5;
```
<img width="268" alt="Screenshot 2025-02-03 at 10 31 55 AM" src="https://github.com/user-attachments/assets/c32e559d-e267-40ea-b646-4ff15d4970c4" />

What is the percentage of sales in the Health and Wellness category by generation

```sh
SELECT 		sum(IF(YEAR(BIRTH_DATE) BETWEEN 1928 and 1945, t.final_sale, 0))/sum(t.final_sale)*100 as Silent_Generation,
			sum(IF(YEAR(BIRTH_DATE) BETWEEN 1946 and 1964, t.final_sale, 0))/sum(t.final_sale)*100 as Baby_Boomers,
			sum(IF(YEAR(BIRTH_DATE) BETWEEN 1965 and 1980, t.final_sale, 0))/sum(t.final_sale)*100 as Generation_X,
			sum(IF(YEAR(BIRTH_DATE) BETWEEN 1981 and 1996, t.final_sale, 0))/sum(t.final_sale)*100 as Milennials,
			sum(IF(YEAR(BIRTH_DATE) BETWEEN 1997 and 2012, t.final_sale, 0))/sum(t.final_sale)*100 as Generation_Z,
			sum(IF(YEAR(BIRTH_DATE) BETWEEN 2013 and YEAR(CURDATE()), t.final_sale, 0))/sum(t.final_sale)*100 as Gen_Alpha
FROM 		users as u
RIGHT JOIN 	transactions as t
ON			u.id = t.user_id
LEFT JOIN 	products as p
ON			p.barcode = t.barcode
WHERE 		p.category_1 = 'Health & Wellness'
    		AND u.BIRTH_DATE IS NOT NULL; # assuming we are excluding null birthdays

```

<img width="926" alt="Screenshot 2025-02-03 at 10 32 41 AM" src="https://github.com/user-attachments/assets/465a38b3-9030-4697-918d-873187cb5025" />


## Open-ended questions
**Who are Fetch's power users?**
First, must define what makes a power user. Using my intuition plus external research and considering the data, I will consider power user to be the top 10 percentile of users who have spent the most through the app additionally how many times they interact with the app calculated through scans. My reasoning being that the 

```sh
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
```
