CREATE TABLE [Sales].[SalesTaxRate] (
	[SalesTaxRateID] int NULL, 
	[StateProvinceID] int NULL, 
	[TaxType] int NULL, 
	[TaxRate] decimal(10,4) NULL, 
	[Name] varchar(8000) NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);