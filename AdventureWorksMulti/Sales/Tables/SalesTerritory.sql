CREATE TABLE [Sales].[SalesTerritory] (
	[TerritoryID] int NULL, 
	[Name] varchar(8000) NULL, 
	[CountryRegionCode] varchar(8000) NULL, 
	[Group] varchar(8000) NULL, 
	[SalesYTD] decimal(19,4) NULL, 
	[SalesLastYear] decimal(19,4) NULL, 
	[CostYTD] decimal(19,4) NULL, 
	[CostLastYear] decimal(19,4) NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);