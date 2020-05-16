SQL-Scripts/data-output.txt                                                                         0000644 0001750 0001750 00000000000 13660060305 014615  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   SQL-Scripts/fill-data.sql                                                                           0000644 0001750 0001750 00000011022 13660042071 014171  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   use suppliers;

insert into tblSupplier (SupplierName, Email, Address, PhoneNumber, CellPhoneNumber)
values ('Dunder Mifflin', 'michael@dunder.com', '1725 Slough Avenue', 5039999999, 50499999998);

insert into tblSupplier (SupplierName, Email, Address, PhoneNumber, CellPhoneNumber)
values ('Types R Us', 'types@rus.ru', '1432 SW Kalashnikov Ave.', 4325436543, NULL);

insert into tblSupplier (SupplierName, Email, Address, PhoneNumber, CellPhoneNumber)
values ('Stereo-Typists', 'dontfukwitus@types.com', '11 Wall St, New York, NY 10005', 1010010010, NULL);

insert into tblPrinter (SupplierID, AvgCost, AvgRating)
select SupplierID, 300, 4
from tblSupplier 
where SupplierName = 'Dunder Mifflin';

insert into tblTypesetter (SupplierID, AvgCost, AvgRating)
select SupplierID, 350, 3
from tblSupplier
where SupplierName = 'Types R Us';

insert into tblTypesetter (SupplierID, AvgCost, AvgRating)
select SupplierID, 500, 2
from tblSupplier
where SupplierName = 'Stereo-Typists';

insert into tblSupplierPayment (SupplierID, AmountOwed, CheckNumber)
select SupplierID, 500, NULL
from tblSupplier
where SupplierName = 'Stereo-Typists';

use projects;

insert into tblRole (RoleName, RightsXML, InsertUser, LastUpdateUser)
values ('Admin', '', 'aris', 'aris');

insert into tblRole (RoleName, RightsXML, InsertUser, LastUpdateUser)
values ('pleb', '', 'aris', 'aris');

insert into tblAccount (FirstName, LastName, FullName, PasswordHash, RoleID)
select 'Default', 'User', 'Default User', 'asdf', RoleID
from tblRole
where RoleName = 'Admin';

insert into tblAccount (FirstName, LastName, FullName, PasswordHash, RoleID)
select 'Jerry', 'Smith', 'Jerry M. Smith', 'fdas', RoleID
from tblRole
where RoleName = 'pleb';

insert into tblAccount (FirstName, LastName, FullName, PasswordHash, RoleID)
select 'Rick', 'Writer', 'Rick Writer', 'fdaqw', RoleID
from tblRole
where RoleName = 'pleb';

insert into tblAccount (FirstName, LastName, FullName, PasswordHash, RoleID)
select 'Baskin', 'Robbins', 'Baskin Robbins', 'afadaqw', RoleID
from tblRole
where RoleName = 'pleb';

insert into tblAuthor (AccountID)
select AccountID
from tblAccount
where FullName like 'Jerry%Smith';

insert into tblAuthor (AccountID)
select AccountID
from tblAccount
where FullName like 'Rick%Writer';

insert into tblAuthor (AccountID)
select AccountID
from tblAccount
where FullName like 'Baskin%Robbins';

insert into tblContract (AccountID, Requirements, Terms)
select AccountID, 'MUST HAVE DONE BY FRIDAY THIS WEEK!!!', 'No pay until $$ is in bruh'
from tblAccount
where FullName like 'Rick%Writer';

insert into tblContract (AccountID, Requirements, Terms)
select AccountID, 'Relax bro. Finish whenever.', 'I''ll pay you as it goes'
from tblAccount
where FullName like 'Baskin%Robbins';

insert into tblProject (AuthorID, ContractID, Title, Notes, isActive)
select AuthorID, ContractID, 'Dragon-Bjorn', 'A story about a Sweedish man making love to an American dragon', 1
from tblAccount as acc
join tblAuthor as au on acc.AccountID = au.AccountID
join tblContract as c on acc.AccountID = c.AccountID;

insert into tblProject (AuthorID, ContractID, Title, Notes, isActive)
select au.AuthorID, c.ContractID, 'Fe-man!', 'The ballad of He-man, but in an alternate reality!!!', 1
from tblAccount as acc
join tblAuthor as au on acc.AccountID = au.AccountID
join tblContract as c on acc.AccountID = c.AccountID;

insert into tblManuscript (ProjectID, InactiveDate)
select ProjectID, NULL
from tblProject
where Title = 'Fe-man!';

insert into tblManuscript (ProjectID, InactiveDate)
select ProjectID, NULL
from tblProject
where Title = 'Dragon-Bjorn';

insert into tblManuscriptVersion (ManuscriptID, InsertDate, ActiveFlag)
select ManuscriptID, CURDATE() - INTERVAL 1 DAY, 0
from tblManuscript as m
join tblProject as p on p.ProjectID = m.ProjectID
where Title = 'Fe-man!';

insert into tblManuscriptVersion (ManuscriptID, InsertDate, ActiveFlag)
select ManuscriptID, CURDATE() - INTERVAL 5 DAY, 1
from tblManuscript as m
join tblProject as p on p.ProjectID = m.ProjectID
where Title = 'Dragon-Bjorn';

insert into tblManuscriptVersion (ManuscriptID, InsertDate, ActiveFlag)
select ManuscriptID, CURDATE(), 1
from tblManuscript as m
join tblProject as p on p.ProjectID = m.ProjectID
where Title = 'Fe-man!';

insert into tblManuscriptVersionContent (ManuscriptVersionID, Content, Notes)
select ManuscriptVersionID, 'CONTENT CONTENT CONTENT', 'WOO NICE JOB BOIS!'
from tblManuscriptVersion as mv
join tblManuscript as m on mv.ManuscriptID = m.ManuscriptID
join tblProject as p on p.ProjectID = m.ProjectID
where p.Title = 'Fe-man!' and mv.ActiveFlag = 1;



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              SQL-Scripts/init-output.txt                                                                         0000644 0001750 0001750 00000000000 13660060272 014652  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   SQL-Scripts/init-supplier-db-assemble.sql                                                           0000644 0001750 0001750 00000001702 13657021156 017327  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   create database suppliers;

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
                                                              SQL-Scripts/init-supplier-db-assemble.sql.bak                                                       0000644 0001750 0001750 00000004042 13655626136 020072  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   create database suppliers;

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

insert into tblSupplier (SupplierName, Email, Address, PhoneNumber, CellPhoneNumber)
values ('Dunder Mifflin', 'michael@dunder.com', '1725 Slough Avenue', 5039999999, 50499999998);

insert into tblSupplier (SupplierName, Email, Address, PhoneNumber, CellPhoneNumber)
values ('Types R Us', 'types@rus.ru', '1432 SW Kalashnikov Ave.', 4325436543, NULL);

insert into tblSupplier (SupplierName, Email, Address, PhoneNumber, CellPhoneNumber)
values ('Stereo-Typists', 'dontfukwitus@types.com', '11 Wall St, New York, NY 10005', 1010010010, NULL);

insert into tblPrinter (SupplierID, AvgCost, AvgRating)
select SupplierID, 300, 4
from tblSupplier 
where SupplierName = 'Dunder Mifflin';

insert into tblTypesetter (SupplierID, AvgCost, AvgRating)
select SupplierID, 350, 3
from tblSupplier
where SupplierName = 'Types R Us';

insert into tblTypesetter (SupplierID, AvgCost, AvgRating)
select SupplierID, 500, 2
from tblSupplier
where SupplierName = 'Stereo-Typists';

insert into tblSupplierPayment (SupplierID, AmountOwed, CheckNumber)
select SupplierID, 500, NULL
from tblSupplier
where SupplierName = 'Stereo-Typists';

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              SQL-Scripts/reset-output.txt                                                                        0000644 0001750 0001750 00000000000 13660060256 015033  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   SQL-Scripts/reset.sql                                                                               0000644 0001750 0001750 00000000061 13656702627 013476  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   drop database projects;
drop database suppliers;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               SQL-Scripts/secondary-output.txt                                                                    0000644 0001750 0001750 00000000000 13660060274 015700  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   SQL-Scripts/secondary-project-db-assemble.sql                                                       0000644 0001750 0001750 00000006500 13657034673 020167  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   create database projects;

use projects;

create table tblRole(
	RoleID INT AUTO_INCREMENT PRIMARY KEY,
	RoleName VARCHAR(50),
	RightsXML MEDIUMTEXT, /* NOT NULL, */
	InsertUser VARCHAR(50) NOT NULL,
	LastUpdateUser VARCHAR(50) NOT NULL
);

create table tblAccount(
	AccountID INT AUTO_INCREMENT PRIMARY KEY,
	FirstName VARCHAR(100),
	LastName VARCHAR(100),
	FullName VARCHAR(250),
	/* I got rid of UserID, it doesn't make sense */
	PasswordHash VARCHAR(500),
	RoleID INT,
	FOREIGN KEY(RoleID) REFERENCES tblRole(RoleID)
);

create table tblAuthor(
	AuthorID INT AUTO_INCREMENT PRIMARY KEY,
	AccountID INT,/* Added */
	FOREIGN KEY(AccountID) REFERENCES tblAccount(AccountID)
);

create table tblContract(
	ContractID INT AUTO_INCREMENT PRIMARY KEY,
	AccountID INT,/* Added */
	Requirements MEDIUMTEXT,
	Terms MEDIUMTEXT,
	FOREIGN KEY(AccountID) REFERENCES tblAccount(AccountID)
);

create table tblProject(
	ProjectID INT AUTO_INCREMENT PRIMARY KEY,
	AuthorID INT,
	ContractID INT,
	Title VARCHAR(50),
	Notes VARCHAR(500),
	isActive BOOLEAN NOT NULL,
	FOREIGN KEY(AuthorID) REFERENCES tblAuthor(AuthorID),
	FOREIGN KEY(ContractID) REFERENCES tblContract(ContractID)
);

create table tblManuscript(
	ManuscriptID INT AUTO_INCREMENT PRIMARY KEY,
	ProjectID INT,
	InactiveDate DATE,
	FOREIGN KEY(ProjectID) REFERENCES tblProject(ProjectID)	
);

create table tblManuscriptVersion(
	ManuscriptVersionID INT AUTO_INCREMENT PRIMARY KEY,
	ManuscriptID INT,
	InsertDate DATE, /* NOT NULL, */
	ActiveFlag BOOLEAN NOT NULL,
	FOREIGN KEY(ManuscriptID) REFERENCES tblManuscript(ManuscriptID)
);

create table tblManuscriptVersionContent(
	ManuscriptVersionContentID INT AUTO_INCREMENT PRIMARY KEY,
	ManuscriptVersionID INT,
	/* Got rid of title, unnecessary, it's in tblProject */
	Content LONGTEXT,	
	Notes LONGTEXT,
	FOREIGN KEY(ManuscriptVersionID) REFERENCES tblManuscriptVersion(ManuscriptVersionID)
);

create table tblISBN(
	ISBNID INT AUTO_INCREMENT PRIMARY KEY,
	ProjectID INT,
	ISBNNumber MEDIUMTEXT NOT NULL UNIQUE,
	FOREIGN KEY(ProjectID) REFERENCES tblProject(ProjectID)
);

create table tblInventory(
	InventoryID INT AUTO_INCREMENT PRIMARY KEY,
	Count INT
);

create table tblLanguage(
	LanguageID INT AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(50),
	CharacterEncoding VARCHAR(10)
);

create table tblFormat(
	FormatID INT AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(50)
);

create table tblBook(
	BookID INT AUTO_INCREMENT PRIMARY KEY,
	ProjectID INT,
	InventoryID INT,
	ISBNID INT,
	PublishDate DATE,
	LanguageID INT,
	FormatID INT,
	Edition INT,
	Price DECIMAL(15,2),
	FOREIGN KEY(ProjectID) REFERENCES tblProject(ProjectID),
	FOREIGN KEY(InventoryID) REFERENCES tblInventory(InventoryID),
	FOREIGN KEY(ISBNID) REFERENCES tblISBN(ISBNID),
	FOREIGN KEY(LanguageID) REFERENCES tblLanguage(LanguageID),
	FOREIGN KEY(FormatID) REFERENCES tblFormat(FormatID)
);

create table tblOrder(
	OrderID INT AUTO_INCREMENT PRIMARY KEY,
	InsertDate DATE NOT NULL,
	IsComplete BOOLEAN NOT NULL,
	Total DECIMAL(15,2),
	IsPaid BOOLEAN NOT NULL
);

create table tblSales(
	SalesID INT AUTO_INCREMENT PRIMARY KEY,
	BookID INT,
	Count INT,
	FOREIGN KEY(BookID) REFERENCES tblBook(BookID)
);

create table tblOrderItem(
	OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
	OrderID INT,
	BookID INT,
	Quantity INT,
	FOREIGN KEY(OrderID) REFERENCES tblOrder(OrderID),
	FOREIGN KEY(BookID) REFERENCES tblBook(BookID)
);


                                                                                                                                                                                                SQL-Scripts/secondary-project-db-assemble.sql.bak                                                   0000644 0001750 0001750 00000004563 13656676565 020745  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   create database projects;

use projects;

create table tblRole(
	RoleID INT AUTO_INCREMENT PRIMARY KEY,
	RoleName VARCHAR(50),
	RightsXML MEDIUMTEXT, -- NOT NULL,
	InsertUser NOT NULL,
	LastUpdateUSER NOT NULL
);

create table tblAccount(
	AccountID AUTO_INCREMENT PRIMARY KEY,
	FirstName VARCHAR(100),
	LastName VARCHAR(100),
	FullName VARCHAR(250),
	-- I got rid of UserID, it doesn't make sense
	PasswordHash VARCHAR(500),
	RoleID INT,
	FOREIGN KEY(RoleID) REFERENCES tblRole(RoleID)
);

create table tblAuthor(
	AuthorID INT AUTO_INCREMENT PRIMARY KEY,
	AccountID INT,
	FOREIGN KEY(AccountID) REFERENCES tblAccount(AccountID)
);

create table tblContract(
	ContractID INT AUTO_INCREMENT PRIMARY KEY,
	Requirements MEDIUMTEXT,
	Terms MEDIUMTEXT
);

create table tblProject(
	ProjectID INT AUTO_INCREMENT PRIMARY KEY,
	AuthorID INT,
	ContractID INT,
	Title VARCHAR(50),
	Notes VARCHAR(500),
	isActive BOOLEAN NOT NULL,
	FOREIGN KEY(AuthorID) REFERENCES tblAuthor(AuthorID),
	FOREIGN KEY(ContractID) REFERENCES tblContract(ContractID)
);

create table tblManuscript(
	ManuscriptID INT AUTO_INCREMENT PRIMARY KEY,
	ProjectID INT,
	InactiveDate DATE,
	FOREIGN KEY(ProjectID) REFERENCES tblProject(ProjectID)	
);

create table tblManuscriptVersion(
	ManuscriptVersionID INT AUTO_INCREMENT PRIMARY KEY,
	ManuscriptID INT,
	InsertDate DATE -- NOT NULL,
	ActiveFlag BOOLEAN NOT NULL,
	FOREIGN KEY(ManuscriptID) REFERENCES tblManuscript(ManuscriptID)
);

create table tblManuscriptVersionContent(
	ManuscriptVersionContentID INT AUTO_INCREMENT PRIMARY KEY,
	ManuscriptVerionID INT,
	Title SMALLTEXT,
	Content LARGETEXT,
	Notes LARGETEXT
);

create table tblInventory(
	InventoryID INT AUTO_INCREMENT PRIMARY KEY,
	Count INT
);

create table tblLanguage(
	LanguageID INT AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(50),
	CharacterEncoding VARCHAR(10)
);

create table tblFormat(
	FormatID INT AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(50)
);

create table tblBook(
	BookID INT AUTO_INCREMENT PRIMARY KEY,
	ProjectID INT,
	InventoryID INT,
	ISBNID INT,
	PublishDate DATE,
	LanguageID INT,
	FormatID INT,
	Edition INT,
	Price DECIMAL(15,2),
	FOREIGN KEY(ProjectID) REFERENCES tblProject(ProjectID),
	FOREIGN KEY(InventoryID) REFERENCES tblInventory(InventoryID),
	FOREIGN KEY(ISBNID) REFERENCES tblISBN(ISBNID),
	FOREIGN KEY(LanguageID) REFERENCES tblLanguage(LanguageID),
	FOREIGN KEY(FormatID) REFERENCES tblFormat(FormatID)
);
                                                                                                                                             SQL-Scripts/tertiary-output.txt                                                                     0000644 0001750 0001750 00000000000 13660060313 015546  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   SQL-Scripts/tertiary-vews-db-addition.sql                                                           0000644 0001750 0001750 00000001064 13660044022 017340  0                                                                                                    ustar   aris                            aris                                                                                                                                                                                                                   use suppliers;

CREATE VIEW vewSuppliers
AS 
SELECT s.SupplierID, s.SupplierName, s.Email, 
s.PhoneNumber, s.Address, IFNULL(t.AvgCost, p.AvgCost) AS AvgCost, 
IFNULL(t.AvgRating, p.AvgRating) AS AvgRating, sp.AmountOwed,
CASE
	WHEN p.PrinterID IS NULL THEN "Typesetter"
	WHEN t.TypesetterID IS NULL THEN "Printer"
	ELSE "ERROR! UNMATCHED SupplierID!!"
END AS ServiceType
FROM tblSupplier AS s
JOIN tblTypesetter AS t ON t.SupplierID = s.SupplierID
JOIN tblPrinter AS p ON p.SupplierID = s.SupplierID
JOIN tblSupplierPayment as sp ON s.SupplierID = sp.SupplierID;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            