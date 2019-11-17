print("You are using QuestHerald! type \\QuestHerald or \\qh to enable or disable quest audio.")

-- Adds references to the libraries used in the addon
QuestHerald = LibStub("AceAddon-3.0"):NewAddon("QuestHerald", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0")

-- Returned API variables 
local rtnval, handle, zoneName

-- Initializes the GUI and sets it to a variable
local AceGUI = LibStub("AceGUI-3.0")

-- Bools which determine which sounds will play
local checkPlayObjective = true
local checkPDescription = true

function QuestHerald:OnInitialize()
    --self:Print("WelcomeHome:OnInitialize!")
	-- Register Slash Commands
    QuestHerald:RegisterChatCommand("QuestHerald", "QuestHeraldShowGui")
    QuestHerald:RegisterChatCommand("qh", "QuestHeraldShowGui")
    QuestHerald:RegisterChatCommand("toggleDescription", "QuestHeraldtoggleDes")
    QuestHerald:RegisterChatCommand("toggleObjective", "QuestHeraldtoggleObj")
    QuestHerald:RegisterChatCommand("enableObjective", "EnableObj")
    QuestHerald:RegisterChatCommand("disableObjective", "DisableObj")
    QuestHerald:RegisterChatCommand("enableDescription", "EnableDes")
    QuestHerald:RegisterChatCommand("disableDescription", "DisableDes")
    QuestHerald:RegisterChatCommand("getLoc", "GetLoc")
end

function QuestHerald:OnEnable()
	--self:Print("Hello World!")
   -- Need to register the event for it to be caught
   -- when the API fires it.
	QuestHerald:RegisterEvent("QUEST_DETAIL")
	QuestHerald:RegisterEvent("QUEST_FINISHED")
	QuestHerald:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
	--self:Print("Goodbye World!")
 end

 

function QuestHerald:QUEST_DETAIL(event)
   questInfo = GetQuestID()
   self:playSounds(questInfo, checkPlayObjective, checkPDescription)
end

-- Used when a quest is closed or accepted
-- stops the current mp3 playing and cancells the 
-- timer which would play the objective
function QuestHerald:QUEST_FINISHED()
	--print("Hit QUEST_DETAIL")
	--print(handle)
	StopSound(handle)
	self:CancelAllTimers()
	--print("StopSound: ")

end

-- Used when a quest is Turned in
-- stops the current mp3 playing and cancells the 
-- timer which would play the objective
function QuestHerald:UNIT_QUEST_LOG_CHANGED()
	StopSound(handle)
	self:CancelAllTimers()
end


function QuestHerald:playSoundObjective(questId)
	rtnval, handle = PlaySoundFile("Interface/AddOns/QuestHerald/QuestAudio/" .. zoneName .. "/" .. questId .. "_Objective.mp3")

	if rtnval == nil then
		print('The quest ' .. questId .. " has yet to be implimented" )
	end
end


function QuestHerald:playSoundDescription(questId)
	rtnval, handle = PlaySoundFile("Interface/AddOns/QuestHerald/QuestAudio/" .. zoneName .. "/" .. questId .."_Description.mp3")

	if rtnval == nil then
		print('The quest ' .. questId .. " has yet to be implimented" )
	end
end

function QuestHerald:playWholeQuest(questId)
	rtnval, handle = PlaySoundFile("Interface/AddOns/QuestHerald/QuestAudio/" .. zoneName .. "/" .. questId .."_Description.mp3")
	
	self:ScheduleTimer("playSoundObjective", questTable[questId .."_Description.mp3"], questId)

	if rtnval == nil then
		print('The quest ' .. questId .. " has yet to be implimented" )
	end
end

function QuestHerald:playSounds(questId, playObjective, playDescription)
	 zoneName = GetZoneText();
	 zoneName = zoneName:gsub("%s+", "")
	 if playObjective == true and playDescription == true then
		 self:playWholeQuest(questId)
	 else
		 if playObjective == true then
			 self:playSoundObjective(questId)
		 end
		 if playDescription == true then
			 self:playSoundDescription(questId)
		 end
	 end
end

---------------------------------------------------------------------
-- Slash inputs
---------------------------------------------------------------------


-- Opens up the GUI to manually modify the play sounds bool
function QuestHerald:QuestHeraldSlash(input)
    input = string.trim(input, " ");
	
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("Example Frame")
	frame:SetStatusText("AceGUI-3.0 Example Container Frame")
end

function QuestHerald:QuestHeraldtoggleObj(input)
	checkPlayObjective = not checkPlayObjective
	print("Objective changed to " .. tostring(checkPlayObjective))
end

function QuestHerald:QuestHeraldtoggleDes(input)
	checkPDescription = not checkPDescription
	print("Description changed to " .. tostring(checkPDescription))
end


function QuestHerald:EnableObj(input)
	checkPlayObjective = true
	print("Playing Objective is set to" .. tostring(checkPlayObjective))
end


function QuestHerald:DisableObj(input)
	checkPlayObjective = false
	print("Playing Objective is set to" .. tostring(checkPlayObjective))
end



function QuestHerald:EnableDes(input)
	checkPDescription = true
	print("Playing Description is set to" .. tostring(checkPDescription))
end


function QuestHerald:DisableDes(input)
	checkPDescription = false
	print("Playing Description is set to" .. tostring(checkPDescription))
end

-- function QuestHerald:GetLoc(input)
	-- local zoneName = GetZoneText();
	-- message(zoneName);
-- end



---------------------------------------------------------------------
-- Gui Set up
---------------------------------------------------------------------


function QuestHerald:QuestHeraldShowGui(input)
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("Example Frame")
	frame:SetStatusText("QuestHerald - Quest Reader")
	frame:SetWidth(350)
	frame:SetHeight(200)
	frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	frame:SetLayout("Flow")
	
	
	local objectiveCheckBox = AceGUI:Create("CheckBox")
    objectiveCheckBox:SetLabel("Play Objective")
	objectiveCheckBox:SetDescription("True to listen to the quest Objective text")
    objectiveCheckBox:SetValue(checkPlayObjective)
	objectiveCheckBox:SetCallback("OnValueChanged",function()
        --frame:SetValue(not frame:GetValue())
		QuestHerald:QuestHeraldtoggleObj()
    end)
	frame:AddChild(objectiveCheckBox)
	
	local descriptionCheckBox = AceGUI:Create("CheckBox")
    descriptionCheckBox:SetLabel("Play Description")
	descriptionCheckBox:SetDescription("True to listen to the quest Description text")
    descriptionCheckBox:SetValue(checkPDescription)
	descriptionCheckBox:SetCallback("OnValueChanged",function()
        --frame:SetValue(not frame:GetValue())
		QuestHerald:QuestHeraldtoggleDes()
    end)
	frame:AddChild(descriptionCheckBox)
end

