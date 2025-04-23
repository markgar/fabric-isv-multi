CREATE TABLE [Sales].[Customer] (
	[CustomerID] int NULL, 
	[PersonID] int NULL, 
	[StoreID] int NULL, 
	[TerritoryID] int NULL, 
	[AccountNumber] varchar(8000) NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);