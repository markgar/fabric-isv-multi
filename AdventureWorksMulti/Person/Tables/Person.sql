CREATE TABLE [Person].[Person] (
	[BusinessEntityID] int NULL,
	[PersonType] char(2) NULL,
	[NameStyle] bit NULL,
	[Title] varchar(8000) NULL,
	[FirstName] varchar(8000) NULL,
	[MiddleName] varchar(8000) NULL,
	[LastName] varchar(8000) NULL,
	[Suffix] varchar(8000) NULL,
	[EmailPromotion] int NULL,
	[AdditionalContactInfo] varchar(MAX) NULL,
	[Demographics] varchar(MAX) NULL,
	[rowguid] uniqueidentifier NULL,
	[ModifiedDate] datetime2(6) NULL
);