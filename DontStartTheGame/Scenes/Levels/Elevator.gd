extends Area2D

func _ready():
	lock_elevator()
	body_entered.connect(get_parent().change_level)

func lock_elevator():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	
func unlock_elevator():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
