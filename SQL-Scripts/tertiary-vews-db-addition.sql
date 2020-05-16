use suppliers;

CREATE VIEW vewSuppliers
AS 
SELECT s.SupplierID, t.TypesetterID, p.PrinterID, sp.SupplierPaymentID, s.SupplierName, s.Email, s.Address, s.PhoneNumber, s.CellPhoneNumber, IFNULL(t.AvgCost, p.AvgCost) AS AvgCost, IFNULL(t.AvgRating, p.AvgRating) AS AvgRating, sp.AmountOwed, IF(CheckNumber IS NULL,0,1) AS isPayed
FROM tblSupplier AS s
JOIN tblTypesetter AS t ON t.SupplierID = s.SupplierID
JOIN tblPrinter AS p ON p.SupplierID = s.SupplierID
JOIN tblSupplierPayment as sp ON s.SupplierID = sp.SupplierID;
