extends Node2D

@export var itemPathToListenFor: String

signal letRuleKnow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func itemUsed():
	letRuleKnow.emit(1)
