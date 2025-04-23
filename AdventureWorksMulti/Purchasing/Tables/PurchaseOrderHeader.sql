CREATE TABLE [Purchasing].[PurchaseOrderHeader] (
	[PurchaseOrderID] int NULL, 
	[RevisionNumber] int NULL, 
	[Status] int NULL, 
	[EmployeeID] int NULL, 
	[VendorID] int NULL, 
	[ShipMethodID] int NULL, 
	[OrderDate] datetime2(6) NULL, 
	[ShipDate] datetime2(6) NULL, 
	[SubTotal] decimal(19,4) NULL, 
	[TaxAmt] decimal(19,4) NULL, 
	[Freight] decimal(19,4) NULL, 
	[TotalDue] decimal(19,4) NULL, 
	[ModifiedDate] datetime2(6) NULL
);