extends Node2D


var leftInventorySlot
var rightInventorySlot

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	leftInventorySlot = $CanvasLayer/LeftInventorySlot
	rightInventorySlot = $CanvasLayer/RightInventorySlot
	
	$MainCharacter.pickedUpLeftObject.connect(leftInventorySlot.addItem)
	$MainCharacter.pickedUpRightObject.connect(rightInventorySlot.addItem)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
