CREATE TABLE [HumanResources].[EmployeeDepartmentHistory] (
	[BusinessEntityID] int NULL, 
	[DepartmentID] smallint NULL, 
	[ShiftID] int NULL, 
	[StartDate] date NULL, 
	[EndDate] date NULL, 
	[ModifiedDate] datetime2(6) NULL
);