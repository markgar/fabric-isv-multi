CREATE TABLE [Purchasing].[ShipMethod] (
	[ShipMethodID] int NULL, 
	[Name] varchar(8000) NULL, 
	[ShipBase] decimal(19,4) NULL, 
	[ShipRate] decimal(19,4) NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);