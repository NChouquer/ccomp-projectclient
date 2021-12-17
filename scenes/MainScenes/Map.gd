extends Node2D

var player_spawn = preload("res://scenes/SupportScenes/OtherPlayer.tscn")
var enemy_spawn = preload("res://scenes/SupportScenes/Monster.tscn")
var last_world_state = 0
var start_args

func _ready():
	pass
	
func start_state(state,startargs = null):
	start_args = startargs
	if state =="Map":
		start_map()
		

func start_map():
	get_node("CanvasLayer/LoginScreen").set_process(false)
	get_node("CanvasLayer/LoginScreen").visible = false
	startPlayer(start_args)
	get_node("CanvasLayer/Chat_window").set_username(start_args["u"])

func startPlayer(user_info):
	var ply = get_node("Characters/Player")
	ply.username = user_info["u"]
	ply.get_node("Sprite/Username").text = user_info["u"]
	ply.position = Vector2(user_info["x"],user_info["y"])
	ply.visible = true
	ply.set_physics_process(true)

func SpawnNewPlayer(player_id,spawn_position,newusername):
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		if not get_node("Characters/OtherPlayers").has_node(str(player_id)):
			var new_player = player_spawn.instance()
			new_player.position = spawn_position
			new_player.name = str(player_id)
			get_node("Characters/OtherPlayers").add_child(new_player,true)
			new_player.setUsername(newusername)
		
	
func DespawnPlayer(player_id):
	get_node("Characters/OtherPlayers/"+str(player_id)).queue_free()
	
func UpdateWorldState(world_state):
	if world_state["T"]>last_world_state:
		last_world_state= world_state["T"]
		world_state.erase("T")
		world_state.erase(get_tree().get_network_unique_id())
		for player in world_state.keys():
			if str(player)=="Enemies":
				continue
			if str(player)=="Chat":
				continue
			if get_node("Characters/OtherPlayers").has_node(str(player)):
				get_node("Characters/OtherPlayers/"+str(player)).MovePlayer(world_state[player]["P"])
			else:
				print("Spawning player")
				SpawnNewPlayer(player,world_state[player]["P"],world_state[player]["U"])
		for enemy in world_state["Enemies"].keys():
			if get_node("Characters/Enemies").has_node(str(enemy)):
				var new_position = world_state["Enemies"][enemy]["EnemyLocation"]
				get_node("Characters/Enemies/"+str(enemy)).move_monster(new_position)
				get_node("Characters/Enemies/"+str(enemy)).EnemyState = world_state["Enemies"][enemy]["EnemyState"]
				get_node("Characters/Enemies/"+str(enemy)).update_health(world_state["Enemies"][enemy]["EnemyHealth"])
			else:
				if world_state["Enemies"][enemy]["EnemyState"]!="Dead":
					SpawnNewEnemy(enemy,world_state["Enemies"][enemy])
		getChatMessages(world_state["Chat"])

func getChatMessages(chat_state):
	get_node("CanvasLayer/Chat_window").clearLog()
	for chat_msg in chat_state:
		get_node("CanvasLayer/Chat_window").add_msg_to_log(chat_msg)


func SpawnNewEnemy(enemy_name,enemy_info):
	var new_enemy = enemy_spawn.instance()
	new_enemy.prepareMonster(enemy_info)
	new_enemy.name = str(enemy_name)
	get_node("Characters/Enemies").add_child(new_enemy,true)
	
