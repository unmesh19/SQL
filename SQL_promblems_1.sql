-- Q1 Given two tables, Person (with personId, firstName, and lastName) and Address 
-- (with personId, city, and state), write a SQL query to retrieve the firstName, lastName, 
-- city, and state for each person, showing NULL for city and state if a person has no 
-- corresponding address.

SELECT p.firstName, p.lastName, a.city, a.state 
FROM Person p
LEFT JOIN Address a
ON p.personId = a.personId;

-- Q2 You are given a dataset containing information about employees, including their 
-- id, name, salary, and the managerId (which represents the ID of their manager). 
-- Write a SQL query to find the employees who earn more than their respective managers.

SELECT e.name AS Employee
FROM Employee e
JOIN Employee m
ON e.managerId = m.id
WHERE e.salary > m.salary;

-- Q3 You are given a table Person with columns id and email. Write a SQL query to find 
-- all the duplicate emails in the dataset.

SELECT email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;

-- Q4 You are given two tables, Customers (with id and name) and Orders (with id and 
-- customerId). Write a SQL query to find all customers who have never placed an order.

SELECT c.name AS Customer
from Customers c
WHERE c.id NOT IN (SELECT o.customerid FROM Orders o);

-- Q5 Given a table named Customer that includes the columns id (the primary key), 
-- name, and referee_id (the ID of the customer who referred them), write a SQL query 
-- to find the names of customers who are not referred by the customer with id = 2.

SELECT name
FROM Customer
WHERE id NOT IN
(SELECT id
FROM Customer
WHERE referee_id = 2);