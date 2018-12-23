local Room = logic_server_global_table.Room or {}

--[[
1.做牌
2.投色子
3.发牌
4.定财神
5.补花
6.出牌
7.吃椪柑（子步骤）
8.大小结算
]]

function Room:init_step_func()
	self._start_game_step_handler_map =
	{
		[Room.GameStep.GAME_STEP_NONE] 				= self.start_step_none,
		[Room.GameStep.GAME_STEP_START_GAME] 		= self.start_step_start_game,
		[Room.GameStep.GAME_STEP_ANTE] 				= self.start_step_ante,
		[Room.GameStep.GAME_STEP_SPECF_MAH] 		= self.start_step_specf_mah,
		[Room.GameStep.GAME_STEP_THROW_CHIP_1] 		= self.start_step_throw_chip_1,
		[Room.GameStep.GAME_STEP_THROW_CHIP_2] 		= self.start_step_throw_chip_2,
		[Room.GameStep.GAME_STEP_TAKE_FIRST] 		= self.start_step_take_first,
		[Room.GameStep.GAME_STEP_THROW_CHIP_3] 		= self.start_step_throw_chip_3,
		[Room.GameStep.GAME_STEP_OPEN_MAH] 			= self.start_step_open_mah,
		[Room.GameStep.GAME_STEP_FIRST_REPLACE] 	= self.start_step_first_replace,
		[Room.GameStep.GAME_STEP_PLAY_MAH] 			= self.start_step_play_mah,
		[Room.GameStep.GAME_STEP_WIN_LOST] 			= self.start_step_win_lost,
		[Room.GameStep.GAME_STEP_END_GAME] 			= self.start_step_end_game,
	}

	self._stop_game_step_handler_map = 
	{
		[Room.GameStep.GAME_STEP_START_GAME] 		= self.stop_step_start_game,
		[Room.GameStep.GAME_STEP_ANTE] 				= self.stop_step_ante,
		[Room.GameStep.GAME_STEP_SPECF_MAH] 		= self.stop_step_specf_mah,
		[Room.GameStep.GAME_STEP_THROW_CHIP_1] 		= self.stop_step_throw_chip_1,
		[Room.GameStep.GAME_STEP_THROW_CHIP_2] 		= self.stop_step_throw_chip_2,
		[Room.GameStep.GAME_STEP_TAKE_FIRST] 		= self.stop_step_take_first,
		[Room.GameStep.GAME_STEP_THROW_CHIP_3] 		= self.stop_step_throw_chip_3,
		[Room.GameStep.GAME_STEP_OPEN_MAH] 			= self.stop_step_open_mah,
		[Room.GameStep.GAME_STEP_FIRST_REPLACE] 	= self.stop_step_first_replace,
		[Room.GameStep.GAME_STEP_PLAY_MAH] 			= self.stop_step_play_mah,
		[Room.GameStep.GAME_STEP_WIN_LOST] 			= self.stop_step_win_lost,
		[Room.GameStep.GAME_STEP_END_GAME] 			= self.stop_step_end_game,
	}

	self._start_game_sub_step_handler_map = 
	{
		[Room.GameSubStep.GAME_SUB_STEP_NONE] 				= self.start_sub_step_none,
		[Room.GameSubStep.GAME_SUB_STEP_WAIT_RESP] 			= self.start_sub_step_wait_resp,
		[Room.GameSubStep.GAME_SUB_STEP_WAIT] 				= self.start_sub_step_wait,
		[Room.GameSubStep.GAME_SUB_STEP_TAKE] 				= self.start_sub_step_take,
		[Room.GameSubStep.GAME_SUB_STEP_PLAY] 				= self.start_sub_step_play,
		[Room.GameSubStep.GAME_SUB_STEP_CHOW] 				= self.start_sub_step_chow,
		[Room.GameSubStep.GAME_SUB_STEP_PUNG] 				= self.start_sub_step_pung,
		[Room.GameSubStep.GAME_SUB_STEP_TKONG] 				= self.start_sub_step_tkong,
		[Room.GameSubStep.GAME_SUB_STEP_MKONG] 				= self.start_sub_step_mkong,
		[Room.GameSubStep.GAME_SUB_STEP_CKONG] 				= self.start_sub_step_ckong,
		[Room.GameSubStep.GAME_SUB_STEP_CANCEL] 			= self.start_sub_step_cancel,
		[Room.GameSubStep.GAME_SUB_STEP_REPLACE] 			= self.start_sub_step_replace,
		[Room.GameSubStep.GAME_SUB_STEP_TWAIT] 				= self.start_sub_step_twait,
		[Room.GameSubStep.GAME_SUB_STEP_CWAIT] 				= self.start_sub_step_cwait,
		[Room.GameSubStep.GAME_SUB_STEP_PWAIT] 				= self.start_sub_step_pwait,
		[Room.GameSubStep.GAME_SUB_STEP_HU] 				= self.start_sub_step_hu,
		[Room.GameSubStep.GAME_SUB_STEP_DRAWN] 				= self.start_sub_step_drawn,
		[Room.GameSubStep.GAME_SUB_STEP_HU_WAIT] 			= self.start_sub_step_hu_wait,
	}
	
	self._stop_game_sub_step_handler_map = 
	{
		[Room.GameSubStep.GAME_SUB_STEP_NONE] 				= self.stop_sub_step_none,
		[Room.GameSubStep.GAME_SUB_STEP_WAIT_RESP] 			= self.stop_sub_step_wait_resp,
		[Room.GameSubStep.GAME_SUB_STEP_WAIT] 				= self.stop_sub_step_wait,
		[Room.GameSubStep.GAME_SUB_STEP_TAKE] 				= self.stop_sub_step_take,
		[Room.GameSubStep.GAME_SUB_STEP_PLAY] 				= self.stop_sub_step_play,
		[Room.GameSubStep.GAME_SUB_STEP_CHOW] 				= self.stop_sub_step_chow,
		[Room.GameSubStep.GAME_SUB_STEP_PUNG] 				= self.stop_sub_step_pung,
		[Room.GameSubStep.GAME_SUB_STEP_TKONG] 				= self.stop_sub_step_tkong,
		[Room.GameSubStep.GAME_SUB_STEP_MKONG] 				= self.stop_sub_step_mkong,
		[Room.GameSubStep.GAME_SUB_STEP_CKONG] 				= self.stop_sub_step_ckong,
		[Room.GameSubStep.GAME_SUB_STEP_CANCEL] 			= self.stop_sub_step_cancel,
		[Room.GameSubStep.GAME_SUB_STEP_REPLACE] 			= self.stop_sub_step_replace,
		[Room.GameSubStep.GAME_SUB_STEP_TWAIT] 				= self.stop_sub_step_twait,
		[Room.GameSubStep.GAME_SUB_STEP_CWAIT] 				= self.stop_sub_step_cwait,
		[Room.GameSubStep.GAME_SUB_STEP_PWAIT] 				= self.stop_sub_step_pwait,
		[Room.GameSubStep.GAME_SUB_STEP_HU] 				= self.stop_sub_step_hu,
		[Room.GameSubStep.GAME_SUB_STEP_DRAWN] 				= self.stop_sub_step_drawn,
		[Room.GameSubStep.GAME_SUB_STEP_HU_WAIT] 			= self.stop_sub_step_hu_wait,
	}
end

function Room:start_game_step(game_step)
	if self._start_game_step_handler_map[game_step] then
		self._start_game_step_handler_map[game_step](self)
	end
end

function Room:stop_game_step(game_step)
	if self._stop_game_step_handler_map[game_step] then
		self._stop_game_step_handler_map[game_step](self)
	end
end

function Room:start_game_sub_step(game_step)
	if self._start_game_sub_step_handler_map[game_step] then
		self._start_game_sub_step_handler_map[game_step](self)
	end
end

function Room:stop_game_sub_step(game_step)
	if self._stop_game_sub_step_handler_map[game_step] then
		self._stop_game_sub_step_handler_map[game_step](self)
	end
end