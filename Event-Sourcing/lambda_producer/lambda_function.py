import json
import os
import uuid
from datetime import datetime
import boto3

kinesis = boto3.client("kinesis")
STREAM = os.environ.get("STREAM_NAME", "orders-stream")

def lambda_handler(event, context):
    # If invoked from API Gateway you can accept payload from event.
    # For console test we create a sample event if fields missing.
    order_id = (event.get("orderId") if isinstance(event, dict) and event.get("orderId") else str(uuid.uuid4())[:8])

    evt = {
        "eventId": str(uuid.uuid4()),
        "type": event.get("type", "OrderCreated") if isinstance(event, dict) else "OrderCreated",
        "orderId": order_id,
        "data": event.get("data", {"items": [{"sku": "SKU-1", "qty": 1}], "total": 100}) if isinstance(event, dict) else {"items":[{"sku":"SKU-1","qty":1}], "total":100},
        "created_at": datetime.utcnow().isoformat() + "Z"
    }

    resp = kinesis.put_record(
        StreamName=STREAM,
        Data=json.dumps(evt).encode("utf-8"),
        PartitionKey=evt["orderId"]
    )

    print("PutRecord response:", resp)
    return {
        "statusCode": 200,
        "body": json.dumps({"event": evt, "putResponse": resp})
    }
