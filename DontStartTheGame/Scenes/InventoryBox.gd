extends TextureRect

@onready var sprite := $ItemSprite
@onready var highlight_effect := $Highlight

var item_ID = null
var item_effect = null

func _ready():
	sprite.visible = false
	highlight_effect.visible = false

func _process(_delta):
	pass

func add_item(item):
	sprite.texture = item.texture
	sprite.visible = true
	item_ID = item.scene_ID
	item_effect = item.effect

func remove_item():
	sprite.texture = null
	sprite.visible = false
	item_ID = null
	item_effect = null

func highlight():
	highlight_effect.visible = true

func unhighlight():
	highlight_effect.visible = false
