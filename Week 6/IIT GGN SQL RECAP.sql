CREATE DATABASE retail_analytics;

USE retail_analytics;


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    status VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),

    PRIMARY KEY (order_id, product_id),

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10,2),
    payment_status VARCHAR(30),

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);

INSERT INTO Customers VALUES
(1, 'Amit', 'Jaipur', '2023-01-10'),
(2, 'Neha', 'Delhi', '2023-02-15'),
(3, 'Rahul', 'Jaipur', '2023-03-20'),
(4, 'Priya', 'Mumbai', '2023-04-10'),
(5, 'Karan', 'Delhi', '2023-05-12'),
(6, 'Sneha', 'Mumbai', '2023-06-18'),
(7, 'Vikas', 'Jaipur', '2023-07-21'),
(8, 'Anjali', 'Delhi', '2023-08-05'),
(9, 'Rohit', 'Mumbai', '2023-09-11'),
(10, 'Pooja', 'Jaipur', '2023-10-15');

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Mobile', 'Electronics'),
(103, 'Headphones', 'Electronics'),
(104, 'Shirt', 'Fashion'),
(105, 'Jeans', 'Fashion'),
(106, 'Shoes', 'Fashion'),
(107, 'Sofa', 'Home'),
(108, 'Table', 'Home'),
(109, 'Face Cream', 'Beauty'),
(110, 'Perfume', 'Beauty');

INSERT INTO Orders VALUES
(1001, 1, '2024-01-05', 50000, 'Completed'),
(1002, 1, '2024-02-10', 15000, 'Completed'),
(1003, 1, '2024-03-15', 25000, 'Completed'),
(1004, 2, '2024-01-12', 10000, 'Completed'),
(1005, 2, '2024-02-18', 20000, 'Completed'),
(1006, 3, '2024-01-20', 30000, 'Completed'),
(1007, 3, '2024-03-22', 45000, 'Completed'),
(1008, 4, '2024-02-05', 12000, 'Completed'),
(1009, 4, '2024-03-10', 18000, 'Completed'),
(1010, 5, '2024-01-25', 8000, 'Completed'),
(1011, 5, '2024-02-25', 12000, 'Completed'),
(1012, 6, '2024-03-05', 22000, 'Completed'),
(1013, 7, '2024-01-08', 15000, 'Completed'),
(1014, 7, '2024-02-08', 18000, 'Completed'),
(1015, 8, '2024-03-12', 9000, 'Completed'),
(1016, 9, '2024-01-15', 35000, 'Completed'),
(1017, 9, '2024-02-15', 40000, 'Completed'),
(1018, 10, '2024-03-20', 11000, 'Pending'),
(1019, 2, '2024-04-05', 25000, 'Completed'),
(1020, 3, '2024-04-10', 18000, 'Completed');

INSERT INTO Order_Items VALUES
(1001, 101, 1, 50000),
(1002, 102, 1, 15000),
(1003, 103, 2, 12500),
(1004, 104, 2, 5000),
(1005, 105, 2, 10000),
(1006, 101, 1, 30000),
(1007, 102, 1, 45000),
(1008, 104, 2, 6000),
(1009, 106, 2, 9000),
(1010, 105, 1, 8000),
(1011, 106, 1, 12000),
(1012, 107, 1, 22000),
(1013, 108, 1, 15000),
(1014, 107, 1, 18000),
(1015, 109, 3, 3000),
(1016, 101, 1, 35000),
(1017, 102, 1, 40000),
(1018, 110, 1, 11000),
(1019, 103, 2, 12500),
(1020, 104, 3, 6000);

INSERT INTO Payments VALUES
(1, 1001, '2024-01-05', 50000, 'Success'),
(2, 1002, '2024-02-10', 15000, 'Success'),
(3, 1003, '2024-03-15', 25000, 'Success'),
(4, 1004, '2024-01-12', 10000, 'Success'),
(5, 1005, '2024-02-18', 20000, 'Success'),
(6, 1006, '2024-01-20', 30000, 'Success'),
(7, 1007, '2024-03-22', 45000, 'Success'),
(8, 1008, '2024-02-05', 12000, 'Success'),
(9, 1009, '2024-03-10', 18000, 'Success'),
(10, 1010, '2024-01-25', 8000, 'Success'),
(11, 1011, '2024-02-25', 12000, 'Success'),
(12, 1012, '2024-03-05', 22000, 'Success'),
(13, 1013, '2024-01-08', 15000, 'Success'),
(14, 1014, '2024-02-08', 18000, 'Success'),
(15, 1015, '2024-03-12', 9000, 'Success'),
(16, 1016, '2024-01-15', 35000, 'Success'),
(17, 1017, '2024-02-15', 40000, 'Failed'),
(18, 1018, '2024-03-20', 11000, 'Pending'),
(19, 1019, '2024-04-05', 20000, 'Success'),
(20, 1019, '2024-04-06', 5000, 'Success'),
(21, 1020, '2024-04-10', 18000, 'Success');


show tables;
desc customers;

select * from customers limit 2;

# Best in class
# which customers have order amount more than 
# avg order amount

select avg(amount) from orders; -- 21900

select customer_id,avg(amount) from orders 
group by customer_id;

# which orders have amount value more than 
# avg order amount value
select avg(amount) from orders; -- 21900

select * from orders where amount > 
(select avg(amount) from orders);

select * from orders limit 10;

# which orders have order amount more than avg order amount 
#in their resp cities

with cte as (
select order_id,city,amount
from customers join orders 
on customers.customer_id=orders.customer_id),
city_avg_amount as 
(select city, avg(amount) as avg_amount from cte group by city)
select * from 
cte join city_avg_amount on cte.city=city_avg_amount.city
where amount > avg_amount;


select * from orders;
select * from customers;

select count(distinct) from orders;
with cte as (
select order_id,city,amount,
avg(amount) over (partition by city) as avg_amount
from customers join orders 
on customers.customer_id=orders.customer_id)
select * from cte
where amount > avg_amount;


with cte as (
select order_id,city,amount,order_date
from customers join orders 
on customers.customer_id=orders.customer_id)

select order_id,order_date,city,amount,
min(amount) over () as avg_amount,
sum(amount) over (order by order_date) as running_amount
-- avg(amount) over (partition by city) as avg_amount_city,
-- avg(amount) over (partition by city order by order_date) as runn_avg_amount
from cte;

# Find out moving average
select *,
avg(amount) over(rows between 3 preceding and 2 following)  as avg_amount from orders;

# Find out mom change in order amount in percentage terms
with cte as (
select month(order_date) as mon,sum(amount) as total_amount 
from orders group by 1)
select *, lag(total_amount) over(order by mon) as prev_am,
(total_amount - lag(total_amount) over(order by mon))*100/lag(total_amount) over(order by mon)  as mom
 from cte;

CREATE TABLE employees (
    emp_id       INT PRIMARY KEY,
    emp_name     VARCHAR(50) NOT NULL,
    designation  VARCHAR(40),
    department   VARCHAR(30),
    salary       INT,
    joining_date DATE,
    manager_id   INT
);

INSERT INTO employees VALUES
(1,  'Nisha',  'CEO',              'Leadership', 450000, '2015-04-01', NULL),
(2,  'Arjun',  'Analytics Head',   'Analytics',  180000, '2017-06-15', 1),
(3,  'Vikram', 'Sales Head',       'Sales',      160000, '2016-09-01', 1),
(4,  'Priya',  'Senior Analyst',   'Analytics',  195000, '2021-03-10', 2),
(5,  'Farhan', 'Analyst',          'Analytics',   90000, '2022-07-01', 2),
(6,  'Zoya',   'Sales Manager',    'Sales',      165000, '2019-01-20', 3),
(7,  'Rahul',  'Sales Executive',  'Sales',       70000, '2023-02-01', 6),
(8,  'Ananya', 'Key Account Exec', 'Sales',      172000, '2024-05-15', 6),
(9,  'Kiran',  'Data Engineer',    'Analytics',  185000, '2016-01-05', 2),
(10, 'Rakesh', 'Operations Head',  'Operations', 150000, '2018-02-01', NULL),
(11, 'Sneha',  'Ops Manager',      'Operations', 158000, '2020-11-11', 10);

select employees.emp_name,employees.salary as em_sal,
 manager.salary as m_sal,manager.emp_name as man_name
 from employees 
left join employees as manager
on employees.manager_id=manager.emp_id
where employees.salary  >  manager.salary;

select * from orders;
with cte as 
(select *,
ntile(4) over (order by order_amount) as grp
from orders)
select grp, min(order_amount),max(order_amount)
from cte group by 1
;



