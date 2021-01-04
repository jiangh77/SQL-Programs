USE practice
CREATE ROLE testuser AUTHORIZATION db_accessadmin
GO

/*-- not working --*/
USE practice
CREATE USER 'test1', 'Dan'