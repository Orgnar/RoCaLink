USE RoCALink

UPDATE Bike_details
SET bikeName = CONCAT('S', bikeName)
WHERE bikeTypeID = 'BT005' OR
brandID = 'BR002' OR groupsetID = 'GR010'

UPDATE Transaction_table 
SET TransactionDate = '2021-07-02'
WHERE TransactionID = 'TR004'

UPDATE Transaction_table
SET TransactionDate = '2019 - 09-24'
WHERE TransactionID = 'TR002'

UPDATE Transaction_table
SET TransactionDate = '2019 - 10-30'
WHERE TransactionID = 'TR005'

UPDATE Bike_details
SET bikePrice = 200000000
WHERE groupsetID = 'GR003'

UPDATE Bike_details
SET bikePrice = 180000000
WHERE groupsetID = 'GR010'


UPDATE Bike_details
SET bikePrice = 120000000
WHERE bikeID = 'BK003'

--1 Display CustomerID, CustomerName, Total Item Variety (obtained from total varieties of bike in transaction and ends with 'Types') for every male customer whose name starts with 'A'.
SELECT
cd.CustomerID,
cd.[name] AS CustomerName,
[Total Item Variety]= CONCAT( CAST( COUNT(bt.bikeTypeID) as VARCHAR(255)), ' Types' )
FROM customer_Detail  cd
JOIN Transaction_table tt ON cd.CustomerID = tt.customerID
JOIN transaction_details td on tt.TransactionID = td.TransactionID
JOIN Bike_details bd ON td.bikeID = bd.bikeID
JOIN bike_type bt ON bd.biketypeID = bt.biketypeID
WHERE cd.[name] LIKE ('A%')
GROUP BY cd.customerID,cd.[name] 

-- 2 Display BikeTypeName, BikeTypeID, And Bike Count (obtained from total bikes that has that groupset), for every bike that has a groupset which name starts with 'Shimano' and has number of gears between 7 and 12.
    
SELECT *
FROM Bike_Groupset

SELECT *
FROM bike_type

SELECT bt.typeName, bd.bikeTypeID, [Bike Count] = COUNT(bd.bikeID)
FROM Bike_details bd
JOIN bike_type bt
ON bd.bikeTypeID = bt.bikeTypeID
JOIN Bike_Groupset bg
ON bg.groupsetID = bd.groupsetID
WHERE bg.[name] LIKE ('Shimano%') AND bg.numberOfGear BETWEEN 7 AND 12
GROUP BY bt.typeName, bd.bikeTypeID

-- 3 Display StaffID, StaffName, Number of Transactions (obtained from total number of different bike sold in one transaction) and Number of Bikes Sold (obtained from total number of bikes sold by staff, and end with ' Bikes') for every staff whose gender is Female and has a name between 5 and 10 characters long.
SELECT T.StaffID, ST.[name], [Number Of Transaction] =  COUNT (TT.BikeID),CONCAT ( CAST(SUM(TT.quantity) as VARCHAR(255)), ' bikes') AS [Number of bikes sold]
FROM Staff_Table ST
join Transaction_table T
ON T.StaffID = ST.StaffID
join Transaction_details TT
ON TT.TransactionID = T.TransactionID
WHERE LEN (ST.[name]) Between 5 AND 10 AND ST.gender = 'Female'
GROUP BY T.StaffID, ST.[name]


-- 4 Display GroupsetID, GroupsetName, Bike Count (obtained from total number of bikes with that groupset), and Average Price (obtained from average price of bikes with that groupset, using rupiah money format) for every bike that has a brand that starts with 'C', and has an average price of more than 150000000.

Select bg.groupsetID, bg.[name],
[Bike Count] = COUNT(bd.bikeID),[Average Price] = 
CONCAT('Rp. ', CAST( AVG(bd.bikePrice) as VARCHAR(255) ))
FROM Bike_Groupset bg
JOIN Bike_details bd 
ON bd.groupsetID = bg.groupsetID
JOIN Bike_brandset bb
ON bd.brandID = bb.brandID
WHERE bb.brandName like 'C%'
GROUP BY bg.groupsetID, bg.[name]
HAVING AVG(bd.bikePrice) > 150000000

-- 5 Display all TransactionID, CustomerName, StaffName, and Transaction Day (obtained from the day name of the transaction date) for every transaction made by staff that has above average salary and was done in February. (alias subquery)

SELECT TransactionID,(cd.[name])[Customer Name],(st.[name]) [Staff Name],[Transaction Day] = DATENAME(WEEKDAY,tt.TransactionDate) 
FROM Customer_Detail cd
JOIN Transaction_table tt ON cd.CustomerID = tt.customerID
JOIN staff_table st ON tt.staffID = st.staffID
WHERE st.salary > (
SELECT AVG(st.salary)
FROM staff_table st
) 
AND MONTH(tt.transactionDate) = 2

-- 6 Display StaffName, BikeName, TransactionID, Transaction Month (obtained from the month name of the transaction date) for every transaction that has a transaction quantity more than the maximum of all the transaction quantity from all transactions made at the 12th day of the month. (alias subquery)

SELECT [StaffName] = st.[name], bikeName, tt.TransactionID, [Transaction Month] = DATENAME(MONTH,TransactionDate)
FROM Staff_Table st
JOIN Transaction_table tt
ON  st.StaffID = tt.StaffID
JOIN Transaction_details td
ON tt. TransactionID = td.TransactionID
JOIN Bike_details bd
ON bd.bikeID = td.BikeID, 
(
    SELECT [MaxQuantity] = MAX(Quantity)
    FROM Transaction_details td2
    JOIN Transaction_table tt2
    ON tt2.TransactionID = td2.TransactionID
    WHERE DAY(tt2.TransactionDate) = 12 
)As First12Day
WHERE Quantity > First12Day.MaxQuantity

--7 Display Average Bikes Sold (obtained from average of total number of bikes sold and ends with ' Bikes'), for every bike that is priced between 100000000 and 150000000 which is not sold over a year ago. (alias subquery)

SELECT [Average Bikes Sold] = AVG(subTotal.[Total Bike])
FROM( Select bd.bikeID, [Total Bike] = COUNT(BD.bikeID)
FROM Bike_details BD
join Transaction_details TD
ON TD.BikeID = BD.bikeID
JOIN Transaction_table TT
ON TD.TransactionID = TT.TransactionID
WHERE BD.bikePrice Between 100000000 and 150000000 AND DATEDIFF(YEAR, TT.TransactionDate, CONVERT(date, GETDATE(), 23)) < 1
GROUP BY BD.bikeID
) as subTotal



-- 8 Display Max Bikes Purchased (obtained from max of total quantity of bikes and ends with ' Bikes') for every bike that has name starts with 'S' and are bought between July and December. (alias subquery)

SELECT [Max Bikes Purchased] = MAX(subTotal.[total quantity])
FROM( SELECT bd.bikeName, [total quantity] = COUNT(td.BikeID)
FROM Bike_details bd
JOIN Transaction_details td
ON bd.bikeID = td.BikeID
JOIN Transaction_table tt
ON tt.TransactionID = td.TransactionID
WHERE bd.bikeName like 'S%'
AND MONTH(tt.TransactionDate) BETWEEN 7 AND 12
GROUP BY bd.bikeName
) as subTotal

-- 9 Create a view named CustomerView that display CustomerName, Total Transactions (obtained from total number of different bike bought by customer), Total Bikes Bought (obtained from total quantity of bikes bought by customer from all transactions), and Customer Phone (obtained by replacing 0 in front of the phone number with '+62'), for every customer that has made between 2 and 5 transactions and has bought more than 5 bikes.
    
CREATE VIEW CustomerView 
AS
SELECT 
    cd.[name],
    COUNT(td.bikeID) as [Total Transactions],
    SUM(td.quantity) as [Total Bikes Bought],
    STUFF(cd.phoneNumber,1,1,'+62') AS [Customer Phone]
FROM Customer_Detail cd
JOIN Transaction_table tt ON cd.CustomerID = tt.CustomerID
JOIN Transaction_details td on tt.TransactionID = td.TransactionID
GROUP BY 
    cd.[name],
    cd.phoneNumber
HAVING 
    COUNT(tt.TransactionID) BETWEEN 2 AND 5 
    AND
    SUM(td.Quantity) > 5

-- 10 Create a view named TransactionView that display TransactionID, Max Quantity (obtained from the maximum quantity of bikes bought in that transaction), Min Quantity (obtained from the minimum quantity of bikes bought in that transaction), and Days Elapsed (obtained from the number of days that has passed since the transaction was made), for every transaction where Max Quantity is not equals Min Quantity and is made by male staff.
CREATE VIEW TransactionView
AS
SELECT
    tt.TransactionID,
    MAX(td.quantity) as [Max Quantity],
    MIN(td.quantity) as [Min Quantity],
    DATEDIFF(DAY,tt.TransactionDate,GETDATE()) as [Days Elapsed]
FROM Transaction_table tt
JOIN Transaction_details td ON td.TransactionID = tt.TransactionID
JOIN Staff_Table ST ON tt.StaffID = st.staffID
WHERE st.gender LIKE 'Male'
GROUP BY tt.TransactionID,st.Gender,tt.TransactionDate
HAVING MAX(td.Quantity) != MIN(td.quantity)


