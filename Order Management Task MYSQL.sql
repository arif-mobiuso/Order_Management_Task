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
limit 1



 
 