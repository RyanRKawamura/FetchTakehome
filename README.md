# Fetch - Data Analyst Takehome Assessment
#### Ryan Kawamura
#### RyanKawamura@g.ucla.edu

## **1 Explore the Data**
Review the unstructured csv files and answer the following questions with code that supports your conclusions:

#### a) Are there any quality issues present?
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

