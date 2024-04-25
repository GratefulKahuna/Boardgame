extends Node2D

var Notarbartolo = preload("res://scenes/players/Notarbartolo.tscn")
var Genius = preload("res://scenes/players/Genius.tscn")
var Speedy = preload("res://scenes/players/Speedy.tscn")
var King_of_keys = preload("res://scenes/players/King_of_keys.tscn")
var Monster = preload("res://scenes/players/Monster.tscn")

@onready var cop_outline = $"CopOutline-modified"
var all_players = [Notarbartolo, Genius, Speedy, King_of_keys, Monster]
var current_player_index = 0
var can_drag = true

var alarm_max = randi_range(4, 7)
var alarm_level = 0

@onready var cop_caution = $Cop_caution
@onready var caution_level_label = $Caution_level
@onready var phase1_music = $Phase_1
@onready var phase2_music = $Phase_2
@onready var phase3_music = $Phase_3
var current_music = "phase1"

@onready var label = $Label

# All tiles
@onready var Antwerp_world_diamond_centre = $"Antwerp world diamond centre"
@onready var Opera = $"Opera/1"
@onready var Cinema = $"Cinema/1"
@onready var Casino = $"Casino/1"
@onready var Cafe = $"Cafe/1"
@onready var Computer_store = $"Computer store/1"
@onready var Casino2 = $"Casino2/1"
@onready var Office = $"Office/1"
@onready var Bar = $"Bar/1"
@onready var Gold_smth = $"Gold smith/1"
@onready var Jeweler = $"Jeweler/1"
@onready var Diamond_dealer = $"Diamond dealer/1"
@onready var Hotel = $"Hotel/1"
@onready var Bank = $"Bank/1"
@onready var Gallery = $"Gallery/1"
@onready var Police_station = $"Police station/1"
@onready var Gold_dealer = $"Gold dealer/1"
@onready var Jewelry_store = $"Jewelry store/1"
@onready var Locksmith = $"Locksmith/1"
@onready var Jewelry_buyer = $"Jewelry buyer/1"
@onready var Watch_store = $"Watch store/1"
@onready var Community_center = $"Community center/1"
@onready var Justice_department = $"Justice department/1"
@onready var Synagogue = $"Synagogue/1"

@onready var all_tiles = [
Antwerp_world_diamond_centre,
Opera,
Cinema,
Casino,
Cafe,
Computer_store,
Casino2,
Office,
Bar,
Gold_smth,
Jeweler,
Diamond_dealer,
Hotel,
Bank,
Gallery,
Police_station,
Gold_dealer,
Jewelry_store,
Locksmith,
Jewelry_buyer,
Watch_store,
Community_center,
Justice_department,
Synagogue]

@onready var coll_dice1 = $"Die-1/die_area"
@onready var coll_dice2 =  $"Die-2/die_area_2"
@onready var coll_dice3 =  $"Die-3/die_area_3"
@onready var coll_dice4 =  $"Die-4/die_area_4"
@onready var coll_dice5 =  $"Die-5/die_area_5"
@onready var coll_dice6 =  $"Die-6/die_area_6"
@onready var coll_dice7 =  $"Die-7/die_area_7"
@onready var coll_dice8 =  $"Die-8/die_area_8"
@onready var coll_dice9 =  $"Die-9/die_area_9"
@onready var coll_dice10 =  $"Die-10/die_area_10"
@onready var coll_dice11 =  $"Die-11/die_area_11"
@onready var coll_dice12 =  $"Die-12/die_area_12"

@onready var all_dice = [
coll_dice1,
coll_dice2,
coll_dice3,
coll_dice4,
coll_dice5,
coll_dice6,
coll_dice7,
coll_dice8,
coll_dice9,
coll_dice10,
coll_dice11,
coll_dice12]

@onready var choose_dragged_screen = $choose_dragged

enum state {CHOOSING_TILE, DRAGGING_PLAYER, UNLOCK_ROLLING, INACTIVE}

var current_state = state.CHOOSING_TILE
var rolled_number = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for n in Global.player_tile_dict:
			Global.player_tile_dict[n] = Antwerp_world_diamond_centre
	for player in all_players:  
		Antwerp_world_diamond_centre.add_child(player.instantiate())
		
	var values = Global.tile_dict.values()
	for i in range(1,all_tiles.size()):
		all_tiles[i].set_texture(load(str("res://images/tiles/numbers/", values[i], ".png")))
	choose_tile_text()
	caution_level_label.push_color("green")
	caution_level_label.append_text("Clear")
	print(alarm_max)

func toggle_dice_areas():
	for die in all_dice:
		die.visible = !die.visible

func toggle_dragged_screen():
	choose_dragged_screen.visible = !choose_dragged_screen.visible
	label.visible = !label.visible


func choose_tile_text():
	label.clear()
	label.append_text("[center]Choose selected tile by " + Global.current_player + " "  + get_image()+"[/center]")

	
func choose_dice_text():
	label.clear()
	label.append_text("Choose selected dice by " + Global.current_player + " " + get_image())

func get_image():
	if Global.current_player == "King of keys":
		return "[img={width=60}]res://images/players/King_of_keys.png[/img]"
	return "[img={width=60}]res://images/players/" + Global.current_player + ".png[/img]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.allZeroes():
		label.clear()
		label.text = "All tiles unlocked"
		current_state = state.INACTIVE
	
	if alarm_level >= (alarm_max / 3):
		if alarm_level >= (alarm_max / 3) * 2 and current_music == "phase2":
			phase2_music.stop()
			phase3_music.play()
			current_music = "phase3"
			caution_level_label.clear()
			caution_level_label.push_color("red")
			caution_level_label.append_text("Alarmed")
			cop_caution.texture = preload("res://images/Alarm_meter/Alarmed.png")
		elif current_music == "phase1":
			phase1_music.stop()
			phase2_music.play()
			current_music = "phase2"
			caution_level_label.clear()
			caution_level_label.push_color("orange")
			caution_level_label.append_text("Cautious")
			cop_caution.texture = preload("res://images/Alarm_meter/cautious.png")
		

func move_player(tile, str):
	if Global.player_tile_dict[Global.current_player] != tile:
		Global.player_tile_dict[Global.current_player].get_tree().get_nodes_in_group(Global.current_player)[0].queue_free()
		
		Global.player_tile_dict[Global.current_player] = tile
		Global.player_tile_str_dict[Global.current_player] = str
		tile.add_child(all_players[current_player_index].instantiate())
	
		Global.player_dict[Global.current_player] = Global.tile_dict[Global.player_tile_str_dict[Global.current_player]]
	
	if(Global.current_player == "Monster"):
		toggle_dragged_screen()
		current_state = state.DRAGGING_PLAYER
	else:
		current_player_index += 1
		Global.nextPlayer()
		choose_tile_text()

	
func reduce_number(number):
	if(Global.player_tile_str_dict[Global.current_player] != "Antwerp_world_diamond_centre"):
		
		var current_num = Global.player_dict[Global.current_player] - number
		if (current_num <= 0):
			Global.tile_dict[Global.player_tile_str_dict[Global.current_player]] = 0
			Global.player_tile_dict[Global.current_player].set_texture(preload("res://images/tiles/open.png"))
			if(Global.current_player == "Monster"):
				current_state = state.CHOOSING_TILE
				toggle_dice_areas()
				current_player_index = 0
				Global.nextPlayer()
				choose_tile_text()
			else:
				current_player_index += 1
				Global.nextPlayer()
				choose_dice_text()
			
			return
		for player in Global.getALlPlayersOnThisTile():
			Global.player_dict[player] = current_num
		Global.tile_dict[Global.player_tile_str_dict[Global.current_player]] = current_num
		
		
		Global.player_tile_dict[Global.current_player].set_texture(load(str("res://images/tiles/numbers/", current_num, ".png")))
	
	if(Global.current_player == "Monster"):
		current_state = state.CHOOSING_TILE
		current_player_index = 0
		toggle_dice_areas()
		Global.nextPlayer()
		choose_tile_text()
	else:
		current_player_index += 1
		Global.nextPlayer()
		choose_dice_text()
		

func _on_die_area_clicked():
	if (current_state == state.UNLOCK_ROLLING):
		reduce_number(1)


func _on_die_area_2_clicked():
	if (current_state == state.UNLOCK_ROLLING):
		reduce_number(2)


func _on_die_area_3_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(3)


func _on_die_area_4_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(4)


func _on_die_area_5_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(5)


func _on_die_area_6_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(6)


func _on_die_area_7_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(7)


func _on_die_area_8_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(8)


func _on_die_area_9_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(9)


func _on_die_area_10_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(10)


func _on_die_area_11_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(11)


func _on_die_area_12_clicked():
	if (current_state == state.UNLOCK_ROLLING):reduce_number(12)


func drag_player(player_to_drag, player_to_drag_index):
	Global.player_tile_dict[player_to_drag].get_tree().get_nodes_in_group(player_to_drag)[0].queue_free()
	
	Global.player_tile_dict[player_to_drag] = Global.player_tile_dict["Monster"]
	Global.player_tile_str_dict[player_to_drag] = Global.player_tile_str_dict["Monster"]
	
	Global.player_tile_dict["Monster"].add_child(all_players[player_to_drag_index].instantiate())
	
	
	Global.player_dict[player_to_drag] = Global.player_dict["Monster"]
	toggle_dragged_screen()
	
	current_player_index = 0
	Global.nextPlayer()
	current_state = state.UNLOCK_ROLLING
	toggle_dice_areas()
	choose_dice_text()
	
func _on_notarbartolo_choice_clicked():
	if	(current_state == state.DRAGGING_PLAYER):
		drag_player("Notarbartolo", 0)


func _on_genius_choice_clicked():
	if	(current_state == state.DRAGGING_PLAYER):
		drag_player("Genius", 1)


func _on_speedy_choice_clicked():
	if	(current_state == state.DRAGGING_PLAYER):
		drag_player("Speedy", 2)


func _on_king_of_keys_choice_clicked():
	if	(current_state == state.DRAGGING_PLAYER):
		drag_player("King of keys", 3)


func _on_nobody_choice_clicked():
	if	(current_state == state.DRAGGING_PLAYER):
		toggle_dragged_screen()
		current_player_index = 0
		Global.nextPlayer()
		current_state = state.UNLOCK_ROLLING
		toggle_dice_areas()
		choose_dice_text()


func _on_opera_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Opera, "Opera")


func _on_cinema_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Cinema, "Cinema")


func _on_casino_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Casino, "Casino")


func _on_cafe_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Cafe, "Cafe")


func _on_computer_store_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Computer_store, "Computer_store")


func _on_casino_2_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Casino2, "Casino2")


func _on_office_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Office, "Office")


func _on_bar_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Bar, "Bar")


func _on_gold_smith_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Gold_smth, "Gold_smith")


func _on_jeweler_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Jeweler, "Jeweler")


func _on_diamond_dealer_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Diamond_dealer, "Diamond_dealer")


func _on_hotel_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Hotel, "Hotel")


func _on_antwerp_world_diamond_centre_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Antwerp_world_diamond_centre, "Antwerp_world_diamond_centre")


func _on_bank_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Bank, "Bank")


func _on_gallery_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Gallery, "Gallery")


func _on_police_station_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Police_station, "Police_station")


func _on_gold_dealer_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Gold_dealer, "Gold_dealer")


func _on_jewelry_store_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Jewelry_store, "Jewelry_store")


func _on_locksmith_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Locksmith, "Locksmith")


func _on_jewelry_buyer_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Jewelry_buyer, "Jewelry_buyer")


func _on_watch_store_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Watch_store, "Watch_store")


func _on_community_center_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Community_center, "Community_center")


func _on_justice_department_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Justice_department, "Justice_department")


func _on_synagogue_clicked():
	if	(current_state == state.CHOOSING_TILE):
		move_player(Synagogue, "Synagogue")


func _on_cop_clicked():
	alarm_level += 1
	cop_outline.visible = true
	await get_tree().create_timer(0.1).timeout
	cop_outline.visible = false
