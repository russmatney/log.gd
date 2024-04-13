extends Resource
class_name TestPlayer

enum Role {Tank, DPS, Healer}

@export var name: String
@export var level: int
@export var role: Role
