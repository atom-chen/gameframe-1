local GameLogic 			= class('GameLogic')
local Cmd                   = require("Cmd")

function GameLogic:send_user_arrived_infos()
	local players = self:get_room_players()
	local users_info = {}
	for i = 1 , #players do
		users_info[#users_info + 1] = players[i]:get_user_arrived_info()
	end
	self:brodcast_in_room(Cmd.eUserArrivedInfos,{userinfo = users_info})
end

function GameLogic:send_user_state()
	local tmp_users_state = {}
	local players = self:get_room_players()
	for i = 1 , #players do
		tmp_users_state[#tmp_users_state + 1] = {seatid = players[i]:get_seat_id() , userstate = players[i]:get_state()}
	end
	local msg = {
		userstate = tmp_users_state
	}
	self:brodcast_in_room(Cmd.eAllUserState, msg)
end

function GameLogic:send_game_result()
    local msg = {score = {1,2,3,4}}
    self:brodcast_in_room(Cmd.eGameResult,msg)
end

function GameLogic:send_game_total_result()
    local msg = {score = {1,2,3,4}}
    self:brodcast_in_room(Cmd.eGameTotalResult,msg) 
end

function GameLogic:send_touzi_num()
	local tmp_touzi_nums = self:get_logic_data():get_touzi_nums()
	local tmp_bomb_nums =  self:get_logic_data():get_bomb_nums()
	local msg = {touzinums = tmp_touzi_nums , bombnums = tmp_bomb_nums}
	self:brodcast_in_room(Cmd.eTouZiNumRes, msg)
end

function GameLogic:send_click_bomb_seatid(seatid)
	self:brodcast_in_room(Cmd.eClickTouZiBombRes, {seatid = seatid})
end


return GameLogic