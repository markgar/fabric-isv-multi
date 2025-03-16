CREATE EXTERNAL DATA SOURCE [MyAzureStorage]
    WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = N'https://whingestion.blob.core.windows.net/cetas',
    CREDENTIAL = [ManagedID]
    );


GO

