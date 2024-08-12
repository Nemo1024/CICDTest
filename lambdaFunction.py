import json

# Sample data (you would typically fetch this data from a database)


def lambda_handler(event, context):
    print(event)
    
    data = [
    {"id": "1", "name": "John Doe", "country": "USA", "salary": 50000, "age": 28, "married": True},
    {"id": "2", "name": "Jane Smith", "country": "Canada", "salary": 60000, "age": 32, "married": True},
    {"id": "3", "name": "Juan Perez", "country": "Mexico", "salary": 45000, "age": 25, "married": False},
    {"id": "4", "name": "Alice Johnson", "country": "UK", "salary": 52000, "age": 29, "married": False},
    {"id": "5", "name": "Ming Li", "country": "China", "salary": 55000, "age": 31, "married": True},
    {"id": "6", "name": "Franz Muller", "country": "Germany", "salary": 48000, "age": 27, "married": False},
    {"id": "7", "name": "Olivia Brown", "country": "Australia", "salary": 53000, "age": 30, "married": False},
    {"id": "8", "name": "Luca Rossi", "country": "Italy", "salary": 49000, "age": 26, "married": True},
    {"id": "9", "name": "Ines Garcia", "country": "Spain", "salary": 51000, "age": 33, "married": True},
    {"id": "10", "name": "Hiro Tanaka", "country": "Japan", "salary": 56000, "age": 34, "married": True},
]
    inputId = event['queryStringParameters']['id']
    print(inputId)
    if not inputId.isdecimal():
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Id is not a number"})
        }
    else:
        result = next((item for item in data if item['id']==inputId), None)
    
        if result:
            return {
                "statusCode": 200,
                "body": json.dumps(result)
            }
        else:
            return {
                "statusCode": 404,
                "body": json.dumps({"error": "Record not found"})
            }
