CREATE TABLE [Person].[EmailAddress] (
	[BusinessEntityID] int NULL, 
	[EmailAddressID] int NULL, 
	[EmailAddress] varchar(8000) NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);