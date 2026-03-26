class_name LaserEffect
extends Node2D

var start_point: Vector2
var end_point: Vector2
var duration: float = 0.05

func _init(_start: Vector2, _end: Vector2):
    start_point = _start
    end_point = _end

func _process(delta):
    duration -= delta
    if duration <= 0:
        queue_free()
    queue_redraw()

func _draw():
    draw_line(
        to_local(start_point),
        to_local(end_point),
        Color(0, 2, 0),
        2
    )