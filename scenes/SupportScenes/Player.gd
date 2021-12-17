extends KinematicBody2D

export var speed = 700.0
export var max_health = 100
export var atk = 10
export var def = 10
onready var anim_tree = get_node("AnimationTree")
onready var anim_mode = anim_tree.get("parameters/playback")
var move_direction = Vector2(0.0,0.0)
var current_health
var is_moving = false
export var is_attacking = false
var player_state
var rate_of_fire = 30
var username= ""



func _ready():
	current_health = max_health
	get_node("Camera2D").current = true
	set_physics_process(false)
	
func update_health(amount):
	current_health = UtilityFunctions.mid(0,current_health + amount,max_health)
	if current_health==0:
		die()
		
func die():
	print("ded")
	

func _unhandled_input(event):
	var input_vector
	if event is InputEvent:
		input_vector = Vector2(
		Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up"))
		
		move_direction=input_vector.normalized()
		if move_direction.x!=0 or move_direction.y!=0:
			anim_tree.set("parameters/Idle/blend_position",move_direction)
		anim_mode.travel("Walk")
		
		if Input.is_action_pressed("ui_accept"):
			if is_attacking == false:
				#is_attacking = true
				CombatController.shootProjectile(position,move_direction,"basic_attack")
				
		

func _physics_process(delta):
	characterMovement(delta)
	DefinePlayerState()
		
func characterMovement(delta):

	move_and_slide(speed*move_direction)
	anim_tree.set("parameters/Walk/blend_position",move_direction)
		
	if move_direction.x==0.0 and move_direction.y==0.0:
		anim_mode.travel("Idle")


func DefinePlayerState():
	player_state = {"T":OS.get_system_time_msecs(),"P":get_global_position(),"U":username}
	Server.SendPlayerState(player_state)
