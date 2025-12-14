from order_service import OrderService
from adapters.rds_order_repo import RdsOrderRepository
from domain.order import Order
import uuid

# Initialize repository and core service
repo = DynamoOrderRepositoryy()
service = OrderService(repo)

def lambda_handler(event, context):
    # Example: create an order from event data
    order = Order(
        id=str(uuid.uuid4()),
        user_id=event['user_id'],
        items=event['items']
    )

    order_id = service.place_order(order)
    
    return {
        "statusCode": 200,
        "body": {"order_id": order_id}
    }
