DECLARE @TenantID INT = 1;
-- Added second tenant parameter
DECLARE @SecondTenantID INT = 2;

-- Address table: side-by-side aggregate comparison for two tenants
SELECT 
  a.[RowCount] AS [RowCount_Tenant1],
  b.[RowCount] AS [RowCount_Tenant2],
  a.MinAddressID AS MinAddressID_Tenant1,
  b.MinAddressID AS MinAddressID_Tenant2,
  a.MaxAddressID AS MaxAddressID_Tenant1,
  b.MaxAddressID AS MaxAddressID_Tenant2
FROM
  (SELECT COUNT(*) AS [RowCount], MIN(AddressID) AS MinAddressID, MAX(AddressID) AS MaxAddressID
   FROM dbo.Address WHERE TenantID = @TenantID) a
CROSS JOIN
  (SELECT COUNT(*) AS [RowCount], MIN(AddressID) AS MinAddressID, MAX(AddressID) AS MaxAddressID
   FROM dbo.Address WHERE TenantID = @SecondTenantID) b;

-- Customer table: side-by-side aggregate comparison for two tenants
SELECT
  c1.[RowCount] AS [RowCount_Tenant1],
  c2.[RowCount] AS [RowCount_Tenant2],
  c1.MinCustomerID AS MinCustomerID_Tenant1,
  c2.MinCustomerID AS MinCustomerID_Tenant2,
  c1.MaxCustomerID AS MaxCustomerID_Tenant1,
  c2.MaxCustomerID AS MaxCustomerID_Tenant2
FROM
  (SELECT COUNT(*) AS [RowCount], MIN(CustomerID) AS MinCustomerID, MAX(CustomerID) AS MaxCustomerID
   FROM dbo.Customer WHERE TenantID = @TenantID) c1
CROSS JOIN
  (SELECT COUNT(*) AS [RowCount], MIN(CustomerID) AS MinCustomerID, MAX(CustomerID) AS MaxCustomerID
   FROM dbo.Customer WHERE TenantID = @SecondTenantID) c2;

-- Product table: side-by-side aggregate comparison for two tenants
SELECT
  p1.[RowCount] AS [RowCount_Tenant1],
  p2.[RowCount] AS [RowCount_Tenant2],
  p1.MinProductID AS MinProductID_Tenant1,
  p2.MinProductID AS MinProductID_Tenant2,
  p1.MaxProductID AS MaxProductID_Tenant1,
  p2.MaxProductID AS MaxProductID_Tenant2
FROM
  (SELECT COUNT(*) AS [RowCount], MIN(ProductID) AS MinProductID, MAX(ProductID) AS MaxProductID
   FROM dbo.Product WHERE TenantID = @TenantID) p1
CROSS JOIN
  (SELECT COUNT(*) AS [RowCount], MIN(ProductID) AS MinProductID, MAX(ProductID) AS MaxProductID
   FROM dbo.Product WHERE TenantID = @SecondTenantID) p2;

-- SalesOrderHeader table: side-by-side aggregate comparison for two tenants
SELECT
  h1.[RowCount] AS [RowCount_Tenant1],
  h2.[RowCount] AS [RowCount_Tenant2],
  h1.MinSalesOrderID AS MinSalesOrderID_Tenant1,
  h2.MinSalesOrderID AS MinSalesOrderID_Tenant2,
  h1.MaxSalesOrderID AS MaxSalesOrderID_Tenant1,
  h2.MaxSalesOrderID AS MaxSalesOrderID_Tenant2
FROM
  (SELECT COUNT(*) AS [RowCount], MIN(SalesOrderID) AS MinSalesOrderID, MAX(SalesOrderID) AS MaxSalesOrderID
   FROM dbo.SalesOrderHeader WHERE TenantID = @TenantID) h1
CROSS JOIN
  (SELECT COUNT(*) AS [RowCount], MIN(SalesOrderID) AS MinSalesOrderID, MAX(SalesOrderID) AS MaxSalesOrderID
   FROM dbo.SalesOrderHeader WHERE TenantID = @SecondTenantID) h2;

-- SalesOrderDetail table: side-by-side aggregate comparison (no TenantID filter)
SELECT
  d1.[RowCount] AS [RowCount_Tenant1],
  d2.[RowCount] AS [RowCount_Tenant2],
  d1.MinSalesOrderDetailID AS MinSalesOrderDetailID_Tenant1,
  d2.MinSalesOrderDetailID AS MinSalesOrderDetailID_Tenant2,
  d1.MaxSalesOrderDetailID AS MaxSalesOrderDetailID_Tenant1,
  d2.MaxSalesOrderDetailID AS MaxSalesOrderDetailID_Tenant2,
  d1.MinSalesOrderID AS MinSalesOrderID_Tenant1,
  d2.MinSalesOrderID AS MinSalesOrderID_Tenant2,
  d1.MaxSalesOrderID AS MaxSalesOrderID_Tenant1,
  d2.MaxSalesOrderID AS MaxSalesOrderID_Tenant2,
  d1.MinProductID AS MinProductID_Tenant1,
  d2.MinProductID AS MinProductID_Tenant2,
  d1.MaxProductID AS MaxProductID_Tenant1,
  d2.MaxProductID AS MaxProductID_Tenant2
FROM
  (SELECT COUNT(*) AS [RowCount],
          MIN(SalesOrderDetailID) AS MinSalesOrderDetailID,
          MAX(SalesOrderDetailID) AS MaxSalesOrderDetailID,
          MIN(SalesOrderID) AS MinSalesOrderID,
          MAX(SalesOrderID) AS MaxSalesOrderID,
          MIN(ProductID) AS MinProductID,
          MAX(ProductID) AS MaxProductID
   FROM dbo.SalesOrderDetail) d1
CROSS JOIN
  (SELECT COUNT(*) AS [RowCount],
          MIN(SalesOrderDetailID) AS MinSalesOrderDetailID,
          MAX(SalesOrderDetailID) AS MaxSalesOrderDetailID,
          MIN(SalesOrderID) AS MinSalesOrderID,
          MAX(SalesOrderID) AS MaxSalesOrderID,
          MIN(ProductID) AS MinProductID,
          MAX(ProductID) AS MaxProductID
   FROM dbo.SalesOrderDetail) d2;

-- CustomerAddress table: side-by-side aggregate comparison for two tenants
SELECT
  ca1.[RowCount] AS [RowCount_Tenant1],
  ca2.[RowCount] AS [RowCount_Tenant2],
  ca1.MinCustomerID AS MinCustomerID_Tenant1,
  ca2.MinCustomerID AS MinCustomerID_Tenant2,
  ca1.MaxCustomerID AS MaxCustomerID_Tenant1,
  ca2.MaxCustomerID AS MaxCustomerID_Tenant2,
  ca1.MinAddressID AS MinAddressID_Tenant1,
  ca2.MinAddressID AS MinAddressID_Tenant2,
  ca1.MaxAddressID AS MaxAddressID_Tenant1,
  ca2.MaxAddressID AS MaxAddressID_Tenant2
FROM
  (SELECT COUNT(*) AS [RowCount], MIN(CustomerID) AS MinCustomerID, MAX(CustomerID) AS MaxCustomerID,
          MIN(AddressID) AS MinAddressID, MAX(AddressID) AS MaxAddressID
   FROM dbo.CustomerAddress WHERE TenantID = @TenantID) ca1
CROSS JOIN
  (SELECT COUNT(*) AS [RowCount], MIN(CustomerID) AS MinCustomerID, MAX(CustomerID) AS MaxCustomerID,
          MIN(AddressID) AS MinAddressID, MAX(AddressID) AS MaxAddressID
   FROM dbo.CustomerAddress WHERE TenantID = @SecondTenantID) ca2;
