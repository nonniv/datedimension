-- =============================================
-- Author:		Jуn Viрar Юorsteinsson
-- Create date: 12. sept 2013
-- Description:	Fall sem finnur fцstudaginn langa. Gerir rбр fyrir aр til sй falliр GetEaserSunday
-- =============================================
if exists( select * from sysobjects where id = object_id(N'GetGoodFriday') AND xtype IN (N'FN', N'IF', N'TF') )
	drop function GetGoodFriday
GO

CREATE FUNCTION GetGoodFriday
(
	@year int
)
RETURNS @Result table
(
	GoodFriday datetime
)
AS
begin
	declare @d as datetime

	select @d = a.EasterSunday from dimDate d
	cross apply dbo.GetEasterSunday(@year) a

	insert into @Result(GoodFriday) select dateadd(day,-2,@d )
	RETURN ;
end
GO

