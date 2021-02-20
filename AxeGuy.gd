extends KinematicBody2D

var max_speed = 150
var acceleration = 800
var move = Vector2.ZERO
var on_target = false
var charging = false
onready var animation = get_node("AnimationPlayer")
onready var hit_area = get_node("HitArea")
onready var body = get_node("Body")
onready var miss = get_node("Miss")

func _physics_process(delta):
	
	#movement
	var axis = get_axis()
	if axis == Vector2.ZERO:
		apply_friction(acceleration * delta)  
	else: 
		apply_move(axis * acceleration * delta)
	move = move_and_slide(move)
	
	#running or idle 
	if (Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up")) and miss.visible == false:
		animation.play("move")
	elif Input.is_action_pressed("ui_accept") and miss.visible == false:
		charging = true
		animation.play("charge")
	
	elif charging == false:
		animation.play("idle")
	
	if Input.is_action_just_released("ui_accept"):
		if on_target:
			animation.play("chop")
			if body.flip_h == true:
				hit_area.play("left")
			else:
				hit_area.play("right")
		else:
			animation.play("missed")
	
	#sprite direction
	if Input.is_action_just_pressed("move_right"):
		body.flip_h = false
	if Input.is_action_just_pressed("move_left"):
		body.flip_h = true

#movement input 
func get_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

#friction 
func apply_friction(amount):
	if move.length() > amount:
		move -= move.normalized() * amount
	else:
		move = Vector2.ZERO

#movement
func apply_move(amount):
	move += amount
	move = move.clamped(max_speed)

func _on_Target_area_entered(_area):
	on_target = true

func _on_Target_area_exited(_area):
	on_target = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "chop" or anim_name == "missed":
		charging = false
