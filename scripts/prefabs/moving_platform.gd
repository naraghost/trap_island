@tool
extends Node3D

@onready var platform:AnimatableBody3D = $platform

@onready var _point_in:Marker3D = $PointIn
@onready var _point_out:Marker3D = $PointOut
@onready var player_detector:Area3D = $player_detector

@export var move_in_editor:bool = true:
	set(value):
		move_in_editor = value
		if !value and Engine.is_editor_hint() and platform:
			target = 1
			progress = 0.0
			platform.position = point_in
			player_detector.position = platform.position
			time = 0.0
			is_waiting = false

@export var point_in:Vector3 = Vector3.ZERO:
	set(p_in):
		point_in = p_in
		_upd()
@export var point_out:Vector3 = Vector3.ZERO:
	set(p_out):
		point_out = p_out
		_upd()

@export var velocity:float = 3

var target:int = 1
var progress:float = 0.0

var wait_timer:float = 1.0
var time:float = 0.0
var is_waiting:bool = false

@export var platform_bounce:bool = false
var platform_direction:int = 1
var platform_bounce_progress:float = 0.0

func _upd():
	if _point_in != null:
		_point_in.position = point_in
		_point_out.position = point_out

var initial_position:Vector3 = Vector3.ZERO
func _ready():
	initial_position = position

func _process(delta):
	if is_waiting:
		time += delta
	
	if platform_bounce:
		platform_bounce_progress += delta * 4 * platform_direction
		platform_bounce_progress = clamp(platform_bounce_progress, 0.0, 1.0)
		
		position.y = lerp(initial_position.y, initial_position.y - .1, ease(platform_bounce_progress, -2))
		if platform_bounce_progress == 0.0 and platform_direction == -1:
			platform_bounce = false
		if platform_bounce_progress == 1.0 or platform_bounce_progress == 0.0:
			platform_direction *= -1
	
	if !is_waiting:
		progress += delta * velocity * target
		move_platform(delta)
	elif time >= wait_timer:
		is_waiting = false
		time = 0.0

func move_platform(delta:float):
	if move_in_editor or !Engine.is_editor_hint():
		if progress <= 0.0:
			progress = 0.0
			is_waiting = true
			target = 1
		if progress >= 1.0:
			progress = 1.0
			is_waiting = true
			target = -1
		platform.position = lerp(point_in,point_out,progress)
		player_detector.position = platform.position

func _on_player_detector_area_entered(body):
	platform_bounce = true
