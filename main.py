from typing import Self
from uuid import UUID, uuid4


class Name:
    def __init__(self: Self, id: UUID):
        self.id: UUID = id

    def __repr__(self: Self):
        return f"Name{self.id}"


name = Name(uuid4())

print(name)
