create database  online_learning_db;
use online_learning_db;

create table Learners(
learner_id int  primary key,
full_name varchar(100) not null,
country varchar(50) not null
);

create table Courses(
course_id int  primary key,
course_name varchar(50)not null,
category varchar(50) not null,
unit_price decimal (10,2) not null
);


create table Purchases(
purchase_id int primary key,
learner_id int,
course_id int,
quantity int not null,
purchase_date date  not null,

foreign key (learner_id) references learners(learner_id),
foreign key (course_id) references courses(course_id)
);

insert into Learners(learner_id, full_name, country)
values
(1, 'Jothi Bala', 'India'),
(2, 'Angel Christina', 'USA'),
(3, 'Bala Niranjan', 'Malaysia'),
(4, 'Zara Khan', 'UK'),
(5, 'Vishwesh Naren', 'Singapore'),
(6, 'George Thomas', 'Australia'),
(7, 'Priya Sharma', 'India'),
(8, 'Abraham Lincoln', 'USA'),
(9, 'Michael Smith', 'Canada'),
(10, 'Diana Joseph', 'France');


insert into Courses(course_id, course_name, category, unit_price)
values
(101, 'Python for Beginners', 'Programming', 4000.00),
(102, 'SQL & Data Analytics', 'Data Science', 6000.00),
(103, 'Digital Marketing', 'Marketing', 2000.00),
(104, 'Advanced Excel', 'Data Science', 3000.00),
(105, 'UI/UX Design Basics', 'Design', 4500.00),
(106, 'Full Stack Web Development', 'Programming', 8000.00),
(107, 'Business Communication', 'Business', 1500.00),
(108, 'Machine Learning Basics', 'Data Science', 5000.00);


insert into Purchases(purchase_id, learner_id, course_id, Quantity, purchase_date)
values
(1001, 1, 101, 1, '2026-01-10'),
(1002, 1, 102, 1, '2026-01-15'),
(1003, 2, 103, 2, '2026-02-01'),
(1004, 3, 101, 1, '2026-02-05'),
(1005, 3, 105, 1, '2026-02-10'),
(1006, 4, 102, 1, '2026-02-12'),
(1007, 4, 104, 2, '2026-02-18'),
(1008, 5, 103, 1, '2026-02-20'),
(1009, 6, 106, 1, '2026-02-22'),
(1010, 7, 102, 2, '2026-02-25'),
(1011, 8, 101, 1, '2026-03-01'),
(1012, 10, 106, 1, '2026-03-03');


-- Combine learner, course, and purchase data. Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).
create view purchase_summary_view as
select l.full_name as learner_name, c.course_name, c.category, p.Quantity, (c.unit_price * p.Quantity) as total_amount, p.purchase_date
from purchases p
join learners  as l  
    on p.learner_id = l.learner_id
join courses as c 
     on p.course_id = c.course_id
order by total_amount desc;

select * from  purchase_summary_view ;


-- Display each learner’s total spending (quantity × unit_price) along with their country.
select  l.full_name as learner_name,l.Country,sum(p.Quantity * c.unit_price) as total_spending
from learners  as l
join purchases as p 
  on l.learner_id = p.learner_id
join courses as c 
  on p.course_id = c.course_id
group by  l.full_name, l.Country;



-- Find the top 3 most purchased courses based on total quantity sold
select c.course_name, sum(p.quantity) as total_quantity_sold
from courses as c
join purchases as p
on c.course_id = p.course_id
group by course_name
order by   total_quantity_sold desc
limit 3;



-- Show each course category’s total revenue and the number of unique learners who purchased from that category.
select
    c.category,SUM(p.Quantity * c.unit_price) as total_revenue,COUNT(distinct p.learner_id) as unique_learners_count
from courses c
inner join purchases p 
on c.course_id = p.course_id
group by  c.category
order by total_revenue desc;


--  List all learners who have purchased courses from more than one category.
select l.learner_id,  l.full_name as learner_name,count(distinct c.category) as distinct_categories_purchased
from learners as l
join purchases as p
on l.learner_id = p.learner_id
join courses as c
on p.course_id = c.course_id
group by l.learner_id, l.full_name
having distinct_categories_purchased >1;



-- Identify courses that have not been purchased at all.
select c.course_id,c.course_name,c.category,c.unit_price
from purchases as p 
 right join courses as c
on p.course_id = c.course_id
where p.purchase_id is null;












