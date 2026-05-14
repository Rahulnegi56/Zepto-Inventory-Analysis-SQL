Create database zepto_inventory;
DROP DATABASE IF EXISTS zepto;
use zepto_inventory;
drop table zepto;
create table zepto(
Category varchar(120),
name varchar(150),
mrp numeric,
discountPercent numeric(10,2),
availableQuantity integer,
discountedSellingPrice numeric(3,2),
weightInGms integer,
outOfStock boolean,
quantity integer);
alter table zepto
modify discountedSellingPrice numeric(10,2);
alter table zepto
modify outOfStock varchar(10);

select count(*) from zepto;

-- DATA EXPLORATION
select * from zepto 
limit 10;

--- finding null values

select*from zepto
where name is null
or category is null
or mrp is null
or discountpercent is null
or availableQuantity is null
or discountedSellingPrice is null
or weightInGms is null
or outOfStock is null
or quantity is null;

-- different product categories

select distinct(category), count(*) from zepto
group by category;

-- product in stock vs outofsock

select * from zepto 
where outOfStock = 'True';

-- product name present multiple time

select name, count(*) as count
from zepto 
group by name
having count >1
order by count desc;

-- data cleaning 

-- product have price zero

select *from zepto 
where mrp = 0 or discountedSellingPrice = 0;

delete from zepto 
where mrp = 0;

-- convert paisa into ruppee

update zepto 
set mrp =mrp/100,
discountedSellingPrice = discountedSellingPrice/100;

select*from zepto;

-- Data analysis 

-- Find the top 10 best-value products based on the discount percentage.

select distinct(name), discountPercent from zepto 
order by discountPercent desc
limit  10;

-- What are the products with high MRP but out of stock?

select distinct(name) , mrp ,outOfStock
from zepto
where outOfStock = 'True' 
and mrp >300
order by Mrp desc
limit 2;

-- Calculate estimated revenue for each category.

select category , sum(discountedSellingPrice* availableQuantity) as total_sales
from zepto 
group by category
order by total_sales desc;

-- Find all products where MRP is greater than ₹500 and discount is less than 10%.

select distinct(name), Mrp, discountpercent
from zepto 
where mrp >500 and 
discountPercent <10;

-- Identify the top 5 categories offering the highest average discount percentage.

select distinct(category),round(avg(discountPercent),2) as avg_discount
from zepto 
group by category
order by avg_discount desc
limit 5;

-- Find the price per gram for products above 100g and sort by best value.

select distinct(name),weightInGms, round((discountedSellingPrice/weightInGms),2) as gram
from zepto 
where  weightInGms >100
order by gram desc
limit 1;

-- Group the products into categories like Low, Medium, Bulk.
select * from zepto;

select distinct(name), quantity,
case
when quantity <=100 then 'Low'
when quantity <=250  then 'Medium'
else 'Bulk'
end as Quantity_category
from zepto;

-- What is the total inventory weight per category?

select category , sum(weightInGms* availableQuantity) as total_inventory_weight
from zepto
group by category;