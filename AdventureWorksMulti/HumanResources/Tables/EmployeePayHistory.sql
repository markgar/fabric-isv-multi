CREATE TABLE [HumanResources].[EmployeePayHistory] (
	[BusinessEntityID] int NULL, 
	[RateChangeDate] datetime2(6) NULL, 
	[Rate] decimal(19,4) NULL, 
	[PayFrequency] int NULL, 
	[ModifiedDate] datetime2(6) NULL
);