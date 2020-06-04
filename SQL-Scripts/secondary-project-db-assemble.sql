create database projects;

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
    Phone VARCHAR(15),
    Email VARCHAR(50),
    Address VARCHAR(100),    
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

/*I made some changes here, now contracts are independent and have their own ID, this means we essentially assign standardized contracts on a per project basis*/
create table tblContract(
	ContractID INT AUTO_INCREMENT PRIMARY KEY,
	/*AccountID INT,/* Added */
	Notes MEDIUMTEXT,
	/*Terms MEDIUMTEXT,*/
	Years INT
	/*FOREIGN KEY(AccountID) REFERENCES tblAccount(AccountID)*/
);

create table tblProject(
	ProjectID INT AUTO_INCREMENT PRIMARY KEY,
	AuthorID INT,
	ContractID INT,
	Title VARCHAR(500),
	Notes VARCHAR(500),
	Edition DECIMAL,
	ApprovalDate DATE,
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
    BookID INT,
	InsertDate DATE NOT NULL,
	IsComplete BOOLEAN NOT NULL,
	Total DECIMAL(15,2),
	IsPaid BOOLEAN NOT NULL,
    FOREIGN KEY(BookID) REFERENCES tblBook(BookID)
);

/*create table tblSales(
	SalesID INT AUTO_INCREMENT PRIMARY KEY,
	BookID INT,
	Count INT,
	FOREIGN KEY(BookID) REFERENCES tblBook(BookID)
);*/

create table tblCustomer(
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(75) NOT NULL,
    PhoneNumber VARCHAR(12),
    Address VARCHAR(255),
    ServiceType INT NOT NULL
);

create table tblOrderItem(
	OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
	OrderID INT,
    BookID INT,
	Quantity INT,
    CustomerID INT,
	FOREIGN KEY(OrderID) REFERENCES tblOrder(OrderID),
	FOREIGN KEY(BookID) REFERENCES tblBook(BookID),
    FOREIGN KEY(CustomerID) REFERENCES tblCustomer(CustomerID)
);

