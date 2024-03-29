extends TextureRect

@export var sprite: Resource
@export var sprite_selected: Resource
@export var description_to_show: RichTextLabel
@onready var item_sprite := $ItemSprite

var item_ID = null
var item_effect = null
var item_description := ""

func _ready():
	texture = sprite
	item_sprite.visible = false

func add_item(item):
	item_sprite.texture = item.texture
	item_sprite.visible = true
	item_ID = item.scene_ID
	item_effect = item.effect
	item_description = item.description

func remove_item():
	item_sprite.texture = null
	item_sprite.visible = false
	item_ID = null
	item_effect = null
	item_description = ""

func highlight():
	texture = sprite_selected

func unhighlight():
	texture = sprite

func show_description():
	description_to_show.get_parent().visible = true
	description_to_show.text = item_description

func hide_description():
	description_to_show.get_parent().visible = false
	description_to_show.text = ""
