CREATE TABLE [Person].[StateProvince] (
	[StateProvinceID] int NULL, 
	[StateProvinceCode] varchar(8000) NULL, 
	[CountryRegionCode] varchar(8000) NULL, 
	[IsOnlyStateProvinceFlag] bit NULL, 
	[Name] varchar(8000) NULL, 
	[TerritoryID] int NULL, 
	[rowguid] uniqueidentifier NULL, 
	[ModifiedDate] datetime2(6) NULL
);