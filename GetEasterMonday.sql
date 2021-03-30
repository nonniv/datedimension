
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jуn Viрar Юorsteinsson
-- Create date: 12. sept 2013
-- Description:	Fall sem finnur annan н pбskum. Gerir rбр fyrir aр til sй falliр GetEaserSunday
-- =============================================
if exists( select * from sysobjects where id = object_id(N'GetEasterMonday') AND xtype IN (N'FN', N'IF', N'TF') )
	drop function GetEasterMonday
GO
CREATE FUNCTION GetEasterMonday
(
	-- Add the parameters for the function here
	@year int
)
RETURNS @Result Table(
 EasterMonday datetime
)
AS
BEGIN
	-- Declare the return variable here
	-- Add the T-SQL statements to compute the return value here
	declare @d as datetime

	select @d = a.EasterSunday from dimDate d
	cross apply dbo.GetEasterSunday(@year) a

	insert into @Result(EasterMonday) SELECT  dateadd(day,1,@d )
	-- Return the result of the function
	RETURN ;
END
GO

