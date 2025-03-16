CREATE TABLE [dbo].[Product] (
    [ProductID]              INT             NULL,
    [Name]                   VARCHAR (MAX)   NULL,
    [ProductNumber]          VARCHAR (MAX)   NULL,
    [Color]                  VARCHAR (MAX)   NULL,
    [StandardCost]           DECIMAL (19, 4) NULL,
    [ListPrice]              DECIMAL (19, 4) NULL,
    [Size]                   VARCHAR (MAX)   NULL,
    [Weight]                 DECIMAL (8, 2)  NULL,
    [ProductCategoryID]      INT             NULL,
    [ProductModelID]         INT             NULL,
    [SellStartDate]          DATETIME2 (7)   NULL,
    [SellEndDate]            DATETIME2 (7)   NULL,
    [DiscontinuedDate]       DATETIME2 (7)   NULL,
    [ThumbnailPhotoFileName] VARCHAR (MAX)   NULL,
    [rowguid]                VARCHAR (MAX)   NULL,
    [ModifiedDate]           DATETIME2 (7)   NULL,
    [TenantID]               INT             NULL
);


GO

