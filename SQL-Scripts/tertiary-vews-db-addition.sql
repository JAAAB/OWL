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
