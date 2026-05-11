-- SQL script to create managed identity user for App Service
-- Run this after deploying infrastructure

-- Replace with your actual App Service name (including the random suffix from Terraform)
-- Run: terraform output app_service_name   to get the actual name (e.g., app-lunchvote-api-dev-a1b2c3)
DECLARE @appServiceName NVARCHAR(100) = 'app-lunchvote-api-dev-CHANGE_ME';

-- Create user from external provider (Managed Identity)
-- Note: You must be connected as the Microsoft Entra admin to run this
DECLARE @sql NVARCHAR(MAX);

-- Check if user already exists
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @appServiceName)
BEGIN
    SET @sql = N'CREATE USER [' + @appServiceName + N'] FROM EXTERNAL PROVIDER;';
    EXEC sp_executesql @sql;
    PRINT 'Created user: ' + @appServiceName;
END
ELSE
BEGIN
    PRINT 'User already exists: ' + @appServiceName;
END

-- Add to db_datareader role
SET @sql = N'ALTER ROLE db_datareader ADD MEMBER [' + @appServiceName + N'];';
EXEC sp_executesql @sql;
PRINT 'Added to db_datareader role';

-- Add to db_datawriter role
SET @sql = N'ALTER ROLE db_datawriter ADD MEMBER [' + @appServiceName + N'];';
EXEC sp_executesql @sql;
PRINT 'Added to db_datawriter role';

-- Grant execute permission if needed for stored procedures
-- ALTER ROLE db_executor ADD MEMBER [@appServiceName];

PRINT 'Managed identity user configured successfully!';
GO
