extends Area2D

var is_locked := true

func _ready():
	lock_elevator()
	body_entered.connect(get_parent().change_level)

func lock_elevator():
	is_locked = true
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	
func unlock_elevator():
	is_locked = false
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
