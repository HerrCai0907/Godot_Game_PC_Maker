class_name BasisComponent
extends ComponentInMap

var calNode:CalculatedComponent

func _init(ID="Null", inSize=0, outSize=0, Pos=Vector2.ZERO, Deg=0).(ID,inSize,outSize,Pos,Deg):
	# create calculation info
	self.calNode = CalculatedComponent.new(ID,self)
	self.add_child(self.calNode)
	
	var num:int = 0
	for InP in self.inPointList:
		InP.PointID = num
		num += 1
	num = 0
	for OutP in self.outPointList:
		OutP.PointID = num
		num += 1

func display_update():
	# display in/out point value
	for i in self.outPointList:
		i.display_value( self.calNode.OPDic[i.PointID]["value"] )
	for i in self.inPointList:
		i.display_value( self.calNode.IPDic[i.PointID]["value"] )

func connection_update():
	self.calNode.IPDic.clear()
	self.calNode.OPDic.clear()
	var pairPoint:Point
	var pairComponent:ComponentInMap
	
	for iPoint in self.inPointList:
		pairPoint = iPoint.find_pair()
		if pairPoint == null:
			self.calNode.IP_add(iPoint.PointID,null,null)
			continue
		pairComponent = pairPoint.linkedComponent
		self.calNode.IP_add(
			iPoint.PointID,
			pairComponent.get_cal_node(pairPoint),
			pairPoint.PointID)
	
	for iPoint in self.outPointList:
		pairPoint = iPoint.find_pair()
		if pairPoint == null:
			self.calNode.OP_add(iPoint.PointID,null,null)
			continue
		pairComponent = pairPoint.linkedComponent
		self.calNode.OP_add(
			iPoint.PointID,
			pairComponent.get_cal_node(pairPoint),
			pairPoint.PointID)
#	print(self.componentID)
#	print(self.calNode.IPDic)
#	print(self.calNode.OPDic)

func get_cal_node(P):
	return self.calNode










