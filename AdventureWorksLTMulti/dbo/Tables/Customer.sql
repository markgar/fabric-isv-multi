CREATE TABLE [dbo].[Customer] (
    [CustomerID]   INT           NULL,
    [NameStyle]    BIT           NULL,
    [Title]        VARCHAR (MAX) NULL,
    [FirstName]    VARCHAR (MAX) NULL,
    [MiddleName]   VARCHAR (MAX) NULL,
    [LastName]     VARCHAR (MAX) NULL,
    [Suffix]       VARCHAR (MAX) NULL,
    [CompanyName]  VARCHAR (MAX) NULL,
    [SalesPerson]  VARCHAR (MAX) NULL,
    [EmailAddress] VARCHAR (MAX) NULL,
    [Phone]        VARCHAR (MAX) NULL,
    [PasswordHash] VARCHAR (MAX) NULL,
    [PasswordSalt] VARCHAR (MAX) NULL,
    [rowguid]      VARCHAR (MAX) NULL,
    [ModifiedDate] DATETIME2 (7) NULL,
    [TenantID]     INT           NULL
);


GO

