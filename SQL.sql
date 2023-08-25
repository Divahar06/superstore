create database superstore;
use superstore;

create table orders (
    row_id INT,
    order_id VARCHAR(255),
    order_date VARCHAR(255),
    ship_date VARCHAR(255),
    ship_mode VARCHAR(255),
    customer_id VARCHAR(255),
    customer_name VARCHAR(255),
    segment VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postal_code VARCHAR(20),
    region VARCHAR(255),
    product_id VARCHAR(255),
    category VARCHAR(255),
    sub_category VARCHAR(255),
    product_name VARCHAR(255),
    sales DECIMAL(10, 5),
    quantity INT,
    discount DECIMAL(10, 2),
    profit DECIMAL(10, 5)
);

create table returns (
    returned VARCHAR(255),
    order_id VARCHAR(255)
);

create table people (
    person VARCHAR(255),
    region VARCHAR(255)
);

select * from orders;
select * from people;
select * from returns;

--- Q- To Find city wise sales and profit ----
select city, round(avg(sales),2) as avg_sales, round(avg(profit),2)as avg_profit 
from orders
group by city
order by city;

--- Q- To Find the max sales based on segment wise----
select segment, round(max(sales),2) as max_Sales , round(max(discount),2)as max_Discount,  round(max(profit),2)as max_Profit from orders
group by segment;


--- Q- To Find city wise top 3 sales ----
select city,sales 
from(
	select 
		city, 
        sales,
        rank() over (partition by city order by sales desc ) as rank_sales
	from orders
)ranked_sales	
where rank_sales <= 3;



select count(*) from orders 
where customer_name in ("Anna Andreadi",
"Chuck Magee",
"Kelly Williams",
"Cassandra Brandow");


--- Q- To creata a new table  as returned_list based on returned column in returns w.t.o orders table  ----
create table returned_list as 
select o.*,r.returned from orders as o
join returns as r on o.order_id = r.order_id;


--- Q- to view infomation about the retuned in orders list w.r.t people and returns table   ----
select o.*,r.returned from orders as o
join returns as r on o.order_id = r.order_id
join people as p on p.person= o.customer_name;


------ to check the previous result we can use the bellow query and compare the results ----
select * from returned_list
where customer_name in  ("Anna Andreadi",
"Chuck Magee",
"Kelly Williams",
"Cassandra Brandow");



----------- create stored procedure-orders table ---------------
delimiter //

create procedure create_orders_table()
begin 
	create table orders (
    row_id INT,
    order_id VARCHAR(255),
    order_date VARCHAR(255),
    ship_date VARCHAR(255),
    ship_mode VARCHAR(255),
    customer_id VARCHAR(255),
    customer_name VARCHAR(255),
    segment VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postal_code VARCHAR(20),
    region VARCHAR(255),
    product_id VARCHAR(255),
    category VARCHAR(255),
    sub_category VARCHAR(255),
    product_name VARCHAR(255),
    sales DECIMAL(10, 5),
    quantity INT,
    discount DECIMAL(10, 2),
    profit DECIMAL(10, 5)
 );
 end //
 
 delimiter ;
 
 
----------- create stored procedure-people table ---------------
delimiter //

create procedure create_people_table()
begin 
	create table people (
    person VARCHAR(255),
    region VARCHAR(255)
);
 end //
 
 delimiter ;
 
 ----------- create stored procedure-returns table ---------------
delimiter //

create procedure create_returns_table()
begin 
	create table returns (
		returned VARCHAR(255),
		order_id VARCHAR(255)
	);
 end //
 
 delimiter ;
 
 

----------- create stored procedure-city wise sales,profit ---------------
delimiter //

create procedure city_wise_values()
begin 
	select city, round(avg(sales),2) as avg_sales, round(avg(profit),2)as avg_profit 
	from orders
	group by city
	order by city;
end //
 
 delimiter ;
 
 
 
 ----------- create stored procedure-segment wise values  ---------------
delimiter //

create procedure segment_wise_values()
begin 
	select segment, round(max(sales),2) as max_Sales , round(max(discount),2)as max_Discount,  round(max(profit),2)as max_Profit from orders
	group by segment;
end //
 
 delimiter ;
 
 
  ----------- create stored procedure-city wise top 3 sales  ---------------
delimiter //

create procedure city_top_3_Sales()
begin 
		select city,sales 
	from(
		select 
			city, 
			sales,
			rank() over (partition by city order by sales desc ) as rank_sales
		from orders
	)ranked_sales	
	where rank_sales <= 3;

end //
 
 delimiter ;
 
 
   ----------- create stored procedure-returned items list  ---------------
delimiter //

create procedure returned_items()
begin 
	create table returned_list as 
	select o.*,r.returned from orders as o
	join returns as r on o.order_id = r.order_id;

end //
 
 delimiter ;
 



---  to call the created stored procedure ---------- 

call city_wise_values();

call city_top_3_Sales();


call segment_wise_values();




