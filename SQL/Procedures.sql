
USE dv1454_ht13_5
GO
CREATE PROCEDURE calculateInterests
AS
BEGIN TRANSACTION [transInterest]
BEGIN TRY

INSERT INTO intrest
SELECT account.id,tInterest.aInterest,SYSDATETIME() AS currentDate
FROM (SELECT account.id AS aID,account.balance * 1.01 AS aInterest FROM account) AS tInterest,account
WHERE account.id = tInterest.aID
COMMIT TRANSACTION [transInterest]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transInterest]
END CATCH
GO
GO


CREATE PROCEDURE addAccountHolder @name varchar(80), @birthdate int, @telephone varchar(20),@email varchar(225),@pin int
AS
BEGIN TRANSACTION [transAddAH]
BEGIN TRY
INSERT INTO accountholder VALUES
(@name,@birthdate,@telephone,@email,@pin)
COMMIT TRANSACTION [transAddAH]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transAddAH]
END CATCH
GO
GO


CREATE PROCEDURE linkAccount @lAHid int, @lAid int
AS
BEGIN TRANSACTION [transLinkAccount]
BEGIN TRY
INSERT INTO aha VALUES
(@lAHid,@lAid)
COMMIT TRANSACTION [transLinkAccount]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transLinkAccount]
END CATCH
GO
GO


CREATE PROCEDURE openAccount @ahID int, @balance int
AS
BEGIN TRANSACTION [transOpenAccount]
BEGIN TRY
INSERT INTO account VALUES
(@balance)
DECLARE @accountid int
SET @accountid = (SELECT MAX(account.id) AS newestID FROM account)
EXEC linkAccount @lAHid = @ahID, @lAid = @accountid
COMMIT TRANSACTION [transOpenAccount]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transOpenAccount]
END CATCH
GO
GO

CREATE PROCEDURE confirmLoginAccess @AHid int, @AHpin int, @Aid int, @result int OUTPUT
AS
BEGIN TRANSACTION [transConfirmLogin]
BEGIN TRY
IF EXISTS
(SELECT aha.aID, aha.ahID,accountholder.id,accountholder.pin FROM aha INNER JOIN accountholder
ON aha.ahID = accountholder.id AND accountholder.id = @AHid AND accountholder.pin = @AHpin AND aha.aid = @Aid)
SET @result = 1
ELSE SET @result = 0
COMMIT TRANSACTION [transConfirmLogin]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transConfirmLogin]
END CATCH
GO
GO


CREATE PROCEDURE takeOutMoney @Aid int, @amount int, @result int OUTPUT
AS
BEGIN TRANSACTION [transTakeOut]
BEGIN TRY
IF (SELECT account.balance FROM account
WHERE account.id = @Aid) >= @amount
BEGIN
SET @result = @amount
UPDATE account
SET balance = balance - @amount
WHERE id = @Aid
INSERT INTO acclog VALUES
(@Aid,0-@amount,SYSDATETIME())
END
ELSE
BEGIN
SET @result = 0
END
COMMIT TRANSACTION [transTakeOut]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transTakeOut]
END CATCH
GO
GO


CREATE PROCEDURE returnBalance @Aid int, @return int OUTPUT
AS
SET @return = (SELECT account.balance FROM account
WHERE account.id = @Aid)
GO


CREATE PROCEDURE depositMoney @Aid int, @amount int, @result int OUTPUT
AS
BEGIN TRANSACTION [transDeposit]
BEGIN TRY
UPDATE account
SET balance = balance + @amount
WHERE id = @Aid
INSERT INTO acclog VALUES
(@Aid,@amount,SYSDATETIME())
SET @result = 0
COMMIT TRANSACTION [transDeposit]
END TRY
BEGIN CATCH
SET @result = 1
ROLLBACK TRANSACTION [transDeposit]
END CATCH
GO
GO


CREATE PROCEDURE getAHName @AHid int, @result varchar(80) OUTPUT
AS
DECLARE @temp varchar(80) = (SELECT name FROM accountholder WHERE id = @AHid)
SET @result = @temp
GO


CREATE PROCEDURE getAHCount @result int OUTPUT
AS
DECLARE @temp int = (SELECT COUNT(ID) FROM accountholder) 
SET @result = @temp
GO


CREATE PROCEDURE getAHBirthdate @AHid int, @result int OUTPUT
AS
DECLARE @temp int = (SELECT birthdate FROM accountholder WHERE id = @AHid)
SET @result = @temp
GO


CREATE PROCEDURE getAHTelephone @AHid int, @result int OUTPUT
AS
DECLARE @temp int = (SELECT telephone FROM accountholder WHERE id = @AHid)
SET @result = @temp
GO


CREATE PROCEDURE getACount @result int OUTPUT
AS
DECLARE @temp int = (SELECT COUNT(ID) FROM account) 
SET @result = @temp
GO


CREATE PROCEDURE getAHPin @AHid int, @result int OUTPUT
AS
DECLARE @temp int = (SELECT pin FROM accountholder WHERE id = @AHid)
SET @result = @temp
GO


CREATE PROCEDURE getAHEmail @AHid int, @result varchar(225) OUTPUT
AS
DECLARE @temp varchar(225) = (SELECT email FROM accountholder WHERE id = @AHid)
SET @result = @temp
GO


CREATE PROCEDURE getABalance @Aid int, @result int OUTPUT
AS
DECLARE @temp int = (SELECT balance FROM account WHERE id = @Aid)
SET @result = @temp
GO


CREATE PROCEDURE getAHACount @result int OUTPUT
AS
DECLARE @temp int = (SELECT COUNT(ahID) FROM aha) 
SET @result = @temp
GO


CREATE PROCEDURE getAHAAHid @index int, @result int OUTPUT
AS
DECLARE @temp int = (SELECT ahID from (SELECT ROW_NUMBER() OVER (ORDER BY AHid) AS Row,ahID,aID FROM aha)
	AS tAHA WHERE Row = @index)
SET @result = @temp
GO


CREATE PROCEDURE getAHAAid @index int, @result int OUTPUT
AS
DECLARE @temp int = (SELECT aID from (SELECT ROW_NUMBER() OVER (ORDER BY AHid) AS Row,ahID,aID FROM aha)
	AS tAHA WHERE Row = @index)
SET @result = @temp
GO	


CREATE PROCEDURE getAid @index int, @result int OUTPUT
AS
DECLARE @temp int = (SELECT ID from (SELECT ROW_NUMBER() OVER (ORDER BY id) AS Row,ID FROM account)
	AS tAccount WHERE Row = @index)
SET @result = @temp
GO


CREATE PROCEDURE getAHid @index int, @result int OUTPUT
AS
DECLARE @temp int = (SELECT ID from (SELECT ROW_NUMBER() OVER (ORDER BY id) AS Row,ID FROM accountholder)
	AS tAccountholder WHERE Row = @index)
SET @result = @temp
GO



DROP PROCEDURE cI
GO
CREATE PROCEDURE cI @aID INT, @return int OUTPUT
AS
	DECLARE @bala INT , @test int
	EXEC returnBalance @aid , @bala output;
	SET @bala = @bala * 0.01;
	EXEC depositMoney @aID ,@bala ,@test output;
	EXEC returnBalance @aID, @bala OUTPUT
	SET @return = @bala
GO




