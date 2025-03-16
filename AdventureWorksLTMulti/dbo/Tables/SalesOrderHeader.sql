CREATE TABLE [dbo].[SalesOrderHeader] (
    [SalesOrderID]           INT             NULL,
    [RevisionNumber]         TINYINT         NULL,
    [OrderDate]              DATETIME2 (7)   NULL,
    [DueDate]                DATETIME2 (7)   NULL,
    [ShipDate]               DATETIME2 (7)   NULL,
    [Status]                 TINYINT         NULL,
    [TotalDue]               DECIMAL (19, 4) NULL,
    [Comment]                VARCHAR (MAX)   NULL,
    [rowguid]                VARCHAR (MAX)   NULL,
    [ModifiedDate]           DATETIME2 (7)   NULL,
    [BillToAddressID]        INT             NULL,
    [ShipMethod]             VARCHAR (MAX)   NULL,
    [CreditCardApprovalCode] VARCHAR (MAX)   NULL,
    [SubTotal]               DECIMAL (19, 4) NULL,
    [TaxAmt]                 DECIMAL (19, 4) NULL,
    [Freight]                DECIMAL (19, 4) NULL,
    [OnlineOrderFlag]        BIT             NULL,
    [SalesOrderNumber]       VARCHAR (MAX)   NULL,
    [PurchaseOrderNumber]    VARCHAR (MAX)   NULL,
    [AccountNumber]          VARCHAR (MAX)   NULL,
    [CustomerID]             INT             NULL,
    [ShipToAddressID]        INT             NULL,
    [TenantID]               INT             NULL
);


GO

