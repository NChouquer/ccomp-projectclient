extends RigidBody2D

var projectile_speed = 400
var life_time = 1
var skill = "basic_attack"

func _ready():
	SelfDestruct()

func prepare_projectile(source_direction,skl):
	rotation = rad2deg(source_direction.angle())
	skill = skl
	apply_impulse(Vector2(),Vector2(projectile_speed,0).rotated(rotation))
	
	
func SelfDestruct():
	yield(get_tree().create_timer(life_time),"timeout")
	queue_free()


func _on_Projectile_body_entered(body):
	get_node("CollisionPolygon2D").set_deferred("disabled",true)
	self.hide()
