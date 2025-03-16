CREATE TABLE [dbo].[CustomerAddress] (
    [CustomerID]   INT           NULL,
    [AddressID]    INT           NULL,
    [AddressType]  VARCHAR (MAX) NULL,
    [rowguid]      VARCHAR (MAX) NULL,
    [ModifiedDate] DATETIME2 (7) NULL,
    [TenantID]     INT           NULL
);


GO

