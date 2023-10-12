-- For example Customer CU004 wants to buy 2 bikes BK003 and BK007 for each bike is 5 and 10 in today transaction. This was the 16th transaction

Insert Into Transaction_table VALUES
('TR016','CU004','ST008',CONVERT(date,GETDATE(),23))

INSERT INTO Transaction_details
VALUES 
('TR016','BK003',5),
('TR016','BK007',10)

-- For example Customer CU010 wants to buy 2 bikes BK001 and BK004 for each bike is 1 in today transaction. This was the 17th transaction

INSERT INTO Transaction_table
VALUES ('TR017','CU010', 'ST005', CONVERT(date, GETDATE(), 23))

INSERT INTO Transaction_details VALUES 
('TR017', 'BK001', 1),
('TR017', 'BK004', 1)

-- For example Customer CU002 wants to buy 3 bikes BK005, BK002, and BK004 for each bike is 2,1,1 in today transaction. This was the 18th transaction
Insert Into Transaction_table VALUES
('TR018','CU002','ST005',CONVERT(date,GETDATE(),23))

INSERT INTO Transaction_details
VALUES
('TR018','BK005',2),
('TR018','BK002',1),
('TR018','BK004',1)
