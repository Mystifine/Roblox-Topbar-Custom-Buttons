-- made by Mystifine

local startergui = game:GetService("StarterGui")
local players = game.Players;

local player = players.LocalPlayer;
local playergui = player:WaitForChild('PlayerGui')

local custom_topbar_ui = script.custom_topbar;
custom_topbar_ui.Parent = playergui;

-- change this offset for larger gaps
local DEFAULT_OFFSET_PER_BUTTON = 42;

local START_POS_CHAT_OFF = 60;
local START_POS_CHAT_ON = 104;

local topbar_button = {}
topbar_button.__index = topbar_button;

local buttons = {};

local function get_button_index(button : ImageButton)
	-- find button position
	local index = 0;
	local located = false;
	while index < #buttons and not located do 
		index += 1;
		if buttons[index] == button then
			located = true;
		end
	end
	return index;
end

local function calculate_button_position_x(button : ImageButton)
	-- find button position
	local index = get_button_index(button);
	
	local start_pos = startergui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) and START_POS_CHAT_ON or START_POS_CHAT_OFF;
	for i = 1, index - 1 do 
		local b = buttons[i];
		if b.Visible then
			start_pos += (DEFAULT_OFFSET_PER_BUTTON + math.abs(b.AbsoluteSize.X-32))
		end
	end
	return start_pos;
end

local function update_button_positions_from(index)
	-- updates every button after this index
	for i = index + 1, #buttons do 
		local button = buttons[i];
		button.Position = UDim2.new(0,calculate_button_position_x(button),0,4)
	end
end

function topbar_button:SetText(text : string)
	self.button.button_text.Text = text;
end

function topbar_button:SetImageId(imageid : string)
	self.button.image_label.Image = imageid;
end

function topbar_button:ScaleIconSize(scale_factor : number)
	-- a value from 0 - 1
	self.button.image_label.Size = UDim2.new(scale_factor, 0, scale_factor, 0);
end

function topbar_button:SetVisible(visible : boolean)
	local index = get_button_index(self.button);

	self.button.Visible = visible;
	
	update_button_positions_from(index)
end

function topbar_button:SetButtonLength(length : number)
	local index = get_button_index(self.button);
	self.button.Size = UDim2.new(0,length,0,self.button.Size.Y.Offset);
	update_button_positions_from(index)
end

function topbar_button:Destroy()
	local index = get_button_index(self.button);
	
	table.remove(buttons, index);
	self.button:Destroy();
	
	update_button_positions_from(index);
end

function topbar_button:BindEvent(callback)
	return self.button.Activated:Connect(callback)
end

return {
	new = function(id : string)
		local new_button = script.button_template:Clone();
		new_button.Name = id or "Button"
		table.insert(buttons, new_button);
		new_button.Position = UDim2.new(0,calculate_button_position_x(new_button),0,4)
		new_button.Parent = custom_topbar_ui;
		
		new_button.MouseEnter:Connect(function()
			new_button.ImageTransparency = 0.2;
		end)
		
		new_button.MouseLeave:Connect(function()
			new_button.ImageTransparency = 0;
		end)

		local button = {
			button = new_button;	
		};
		setmetatable(button, topbar_button);
		return button;
	end,
	get_button_from_id = function(id : string)
		local button
		local i = 1;
		while button == nil and i <= #buttons do 
			
			local b = buttons[i];
			if b.Name == id then
				button = b;
			end
			
			i += 1;
		end
		return button
	end,
}
