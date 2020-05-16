extends Sprite

export var shadows : bool = false

func _ready():
	$Light2D.show()
	$Light2D.shadow_enabled = shadows
