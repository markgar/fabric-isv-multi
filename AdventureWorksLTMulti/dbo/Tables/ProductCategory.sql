CREATE TABLE [dbo].[ProductCategory] (
    [ProductCategoryID]       INT           NULL,
    [ParentProductCategoryID] INT           NULL,
    [Name]                    VARCHAR (MAX) NULL,
    [rowguid]                 VARCHAR (MAX) NULL,
    [ModifiedDate]            DATETIME2 (7) NULL,
    [TenantID]                INT           NULL
);


GO

