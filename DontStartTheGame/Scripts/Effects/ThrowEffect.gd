extends Node2D

@export var required_object: PackedScene

func _on_area_2d_body_entered(body):
	if "collision_layer" not in body:
		return
	if body.collision_layer != 4:
		return
	if body.scene_file_path == required_object.resource_path:
		var parent = get_parent()
		parent.visible = false
		$SFX.play()
		await $SFX.finished
		parent.get_parent().remove_child(parent)
