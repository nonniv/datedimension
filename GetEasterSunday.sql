SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jón Viðar Þorsteinsson
-- Create date: 12. sept 2013
-- Description:	Fall sem finnur páskadag
-- =============================================
if exists( select * from sysobjects where id = object_id(N'GetEasterSunday') AND xtype IN (N'FN', N'IF', N'TF') )
	drop function GetEasterSunday
GO
CREATE FUNCTION GetEasterSunday 
(
	@year int
)
RETURNS @EasterSunday Table(
	EasterSunday datetime
)

AS
BEGIN
	declare  @a int, @b int, @c int, @e int, @f int, @g int, @h int, @i int, @j int, @m int, @d int, @k int, @n int, @p int
		  -- Deilið í ártalið með 19 og kallið afganginn a. 
	  set @a = @year % 19
	  --  Deilið í ártalið með 100, kallað deildina b og afganginn c. 
	  set @b = @year /  100
	  set @c = @year % 100
	  --  Deilið í b með 4, kallið deildina d og afganginn e. 
	  set @d = @b / 4
	  set @e = @b % 4
	  --  Deilið í b + 8 með 25 og kallið deildina f. 
	  set @f = ( @b + 8 ) / 25
	  -- Deilið í b –f + 1 með 3 og kallið deildina g. 
	  set @g = ( @b - @f + 1 ) / 3
	  -- Deilið í 19a + b – d – g + 15 með 30 og kallið afganginn h. 
	  set @h = ( 19 * @a + @b - @d -@g + 15 ) % 30
	  --  Deilið í c með 4 og kallið deildina i og afganginn j.   
	  set @i = @c / 4
	  set @j = @c % 4
	  --  Deilið í 32 + 2e + 2i – h – j með 7 og kallið afganginn k.   
	  set @k = (32 + 2 * @e + 2 * @i - @h -@j) % 7
	  --  Deilið í a + 11h+22k með 451 og kallið deildina m.   
	  set @m = ( @a + 11 * @h + 22 * @k ) / 451
	  --  Deilið í h + k – 7m + 114 með 31, kallið deildina n og afganginn p. Leggið einn við afganginn.
	  set @p = ( @h + @k +- 7 * @m + 114 ) %  31 + 1
	  set @n = ( @h + @k + - 7 * @m + 114 ) / 31
	  -- Þá er n mánuðurinn sem páskadagur fellur í, og p er mánaðardagurinn.
	  --declare @ddd datetime
	insert into @EasterSunday(EasterSunday)  select convert(datetime, cast(@year as varchar) + '.' + cast(@n as varchar) + '.' + cast(@p as varchar),102)
	return;
END
GO