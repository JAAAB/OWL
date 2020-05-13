create database suppliers;

use suppliers;

create table tblSupplier(
	SupplierID INT AUTO_INCREMENT PRIMARY KEY, 
	SupplierName VARCHAR(25) NOT NULL,
	Email VARCHAR(25) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(12),
	CellPhoneNumber VARCHAR(12),
	UNIQUE INDEX suppliers_unique (SupplierID DESC)
);

create table tblTypesetter(
	TypesetterID INT AUTO_INCREMENT PRIMARY KEY,
	SupplierID INT,
	AvgCost INT DEFAULT NULL,
	AvgRating INT DEFAULT NULL,
	FOREIGN KEY(SupplierID) REFERENCES tblSupplier(SupplierID)
);

create table tblSupplierPayment(
	SupplierPaymentID INT AUTO_INCREMENT PRIMARY KEY, 
	SupplierID INT,
	AmountOwed INT DEFAULT NULL,
	CheckNumber INT DEFAULT NULL,
	FOREIGN KEY(SupplierID) REFERENCES tblSupplier(SupplierID)
);

create table tblPrinter(
	PrinterID INT AUTO_INCREMENT PRIMARY KEY,
	SupplierID INT,
	AvgCost INT DEFAULT NULL,
	AvgRating INT DEFAULT NULL,
	FOREIGN KEY(SupplierID) REFERENCES tblSupplier(SupplierID)
);
