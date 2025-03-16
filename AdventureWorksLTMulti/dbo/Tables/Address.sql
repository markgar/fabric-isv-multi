CREATE TABLE [dbo].[Address] (
    [AddressID]     INT            NULL,
    [AddressLine1]  NVARCHAR (MAX) NULL,
    [AddressLine2]  VARCHAR (MAX)  NULL,
    [City]          VARCHAR (MAX)  NULL,
    [StateProvince] VARCHAR (MAX)  NULL,
    [CountryRegion] VARCHAR (MAX)  NULL,
    [PostalCode]    VARCHAR (MAX)  NULL,
    [rowguid]       VARCHAR (MAX)  NULL,
    [ModifiedDate]  DATETIME2 (7)  NULL,
    [TenantID]      INT            NULL
);


GO

