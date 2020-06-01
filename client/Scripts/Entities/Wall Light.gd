extends Sprite

export var shadows : bool = false
export var energy : float = 1.1

func _ready():
	$Light2D.show()
	$Light2D.shadow_enabled = shadows
	$Light2D.energy = energy
