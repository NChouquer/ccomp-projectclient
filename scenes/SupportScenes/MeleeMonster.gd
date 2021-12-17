extends KinematicBody2D

export var speed = 300.0
onready var anim_tree = get_node("AnimationTree")
onready var anim_mode = anim_tree.get("parameters/playback")
var move_direction = Vector2(0.0,0.0)
var current_health
var max_health
var type
var EnemyState

func _ready():
	current_health = max_health
	
	
func prepareMonster(monster_data):
	
	max_health = monster_data["EnemyMaxHealth"]
	current_health = monster_data["EnemyHealth"]
	position = monster_data["EnemyLocation"]
	EnemyState = monster_data["EnemyState"]
	type = monster_data["EnemyType"]
	var local_data = DataImport.enemy_data[type]
	get_node("Sprite").texture = load("res://assets/sprites/"+local_data["sprt"])
	get_node("Sprite").region_enabled = true
	get_node("Sprite").region_rect = Rect2(local_data["reg_x"],local_data["reg_y"],local_data["reg_w"],local_data["reg_h"])
	if monster_data["EnemyState"] =="Dead":
		get_node("AnimationPlayer").stop()
		get_node("CollisionShape2D").set_deferred("disabled",true)
		
	
	
func update_health(new_amount):
	current_health = new_amount
	if current_health<=0:
		die()
		
func die():
	get_node("AnimationPlayer").stop()
	get_node("CollisionShape2D").set_deferred("disabled",true)
	queue_free()
	
func move_monster(new_position):
	position = new_position
	

