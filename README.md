# datedimension
Date dimension for SQL Server with Icelandic hollidays

The dimension is populated with stored procedure that uses some table value functions.

Following code can be run daily:
```SQL

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'  AND TABLE_NAME='DimDate')
	DROP TABLE [dbo].[DimDate]

GO 
CREATE TABLE [dbo].[DimDate](
	[DateKey] [int] NOT NULL,
	[DateKeyStr] [varchar](8) NULL,
	[Date] [datetime] NOT NULL,
	[YearNum] [int] NULL,
	[MonthNum] [varchar](2) NULL,
	[MonthName] [varchar](20) NULL,
	[NameOfDay] [varchar](20) NULL,
	[DayOfWeek] [int] NULL,	
	[NameOfDayEng] [varchar](20) NULL,
	[NameOfMonthEng] [varchar](20) NULL,
	[Weekend] [varchar](1) NULL,
	[IsBankingDay] [varchar](1) NULL,
	[IcelandicHolliday] [varchar](1) NULL,
	DayOfYear int, 
	DayOfMonth int,
	[Quarter] [varchar](10) NULL,
	YearQ varchar(7),
	LeapYear varchar(1)
) 

exec PopulateDimDate

