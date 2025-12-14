from abc import ABC, abstractmethod

class OrderRepositoryPort(ABC):
    @abstractmethod
    def save(self, order):
        pass

    @abstractmethod
    def get_by_id(self, order_id):
        pass
