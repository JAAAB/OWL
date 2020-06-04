USE suppliers;

CREATE VIEW vewSuppliers
AS
SELECT SupplierID, SupplierName, Email, PhoneNumber, Address,
COALESCE (tblTypesetter.AvgRating, tblPrinter.AvgRating) AS AvgRating,
COALESCE (tblTypesetter.AvgCost, tblPrinter.AvgCost) AS AvgCost,
AmountOwed,
CASE
	WHEN tblTypesetter.TypesetterID IS NULL THEN 'Printer'
	WHEN tblPrinter.PrinterID IS NULL THEN 'Typesetter'
	ELSE 'ERR or TS'
END AS 'ServiceType'
FROM tblSupplier
LEFT JOIN tblTypesetter USING (SupplierID)
LEFT JOIN tblPrinter USING (SupplierID)
LEFT JOIN tblSupplierPayment USING (SupplierID)
ORDER BY SupplierID ASC;

USE projects;

CREATE VIEW vewProjects
AS
SELECT tblProject.ProjectID, Title,
CONCAT (FirstName, " ", LastName) AS 'Author',
CASE
    WHEN tblProject.Edition IS NULL THEN '0'
    ELSE tblProject.Edition
END AS Edition,
CASE
	WHEN isActive THEN 'Active'
	ELSE 'Inactive'
END AS Status,
tblProject.ApprovalDate,
tblContract.Years,
tblProject.Notes
/* Manuscripts */
FROM tblProject
LEFT JOIN tblAuthor USING (AuthorID)
LEFT JOIN tblAccount USING (AccountID)
LEFT JOIN tblManuscript ON tblManuscript.ProjectID = tblProject.ProjectID
LEFT JOIN tblContract ON tblContract.ContractID = tblProject.ContractID
ORDER BY Status, Title DESC;

USE projects;

CREATE VIEW vewAuthors
AS
SELECT tblAuthor.AuthorID, tblAccount.FullName, tblAccount.Phone, tblAccount.Email,
tblAccount.Address
FROM tblAuthor
LEFT JOIN tblAccount ON tblAuthor.AccountID = tblAccount.AccountID
ORDER BY tblAuthor.AuthorID ASC;

CREATE VIEW vewBooks
AS
SELECT tblBook.BookID, tblISBN.ISBNNumber, tblProject.Title, tblAccount.FullName, tblFormat.Name AS
FormatName, tblBook.Edition, tblBook.Price, tblLanguage.Name AS LanguageName
FROM tblBook
LEFT JOIN tblISBN ON tblISBN.ISBNID = tblBook.ISBNID
LEFT JOIN tblProject ON tblProject.ProjectID = tblBook.ProjectID
LEFT JOIN tblAuthor ON tblAuthor.AuthorID = tblProject.AuthorID
LEFT JOIN tblAccount ON tblAccount.AccountID = tblAuthor.AccountID
LEFT JOIN tblFormat ON tblFormat.FormatID = tblBook.FormatID
LEFT JOIN tblLanguage ON tblLanguage.LanguageID = tblBook.LanguageID
ORDER BY tblISBN.ISBNNumber ASC;
