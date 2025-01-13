CREATE DATABASE sm;
USE sm;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    shipping_address TEXT
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    stock_quantity INT
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_at_time_of_order DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers (first_name, last_name, email, phone_number, shipping_address)
VALUES ('John', 'Doe', 'johndoe@example.com', '123-456-7890', '123 Main St, City, Country');

INSERT INTO Products (name, description, price, stock_quantity)
VALUES ('Laptop', 'High-performance laptop', 999.99, 100),
       ('Smartphone', 'Latest model smartphone', 799.99, 150);

INSERT INTO Orders (customer_id, status)
VALUES (1, 'Pending');

INSERT INTO Order_Items (order_id, product_id, quantity, price_at_time_of_order)
VALUES (1, 1, 1, 999.99),  -- Order 1: 1 Laptop
       (1, 2, 1, 799.99);  -- Order 1: 1 Smartphone

INSERT INTO Payments (order_id, payment_amount, payment_method, payment_status)
VALUES (1, 1799.98, 'Credit Card', 'Completed');

SELECT o.order_id, o.order_date, o.status, 
       p.name AS product_name, oi.quantity, oi.price_at_time_of_order
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.customer_id = 1;

UPDATE Orders
SET status = 'Shipped'
WHERE order_id = 1;

UPDATE Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 1;

SELECT SUM(p.payment_amount) AS total_sales
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
WHERE o.order_date BETWEEN '2025-01-01' AND '2025-01-31';

SELECT o.order_id, 
       o.order_date, 
       c.first_name, 
       c.last_name, 
       SUM(oi.quantity * oi.price_at_time_of_order) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
WHERE o.status = 'Pending'
GROUP BY o.order_id, o.order_date, c.first_name, c.last_name;

