extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_elevator()
	body_entered.connect(get_parent().change_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lock_elevator():
	monitorable = false
	monitoring = false
	
func unlock_elevator():
	monitorable = true
	monitoring = true
