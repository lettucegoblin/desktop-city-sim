extends Window

var winDrag : bool
var startPos : Vector2
var offset : Vector2
var hold_time : float
var hold_candidate : bool
var cTheme : int
@onready var mainWindow : Window = get_tree().get_root()

@onready var origo = %Panel.get_viewport_rect().size / 2 #.rect_size/2
@onready var pointer = {"second" : Vector2(origo.x - 8,0), "minute" :  Vector2(origo.x - 16,0), "hour" : Vector2(origo.x - 24,0)}
@onready var themeSets = {"0" : {"panelRadius" : 40, "panelColor" : Color("#62000000"), "lcd" : Color.AQUA, "tick" : Color.WHITE, "second" : Color(1,1,1,0.5), "minute" : Color("ece8e680"), "hour" : Color("8888f8")},
						 "1" : {"panelRadius" :  8, "panelColor" : Color("#6ff22222"), "lcd" : Color(1,1,1,.8), "tick" : Color.WHITE_SMOKE, "second" : Color.BLACK, "minute" : Color.GRAY, "hour" : Color(.8,.2,.2,1)},
						 "2" : {"panelRadius" : 64, "panelColor" : Color(.1,.1,1.0,.5), "lcd" : Color.LIGHT_BLUE, "tick" : Color(.7,.7,1), "second" : Color.DARK_BLUE, "minute" : Color.LIGHT_GRAY, "hour" : Color.WHITE},
						 "3" : {"panelRadius" : 64, "panelColor" : Color(.1,.1,1.0,0), "lcd" : Color(0,0,0,0), "tick" : Color(.7,.7,1), "second" : Color(0,0,0,0), "minute" : Color.LIGHT_GRAY, "hour" : Color.WHITE},
						 "4" : {
							"panelRadius" : 0, 
							"panelColor" : Color(.1,.1,1.0,0), 
							"lcd" : Color(0.1,1,0.1,1), 
							"tick" : Color(0,0,0,0), 
							"second" : Color(0,0,0,0), 
							"minute" : Color(0,0,0,0), 
							"hour" : Color(0,0,0,0)}}

func _ready():
	
	setPanel()
	setTicks()
	loadCfg()
	
func _on_Timer_timeout():
	var h : float  = Time.get_time_dict_from_system().hour
	var m : float  = Time.get_time_dict_from_system().minute
	var s : float = Time.get_time_dict_from_system().second
	$Panel/lblTime.text = str(h) + ":" + "%02d" % m + ":" + "%02d" % s
	$Panel/lineSec.points[1] = origo + (pointer.second).rotated((1.5 + s/30) * PI)
	$Panel/lineMin.points[1] = origo + (pointer.minute).rotated((1.5 + (m + s/60)/30) * PI)
	$Panel/lineHour.points[1] = origo + (pointer.hour).rotated((1.5 + (h + m/60)/6) * PI)

func setPanel():
	mainWindow.set_transparent_background(true)
	mainWindow.always_on_top = true
	$Panel.visible = false
	await get_tree().create_timer(1).timeout
	$Panel.visible = true
	
func setTicks():
	pass

func loadCfg():
	var config = ConfigFile.new()
	var err = config.load("user://desktopClock.cfg")
	if err == OK:
		mainWindow.window_position = config.get_value("Recent", "position", Vector2(400,400))
		cTheme = config.get_value("Recent", "theme", 0) - 1
	chgTheme()
	
func saveCfg():
	var config = ConfigFile.new()
	config.set_value("Recent", "position", mainWindow.window_position)
	config.set_value("Recent", "theme", cTheme)
	config.save("user://desktopClock.cfg")

func chgTheme():
	pass
	
func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_left") and not Input.is_action_just_released("mouse_left"):
		winDrag = true
		startPos = mainWindow.get_global_mouse_position()
		offset = mainWindow.rect_position - startPos
	if Input.is_action_just_released("mouse_left"):
		winDrag = false
		saveCfg()
	if winDrag: mainWindow.window_position = mainWindow.window_position +  mainWindow.get_global_mouse_position() + offset
	if hold_candidate: hold_time = hold_time + delta
	if Input.is_action_just_pressed("mouse_right"):
		hold_candidate = true
		hold_time = 0.0
	if Input.is_action_just_released("mouse_right"):
		if hold_time <1:
			chgTheme()
			saveCfg()
			hold_candidate = false
		else: get_tree().quit()
	#$Panel/exitLine.visible = hold_time > 1
