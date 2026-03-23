extends Node

const MIN_ZOOM: Vector2 = Vector2(0.1, 0.1)
const MAX_ZOOM: Vector2 = Vector2(10.0, 10.0)

var cam: Camera2D
var zoom_speed: float = 2.0


func _ready():
	cam = Camera2D.new()
	cam.position = Vector2.ZERO
	add_child(cam)


func _physics_process(delta):
	handle_zooming(delta)


func handle_zooming(delta):
	var zoom_dir: float = 0
	if Input.is_action_just_pressed("scroll_up"):
		zoom_dir += zoom_speed
	if Input.is_action_just_pressed("scroll_down"):
		zoom_dir -= zoom_speed
	var zoom = cam.zoom + Vector2(zoom_dir, zoom_dir) * delta
	cam.zoom = zoom.clamp(MIN_ZOOM, MAX_ZOOM)
