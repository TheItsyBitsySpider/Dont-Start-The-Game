extends TextureRect

var spriteToUse

# Called when the node enters the scene tree for the first time.
func _ready():
	spriteToUse = null
	$ItemSprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addItem(item):
	$ItemSprite.texture = item.texture
	$ItemSprite.visible = true

func removeItem():
	$ItemSprite.texture = null
	$ItemSprite.visible = false
