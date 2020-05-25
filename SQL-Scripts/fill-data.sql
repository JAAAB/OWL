use suppliers;

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

insert into tblContract (Notes, Years)
values ('Print and EBook', 2);

insert into tblContract (Notes, Years)
values ('', 5);

insert into tblContract (Notes, Years)
values ('Exclusive deal', 10);


--insert into tblContract (AccountID, Requirements, Terms)
--select AccountID, '2 Books', '2 Year'
--from tblAccount
--where FullName like 'Rick%Writer';

--insert into tblContract (AccountID, Requirements, Terms)
--select AccountID, '4 Books', '5 Year'
--from tblAccount
--where FullName like 'Baskin%Robbins';

insert into tblProject (AuthorID, ContractID, Title, Notes, Edition, ApprovalDate, isActive)
select AuthorID, 1, 'Dragon-Bjorn', 'A story about a Swedish man making love to an American dragon',
2.2, STR_TO_DATE("2018-03-03",GET_FORMAT(DATE,'ISO')), 1
from tblAccount as acc
join tblAuthor as au on acc.AccountID = au.AccountID
where au.AuthorID = 3;

insert into tblProject (AuthorID, ContractID, Title, Notes, Edition, ApprovalDate, isActive)
select au.AuthorID, 2, 'Fe-man!', 'The ballad of He-man, but in an alternate reality!!!', 1.5,
STR_TO_DATE("2020-01-25",GET_FORMAT(DATE,'ISO')), 1
from tblAccount as acc
join tblAuthor as au on acc.AccountID = au.AccountID
where au.AuthorID = 2;

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



