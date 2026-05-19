$ErrorActionPreference = 'Stop'
$token = az account get-access-token --resource https://database.windows.net --query accessToken -o tsv
Add-Type -AssemblyName System.Data
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = 'Server=tcp:sql-lunchvote-nonprod-lt1grn.database.windows.net,1433;Database=sqldb-lunchvote-lt1grn;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
$conn.AccessToken = $token
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = 'SELECT name, type_desc FROM sys.database_principals'
$reader = $cmd.ExecuteReader()
while ($reader.Read()) { Write-Host "$($reader['name']) - $($reader['type_desc'])" }
$reader.Close()
$conn.Close()
