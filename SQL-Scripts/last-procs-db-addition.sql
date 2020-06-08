use suppliers;

DELIMITER //
create or replace procedure AddSupplier (ServiceName varchar(25), ServiceEmail varchar(25),
        ServicePhoneNumber varchar(12), ServiceAddress varchar(50), ServiceAvgRating int,
        ServiceAvgCost int, svctype int, amtowed int)
BEGIN
    set @TableName = '';
    IF svctype = 1 THEN
        set @TableName = 'tblPrinter';
    ELSE
        set @TableName = 'tblTypesetter';
    END IF;
   
    insert into tblSupplier (SupplierName, Email, Address, PhoneNumber)
    values (ServiceName, ServiceEmail, ServiceAddress, ServicePhoneNumber);

    select @ID := SupplierID from tblSupplier where SupplierName = ServiceName;
    set @cost := ServiceAvgCost;
    set @rating := ServiceAvgRating;
    
    set @query := CONCAT('insert into ',@TableName,' (SupplierID, AvgCost, AvgRating) values (@ID,
                @cost, @rating);');
    PREPARE stmt FROM @query;
    EXECUTE stmt;

    IF amtowed != 0 THEN
        insert into tblSupplierPayment (SupplierID, AmountOwed, CheckNumber)
        values (@ID, amtowed, null);
    END IF;
END; //
DELIMITER ;
