extends Node

var IngameMenu: Node2D
var _moneyLabel: Label
var _unitKilledLabel: Label
var _shotsFiredLabel: Label
var _buyMenu: PopupMenu

var store = [
	{
		"title": "Laser Tower (100 €)",
		"price": 100,
		"tower": LaserTower
	},
	{
		"title": "Rocket Tower (300 €)",
		"price": 300,
		"tower": RocketTower
	}
]

func ready():
	_moneyLabel = IngameMenu.find_child("Money")
	_moneyLabel.text = str(Money)
	_unitKilledLabel = IngameMenu.find_child("UnitsKilled")
	_unitKilledLabel.text = str(UnitsKilled)
	_shotsFiredLabel = IngameMenu.find_child("ShotsFired")
	_shotsFiredLabel.text = str(ShotsFired)
	var menu = IngameMenu.find_child("BuyMenu") as MenuButton
	_buyMenu = menu.get_popup()
	#_setupMenu()

	var buyLaserTowerButton = IngameMenu.find_child("BuyLaserTower") as TextureButton
	buyLaserTowerButton.pressed.connect(_on_buy.bind(0))
	var buyRocketTowerButton = IngameMenu.find_child("BuyRocketTower") as TextureButton
	buyRocketTowerButton.pressed.connect(_on_buy.bind(1))

func _setupMenu():
	_buyMenu.connect("id_pressed", Callable(self, "_on_buy"))
	for i in range(0, store.size()):
		var item = store[i]
		_buyMenu.add_item(item["title"], i)

var _money: float = 1000.0
var Money: float :
	get:
		return _money
	set(value):
		_money = value
		_moneyLabel.text = str(value)
var _health: int = 5
var Health: int:
	get:
		return _health
	set(value):
		_health = value
var _unit_killed: int = 0
var UnitsKilled : int :
	get:
		return _unit_killed
	set(value):
		_unit_killed = value
		_unitKilledLabel.text = str(value)
var _shots_fired: int = 0
var ShotsFired : int :
	get:
		return _shots_fired
	set(value):
		_shots_fired = value
		_shotsFiredLabel.text = str(value)

var HasPlacement: bool = false
var NewTower: Variant

func _on_buy(id):
	var item = store[id]
	var price = item["price"]
	if Money >= price:
		Money -= price
		HasPlacement = true
		NewTower = item["tower"]
