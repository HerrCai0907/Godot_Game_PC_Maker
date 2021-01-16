class_name CalculatedComponent
extends Node

var IPDic:Dictionary = {} # {PName:{Component:*Component,PN:PName -> OPDic,Value:bool},..}
var OPDic:Dictionary = {} # {PName:{Component:*Component,PN:PName -> IPDic,Value:bool},..}
var CID:String = "" # basis type - e.g. Gate_And

var data:bool = false

var linkedDisplay = null

func _init(lCID:String="",lDisplay=null):
	self.add_to_group("CalComponents")
	self.CID = lCID
	if lDisplay != null:
		self.linkedDisplay = lDisplay

func IP_add(PName,linkedComponent,linkedPName): # can be used to modify connect
	self.IPDic[PName] = {
		"Component" : linkedComponent,
		"PN" : linkedPName,
		"value" : false
		}
	
func OP_add(PName,linkedComponent,linkedPName):
	self.OPDic[PName] = {
		"Component" : linkedComponent,
		"PN" : linkedPName,
		"value" : false
		}

func IP_update():
	for key in self.IPDic:
		self.IPDic[key]["value"] = (self.IPDic[key]["Component"] as CalculatedComponent).OPDic[self.IPDic[key]["PN"]]["value"]
func OP_update():
	for key in self.OPDic:
		if self.OPDic[key]["Component"] == null:
			continue
		(self.OPDic[key]["Component"] as CalculatedComponent).IPDic[self.OPDic[key]["PN"]]["value"] = self.OPDic[key]["value"]

func calculate():
	match self.CID:
		"Gate_And":
			self.OPDic[0]["value"] = self.IPDic[0]["value"] and self.IPDic[1]["value"]
		"Gate_Or":
			self.OPDic[0]["value"] = self.IPDic[0]["value"] or self.IPDic[1]["value"]
		"Gate_Not":
			self.OPDic[0]["value"] = !self.IPDic[0]["value"]
		"Pole_Positive":
			self.OPDic[0]["value"] = true
		"Pole_Negative":
			self.OPDic[0]["value"] = false
		"IO_Input":
			self.OPDic[0]["value"] = self.data
		"Gate_Proliferation":
			for key in self.OPDic:
				self.OPDic[key]["value"] = self.IPDic[0]["value"]
		"none":
			self.OPDic.values()[0]["value"] = self.IPDic.values()[0]["value"]
		"DFF":
			self.data = self.IPDic[0]["value"]
	
	self.OP_update()
	
#	var a := []
#	var b := []
#	for i in self.IPDic:
#		a.append( self.IPDic[i]["value"] )
#	for i in self.OPDic:
#		b.append( self.OPDic[i]["value"] )
#	print(self," type: ",self.CID," in:",a," out:",b)
	
func precalculate():
	match self.CID:
		"DFF":
			self.OPDic[0]["value"] = self.data
	self.OP_update()

func refresh():
	match self.CID:
		"DFF":
			self.data = false

func find_parents():
	var list:Array = []
	for iPN in self.IPDic:
		list.append(self.IPDic[iPN]["Component"])
	return list
func find_descendents():
	var list:Array = []
	for iPN in self.OPDic:
		list.append(self.OPDic[iPN]["Component"])
	return list


#-------------------------------------------------------------------
#------------------------save and load------------------------------
#-------------------------------------------------------------------

#	Node ID : {
#		componentID : 
#		(IOName : )
#		input_point : {
#			input_point_No : {
#				linkedcomponent : 
#				No : 
#			}
#			......
#		}
#		output_point : {
#			output_point_No : false
#			......
#		}
#	}
func info_save() -> Dictionary:
	var input_point := {}
	var output_point := {}
	var info_dic := {
		"CID" : self.CID,
		"input_point" : input_point,
		"output_point" : output_point
	}
	for iPN in self.IPDic: # PName:{Component:*Component,PN:PName -> OPDic,Value:bool}
		if self.IPDic[iPN]["Component"] == null or self.IPDic[iPN]["PN"] == null:
			continue
		input_point[iPN] = {
			"linkedcomponent" : self.IPDic[iPN]["Component"].to_string(),
			"No" : self.IPDic[iPN]["PN"]
			}
	for iPN in self.OPDic: # PName:{Component:*Component,PN:PName -> IPDic,Value:bool}
		if self.OPDic[iPN]["Component"] == null or self.OPDic[iPN]["PN"] == null:
			continue
		output_point[iPN] = {
			"linkedcomponent" : self.OPDic[iPN]["Component"].to_string(),
			"No" : self.OPDic[iPN]["PN"]
			}
	return info_dic

func info_load(info_dic:Dictionary,lut:Dictionary):
	var input_point:Dictionary = info_dic["input_point"]
	var output_point:Dictionary= info_dic["output_point"]
	
	match info_dic["CID"]:
		"IO_Input":
			self.CID = "none"
			self.IPDic = {
				0 : {
				"Component" : null,
				"PN" : null,
				"value" : false
				}
			}
			self.OPDic = {
				0 : {
				"Component" : lut[output_point[0]["linkedcomponent"]],
				"PN" : output_point[0]["No"],
				"value" : false
				}
			}
			return self
		"IO_Output":
			self.CID = "none"
			self.IPDic = {
				0 : {
				"Component" : lut[input_point[0]["linkedcomponent"]],
				"PN" : input_point[0]["No"],
				"value" : false
				}
			}
			self.OPDic = {
				0 : {
				"Component" : null,
				"PN" : null,
				"value" : false
				}
			}
			return self
		_:
			self.CID = info_dic["CID"]
			for iPN in input_point:
				if lut.has(input_point[iPN]["linkedcomponent"]):
					self.IPDic[iPN] = {
						"Component" : lut[input_point[iPN]["linkedcomponent"]],
						"PN" : input_point[iPN]["No"],
						"value" : false
					}
			for iPN in output_point:
				if lut.has(output_point[iPN]["linkedcomponent"]):
					self.OPDic[iPN] = {
						"Component" : lut[output_point[iPN]["linkedcomponent"]],
						"PN" : output_point[iPN]["No"],
						"value" : false
					}






















