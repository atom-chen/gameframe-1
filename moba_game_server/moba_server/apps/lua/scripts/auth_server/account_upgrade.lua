local mysql_center = require("database/mysql_auth_center")

local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")

local function _do_account_upgrade(s, req, uid, uname, upwdmd5)
	mysql_center.do_guest_account_upgrade(uid, uname, upwdmd5, function (err, ret)
		if err then
			local msg = {Stype.Auth, Cmd.eAccountUpgradeRes, uid, {
				status = Respones.SystemErr,
			}}

			Session.send_msg(s, msg)
			return
		end

		local msg = {Stype.Auth, Cmd.eAccountUpgradeRes, uid, {
			status = Respones.OK,
		}}

		Session.send_msg(s, msg) 
	end)
end

local function _check_is_guest(s, req, uid, uname, upwdmd5)
	mysql_center.get_uinfo_by_uid(uid, function (err, uinfo)
		if err then
			local msg = {Stype.Auth, Cmd.eAccountUpgradeRes, uid, {
				status = Respones.SystemErr,
			}}

			Session.send_msg(s, msg)
			return
		end

		if uinfo.is_guest ~= 1 then -- 不是游客账号了
			local msg = {Stype.Auth, Cmd.eAccountUpgradeRes, uid, {
				status = Respones.UserIsNotGuest,
			}}

			Session.send_msg(s, msg)
			return
		end

		_do_account_upgrade(s, req, uid, uname, upwdmd5)
	end)
end

local function do_upgrade(s, req)
	local uid = req[3]
	local account_upgrade_req = req[4]
	local uname 	= account_upgrade_req.uname
	local upwdmd5	= account_upgrade_req.upwdmd5
	-- if string.len(uname) <= 0 or string.len(upwdmd5) ~= 32 then  --TODO md5 check
	if string.len(uname) <= 0 then
		local msg = {Stype.Auth, Cmd.eAccountUpgradeRes, uid, {
			status = Respones.InvalidParams,
		}}
		Session.send_msg(s, msg)
		return
	end

	mysql_center.check_uname_exist(uname, function (err, ret)
		if err then 
			local msg = {Stype.Auth, Cmd.eAccountUpgradeRes, uid, {
				status = Respones.SystemErr,
			}}
			Session.send_msg(s, msg)
			return
		end

		if ret then -- uname已经被占用了
			local msg = {Stype.Auth, Cmd.eAccountUpgradeRes, uid, {
				status = Respones.UnameIsExist,
			}}
			Session.send_msg(s, msg)
			return 
		end
		_check_is_guest(s, req, uid, uname, upwdmd5)
	end)
end

local account_upgrade = {
	do_upgrade = do_upgrade,
}

return account_upgrade
