extends KinematicBody2D

export var speed = 700.0
export var max_health = 100
export var atk = 10
export var def = 10
onready var anim_tree = get_node("AnimationTree")
onready var anim_mode = anim_tree.get("parameters/playback")
var move_direction = Vector2(0.0,0.0)
var current_health
var player_name : String


func MovePlayer(pos):
	position = pos
	
func setUsername(username):
	player_name = username
	get_node("Sprite/Username").text = username
