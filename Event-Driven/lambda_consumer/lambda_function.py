import json

def handler(event, context):
    for record in event["Records"]:
        body = record["body"]
        print(f"Received message: {body}")
    return {"status": "ok"}
