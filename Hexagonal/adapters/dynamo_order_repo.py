import boto3
from ports import OrderRepositoryPort

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Orders')

class DynamoOrderRepository(OrderRepositoryPort):
    def save(self, order):
        table.put_item(Item=order.to_dict())

    def get_by_id(self, order_id):
        response = table.get_item(Key={'id': order_id})
        return response.get('Item')
