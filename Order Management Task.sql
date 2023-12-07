-- 1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) 
-- as per the following criteria and sort them in descending order of category: a. If the category is 2050, increase 
-- the price by 2000 b. If the category is 2051, increase the price by 500 c. If the category is 2052, increase the price
--  by 600. Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]


-- solution 


select  PRODUCT_CLASS_CODE  , PRODUCT_ID , PRODUCT_DESC , PRODUCT_PRICE , 
case PRODUCT_CLASS_CODE
	when 2050 
		then PRODUCT_PRICE+2000
	when 2051
		then PRODUCT_PRICE+500
	when 2052 
		then PRODUCT_PRICE+600
	else 
		PRODUCT_PRICE
	end PRODUCT_PRICE 
	from PRODUCT
order by PRODUCT_CLASS_CODE desc





-- 2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status
--  of products as below as per their available quantity: a. For Electronics and Computer categories, if available quantity is <= 10, 
--  show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' b. For Stationery and Clothes categories, if qty <= 20,
--  show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' c. Rest of the categories, if qty <= 15 – 'Low Stock', 
-- 6 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'.
-- t: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]


-- solution 


SELECT PRODUCT_CLASS_DESC , PRODUCT_ID , PRODUCT_DESC  , PRODUCT_QUANTITY_AVAIL , 
case 
	when 
		  PRODUCT_CLASS_DESC =  'Electronics'  or  PRODUCT_CLASS_DESC = 'Computer'
	then case 
			when PRODUCT_QUANTITY_AVAIL <= 10 then "Low Stock"
			when PRODUCT_QUANTITY_AVAIL >= 11 and PRODUCT_QUANTITY_AVAIL <= 30 then "In Stock"
			when PRODUCT_QUANTITY_AVAIL >= 31 then "Enough Stock"
			END
	when 
		 PRODUCT_CLASS_DESC = 'Stationary' or  PRODUCT_CLASS_DESC = 'Clothes'
	then case 
			when PRODUCT_QUANTITY_AVAIL <= 20 then "Low Stock"
			when PRODUCT_QUANTITY_AVAIL >= 21 and  PRODUCT_QUANTITY_AVAIL <= 80 then "In Stock"
			when PRODUCT_QUANTITY_AVAIL  >= 81 then "Enough Stock"
			END
	else  
		case 
			when PRODUCT_QUANTITY_AVAIL <= 15  then "Low Stock"
			when  PRODUCT_QUANTITY_AVAIL >= 16 and PRODUCT_QUANTITY_AVAIL <= 50 then "In Stock"
			when PRODUCT_QUANTITY_AVAIL >= 51 then "Enough Stock"
			END
	END status
		FROM PRODUCT 
		JOIN PRODUCT_CLASS
		on PRODUCT.PRODUCT_CLASS_CODE = PRODUCT_CLASS.PRODUCT_CLASS_CODE



-- 3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more than 1 city, in the descending order of CITIES.
--  (2 rows) [NOTE: ADDRESS TABLE, Do not use Distinct]



-- solution 


SELECT COUNTRY , count (CITY) as Total_cities
	from ADDRESS
	group by COUNTRY
	HAVING country != "USA" and 
		   Country != "Malaysia" and 
		   Total_cities > 1
	order by CITY desc
