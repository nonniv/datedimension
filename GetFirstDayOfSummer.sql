SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jón Viðar Þorsteinsson
-- Create date: 12. sept 2013
-- Description:	Fall sem finnur sumardaginn fyrsta. Gerir ráð fyrir að til sé fallið GetEaserSunday
-- =============================================
if exists( select * from sysobjects where id = object_id(N'GetFirstDayOfSummer') AND xtype IN (N'FN', N'IF', N'TF') )
	drop function GetFirstDayOfSummer
GO
CREATE FUNCTION GetFirstDayOfSummer
(
	@year int
)
RETURNS @Results Table(
	FirstDayOfSummer datetime
)
AS
BEGIN


	with mangal as
	(
		select convert(datetime,cast(@year as varchar) + '.' + '04.19',102) Date
		union all
		select Date + 1
		from mangal
		where date + 1 < dateadd(day,7,convert(datetime,cast(@year as varchar) + '.' + '04.19',102))
	)
	insert into @Results(FirstDayOfSummer) select  m.Date from mangal m where datename(dw,m.Date) = 'Thursday'
	-- Return the result of the function
	RETURN ;
END
GO

