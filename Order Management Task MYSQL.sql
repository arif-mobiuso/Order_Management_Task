-- 7. Write a query to display carton id, (len*width*height) as carton_vol and identify
--  the optimum carton (carton with the least volume whose volume is greater than the total 
--  volume of all items (len * width * height * product_quantity)) for a given order whose order
--  id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW)
--  [NOTE: CARTON TABLE]


-- solution 

select carton_id  , 
	  (len*Width* height) as carton_vol 
from carton 
where (len*Width* height)  > (select sum(product.len * product.width * product.height*order_items.PRODUCT_QUANTITY) as  Product_volume 
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

 
 