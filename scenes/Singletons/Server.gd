extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 5000

func _ready():
	self.name = "Server"
	connectToServer()
	print(self.get_path())

func connectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	network.connect("connection_failed",self,"_OnConnectionFailed")
	network.connect("connection_succeeded",self,"_OnConnectionSucceeded")
	

func _OnConnectionFailed():
	print("Failed to connect")
	
func _OnConnectionSucceeded():
	print("Connected successfully")


func SendPlayerState(player_state):
	if get_node("../Client").current_scenename!="Map":
		return
	#print(player_state)
	rpc_unreliable_id(1,"ReceivePlayerState",player_state)
	
remote func ReceiveWorldState(world_state):
	#print(world_state)
	if get_node("../Client").current_scenename!="Map":
		return
	get_node("../Client/Map").UpdateWorldState(world_state)

remote func SpawnNewPlayer(player_id,spawn_position,username):
	if get_node("../Client").current_scenename!="Map":
		return
	get_node("../Client/Map").SpawnNewPlayer(player_id,spawn_position,username)

remote func DespawnPlayer(player_id):
	get_node("../Client/Map").DespawnPlayer(player_id)

	
func SendAttack(start_pos,direction,skill):
	if get_node("../Client").current_scenename!="Map":
		return
	rpc_id(1,"Attack",start_pos,direction,skill)

func ReceiveAttack(start_pos,direction,skill):
	pass

func SendChatMessage(message):
	if get_node("../Client").current_scenename!="Map":
		return
	rpc_id(1,"ReceiveChatMessage",message,OS.get_system_time_msecs())
	

func SendCreateAccount(username,password):
	rpc_id(1,"CreateAccount",username,password)
	
func SendLogIn(username,password):
	rpc_id(1,"LogIn",username,password)
	
remote func CreateAccountResponse(server_response,response_info,player_id):
	if get_tree().get_network_unique_id() != player_id:
		return
	if server_response==0:
		print("Account created, username "+ response_info["u"])
		get_node("../Client").switch_to_scene("Map",response_info)
	elif server_response ==1:
		print("Account already exists")
	
remote func LogInResponse(server_response,response_info,player_id):
	if get_tree().get_network_unique_id() != player_id:
		return
	if server_response==0:
		print("Account exists, username "+ response_info["u"])
		get_node("../Client").switch_to_scene("Map",response_info)
	elif server_response ==1:
		print("Wrong password")
	elif server_response == -1:
		print("User doesn't exist")


