extends Path2D

func _ready():
	set_process(true)

func _process(delta):
	$PathFollow2D.offset = $PathFollow2D.offset + 300 * delta
