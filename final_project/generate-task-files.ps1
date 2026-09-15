# Run from final_project/ AFTER: npm install ; npm start (server on :5000, in another terminal)
# Usage: .\generate-task-files.ps1 harismahmood1997

param(
    [string]$GHUSER = "YOUR_GITHUB_USERNAME"
)

$base = "http://localhost:5000"

function Save-Task($file, $command, $output) {
    "Command:", $command, "", "Output:", $output | Set-Content -Path $file -Encoding utf8
    Write-Host "wrote $file"
}

# Task 14
$cmd = "curl.exe -s https://api.github.com/repos/$GHUSER/expressBookReviews"
$raw = curl.exe -s "https://api.github.com/repos/$GHUSER/expressBookReviews"
try {
    $parent = ($raw | ConvertFrom-Json).parent.full_name
} catch {
    $parent = "(could not parse response - is the repo public and named expressBookReviews?)"
}
Save-Task "githubrepo" "$cmd | jq '.parent.full_name'" $parent

# Task 1
$cmd = 'curl.exe http://localhost:5000/'
$out = curl.exe -s "$base/"
Save-Task "getallbooks" $cmd $out

# Task 2
$cmd = 'curl.exe http://localhost:5000/isbn/1'
$out = curl.exe -s "$base/isbn/1"
Save-Task "getbooksbyISBN" $cmd $out

# Task 3
$cmd = 'curl.exe "http://localhost:5000/author/Jane Austen"'
$out = curl.exe -s "$base/author/Jane%20Austen"
Save-Task "getbooksbyauthor" $cmd $out

# Task 4
$cmd = 'curl.exe "http://localhost:5000/title/Fairy tales"'
$out = curl.exe -s "$base/title/Fairy%20tales"
Save-Task "getbooksbytitle" $cmd $out

# Task 5
$cmd = 'curl.exe http://localhost:5000/review/1'
$out = curl.exe -s "$base/review/1"
Save-Task "getbookreview" $cmd $out

# Task 6
$cmd = 'curl.exe -X POST "http://localhost:5000/register" -H "Content-Type: application/json" -d "{\"username\":\"testuser1\",\"password\":\"Test@123\"}"'
$out = curl.exe -s -X POST "$base/register" -H "Content-Type: application/json" -d '{\"username\":\"testuser1\",\"password\":\"Test@123\"}'
Save-Task "register" $cmd $out

# Task 7 - login, save cookie for later steps
$cmd = 'curl.exe -c cookies.txt -X POST "http://localhost:5000/customer/login" -H "Content-Type: application/json" -d "{\"username\":\"testuser1\",\"password\":\"Test@123\"}"'
$out = curl.exe -s -c cookies.txt -X POST "$base/customer/login" -H "Content-Type: application/json" -d '{\"username\":\"testuser1\",\"password\":\"Test@123\"}'
Save-Task "login" $cmd $out

# Task 8 - add/modify review, needs cookie from login
$cmd = 'curl.exe -b cookies.txt -X PUT "http://localhost:5000/customer/auth/review/1?review=Amazing read"'
$out = curl.exe -s -b cookies.txt -X PUT "$base/customer/auth/review/1?review=Amazing%20read"
Save-Task "reviewadded" $cmd $out

# Task 9 - delete review, needs cookie from login
$cmd = 'curl.exe -b cookies.txt -X DELETE "http://localhost:5000/customer/auth/review/1"'
$out = curl.exe -s -b cookies.txt -X DELETE "$base/customer/auth/review/1"
Save-Task "deletereview" $cmd $out

Write-Host ""
Write-Host "Done. Files: getallbooks getbooksbyISBN getbooksbyauthor getbooksbytitle getbookreview register login reviewadded deletereview githubrepo"
