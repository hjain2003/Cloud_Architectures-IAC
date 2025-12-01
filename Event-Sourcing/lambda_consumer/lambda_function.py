import os
import json
import base64
import boto3

dynamodb = boto3.client("dynamodb")
TABLE = os.environ.get("PROJECTION_TABLE", "orders-projection")

def lambda_handler(event, context):
    """
    Kinesis invokes the lambda with records in event['Records'].
    Each record has base64-encoded data at record['kinesis']['data'].
    """
    for rec in event.get("Records", []):
        try:
            kdata_b64 = rec["kinesis"]["data"]
            raw = base64.b64decode(kdata_b64)
            evt = json.loads(raw)
        except Exception as e:
            print("failed to decode/parse event:", e, "raw:", rec.get("kinesis", {}).get("data"))
            continue

        print("Processing event:", evt.get("type"), evt.get("eventId"))

        # Very simple projector: create/update order item in DynamoDB
        order_id = evt.get("orderId")
        if not order_id:
            print("no orderId, skipping")
            continue

        # store minimal projection (id, lastEventType, payload)
        try:
            dynamodb.put_item(
                TableName=TABLE,
                Item={
                    "orderId": {"S": order_id},
                    "lastEvent": {"S": evt.get("type", "unknown")},
                    "payload": {"S": json.dumps(evt.get("data", {}))}
                }
            )
        except Exception as e:
            print("DynamoDB put_item failed:", e)
            # do not crash the whole function for one record in demo; real production should handle retries
            continue

    return {"statusCode": 200}
