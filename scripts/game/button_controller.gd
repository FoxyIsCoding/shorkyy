extends Control
var controller = load("res://scripts/shop/main_controller.gd")
var debugger = load("res://scripts/debugger.gd")
func _ready():
	load_inventory()

func _on_shop_btn_pressed():
	controller.save_shop()
	$audio/button.play()
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
	
func _on_menu_btn_pressed():
	controller.save_shop()
	$audio/button.play()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
		   

func load_inventory():
	if controller.femboys_owned > 0:
		# visibility stuff
		$femboy/femboy.visible = true
		$femboy/femboyCount.visible = true
		# text or whatever
		if controller.femboys_owned == 1:
			$femboy/femboyCount.text = str(controller.femboys_owned) + " Femboy"
		else:
			$femboy/femboyCount.text = str(controller.femboys_owned) + " Femboys"
	if controller.blahaj_owned > 0:
		# visibility stuff
		$blahaj/blahaj.visible = true
		$blahaj/blahajCount.visible = true
		# umm that text ye :3
		if controller.blahaj_owned == 1:
			$blahaj/blahajCount.text = str(controller.blahaj_owned) + " Blahaj"
		else:
			$blahaj/blahajCount.text = str(controller.blahaj_owned) + " Blahaj's"

	if controller.useless_coin_owned > 0:
		# visibility stuff
		$"useless coin/coins".visible = true
		$"useless coin/coinCount".visible = true
		# umm that text ye :3
		if controller.useless_coin_owned == 1:
			$"useless coin/coinCount".text = str(controller.useless_coin_owned) + " Coin"
		else:
			$"useless coin/coinCount".text = str(controller.useless_coin_owned) + " Coins's"
	
	
