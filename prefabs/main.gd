extends Node

const player_scene = preload("res://prefabs/player.tscn")

# Anything inside this node is synchronized
@onready var sync_parent: Node3D = %Synchronized

var players: Dictionary = {}

var _my_player_entity: Node

func _ready():
	# Setup multiplayer
	#$RivetMultiplayerManager.transport = RivetMultiplayerManager.Transport.WEB_SOCKET 
	$RivetMultiplayerManager.setup_multiplayer()
	#multiplayer.peer_connected.connect(_on_peer_connected)
	#multiplayer.peer_disconnected.connect(_on_server_disconnected)
	$RivetMultiplayerManager.client_connected.connect(_on_client_connected)
	$RivetMultiplayerManager.client_disconnected.connect(_on_client_disconnected)
	#multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	# Setup menu
	if not $RivetMultiplayerManager.is_server:
		_update_ui_status("Idle")
		_fetch_regions()
		#$CanvasLayer/ChatPanel/Panel/ScrollContainer/ChatHistory.text = ""

# === Multiplayer ===
@rpc("authority","call_remote","reliable")
func _on_peer_connected(id: int):
	if not $RivetMultiplayerManager.is_server and id != 1 and id != multiplayer.get_unique_id():
		#print("_on_peer_connected | id: %d  multiplayer.get_unique_id(): %d" % [id, multiplayer.get_unique_id()])
		#await get_tree().create_timer(0.1).timeout # change this
		var player_character: = sync_parent.find_child( str(id), false, false)
		if is_instance_valid(player_character):
			pass#player_character.bark_sent.connect(_on_bark_sent)
		else:
			printerr("Peer connected to server, but couldn't find a player character with their unique_id ", id)

@rpc("authority","call_remote","reliable")
func _on_connected_to_server():
	_update_ui_status("Connected")
	%MainMenu.fade_show = false
	var player_character: = sync_parent.find_child( str(multiplayer.get_unique_id()), false, false)
	if is_instance_valid(player_character):
		%PlayerController.control_target = player_character
		_my_player_entity = player_character
	else:
		printerr("Connected to server, but couldn't find a player character with my unique_id ", multiplayer.get_unique_id())
		
	_my_player_entity.user_name = $CanvasLayer/MainMenu/VBoxContainer/Name.text
	_my_player_entity.portrait_index = $CanvasLayer/MainMenu/AvatarSelection.selection
	_my_player_entity.color = $CanvasLayer/MainMenu/VBoxContainer/ColorPickerButton.color
	
func _on_server_disconnected():
	_update_ui_status("Disconnected")
	%MainMenu.fade_show = true
	%PlayerController.control_target = null

# Called on only the server
func _on_client_connected(id: int):
	var player = player_scene.instantiate()
	player.name = str(id)
	players[id] = player
	print("Player added %s" % id)
	sync_parent.add_child.call_deferred( player )
	rpc_id.call_deferred(id, "_on_connected_to_server")
	rpc.call_deferred("_on_peer_connected", id)

# Called on only the server
func _on_client_disconnected(id: int):
	var player = players[id]
	if player != null:
		players.erase(id)
		print("Player removed %s" % id)
		player.queue_free()

# === UI===
var regions_data = null
var find_data = null

func _update_ui_status(status: String):
	var text = "[b]Status[/b] %s\n" % status
	text += "[b]Game Version[/b] %s\n" % Rivet.configuration.game_version
	text += "[b]Transport[/b] %s\n" % $RivetMultiplayerManager.Transport.keys()[$RivetMultiplayerManager.transport]
	if find_data != null:
		if find_data.is_ok():
			text += "[b]Lobby ID[/b] %s\n" % find_data.body.lobby.id
			text += "[b]Lobby Tags[/b] %s\n" % JSON.stringify(find_data.body.lobby.tags)
			text += "[b]Region[/b] %s\n" % find_data.body.lobby.region.name
		else:
			text += "[b]Find Error[/b] %s\n" % JSON.stringify(find_data.body)
	%LobbyStatus.text = text

func _fetch_regions():
	# Select a region
	regions_data = await Rivet.lobbies.list_regions({}).async()
	if !regions_data.is_ok():
		return
		
	# Update UI
	%RegionOption.clear()
	for region in regions_data.body.regions:
		%RegionOption.add_item(region.name)

func _on_find_lobby_pressed():
	# Find a lobby
	_update_ui_status("Waiting For Lobby")
	$CanvasLayer/MainMenu/VBoxContainer/FindLobby.disabled = true
	var region = regions_data.body.regions[%RegionOption.selected].slug
	find_data = await Rivet.lobbies.find_or_create({
		"version": Rivet.configuration.game_version,
		"regions": [region],
		"tags": {},
		"players": [{}],
		"createConfig": {
			"region": region,
			"tags": {},
			"maxPlayers": 32,
			"maxPlayersDirect": 32,
		}
	}).async()
	if !find_data.is_ok():
		_update_ui_status("Find Lobby Failed (See Logs)")
	$CanvasLayer/MainMenu/VBoxContainer/FindLobby.disabled = false
	

	# Open a network connection to the server
	_update_ui_status("Connecting")
	$RivetMultiplayerManager.connect_to_lobby(find_data.body.lobby, find_data.body.players[0])

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		match event.keycode:
			KEY_ENTER:
				%ChatBox/ChatInput.grab_focus()
			KEY_F1:
				%LobbyStatus.visible = not %LobbyStatus.visible
			KEY_ESCAPE:
				get_window().gui_release_focus()
	if event is InputEventMouseButton:
		get_window().gui_release_focus()
		


func _on_chat_input_text_submitted(new_text: String) -> void:
	if new_text != "":
		send_bark.rpc( new_text )
	else:
		get_window().gui_release_focus()
	$CanvasLayer/ChatBox/ChatInput.text = ""

@rpc("any_peer", "call_local")
func send_bark(text: String) -> void:
	var player_character: = sync_parent.find_child( str(multiplayer.get_remote_sender_id()), false, false)
	if is_instance_valid(player_character):
		%ChatBox.push_message( player_character.send_bark( text ) )
