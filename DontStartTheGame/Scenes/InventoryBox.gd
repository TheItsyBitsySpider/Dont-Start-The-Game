extends TextureRect

var spriteToUse
var effect
var itemID
var highlightBox

# Called when the node enters the scene tree for the first time.
func _ready():
	spriteToUse = $ItemSprite
	highlightBox = $Highlight
	highlightBox.visible = false
	spriteToUse.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addItem(item):
	spriteToUse.texture = item.texture
	spriteToUse.visible = true
	effect = item.effect
	itemID = item.sceneID

func removeItem():
	spriteToUse.texture = null
	spriteToUse.visible = false
	effect = null
	itemID = null

func makeHighlighted():
	highlightBox.visible = true

func unmakeHighlighted():
	highlightBox.visible = false
