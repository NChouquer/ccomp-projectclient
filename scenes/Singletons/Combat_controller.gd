extends Node

var projectile = preload("res://scenes/SupportScenes/Projectile.tscn")

func _ready():
	pass

func execute_skill(skill,target_id):
	#Server.FetchSkillDamage(skill,target_id,get_instance_id())
	Server.NPCHit(skill,target_id)

func shootProjectile(start_pos,direction,skill):
	var n_projectile = projectile.instance()
	n_projectile.position = start_pos
	Server.SendAttack(start_pos,direction,skill)
	n_projectile.prepare_projectile(direction,skill)
	get_parent().get_node("Client/Map").add_child(n_projectile)
