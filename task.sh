#!/bin/bash

# Define 3 colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
NC='\033[0m'       # No Color

# Defining some functions that will represent the tests:
#
# Function to compare JSON with CSV values
compareJSONcsv() {
    json_value=$(jq -r ".$1" <<<"$content")
    csv_value="$2"
    
    if [ "$json_value" != "$csv_value" ]; then
        echo -e "${Red}Failed${NC}"
        echo "Mismatch for $1: API value = '$json_value', CSV value = '$csv_value'"
        return 1
    else
        echo -e "${Green}Passed${NC}"
        echo "$1 is: '$json_value'"
        return 0
    fi
}

# Function to check if status of the request is OK (200)
checkStatusIsOK() {
    if [ "$1" -eq "200" ];then
        echo -e "${Green}Passed${NC}"
        return 0
    else
        echo -e "${Red}Failed${NC}"
        echo "Actual status code is $1"
        return 1
    fi
}

# Function to check if salary is >= 50000
checkSalaryOver50000(){
    if [ "$1" -ge '50000' ];then
        echo -e "${Green}Passed${NC}"
        return 0
    else
        echo -e "${Red}Failed${NC}"
        echo "Actual salary is $1"
        return 1
    fi

}
# Function to check if age is between 20 and 30
checkAge20s(){
    if [[ "$1" -lt 30 && "$1" -ge 20 ]];then
        echo -e "${Green}Passed${NC}"
        return 0
    else
        echo -e "${Red}Failed${NC}"
        echo "Actual age is $1"
        return 1
    fi
}

# Function to check if person is married
checkIsMarried(){
    if [ "$1" = 'true' ];then
        echo -e "${Green}Passed${NC}"
        return 0
    else
        echo -e "${Red}Failed${NC}"
        echo "Actual married status is $1" 
        return 1
    fi
}

# Checks if an input argument was provided to the script
if [ -z "$1" ];then
    echo "This script requires an id: $0 <id>"
    exit 1
fi

# Constants
id_value=$1
API_URL="https://7h06b7ir76.execute-api.eu-north-1.amazonaws.com/test"
CSV_FILE="input.csv" 



# Make the API call and store the JSON response
json_response=$(curl -s -w "\n%{http_code}"  -X GET "$API_URL?id=$id_value")
# echo $json_response
http_code=$(tail -n1 <<<"$json_response")
content=$(sed '$ d' <<<"$json_response")
# echo "--------------"
# echo "$http_code"
# echo "------------"
# echo "$content"

# Check if the API call was successful
if [ -z "$json_response" ]; then
    echo "Failed to get data from API."
    exit 1
fi

# Read the CSV file line by line, skipping the header
while IFS=, read -r id name country salary age married; do
    if [ "$id" == "$id_value" ]; then
        echo "Found matching row in CSV: id=$id, name=$name, country=$country, salary=$salary, age=$age, married=$married"
        
        # Here we call the test functions:
        echo "TEST 1"
        echo "Check name"
        compareJSONcsv "name" "$name"
        echo "---------------------"
        echo "TEST 2"
        echo "Check country"
        compareJSONcsv "country" "$country"
        echo "---------------------"
        echo "TEST 3"
        echo "Check salary"
        compareJSONcsv "salary" "$salary"
        echo "---------------------"
        echo "TEST 4"
        echo "Check age"
        compareJSONcsv "age" "$age"
        echo "---------------------"
        echo "TEST 5"
        echo "Check married"
        compareJSONcsv "married" "$married"
        echo "---------------------"
        echo "TEST 6"
        echo "Check status is ok"
        checkStatusIsOK "$http_code"
        echo "---------------------"
        echo "TEST 7"
        echo "Check salary over 50000"
        checkSalaryOver50000 "$salary"
        echo "---------------------"
        echo "TEST 8"
        echo "Check age is in 20s"
        checkAge20s "$age"
        echo "---------------------"
        echo "TEST 9"
        echo "Check is married"
        checkIsMarried "$married"
        echo "---------------------"


        exit 0
    fi
done < <(tail -n +2 "$CSV_FILE")  # Skip the header row

# If no match is found, notify the user
echo "No match found for id '$id_value' in the file '$csv_file'."


