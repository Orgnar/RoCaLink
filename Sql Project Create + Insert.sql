create database RoCALink

use RoCALink

create table Staff_Table (
	StaffID char(5) primary key CHECK(StaffID like 'ST[0-9][0-9][0-9]') NOT NULL,
	[name] varchar(255) NOT NULL,
	Email varchar(255) NOT NULL,
	phoneNumber varchar(13) NOT NULL,
	gender varchar(7) NOT NULL,
	salary integer NOT NULL,

	CONSTRAINT staffName CHECK(LEN([name]) > 4),
	CONSTRAINT staffEmail CHECK(email like '%@rocalink.com'),
	CONSTRAINT staffPhone CHECK(phoneNumber like '08%'),
	CONSTRAINT staffGender CHECK(gender like 'Male' or gender like 'Female')
)

create table Customer_Detail (
	CustomerID char(5) primary key CHECK(CustomerID like 'CU[0-9][0-9][0-9]') NOT NULL,
	[name] varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	phoneNumber varchar(13) NOT NULL,
	gender varchar(7) NOT NULL,

	CONSTRAINT customerName CHECK(LEN([name]) > 4),
	CONSTRAINT customerEmail CHECK(email like '%@gmail.com'),
	CONSTRAINT customerPhone CHECK(phoneNumber like '08%'),
	CONSTRAINT customerGender CHECK(gender like 'Male' or gender like 'Female')
)

create table bike_type (
	bikeTypeID char(5) primary key NOT NULL CHECK(bikeTypeID like 'BT[0-9][0-9][0-9]'),
	typeName varchar(255) NOT NULL
)

create table Bike_brandset (
    brandID char(5) primary key NOT NULL CHECK (brandID LIKE('BR[0-9][0-9][0-9]')),
    brandName varchar(255) NOT NULL,
    brandDescription varchar(255) NOT NULL,
    brandWebsite varchar(255) NOT NULL CHECK (brandWebsite LIKE('www.%')),
    brandNationality varchar(255) NOT NULL
)

--group set 
create table Bike_Groupset (
	groupsetID char(5) primary key NOT NULL CHECK(groupsetID like 'GR[0-9][0-9][0-9]'),
	[name] varchar(255) NOT NULL,
	numberOfGear integer NOT NULL,
	wirelessCapability varchar(255) NOT NULL
)

ALTER TABLE Bike_Groupset
ADD CONSTRAINT GearValidator CHECK(numberOfGear BETWEEN 4 AND 12)

ALTER TABLE Bike_Groupset
ADD CONSTRAINT WirelessCapability CHECK(wirelessCapability LIKE 'True' OR wirelessCapability LIKE 'False')

--groupset

create table Bike_details (
	bikeID char(5) primary key NOT NULL CHECK(bikeID like 'BK[0-9][0-9][0-9]'),
	bikeTypeID char(5) NOT NULL REFERENCES bike_type(bikeTypeID) ON  DELETE CASCADE ON UPDATE CASCADE ,
	brandID char(5) NOT NULL REFERENCES Bike_brandset(brandID) ON  DELETE CASCADE ON UPDATE CASCADE ,
	groupsetID char(5) NOT NULL REFERENCES Bike_Groupset(groupsetID) ON  DELETE CASCADE ON UPDATE CASCADE,
	bikeName varchar(15) NOT NULL,
	bikePrice integer NOT NULL,
	bikeStock integer NOT NULL

	CONSTRAINT stockValidate CHECK(bikeStock > 0),
	CONSTRAINT priceConstraint CHECK(bikePrice > 0),
	CONSTRAINT btIDConstraint CHECK(bikeTypeID like 'BT[0-9][0-9][0-9]'),
	CONSTRAINT gsIDConstraint CHECK(groupsetID like 'GR[0-9][0-9][0-9]')
)

create table Transaction_table (
	TransactionID char(5) primary key NOT NULL,
	CustomerID char(5) REFERENCES Customer_Detail(CustomerID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	StaffID char(5) REFERENCES Staff_Table(StaffID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	TransactionDate date NOT NULL,

	CONSTRAINT transDate CHECK(TransactionDate <= GETDATE()),
	CONSTRAINT transIDConst CHECK (TransactionID like 'TR[0-9][0-9][0-9]'),
	CONSTRAINT custID CHECK(CustomerID like 'CU[0-9][0-9][0-9]')
)

create table Transaction_details (
	TransactionID char(5) REFERENCES Transaction_table(TransactionID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	BikeID char(5) REFERENCES Bike_details(BikeID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	Quantity integer NOT NULL,

	primary key(TransactionID, BikeID),

	CONSTRAINT transID CHECK (TransactionID like 'TR[0-9][0-9][0-9]'),
    CONSTRAINT transQuantity CHECK (Quantity > 0),
)


INSERT INTO Staff_Table VALUES 
('ST001', 'Wahuy', 'Wahuy@rocalink.com', '0812313', 'Male', 500),
('ST002', 'Siska', 'Siska@rocalink.com', '0812313', 'female', 200),
('ST003', 'Jonis', 'Joni@rocalink.com', '08345723', 'Male', 300),
('ST004', 'Honie', 'Honi@rocalink.com', '0847898', 'female', 400), 
('ST005', 'Brody', 'Brody@rocalink.com', '08772727', 'Male', 1000),
('ST006', 'Senaka', 'Senaka@rocalink.com', '080192931', 'female', 700),
('ST007', 'Jorgey', 'Jorgey@rocalink.com', '08888182', 'Male', 750),
('ST008', 'Honiesa', 'Honiesa@rocalink.com', '0855515521', 'female', 400),
('ST009', 'Budis', 'Budi@rocalink.com', '08888182', 'Male', 950),
('ST010', 'Hosie', 'Hosie@rocalink.com', '085777272', 'female', 800)

INSERT INTO Customer_Detail VALUES 
('CU001', 'Wahuy', 'Wahuy@gmail.com', '08123132', 'Male'),
('CU002', 'Siska', 'Siska@gmail.com', '08123131', 'female'),
('CU003', 'Jonis', 'Joni@gmail.com', '083457230', 'Male'),
('CU004', 'Honie', 'Honi@gmail.com', '08478988', 'female'),
('CU005', 'Andika', 'Andi@gmail.com', '08123129', 'Male'),
('CU006','James','James@gmail.com','08783027','Male'),
('CU007','Cindy','Cindy@gmail.com','08182342' ,'Female'),
('CU008','Budis', 'Budi@gmail.com','08314453','Male'),
('CU009','Danin','Danin@gmail.com','08583215','Male'),
('CU010','Udina', 'Udin@gmail.com','08219584','Male')

INSERT INTO Bike_brandset VALUES
('BR001', 'Family', 'Sepeda Anak', 'www.Family.com', 'Indonesia'),
('BR002', 'CBMX', 'Sepeda Atraksi', 'www.BMX.com', 'Amerika Serikat'),
('BR003', 'Fixie', 'Sepeda Remaja', 'www.Fixie.com', 'Amerika Serikat'),
('BR004', 'Colygon', 'Sepeda Gunung', 'www.Polygon.com', 'Indonesia'),
('BR005', 'Brompton', 'Sepeda Lipat', 'www.Brompton.com', 'Inggris'),
('BR006', 'Ctapses', 'Sepeda Kami', 'www.Ntapses.com', 'Canada'),
('BR007', 'Cerrari', 'Sepeda Cepat', 'www.Ferrari.com', 'India'),
('BR008', 'Testing', 'Sepeda Testing', 'www.Testing.com', 'Belanda'),
('BR009', 'Holygon', 'Sepeda Berbentuk', 'www.Holygon.com', 'Jepang'),
('BR010', 'Gingga', 'Sepeda Asyik', 'www.Gingga.com', 'Jerman')

INSERT INTO Bike_Groupset VALUES
('GR001', 'Judo Family', 6, 'True'),
('GR002', 'Regular BMX', 7, 'False'),
('GR003', 'Regular Fixie', 10, 'False'),
('GR004', 'Judo Polygon', 5,'True'),
('GR005', 'Shimano Brompton', 4, 'False'),
('GR006', 'Shimano Ntapses', 6,'False'),
('GR007', 'Judo Ferrari', 10, 'True'),
('GR008', 'Shimano Testing', 12, 'False'),
('GR009', 'Judo Holygon', 5,'False'),
('GR010', 'Regular Gingga', 8, 'True')

INSERT INTO BIKE_TYPE VALUES
('BT001', 'ROADBIKE Types'),
('BT002', 'FOLDINGBIKE'),
('BT003', 'MOUNTAINBIKE Types'),
('BT004', 'TOURINGBIKE'),
('BT005', 'BMXBIKE Types'),
('BT006', 'CRUISER'),
('BT007', 'FIXEDBIKE Types'),
('BT008', 'UTILITYBIKE'),
('BT009', 'RECUMBENTBIKE Types'),
('BT010', 'SUPERBIKE')


INSERT INTO bike_details VALUES
('BK001', 'BT005', 'BR001' , 'GR001', 'Brompton Bikes', 2500000,100),
('BK002', 'BT008', 'BR002', 'GR003', 'Polygon', 600000,150),
('BK003', 'BT004', 'BR003', 'GR002', 'Wimcycle Bikes', 800000,350),
('BK004', 'BT002', 'BR004', 'GR004', 'Element', 1500000,113),
('BK005', 'BT001', 'BR005', 'GR007', 'JorGX Bikes', 20000000,128),
('BK006', 'BT003', 'BR006', 'GR010', 'huyMX', 15000000,148),
('BK007', 'BT009', 'BR007', 'GR008', 'NULLINX Bikes', 75000000,500),
('BK008', 'BT005', 'BR008', 'GR006', 'reyHC', 100000000,250),
('BK009', 'BT006', 'BR009', 'GR009', 'JMX Bikes', 120000000,230),
('BK010', 'BT010', 'BR010', 'GR005', 'WahRX', 500000000,220),
('BK011', 'BT001', 'BR005', 'GR007', 'JVX Bikes', 3000000,120),
('BK012', 'BT003', 'BR006', 'GR010', 'hmD', 20000000,400),
('BK013', 'BT009', 'BR007', 'GR008', 'NCT Bikes', 89000000,70),
('BK014', 'BT005', 'BR008', 'GR006', 'KCC', 290000000,50),
('BK015', 'BT006', 'BR009', 'GR009', 'BKT Bikes', 3000000,30),
('BK016', 'BT010', 'BR010', 'GR005', 'Bromand', 170000000,15)


INSERT INTO Transaction_table VALUES
('TR001', 'CU003', 'ST005', '2022-02-11'),
('TR002','CU002','ST001', '2022-03-22'),
('TR003', 'CU005', 'ST002', '2022-05-12'),
('TR004','CU006','ST006', '2020-05-17'),
('TR005', 'CU004', 'ST007', '2021-05-01'),
('TR006', 'CU001','ST010', '2022-05-02'),
('TR007', 'CU010', 'ST009', '2020-02-01'),
('TR008','CU001','ST010', '2021-05-30'),
('TR009', 'CU008', 'ST008', '2022-02-28'),
('TR010','CU005','ST004', '2022-04-12'),
('TR011', 'CU009', 'ST005', '2021-02-20'),
('TR012','CU004','ST006', '2022-05-16'),
('TR013', 'CU005', 'ST010', '2019-08-11'),
('TR014','CU007','ST003', '2020-06-17'),
('TR015', 'CU001', 'ST006', '2021-12-25')


INSERT INTO Transaction_details VALUES
('TR001', 'BK009', 4),
('TR002', 'BK001', 3),
('TR002', 'BK005', 10),
('TR004', 'BK010', 2),
('TR012', 'BK004', 1),
('TR003', 'BK003', 3),
('TR004', 'BK002', 2),
('TR005', 'BK002', 2),
('TR006', 'BK005', 1),
('TR007', 'BK010', 3),
('TR008', 'BK008', 1),
('TR009', 'BK009', 2),
('TR010', 'BK002', 3),
('TR011', 'BK007', 5),
('TR012', 'BK006', 6),
('TR013', 'BK008', 2),
('TR014', 'BK010', 9),
('TR015', 'BK002', 1),
('TR001', 'BK003', 14),
('TR002', 'BK004', 3),
('TR003', 'BK006', 2),
('TR004', 'BK001', 5),
('TR005', 'BK001', 1),
('TR006', 'BK007', 6),
('TR007', 'BK008', 7)

drop database RoCALink