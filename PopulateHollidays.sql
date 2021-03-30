/****** Object:  StoredProcedure [dbo].[PopulateHollidays]    Script Date: 10.9.2013 09:11:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists( select * from sysobjects where id = object_id(N'PopulateHollidays') AND xtype = N'P')
	drop procedure PopulateHollidays
GO
Create procedure [dbo].[PopulateHollidays] as 

	update dimDate set IsBankingDay = 'Y', IcelandicHolliday = 'N' where DayOfWeek in ( 2, 3, 4, 5, 6 )
	--Laugardagar og sunnudagar
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'N' where DayOfWeek in ( 1, 7 )
	--Nýársdagur
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where DateKey like '____0101'
	--1. maí
	update dimDate set IsBankingDay = 'N' where DateKey like '____0501' 
	--17. júní
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where DateKey like '____0617' 
	--Aðfangadagur
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where DateKey like '____1224'
	--Jóladagur
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where DateKey like '____1225'
	--Annar í jólum
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where DateKey like '____1226'


	--Skírdagur
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where date in
	(
		select distinct a.MaundryThursday from dimDate d
		cross apply dbo.GetMaundryThursday(d.YearNum) a
	)

	--Páskadagur
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where date in
	(
		select distinct a.EasterSunday from dimDate d
		cross apply dbo.GetEasterSunday(d.YearNum) a
	)

	--Annar í páskum
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where date in
	(
		select distinct a.EasterMonday from dimDate d
		cross apply dbo.GetEasterMonday(d.YearNum) a
	)

	--Upstigningardagur
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where date in
	(
		select distinct a.AscensionDay from dimDate d
		cross apply dbo.GetAscensionDay(d.YearNum) a
	)

	-- Frídagur verslunnarmanna
	update dimDate set IsBankingDay = 'N', IcelandicHolliday = 'Y' where date in
	(
		select distinct a.FirstMondayOfAugust from dimDate d
		cross apply dbo.GetFirstMondayOfAugust(d.YearNum) a
	)

END
