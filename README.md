# Instruction for setup

# Language Version Required
* Ruby version : 2.4.2
* Rails version : 5.2.1

# Application Setup
* Database : MongoDB
* Clone this Git Repo : https://github.com/sapnamishra12/search_book_data.git
* Run Command : bundle install

# Database Creation & Populate Data
* Create : rails db:create
* Poupulate Model Data : rails model:populate

# API cURL Details

# User Aunthentication API

* First get token with below cURL request :

  curl --request POST \
    --url http://localhost:3000/user_authentication \
    --header 'Cache-Control: no-cache' \
    --header 'Postman-Token: 27f91045-e41a-4ddf-8bbe-3e8cdfd17926' \
    --header 'content-type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' \
    --form email=admin@example.com \
    --form password=admin@123

# Search API

* Pass token in header and call search api with below cURL request :

  curl --request GET \
    --url 'http://localhost:3000/search?search=Mark' \
    --header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNWI5YzhiNzUyN2U0ZGYxZTQ5YWJjN2JkIn0.-4mgETmp1o5S-Z2C71phUKDB24rh7oW9djtvebMeVWw' \
    --header 'Cache-Control: no-cache' \
    --header 'Postman-Token: c9fc8225-a89a-4d52-b96c-e75bc7f17b76'
