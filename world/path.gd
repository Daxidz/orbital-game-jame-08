extends Path2D

var started = false

func init():
	started = false
	$PathFollow2D.offset = 0

func _ready():
	set_process(true)

func _process(delta):
	if started:
		$PathFollow2D.offset = $PathFollow2D.offset + 300 * delta
