IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'app-lunchvote-api-nonprod-cfmkd6')
BEGIN
    CREATE USER [app-lunchvote-api-nonprod-cfmkd6] FROM EXTERNAL PROVIDER;
END
ALTER ROLE db_datareader ADD MEMBER [app-lunchvote-api-nonprod-cfmkd6];
ALTER ROLE db_datawriter ADD MEMBER [app-lunchvote-api-nonprod-cfmkd6];
ALTER ROLE db_ddladmin ADD MEMBER [app-lunchvote-api-nonprod-cfmkd6];
