-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
if exists( select * from sysobjects where id = object_id(N'GetFirstMondayOfAugust') AND xtype IN (N'FN', N'IF', N'TF') )
	drop function GetFirstMondayOfAugust
GO
CREATE FUNCTION GetFirstMondayOfAugust
(
	@year int
)
RETURNS @Results Table(
	FirstMondayofAugust datetime
)
AS
BEGIN


	with mangal as
	(
		select convert(datetime,cast(@year as varchar) + '.' + '07.31',102) Date
		union all
		select Date + 1
		from mangal
		where date + 1 < dateadd(day,7,convert(datetime,cast(@year as varchar) + '.' + '04.19',102))
	)
	insert into @Results(FirstMondayofAugust) select  m.Date from mangal m where datename(dw,m.Date) = 'Monday'
	-- Return the result of the function
	RETURN ;
END
GO

