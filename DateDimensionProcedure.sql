SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists( select * from sysobjects where id = object_id(N'PopulateDimDate') AND xtype = N'P')
	drop procedure PopulateDimDate
GO

Create procedure [dbo].[PopulateDimDate]
     @StartDate datetime = NULL
     ,@EndDate datetime = NULL
     ,@nrYearsInFuture int = 40
 as 
 begin

	if( @StartDate is null )
	begin
		-- ef það eru engar færslur í töflunni, þá verður fyrsta færslan 1.1.1981 annrs næsti dagur eftir síðustu færslu
		declare @s datetime
		set @s = '1980-12-31 00:00:00.000'
		select @StartDate = isnull(max(date),@s) + 1 from DimDate
	end

	if( @EndDate is null )
	begin
		declare @e datetime
		set @e = '2050-01-01 00:00:00.000'
		select @EndDate =  dateadd(year,1,isnull(dateadd(day,1,max(date)),@e) ) from DimDate
	end;
	print 'From date ' + cast(@StartDate as varchar) + ' toDate ' + cast(@EndDate as varchar);

	if( year(@EndDate) - year(getdate()) > @nrYearsInFuture )
	begin
		print 'Table has ' + cast(year(@EndDate) - year(getdate()) as varchar)+ ' years into the future. Nothing to do'
		return;
	end;

		with mangal as
		(
			select @StartDate Date
			union all
			select Date + 1
			from mangal
			where date + 1 < @EndDate
		)
	
		insert into dimDate(date,datekey,DateKeyStr,YearNum,MonthNum,MonthName,NameOfDay,DayOfWeek,Weekend,Quarter,YearQ,DayOfYear,DayOfMonth,NameOfDayEng,NameOfMonthEng,LeapYear) 
		select 
			date
			, right(convert(int,Year(Date)),4) * 10000+RIGHT('0' + convert(int,month(date)),2) * 100+RIGHT('0' + convert(int,day(date)),2) 
			, right(convert(varchar(4),Year(Date)),4) + RIGHT('0' + convert(varchar,month(date)),2) + RIGHT('0' + convert(varchar,day(date)),2) 
			,Year(date)
			,Month(date)
			,CASE WHEN Month(Date) =  1 THen 'Janúar' WHEN Month(Date) =  2 THen 'Febrúar' 	WHEN Month(Date) =  3 THen 'Mars'	WHEN Month(Date) =  4 THen 'Apríl'	WHEN Month(Date) =  5 THen 'Maí' WHEN Month(Date) =  6 THen 'Júní' WHEN Month(Date) =  7 THen 'Júlí' WHEN Month(Date) =  8 THen 'Ágúst' 	WHEN Month(Date) =  9 THen 'September' 	WHEN Month(Date) = 10 THen 'Október' 	WHEN Month(Date) = 11 THen 'Nóvember' 	WHEN Month(Date) = 12 THen 'Desember' End
			,CASE When DatePart(dw,Date) = 2 THEN 'Mánudagur' When DatePart(dw,Date) = 3 THEN 'Þriðjudagur'	When DatePart(dw,Date) = 4 THEN 'Miðvikudagur'	When DatePart(dw,Date) = 5 THEN 'Fimmtudagur'	When DatePart(dw,date) = 6 THEN 'Föstudagur'	When DatePart(dw,Date) = 7 THEN 'Laugadagur'	When DatePart(dw,Date) = 1 THEN 'Sunnudagur' END
			,DatePart(dw,Date)
			,CASE WHEN DatePart(dw,Date) = 7 THEN 'Y' WHEN DatePart(dw,Date) = 1 THEN 'Y'	Else 'N' END
			,'Q'+ convert(varchar(2), Datepart(qq,date),2)
			,convert(varchar(4),Datepart(YYYY,date),4) + '-Q'+ convert(varchar(2), Datepart(qq,date),2)
			,convert(varchar(4),Datepart(dy,date),4)
			,DATEPART(dd,date)
			,DateName(dw,Date)
			,DateName(Month,Date)
			,CASE WHEN (Datepart(YYYY,date) % 4 = 0 AND Datepart(YYYY,date) % 100 <> 0) OR Datepart(YYYY,date) % 400 = 0 THEN 'Y' ELSE 'N' END
			from mangal option (maxrecursion 0)
	
	exec [PopulateHollidays]

END
