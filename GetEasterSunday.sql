SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		J�n Vi�ar �orsteinsson
-- Create date: 12. sept 2013
-- Description:	Fall sem finnur p�skadag
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
		  -- Deili� � �rtali� me� 19 og kalli� afganginn a. 
	  set @a = @year % 19
	  --  Deili� � �rtali� me� 100, kalla� deildina b og afganginn c. 
	  set @b = @year /  100
	  set @c = @year % 100
	  --  Deili� � b me� 4, kalli� deildina d og afganginn e. 
	  set @d = @b / 4
	  set @e = @b % 4
	  --  Deili� � b + 8 me� 25 og kalli� deildina f. 
	  set @f = ( @b + 8 ) / 25
	  -- Deili� � b �f + 1 me� 3 og kalli� deildina g. 
	  set @g = ( @b - @f + 1 ) / 3
	  -- Deili� � 19a + b � d � g + 15 me� 30 og kalli� afganginn h. 
	  set @h = ( 19 * @a + @b - @d -@g + 15 ) % 30
	  --  Deili� � c me� 4 og kalli� deildina i og afganginn j.   
	  set @i = @c / 4
	  set @j = @c % 4
	  --  Deili� � 32 + 2e + 2i � h � j me� 7 og kalli� afganginn k.   
	  set @k = (32 + 2 * @e + 2 * @i - @h -@j) % 7
	  --  Deili� � a + 11h+22k me� 451 og kalli� deildina m.   
	  set @m = ( @a + 11 * @h + 22 * @k ) / 451
	  --  Deili� � h + k � 7m + 114 me� 31, kalli� deildina n og afganginn p. Leggi� einn vi� afganginn.
	  set @p = ( @h + @k +- 7 * @m + 114 ) %  31 + 1
	  set @n = ( @h + @k + - 7 * @m + 114 ) / 31
	  -- �� er n m�nu�urinn sem p�skadagur fellur �, og p er m�na�ardagurinn.
	  --declare @ddd datetime
	insert into @EasterSunday(EasterSunday)  select convert(datetime, cast(@year as varchar) + '.' + cast(@n as varchar) + '.' + cast(@p as varchar),102)
	return;
END
GO