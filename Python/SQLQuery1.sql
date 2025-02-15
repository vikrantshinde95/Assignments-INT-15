use biz;

-- Create the employees table
CREATE TABLE employees (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100),
    mobile NVARCHAR(20),
    address NVARCHAR(200)
);

-- Create the dummy leaves table for leave applications
CREATE TABLE dummy_leaves1 (
    id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT,
    leave_type NVARCHAR(50),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);
GO

-- Create the leaves table for approved leaves
CREATE TABLE leaves (
    id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT,
    leave_type NVARCHAR(50),
    start_date DATE,
    end_date DATE,
    status NVARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);
GO
