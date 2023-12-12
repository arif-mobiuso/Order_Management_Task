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
order by PRODUCT_CLASS_CODE desc ; 






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
		on PRODUCT.PRODUCT_CLASS_CODE = PRODUCT_CLASS.PRODUCT_CLASS_CODE ; 



-- 3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more than 1 city, in the descending order of CITIES.
--  (2 rows) [NOTE: ADDRESS TABLE, Do not use Distinct]



-- solution 


SELECT COUNTRY  , count(CITY) as Total_cities
	from ADDRESS
	group by COUNTRY
	HAVING country != "USA" and 
		   Country != "Malaysia" and 
		   Total_cities > 1
	order by Total_cities desc ; 
	
	
-- 	
-- 4. Write a query to display the customer_id,customer full name ,city,pincode,and order details 
-- (order id, product class desc, product desc, subtotal(product_quantity * product_price)) for orders shipped to
--  cities whose pin codes do not have any 0s in them. Sort the output on customer name and subtotal. (52 ROWS) 
--  [NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]


-- solution 


SELECT ONLINE_CUSTOMER.CUSTOMER_ID ,
		concat(ONLINE_CUSTOMER.CUSTOMER_FNAME  , " " , ONLINE_CUSTOMER.CUSTOMER_LNAME )as Customer_FullName  ,
		ADDRESS.CITY ,
		ADDRESS.PINCODE , 
		ORDER_HEADER.ORDER_ID , 
		PRODUCT_CLASS.PRODUCT_CLASS_DESC ,
		PRODUCT.PRODUCT_DESC ,
		ORDER_ITEMS.PRODUCT_QUANTITY * PRODUCT.PRODUCT_PRICE as SubTotal 
from ONLINE_CUSTOMER 
		join ADDRESS on ONLINE_CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
		join ORDER_HEADER on ORDER_HEADER.CUSTOMER_ID = ONLINE_CUSTOMER.CUSTOMER_ID
		join ORDER_ITEMS on ORDER_ITEMS.ORDER_ID = ORDER_HEADER.ORDER_ID
		join PRODUCT on product.PRODUCT_ID = ORDER_ITEMS.PRODUCT_ID
		join PRODUCT_CLASS on product.PRODUCT_CLASS_CODE = PRODUCT_CLASS.PRODUCT_CLASS_CODE
where PINCODE not like "%0%" and 
		ORDER_HEADER.ORDER_STATUS = "Shipped"
order by Customer_FullName  , SubTotal ; 



-- 
-- 5. Write a Query to display product id,product description,totalquantity(sum(product quantity) for an item which has been 
-- bought maximum no. of times (Quantity Wise) along with product id 201. (USE SUB-QUERY) (1 ROW) [NOTE: ORDER_ITEMS TABLE, PRODUCT TABLE]



-- solution



-- Using joins 

select PRODUCT.PRODUCT_ID  , PRODUCT.PRODUCT_DESC , sum(ORDER_ITEMS.PRODUCT_QUANTITY) as Total_Quantity
from PRODUCT
join ORDER_ITEMS  on ORDER_ITEMS.PRODUCT_ID =  PRODUCT.PRODUCT_ID
where  PRODUCT.PRODUCT_ID   = 201
group by PRODUCT.PRODUCT_ID
order by Total_Quantity DESC limit 1  ; 

-- Using Sub-query

SELECT  PRODUCT.PRODUCT_ID  ,
		PRODUCT.PRODUCT_DESC  , 
	   (select sum(ORDER_ITEMS.PRODUCT_QUANTITY)
		from ORDER_ITEMS 
		where ORDER_ITEMS.PRODUCT_ID = PRODUCT.PRODUCT_ID) as Total_Quantity
from PRODUCT
where  PRODUCT.PRODUCT_ID   = 201
ORDER BY Total_Quantity DESC 
LIMIT 1 ;



-- 6. Write a query to display the customer_id,customer name, email and order details (order id, product desc,product qty,
--  subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.(225 ROWS) 
--  [NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]



-- solution 


select ONLINE_CUSTOMER.CUSTOMER_ID ,
		concat(ONLINE_CUSTOMER.CUSTOMER_FNAME  , " " , ONLINE_CUSTOMER.CUSTOMER_LNAME )as Customer_FullName  ,
		ONLINE_CUSTOMER.CUSTOMER_EMAIL , 
		ORDER_HEADER.ORDER_ID , 
		PRODUCT.PRODUCT_DESC ,
		ORDER_ITEMS.PRODUCT_QUANTITY, 
		ORDER_ITEMS.PRODUCT_QUANTITY * PRODUCT.PRODUCT_PRICE as SubTotal 
FROM ONLINE_CUSTOMER
		left join ORDER_HEADER on ORDER_HEADER.CUSTOMER_ID = ONLINE_CUSTOMER.CUSTOMER_ID
		left join ORDER_ITEMS on ORDER_ITEMS.ORDER_ID = ORDER_HEADER.ORDER_ID
		left join PRODUCT on product.PRODUCT_ID = ORDER_ITEMS.PRODUCT_ID ;
		


-- 7. Write a query to display carton id, (len*width*height) as carton_vol and identify
--  the optimum carton (carton with the least volume whose volume is greater than the total 
--  volume of all items (len * width * height * product_quantity)) for a given order whose order
--  id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW)
--  [NOTE: CARTON TABLE]


-- solution 

select carton_id  , 
	  (len*Width* height) as carton_vol 
from carton 
where (len*Width* height)  >= (select sum(product.len * product.width * product.height*order_items.PRODUCT_QUANTITY) as  Product_volume 
							  from product 
							  join order_items on order_items.PRODUCT_ID = product.PRODUCT_ID
							  where order_id = 10006
							  group by order_items.order_id)
order by carton_vol asc 
limit 1 ; 


-- 8. Write a query to display details (customer id,customer fullname,order id,product quantity)
--  of customers who bought more than ten (i.e. total order qty) products per shipped order.
--  (11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]


-- solution 


select online_customer.customer_id , 
		concat(ONLINE_CUSTOMER.CUSTOMER_FNAME , " " , ONLINE_CUSTOMER.CUSTOMER_LNAME) as Customer_FullName  ,
		order_header.order_id , 
        sum(order_items.product_quantity) as Total_Quantity 
from online_customer
        join ORDER_HEADER on ORDER_HEADER.CUSTOMER_ID = ONLINE_CUSTOMER.CUSTOMER_ID
        join ORDER_ITEMS on ORDER_ITEMS.ORDER_ID = ORDER_HEADER.ORDER_ID
where  order_header.order_status = "shipped"
group by order_items.order_id
having sum(order_items.product_quantity) > 10 ;
        
        
      

-- 9. Write a query to display the order_id, customer id and customer full name of customers along with 
-- (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) 
-- [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]


-- solution 


select online_customer.customer_id , 
		concat(ONLINE_CUSTOMER.CUSTOMER_FNAME , " " , ONLINE_CUSTOMER.CUSTOMER_LNAME) as Customer_FullName  ,
		order_header.order_id , 
        sum(order_items.product_quantity) as Total_Quantity 
from online_customer
        join ORDER_HEADER on ORDER_HEADER.CUSTOMER_ID = ONLINE_CUSTOMER.CUSTOMER_ID
        join ORDER_ITEMS on ORDER_ITEMS.ORDER_ID = ORDER_HEADER.ORDER_ID
where  order_header.order_status = "shipped"
group by order_items.order_id
having  order_header.order_id > 10060 ;




-- 10. Write a query to display product calss  description ,total quantity (sum(product_quantity),
-- Total value (product_quantity * product price) and show which class of products have been shipped
--  highest(Quantity) to countries outside India other than USA? Also show the total value of those 
--  items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS 
--  TABLE,PRODUCT_CLASS TABLE]


-- solution 


select PRODUCT_CLASS.product_class_desc,
		sum(order_items.product_quantity) as Total_Quantity , 
        sum(order_items.product_quantity * product.product_price)as Total_Value
from online_customer
        join ADDRESS on ONLINE_CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
		join ORDER_HEADER on ORDER_HEADER.CUSTOMER_ID = ONLINE_CUSTOMER.CUSTOMER_ID
		join ORDER_ITEMS on ORDER_ITEMS.ORDER_ID = ORDER_HEADER.ORDER_ID
		join PRODUCT on product.PRODUCT_ID = ORDER_ITEMS.PRODUCT_ID
		join PRODUCT_CLASS on product.PRODUCT_CLASS_CODE = PRODUCT_CLASS.PRODUCT_CLASS_CODE
where country not in ('india' , 'USA') 
group by PRODUCT_CLASS.PRODUCT_CLASS_CODE
order by Total_Quantity desc 
limit 1  ; 
 
 