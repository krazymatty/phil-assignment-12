-- drop database `pizza_shop`;

create database `pizza_shop`;
use `pizza_shop`;

create table `pizza_shop`.`customers` (
  `id` bigint not null auto_increment,
  `name` varchar(100) not null,
  `phone` varchar(15) not null unique,
  primary key (`id`));

create table `pizza_shop`.`pizzas` (
  `id` bigint not null auto_increment,
  `name` varchar(50) not null,
  `price` decimal(15,2) not null,
  primary key (`id`));

create table `pizza_shop`.`orders` (
  `id` bigint not null auto_increment,
  `customer_id` bigint not null,
  `order_date` datetime not null,
  `total_price` decimal(15,2) not null,
  primary key (`id`),
  foreign key (`customer_id`)
  references `pizza_shop`.`customers` (`id`));

create table `pizza_shop`.`order_items` (
  `id` bigint not null auto_increment,
  `order_id` bigint not null,
  `pizza_id` bigint not null,
  `quantity` int not null,
  primary key (`id`),
  foreign key (`order_id`)
  references `pizza_shop`.`orders` (`id`),
  foreign key (`pizza_id`)
  references `pizza_shop`.`pizzas` (`id`));

-- Populating Database with customers, menu, orders, and pizza_orders\
-- Populating Menu
insert into `pizza_shop`. `pizzas` (name, price) values ('pepperoni & cheese', 7.99);
insert into  `pizza_shop`. `pizzas` (name, price) values ('meat lovers', 14.99);  
insert into  `pizza_shop`. `pizzas` (name, price) values ('vegerarian', 9.99);  
insert into  `pizza_shop`. `pizzas` (name, price) values ('hawaiian', 12.99);    

-- inserting customer
insert into  `pizza_shop`. `customers` (name, phone) 
	values ('trevor page', '226-555-4982') on duplicate key update name = name;

-- inserting pizza order
set @customer_id = (select id from `pizza_shop`.`customers` where `phone` = '226-555-4982');
insert into  `pizza_shop`.`orders` (`customer_id`, `order_date`, `total_price`) 
	values (@customer_id, '2014-10-09 09:47:00', 0);

-- add pizzas to order
set @order_id = (select `id` from `pizza_shop`.`orders` where `customer_id` = @customer_id and `order_date` =  '2014-10-09 09:47:00');
insert into  `pizza_shop`.`order_items` (`order_id`, `pizza_id`, `quantity`) values (@customer_id, 1, 1);
insert into  `pizza_shop`.`order_items` (`order_id`, `pizza_id`, `quantity`) values (@customer_id, 2, 1);

update `pizza_shop`.`orders` 
	set `total_price` = (select sum(pizzas.price * order_items.quantity) 
    from `pizza_shop`.`order_items` 
    join pizzas on order_items.pizza_id = pizzas.id 
    where order_items.order_id = @order_id) 
    where `id` = @customer_id;
    
-- inserting customer
insert into  `pizza_shop`. `customers` (name, phone) 
	values ('john doe', '555-555-9498') on duplicate key update name = name;
    
set @customer_id = (select `id` from `pizza_shop`.`customers` where `phone` = '555-555-9498');
insert into  `pizza_shop`.`orders` (`customer_id`, `order_date`, `total_price`) 
	values (@customer_id, '2014-10-09 01:20:00', 0);

-- add pizzas to order
set @order_id = (select `id` from `pizza_shop`.`orders` where `customer_id` = @customer_id and `order_date` = '2014-10-09 01:20:00');
insert into  `pizza_shop`.`order_items` (`order_id`, `pizza_id`, `quantity`) values (@order_id, 3, 1);
insert into  `pizza_shop`.`order_items` (`order_id`, `pizza_id`, `quantity`) values (@order_id, 2, 2);

update `pizza_shop`.`orders` 
	set `total_price` = (select sum(pizzas.price * order_items.quantity) 
    from `pizza_shop`.`order_items` 
    join pizzas on order_items.pizza_id = pizzas.id where order_items.order_id = @customer_id) 
    where `id` = @customer_id;

-- inserting customer
insert into  `pizza_shop`. `customers` (name, phone) 
	values ('trevor page', '226-555-4982') on duplicate key update name = name;

-- inserting pizza order
set @customer_id = (select id from `pizza_shop`.`customers` where `phone` = '226-555-4982');
insert into  `pizza_shop`.`orders` (`customer_id`, `order_date`, `total_price`) 
	values (@customer_id, '2014-10-09 21:47:00', 0);

-- add pizzas to order  
set @order_id = (select `id` from `pizza_shop`.`orders` where `customer_id` = @customer_id and `order_date` ='2014-10-09 21:47:00');
insert into  `pizza_shop`.`order_items` (`order_id`, `pizza_id`, `quantity`) values (@order_id, 2, 1);
insert into  `pizza_shop`.`order_items` (`order_id`, `pizza_id`, `quantity`) values (@order_id, 4, 1);

update `pizza_shop`.`orders` set `total_price` = (select sum(pizzas.price * order_items.quantity) 
	from `pizza_shop`.`order_items` 
	join pizzas on order_items.pizza_id = pizzas.id 
	where order_items.order_id = @customer_id) 
    where `id` = @order_id;

-- Query 4
select customers.name, sum(orders.total_price) as 'total spent'
	from `pizza_shop`.`customers`
	join `pizza_shop`.`orders` on customers.id = orders.customer_id
	group by customers.name;

-- Query 5
select `pizza_shop`.customers.name, 
	date(orders.order_date) as 'order date', sum(orders.total_price) as 'total spent'
	from `pizza_shop`.`customers`
	join `pizza_shop`.`orders` 
    on customers.id = orders.customer_id
	group by customers.name, 
    date(orders.order_date);

-- Extra Query includes phone number
select `pizza_shop`.customers.name, customers.phone, sum(orders.total_price) as 'total spent'
	from `pizza_shop`.`customers`
	join `pizza_shop`.`orders` on customers.id = orders.customer_id
	group by customers.name, customers.phone;

-- Extra Query include date plus time    
select customers.name, 
	date(orders.order_date) as 'order date', 
    time(orders.order_date) as 'order time', sum(orders.total_price) as 'total spent'
	from `pizza_shop`.`customers`
	join `pizza_shop`.`orders` on customers.id = orders.customer_id
	group by customers.name, 
    date(orders.order_date), time(orders.order_date);

-- select * from `pizza_shop`. `pizzas`;
-- select * from `pizza_shop`. `order_items`;
-- select * from `pizza_shop`. `orders`;

-- insert into `pizza_shop`. `order_items` (order_id, pizza_id, qty) values (1,1,1);
-- insert into `pizza_shop`. `order_items` (order_id, pizza_id, qty) values (1,2,1);
-- insert into `pizza_shop`. `customer_pizza` (customer_id, pizza_id) values (1, 1);
-- insert into `pizza_shop`. `customer_pizza` (customer_id, pizza_id) values (1, 2);

