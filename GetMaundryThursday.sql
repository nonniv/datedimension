SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jуn Viрar Юorsteinsson
-- Create date: 12. sept 2013
-- Description:	Fall sem finnur uppstigningardag. Gerir rбр fyrir aр til sй falliр GetEaserSunday
-- =============================================
if exists( select * from sysobjects where id = object_id(N'GetMaundryThursday') AND xtype IN (N'FN', N'IF', N'TF') )
	drop function GetMaundryThursday
GO
CREATE FUNCTION GetMaundryThursday 
(
	-- Add the parameters for the function here
	@year int
)
RETURNS @Results Table(

MaundryThursday  datetime
)
AS
BEGIN
	-- Declare the return variable here
	-- Add the T-SQL statements to compute the return value here
	declare @d as datetime

	select @d = a.EasterSunday from dimDate d
	cross apply dbo.GetEasterSunday(@year) a

	insert into @Results(MaundryThursday) SELECT  dateadd(day,-3,@d )
	-- Return the result of the function
	RETURN ;
END
GO

