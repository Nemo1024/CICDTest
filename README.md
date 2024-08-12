# CICDTest

Instead of using an existing public API, I have created a lambda function that is hosted in AWS.
I have added the lambda funtion here called "lambdaFunction.py", it can be accessed at "https://7h06b7ir76.execute-api.eu-north-1.amazonaws.com/test?id=1"
The data inside is hardcoded, you need to provide an id as a parameter for GET request (?id=)

Note: The lambda function is for temporary use so I will shut it down after the review is done.

The main bash script is in test.sh
this script requires 1 argumet which is the the id of tested object
Example how to call it:
./task.sh 2

What the script does:
Inside the script we have a couple of functions which are representing the tests we want to run:
compareJSONCSV() - this function will be called for each field in the csv, it is comparing expected value from csv with actual value from api response
checkstatusisOK() - this function checks the status of the response is 200
checkSalaryOver50000() - this function check if the salary is over 50000
checkAge20s() - this function checks if age is in range(20-30)
checkIsMarried() - this function check if isMarried value is "True"

After the functions we read each value of the csv corresponding to the inputed id and call these tests.

Note: Some values in the input.csv are different from what is in the api, so that we can fail some tests on purpose.

testSuite.sh is a small script that calls test.sh with each input value from 1 to 10

A CI/CD solution could be to create a job called "test" that calls testSuite.sh script after all the necesary jobs have finished, like build, deploy ...

As an example I have created a Github workflow it is in .github/workflows/main.yml, the trigger action to run the workflows is on:push it has 2 jobs: first is "build" which should build the application ( here it has only a echo "build") and the second job called "test" which will run "bash testSuite.sh", both of these jobs run on a ubuntu server

