extends TextureRect

@export var sprite: Resource
@export var sprite_selected: Resource
@onready var item_sprite := $ItemSprite

var item_ID = null
var item_effect = null

func _ready():
	texture = sprite
	item_sprite.visible = false

func add_item(item):
	item_sprite.texture = item.texture
	item_sprite.visible = true
	item_ID = item.scene_ID
	item_effect = item.effect

func remove_item():
	item_sprite.texture = null
	item_sprite.visible = false
	item_ID = null
	item_effect = null

func highlight():
	texture = sprite_selected

func unhighlight():
	texture = sprite
