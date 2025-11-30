import boto3
import os
import json
import uuid
from datetime import datetime

sqs = boto3.client("sqs")
QUEUE_URL = os.environ.get("QUEUE_URL")

def lambda_handler(event, context):
    payload = {
        "id": str(uuid.uuid4()),
        "created_at": datetime.utcnow().isoformat() + "Z",
        "type": "demo.event",
        "data": {"message": "hello from producer"}
    }

    resp = sqs.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=json.dumps(payload)
    )

    return {
        "statusCode": 200,
        "body": json.dumps({"messageId": resp.get("MessageId")})
    }
