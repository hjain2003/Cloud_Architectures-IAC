#Core logic
class OrderService:
    def __init__(self, order_repo: OrderRepositoryPort):
        self.repo = order_repo

    def place_order(self, order):
        # business logic here
        self.repo.save(order)
        return order.id
