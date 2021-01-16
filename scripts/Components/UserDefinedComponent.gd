class_name UserDefinedComponent
extends ComponentInMap

var loadData:Dictionary = {}
var calNodeList:Array = []
var cal_in_node_list:Dictionary = {}  # {PID : *calNode , ..}
var cal_out_node_list:Dictionary = {}

func _init(Pos=Vector2.ZERO,Deg=0,ID:String="ud_user://test").("Null",0,0,Pos,Deg):
	self.loadData = self.data_load(ID)
	var IO_num:Vector2 = self.data_analyze_step1()
	._init(ID,IO_num.x,IO_num.y,Pos,Deg)
	self.data_analyze_step2()
	self.data_analyze_step3()

func data_load(ID:String) -> Dictionary:
	var path = ID.right(3) + ".dat"
	var file = File.new()
	file.open(path,File.READ)
	var tmpData:Dictionary = str2var(file.get_as_text())
	file.close()
	return tmpData

func data_analyze_step1() -> Vector2: # statistic in/out IO number
	var IO_in_num:int = 0
	var IO_out_num:int = 0
	for level in self.loadData:
		for node in self.loadData[level]:
			if self.loadData[level][node]["CID"] == "IO_Input":
				IO_in_num += 1
			if self.loadData[level][node]["CID"] == "IO_Output":
				IO_out_num += 1
	return Vector2(IO_in_num,IO_out_num)
func data_analyze_step2(): # acc file create CalculatedComponent
	var lut:Dictionary = {} #{String : *CalculatedComponent,..}
	# create look-up table between CalculatedComponent and loadData.nodeID
	for ilevel in self.loadData:
		for inode in self.loadData[ilevel]:
			var tmp1 = CalculatedComponent.new()
			lut[inode] = tmp1
			self.add_child(tmp1)
			self.calNodeList.append(tmp1)
	for ilevel in self.loadData:
		for inode in self.loadData[ilevel]:
			var tmp1 = self.loadData[ilevel][inode]
			match tmp1["CID"]:
				"IO_Input":
					while self.cal_in_node_list.has(tmp1["IOName"]):
						tmp1["IOName"] += "*"
					self.cal_in_node_list[tmp1["IOName"]] = lut[inode].info_load(tmp1,lut)
				"IO_Output":
					while self.cal_out_node_list.has(tmp1["IOName"]):
						tmp1["IOName"] += "*"
					self.cal_out_node_list[tmp1["IOName"]] = lut[inode].info_load(tmp1,lut)
				_:
					lut[inode].info_load(tmp1,lut)
func data_analyze_step3(): # acc IOName Create Point ID
	var in_point_name_list:Array = self.cal_in_node_list.keys()
	in_point_name_list.sort()
	assert(in_point_name_list.size() == self.inPointList.size())
	for i in range(in_point_name_list.size()):
		var disID = Label.new()
		self.inPointList[i].PointID = in_point_name_list[i]
		disID.text = in_point_name_list[i]
		self.inPointList[i].add_child(disID)
	var out_point_name_list:Array = self.cal_out_node_list.keys()
	out_point_name_list.sort()
	assert(out_point_name_list.size() == self.outPointList.size())
	for i in range(out_point_name_list.size()):
		var disID = Label.new()
		self.outPointList[i].PointID = out_point_name_list[i]
		disID.text = out_point_name_list[i]
		self.outPointList[i].add_child(disID)

func display_update():
	for i in self.outPointList:
		i.display_value( self.cal_out_node_list[i.PointID].OPDic.values()[0]["value"] )
	for i in self.inPointList:
		i.display_value( self.cal_in_node_list[i.PointID].IPDic.values()[0]["value"] )

func connection_update():
	for key in self.cal_in_node_list:
		self.cal_in_node_list[key].IPDic.clear()
	for key in self.cal_out_node_list:
		self.cal_out_node_list[key].OPDic.clear()
	var pairPoint:Point
	var pairComponent:ComponentInMap
	
	for iPoint in self.inPointList:
		pairPoint = iPoint.find_pair()
		if pairPoint == null:
			self.cal_in_node_list[iPoint.PointID].IP_add(iPoint.PointID,null,null)
			continue
		pairComponent = pairPoint.linkedComponent
		self.cal_in_node_list[iPoint.PointID].IP_add(
			iPoint.PointID,
			pairComponent.get_cal_node(pairPoint),
			pairPoint.PointID)
	
	for iPoint in self.outPointList:
		pairPoint = iPoint.find_pair()
		if pairPoint == null:
			self.cal_out_node_list[iPoint.PointID].OP_add(iPoint.PointID,null,null)
			continue
		pairComponent = pairPoint.linkedComponent
		self.cal_out_node_list[iPoint.PointID].OP_add(
			iPoint.PointID,
			pairComponent.get_cal_node(pairPoint),
			pairPoint.PointID)

func get_cal_node(P:Point):
	if P.status == 0:
		return self.cal_in_node_list[P.PointID]
	elif P.status == 1:
		return self.cal_out_node_list[P.PointID]



