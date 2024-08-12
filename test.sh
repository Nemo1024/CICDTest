#!/bin/bash

#Check if input was provided
if [ -z "$1" ]; then
	echo "This script require an id: $0 <id>"
	exit 1
fi

id=$1

API_URL="https://7h06b7ir76.execute-api.eu-north-1.amazonaws.com/test"

response=$(curl -s -X GET "$API_URL?id=$id")

if [ -z "$response" ]; then
	echo "No data found for ID: $id"
else
	echo "$response"
fi
