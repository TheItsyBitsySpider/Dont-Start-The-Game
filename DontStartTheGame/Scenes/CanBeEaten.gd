extends Node2D

@export var EatSFX: Resource

signal effectPlayed

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().effect = EatEffect
	get_parent().effectNode = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func EatEffect(player):
	if EatSFX:
		player.playSound(EatSFX)
	effectPlayed.emit()
	return true
