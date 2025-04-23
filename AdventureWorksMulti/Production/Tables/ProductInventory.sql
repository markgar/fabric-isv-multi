CREATE TABLE [Production].[ProductInventory] (
	[ProductID] int NULL, 
	[LocationID] smallint NULL, 
	[Shelf] varchar(8000) NULL, 
	[Bin] int NULL, 
	[Quantity] smallint NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);