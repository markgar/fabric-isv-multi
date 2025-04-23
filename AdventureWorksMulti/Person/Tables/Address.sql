CREATE TABLE [Person].[Address] (
	[AddressID] int NULL,
	[AddressLine1] varchar(8000) NULL,
	[AddressLine2] varchar(8000) NULL,
	[City] varchar(8000) NULL,
	[StateProvinceID] int NULL,
	[PostalCode] varchar(8000) NULL,
	[SpatialLocation] varchar(8000) NULL,
	[rowguid] uniqueidentifier NULL,
	[ModifiedDate] datetime2(6) NULL
);