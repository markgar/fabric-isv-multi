CREATE TABLE [Production].[ProductModel] (
	[ProductModelID] int NULL,
	[Name] varchar(8000) NULL,
	[CatalogDescription] varchar(MAX) NULL,
	[Instructions] varchar(MAX) NULL,
	[rowguid] uniqueidentifier NULL,
	[ModifiedDate] datetime2(6) NULL
);