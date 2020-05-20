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
END AS 'Service Type'
FROM tblSupplier
LEFT JOIN tblTypesetter USING (SupplierID)
LEFT JOIN tblPrinter USING (SupplierID)
LEFT JOIN tblSupplierPayment USING (SupplierID)
ORDER BY SupplierID ASC;

USE projects;

CREATE VIEW vewProjects
AS
SELECT ProjectID, Title,
CONCAT (FirstName, " ", LastName) AS 'Author',
CASE
	WHEN isActive THEN 'Active'
	ELSE 'Inactive'
END AS Status
FROM tblProject
LEFT JOIN tblAuthor USING (AuthorID)
LEFT JOIN tblAccount USING (AccountID)
ORDER BY Status, Title DESC;
