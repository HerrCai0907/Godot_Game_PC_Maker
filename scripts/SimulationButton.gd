extends Button

var componentDic:Dictionary = {} # {0:[..],1:[..],..}

var if_playing:bool = false

#-----------------------------------------------------------
#---------------------setget--------------------------------
#-----------------------------------------------------------

#-----------------------------------------------------------
#---------------------system--------------------------------
#-----------------------------------------------------------
func _ready():
	$StepButton.connect("pressed",self,"_on_step_button_pressed")
	$PlayButton.connect("pressed",self,"_on_play_button_pressed")
	$StopButton.connect("pressed",self,"_on_stop_button_pressed")

#-----------------------------------------------------------
#---------------------signal--------------------------------
#-----------------------------------------------------------
func _on_step_button_pressed():
	if self.get_tree().get_nodes_in_group("Map")[0].status != GlobalFunc.STATUS.simulation:
		return
	self._on_stop_button_pressed()
	self.simulation_main_process()
func _on_play_button_pressed():
	if self.get_tree().get_nodes_in_group("Map")[0].status != GlobalFunc.STATUS.simulation:
		$PlayButton.pressed = false
		return
	self.if_playing = true
	while self.if_playing:
		self.simulation_main_process()
		yield(get_tree().create_timer(0.5), "timeout")
func _on_stop_button_pressed():
	if self.get_tree().get_nodes_in_group("Map")[0].status != GlobalFunc.STATUS.simulation:
		return
	self.if_playing = false
	$PlayButton.pressed = false

func _pressed():
	# situation: simulation cannot start because status is not idle
	if self.pressed and self.get_tree().get_nodes_in_group("Map")[0].status != GlobalFunc.STATUS.idle:
		self.pressed = false
#		self.get_tree().call_group("Map","set_status",GlobalFunc.STATUS.idle)
		print("Simulation not Start")
		return
	# start or finish simulation
	if self.pressed:
		self.simulation_start()
		self.get_tree().call_group("Map","set_status",GlobalFunc.STATUS.simulation)
		self.simulation_main_process()
	else:
		self.get_tree().call_group("Map","set_status",GlobalFunc.STATUS.idle)
		self.simulation_finish()
		self._on_stop_button_pressed()

#-----------------------------------------------------------
#---------------------function------------------------------
#-----------------------------------------------------------
func simulation_start():
	self.componentDic.clear()
	# update link
#	for iNode in self.get_tree().get_nodes_in_group("Components"):
#		(iNode as BasisComponent).connection_update()
	self.get_tree().call_group_flags(2,"Components","connection_update")
	# create_structure_level for CalComponent
	var componentList:Array = self.get_tree().get_nodes_in_group("CalComponents")
	self.componentDic = self.create_structure_level(componentList)
	for iNode in self.componentDic["DFF"]:
		(iNode as CalculatedComponent).refresh()
func simulation_finish():
	self.get_tree().call_group("Components","_calculate_finished")
	self.if_playing = false
func simulation_main_process():
#	print(self.componentDic)
	for iNode in self.componentDic["DFF"]:
		(iNode as CalculatedComponent).precalculate()
	var level:int = 0
	while self.componentDic.has(level):
		for iNode in self.componentDic[level]:
			iNode.calculate()
		level += 1
	self.get_tree().call_group("Components","display_update")

func create_structure_level(local_componentList:Array):  # create level
	var openList:Array = []
	var closeList:Array = []
	var local_componentDic:Dictionary = {}
	# setup DFF
	local_componentDic["DFF"] = []
	for i in local_componentList:
		if (i as CalculatedComponent).CID == "DFF":
			self.add_into_array(i,closeList)
			local_componentDic["DFF"].append(i)
			for j in (i as CalculatedComponent).find_descendents():
				self.add_into_array(j,openList)
	# setup init open & close
	local_componentDic[0] = []
	for i in local_componentList:
		if (i as CalculatedComponent).IPDic.empty():
			self.add_into_array(i,closeList)
			local_componentDic[0].append(i)
			for j in (i as CalculatedComponent).find_descendents():
				self.add_into_array(j,openList)
	# start distinguish level
	var tmp_close_size:int = 0
	var calculation_level:int = 0
	while tmp_close_size != closeList.size():
		tmp_close_size = closeList.size()
		calculation_level += 1
		local_componentDic[calculation_level] = []
		for i in openList: # if one in openlist has no unknown input, move to closelist and put all the children into openlist
			var if_goto_close:bool = true
			for j in (i as CalculatedComponent).find_parents():
				if !closeList.has(j):
					if_goto_close = false
					break
			if if_goto_close:
				self.add_into_array(i,closeList)
				openList.erase(i)
				local_componentDic[calculation_level].append(i)
				if (i as CalculatedComponent).CID != "DFF":
					for j in (i as CalculatedComponent).find_descendents():
						self.add_into_array(j,openList)
	return local_componentDic

func add_into_array(value,list:Array):
	if !list.has(value) and value != null:
		list.append(value)




