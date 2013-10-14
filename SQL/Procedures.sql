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


CREATE PROCEDURE openAccount @ahID int
AS
BEGIN TRANSACTION [transOpenAccount]
BEGIN TRY
INSERT INTO account VALUES
(0)
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
	IF EXISTS(SELECT aha.aID, aha.ahID,accountholder.id,accountholder.pin FROM aha INNER JOIN accountholder
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

DROP PROCEDURE login
GO
CREATE PROCEDURE login @AHid int, @AHpin int, @ret int OUTPUT
AS 
	IF EXISTS(SELECT * FROM accountholder WHERE id = @AHid AND pin = @AHpin)
	BEGIN 
		SET @ret = 1
	END
	ELSE
	BEGIN
		SET @ret = 0
	END
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
					
					
					
