extends Node2D

@export var ruleText: String
@export var amount: int


var completed = false
var curCount = 0

signal ruleCompleted

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func addToCount():
	curCount += 1
	if curCount >= amount:
		completed = true
		ruleCompleted.emit()
