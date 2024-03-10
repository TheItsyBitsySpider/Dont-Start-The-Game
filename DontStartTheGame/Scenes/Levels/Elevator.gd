extends Area2D

func _ready():
	lock_elevator()
	body_entered.connect(get_parent().change_level)

func lock_elevator():
	monitorable = false
	monitoring = false
	
func unlock_elevator():
	monitorable = true
	monitoring = true
