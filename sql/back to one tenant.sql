-- Delete rows from tables with TenantID column, except SalesOrderHeader for now
DELETE FROM dbo.Address WHERE TenantID <> 1;
DELETE FROM dbo.CustomerAddress WHERE TenantID <> 1;
DELETE FROM dbo.Customer WHERE TenantID <> 1;
DELETE FROM dbo.ProductModelProductDescription WHERE TenantID <> 1;
DELETE FROM dbo.ProductDescription WHERE TenantID <> 1;
DELETE FROM dbo.ProductModel WHERE TenantID <> 1;
DELETE FROM dbo.ProductCategory WHERE TenantID <> 1;
DELETE FROM dbo.Product WHERE TenantID <> 1;

-- Delete SalesOrderDetail rows using join to SalesOrderHeader (still intact)
DELETE d
FROM dbo.SalesOrderDetail d
RIGHT JOIN dbo.SalesOrderHeader h ON d.SalesOrderID = h.SalesOrderID
WHERE h.TenantID IS NULL OR h.TenantID <> 1;

-- Now delete SalesOrderHeader rows
DELETE FROM dbo.SalesOrderHeader WHERE TenantID <> 1;
