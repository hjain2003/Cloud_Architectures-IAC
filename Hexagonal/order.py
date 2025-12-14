# Domain object
class Order:
    def __init__(self, id, user_id, items):
        self.id = id
        self.user_id = user_id
        self.items = items

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'items': self.items
        }
