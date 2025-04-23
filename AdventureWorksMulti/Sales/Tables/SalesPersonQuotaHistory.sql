CREATE TABLE [Sales].[SalesPersonQuotaHistory] (
	[BusinessEntityID] int NULL, 
	[QuotaDate] datetime2(6) NULL, 
	[SalesQuota] decimal(19,4) NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);