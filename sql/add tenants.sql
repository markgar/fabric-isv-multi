DECLARE @startTenant INT = 2;
DECLARE @endTenant INT = 5;
DECLARE @currentTenant INT = @startTenant;

WHILE @currentTenant <= @endTenant
BEGIN
	-- Address
	INSERT INTO Address (
		[AddressID],
		[AddressLine1],
		[AddressLine2],
		[City],
		[StateProvince],
		[PostalCode],
		[CountryRegion],
		[TenantID],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[AddressID] + (100000 * (@currentTenant - 1)),
		[AddressLine1],
		[AddressLine2],
		[City],
		[StateProvince],
		[PostalCode],
		[CountryRegion],
		@currentTenant,
		[rowguid],
		[ModifiedDate]
	FROM Address
	WHERE [TenantID] = 1;

	-- Customer
	INSERT INTO Customer (
		[CustomerID],
		[NameStyle],
		[Title],
		[FirstName],
		[MiddleName],
		[LastName],
		[Suffix],
		[CompanyName],
		[SalesPerson],
		[EmailAddress],
		[Phone],
		[PasswordHash],
		[PasswordSalt],
		[TenantID],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[CustomerID] + (100000 * (@currentTenant - 1)),
		[NameStyle],
		[Title],
		[FirstName],
		[MiddleName],
		[LastName],
		[Suffix],
		[CompanyName],
		[SalesPerson],
		[EmailAddress],
		[Phone],
		[PasswordHash],
		[PasswordSalt],
		@currentTenant,
		[rowguid],
		[ModifiedDate]
	FROM Customer
	WHERE [TenantID] = 1;

	-- CustomerAddress
	INSERT INTO CustomerAddress (
		[CustomerID],
		[AddressID],
		[AddressType],
		[TenantID],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[CustomerID] + (100000 * (@currentTenant - 1)),
		[AddressID] + (100000 * (@currentTenant - 1)),
		[AddressType],
		@currentTenant,
		[rowguid],
		[ModifiedDate]
	FROM CustomerAddress
	WHERE [TenantID] = 1;

	-- Product
	INSERT INTO Product (
		[ProductID],
		[Name],
		[ProductNumber],
		[Color],
		[StandardCost],
		[ListPrice],
		[Size],
		[Weight],
		[ProductCategoryID],
		[ProductModelID],
		[SellStartDate],
		[SellEndDate],
		[DiscontinuedDate],
		[TenantID],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[ProductID] + (100000 * (@currentTenant - 1)),
		[Name],
		[ProductNumber],
		[Color],
		[StandardCost],
		[ListPrice],
		[Size],
		[Weight],
		[ProductCategoryID] + (100000 * (@currentTenant - 1)),
		[ProductModelID] + (100000 * (@currentTenant - 1)),
		[SellStartDate],
		[SellEndDate],
		[DiscontinuedDate],
		@currentTenant,
		[rowguid],
		[ModifiedDate]
	FROM Product
	WHERE [TenantID] = 1;

	-- ProductCategory
	INSERT INTO ProductCategory (
		[ProductCategoryID],
		[Name],
		[TenantID],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[ProductCategoryID] + (100000 * (@currentTenant - 1)),
		[Name],
		@currentTenant,
		[rowguid],
		[ModifiedDate]
	FROM ProductCategory
	WHERE [TenantID] = 1;

	-- ProductDescription
	INSERT INTO ProductDescription (
		[ProductDescriptionID],
		[Description],
		[TenantID],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[ProductDescriptionID] + (100000 * (@currentTenant - 1)),
		[Description],
		@currentTenant,
		[rowguid],
		[ModifiedDate]
	FROM ProductDescription
	WHERE [TenantID] = 1;

	-- ProductModel
	INSERT INTO ProductModel (
		[ProductModelID],
		[Name],
		[CatalogDescription],
		[TenantID],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[ProductModelID] + (100000 * (@currentTenant - 1)),
		[Name],
		[CatalogDescription],
		@currentTenant,
		[rowguid],
		[ModifiedDate]
	FROM ProductModel
	WHERE [TenantID] = 1;

	-- ProductModelProductDescription
	INSERT INTO ProductModelProductDescription (
		[ProductModelID],
		[ProductDescriptionID],
		[Culture],
		[TenantID],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[ProductModelID] + (100000 * (@currentTenant - 1)),
		[ProductDescriptionID] + (100000 * (@currentTenant - 1)),
		[Culture],
		@currentTenant,
		[rowguid],
		[ModifiedDate]
	FROM ProductModelProductDescription
	WHERE [TenantID] = 1;

	-- SalesOrderDetail
	INSERT INTO SalesOrderDetail (
		[SalesOrderDetailID],
		[SalesOrderID],
			[OrderQty],
		[ProductID],
		[UnitPrice],
		[UnitPriceDiscount],
		[LineTotal],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		d.[SalesOrderDetailID] + (100000 * (@currentTenant - 1)),
		d.[SalesOrderID] + (100000 * (@currentTenant - 1)),
		d.[OrderQty],
		d.[ProductID] + (100000 * (@currentTenant - 1)),
		d.[UnitPrice],
		d.[UnitPriceDiscount],
		d.[LineTotal],
		d.[rowguid],
		d.[ModifiedDate]
	FROM SalesOrderDetail d
	JOIN SalesOrderHeader h ON d.[SalesOrderID] = h.[SalesOrderID]
	WHERE h.[TenantID] = 1;

	-- SalesOrderHeader
	INSERT INTO SalesOrderHeader (
		[SalesOrderID],
		[CustomerID],
		[ShipMethod],
		[CreditCardApprovalCode],
		[TenantID],
		[RevisionNumber],
		[OrderDate],
		[DueDate],
		[ShipDate],
		[Status],
		[OnlineOrderFlag],
		[SalesOrderNumber],
		[PurchaseOrderNumber],
		[AccountNumber],
		[SubTotal],
		[TaxAmt],
		[Freight],
		[TotalDue],
		[Comment],
		[rowguid],
		[ModifiedDate]
	)
	SELECT
		[SalesOrderID] + (100000 * (@currentTenant - 1)),
		[CustomerID] + (100000 * (@currentTenant - 1)),
		[ShipMethod],
		[CreditCardApprovalCode],
		@currentTenant,
		[RevisionNumber],
		[OrderDate],
		[DueDate],
		[ShipDate],
		[Status],
		[OnlineOrderFlag],
		[SalesOrderNumber],
		[PurchaseOrderNumber],
		[AccountNumber],
		[SubTotal],
		[TaxAmt],
		[Freight],
		[TotalDue],
		[Comment],
		[rowguid],
		[ModifiedDate]
	FROM SalesOrderHeader
	WHERE [TenantID] = 1;

	SET @currentTenant = @currentTenant + 1;
END
