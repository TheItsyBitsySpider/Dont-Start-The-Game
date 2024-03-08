extends Sprite2D


var player = null
var popupNode
var sceneID

func _ready():
	popupNode = $Popup
	sceneID = scene_file_path

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	player = body
	player.nearbyItems.append(self)
	popupNode.visible = true
	


func _on_area_2d_body_exited(body):
	player.nearbyItems.erase(self)
	player = null
	popupNode.visible = false
