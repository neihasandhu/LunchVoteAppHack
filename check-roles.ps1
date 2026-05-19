$ErrorActionPreference = 'Stop'
$token = az account get-access-token --resource https://database.windows.net --query accessToken -o tsv
Add-Type -AssemblyName System.Data
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = 'Server=tcp:sql-lunchvote-nonprod-lt1grn.database.windows.net,1433;Database=sqldb-lunchvote-lt1grn;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
$conn.AccessToken = $token
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = 'SELECT DP1.name AS DatabaseRoleName, DP2.name AS DatabaseUserName FROM sys.database_role_members AS DRM RIGHT OUTER JOIN sys.database_principals AS DP1 ON DRM.role_principal_id = DP1.principal_id LEFT OUTER JOIN sys.database_principals AS DP2 ON DRM.member_principal_id = DP2.principal_id WHERE DP1.type = ''R'';'
$reader = $cmd.ExecuteReader()
while ($reader.Read()) { Write-Host "$($reader['DatabaseRoleName']) - $($reader['DatabaseUserName'])" }
$reader.Close()
$conn.Close()
