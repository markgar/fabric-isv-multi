CREATE TABLE [dbo].[SalesOrderDetail] (
    [SalesOrderID]       INT             NULL,
    [SalesOrderDetailID] INT             NULL,
    [OrderQty]           SMALLINT        NULL,
    [ProductID]          INT             NULL,
    [UnitPrice]          DECIMAL (19, 4) NULL,
    [UnitPriceDiscount]  DECIMAL (19, 4) NULL,
    [LineTotal]          DECIMAL (38, 6) NULL,
    [rowguid]            VARCHAR (MAX)   NULL,
    [ModifiedDate]       DATETIME2 (7)   NULL
);


GO

