
$content = Get-Content -Path src/LunchVoteApi/Program.cs -Raw
$content = $content -replace "Console\.WriteLine\(`"\`$""""DB CREATION FAILED: \{ex\}""""`"\);", "Console.WriteLine(`"`$DB CREATION FAILED: {ex}`");"
Set-Content -Path src/LunchVoteApi/Program.cs -Value $content

