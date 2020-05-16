use suppliers;

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
