extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_host_pressed():
	Network.connect("server_player_connected", self ,"_host_player_connected")
	var err = Network.create_server(Global.server.max_player, Global.server.port,{})
	if err != OK:
		return
		
func _host_player_connected(_player_network_unique_id : int, _player : Dictionary):
	get_tree().change_scene("res://gameplay/test/host/battle.tscn")
	
func _on_join_pressed():
	Network.connect("client_player_connected", self , "_client_player_connected")
	var err = Network.connect_to_server("192.168.100.162", Global.client.port , {})
	if err != OK:
		return
		
func _client_player_connected(_player_network_unique_id : int, _player : Dictionary):
	get_tree().change_scene("res://gameplay/test/client/battle.tscn")
	
