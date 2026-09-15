#!/usr/bin/env bash
# Run this from final_project/ AFTER: npm install && npm start (server on :5000)
# Usage: bash generate-task-files.sh <your-github-username>
set -u
BASE="http://localhost:5000"
GHUSER="${1:-YOUR_GITHUB_USERNAME}"

save() { { echo "Command:"; echo "$2"; echo; echo "Output:"; echo "$3"; } > "$1"; echo "wrote $1"; }

# Task 14 first (doesn't need the server)
CMD="curl -s https://api.github.com/repos/$GHUSER/expressBookReviews | jq '.parent.full_name'"
OUT=$(curl -s "https://api.github.com/repos/$GHUSER/expressBookReviews" | jq '.parent.full_name')
save githubrepo "$CMD" "$OUT"

# Task 1
CMD='curl http://localhost:5000/'
OUT=$(curl -s "$BASE/")
save getallbooks "$CMD" "$OUT"

# Task 2
CMD='curl http://localhost:5000/isbn/1'
OUT=$(curl -s "$BASE/isbn/1")
save getbooksbyISBN "$CMD" "$OUT"

# Task 3
CMD='curl http://localhost:5000/author/Jane%20Austen'
OUT=$(curl -s "$BASE/author/Jane%20Austen")
save getbooksbyauthor "$CMD" "$OUT"

# Task 4
CMD='curl http://localhost:5000/title/Fairy%20tales'
OUT=$(curl -s "$BASE/title/Fairy%20tales")
save getbooksbytitle "$CMD" "$OUT"

# Task 5
CMD='curl http://localhost:5000/review/1'
OUT=$(curl -s "$BASE/review/1")
save getbookreview "$CMD" "$OUT"

# Task 6
CMD='curl -X POST "http://localhost:5000/register" -H "Content-Type: application/json" -d '"'"'{"username":"testuser1","password":"Test@123"}'"'"''
OUT=$(curl -s -X POST "$BASE/register" -H "Content-Type: application/json" -d '{"username":"testuser1","password":"Test@123"}')
save register "$CMD" "$OUT"

# Task 7 (login, keep cookies for later steps)
CMD='curl -c cookies.txt -X POST "http://localhost:5000/customer/login" -H "Content-Type: application/json" -d '"'"'{"username":"testuser1","password":"Test@123"}'"'"''
OUT=$(curl -s -c cookies.txt -X POST "$BASE/customer/login" -H "Content-Type: application/json" -d '{"username":"testuser1","password":"Test@123"}')
save login "$CMD" "$OUT"

# Task 8 (add/modify review, needs cookie from login)
CMD='curl -b cookies.txt -X PUT "http://localhost:5000/customer/auth/review/1?review=Amazing%20read"'
OUT=$(curl -s -b cookies.txt -X PUT "$BASE/customer/auth/review/1?review=Amazing%20read")
save reviewadded "$CMD" "$OUT"

# Task 9 (delete review, needs cookie from login)
CMD='curl -b cookies.txt -X DELETE "http://localhost:5000/customer/auth/review/1"'
OUT=$(curl -s -b cookies.txt -X DELETE "$BASE/customer/auth/review/1")
save deletereview "$CMD" "$OUT"

echo
echo "Done. Files: getallbooks getbooksbyISBN getbooksbyauthor getbooksbytitle getbookreview register login reviewadded deletereview githubrepo"
