extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 5000

var username
var password

func _ready():
	pass
	
	
func ConnectToServer(_username,_password):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	network.create_client(ip,port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_failed",self,"_OnConnectionFailed")
	network.connect("connection_succeded",self,"_OnConnectionSucceded")
	
func _OnConnectionFailed():
	print("Failed to connect to login server")
	print("Pop-up server offline")
	#get_node("../SceneHandler/Map/GUI/LoginScreen").login_button.disabled = false
	
func _OnConnectionSucceded():
	print("Successfully connected to the login server")
	
	
func RequestLogin():
	pass
	
	
remote func ReturnLoginResults():
	pass
