@tool
extends Node3D

@onready var platform:AnimatableBody3D = $platform

@onready var _point_in:Marker3D = $PointIn
@onready var _point_out:Marker3D = $PointOut

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

var plat_y_target:float = 0.0

func _upd():
	if _point_in != null:
		_point_in.position = point_in
		_point_out.position = point_out

func _process(delta):
	if is_waiting:
		time += delta
	
	if !is_waiting:
		progress += delta * velocity * target
		move_plataform(delta)
	elif time >= wait_timer:
		is_waiting = false
		time = 0.0
	

func platform_bounce():
	pass

func move_plataform(delta:float):
	if progress <= 0.0:
		progress = 0.0
		is_waiting = true
		target = 1
	if progress >= 1.0:
		progress = 1.0
		is_waiting = true
		target = -1
	platform.position = lerp(point_in,point_out,progress)

	#if abs(point_in.z - plataform.position.z) <= 0.1:
		#target = 1
	#elif abs(point_out.z - plataform.position.z) <= 0.1:
		#target = -1
	#if target == 1:
		#plataform.position = lerp(plataform.position,point_out,delta * velocity)
	#if target == -1:
		#plataform.position = lerp(plataform.position,point_in,delta * velocity)
