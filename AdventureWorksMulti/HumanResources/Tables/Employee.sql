CREATE TABLE [HumanResources].[Employee] (
	[BusinessEntityID] int NULL,
	[NationalIDNumber] varchar(8000) NULL,
	[LoginID] varchar(8000) NULL,
	[OrganizationNode] varchar(8000) NULL,
	[OrganizationLevel] smallint NULL,
	[JobTitle] varchar(8000) NULL,
	[BirthDate] date NULL,
	[MaritalStatus] char(1) NULL,
	[Gender] char(1) NULL,
	[HireDate] date NULL,
	[SalariedFlag] bit NULL,
	[VacationHours] smallint NULL,
	[SickLeaveHours] smallint NULL,
	[CurrentFlag] bit NULL,
	[rowguid] uniqueidentifier NULL,
	[ModifiedDate] datetime2(6) NULL
);