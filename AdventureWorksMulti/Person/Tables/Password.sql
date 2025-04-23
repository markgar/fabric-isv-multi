CREATE TABLE [Person].[Password] (
	[BusinessEntityID] int NULL, 
	[PasswordHash] varchar(8000) NULL, 
	[PasswordSalt] varchar(8000) NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);