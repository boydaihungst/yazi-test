--- @since 25.5.28

local M = {}

local STATE_KEY = {
	tasks_move = "tasks_move",
}

local ACTION = {
	files_transfered = "files-transfered",
}

local PUBSUB_KIND = {
	files_move = "move",
}

local enqueue_task = ya.sync(function(state, task_name, task_data)
	if not state[task_name] or type(state[task_name]) ~= "table" then
		state[task_name] = {}
	end
	table.insert(state[task_name], task_data)
end)

local dequeue_task = ya.sync(function(state, task_name)
	if not state[task_name] or type(state[task_name]) ~= "table" then
		return {}
	end
	return table.remove(state[task_name], 1)
end)

function M:setup(opts)
	local st = self
	st[STATE_KEY.tasks_move] = {}

	ps.sub(PUBSUB_KIND.files_move, function(payload)
		local changed_files = {}
		for _, item in pairs(payload.items) do
			local from = item.from
			local to = item.to
			changed_files[tostring(from)] = tostring(to)
		end
		enqueue_task(STATE_KEY.tasks_move, changed_files)
		local args = ya.quote(ACTION.files_transfered)
		ya.emit("plugin", {
			self._id,
			args,
		})
	end)
end

function M:entry(job)
	local action = job.args[1]
	if action == ACTION.files_transfered then
		ya.dbg("---------------------Action triggered---------------------")
		-- FIXME: This is not working
		local changes = dequeue_task(STATE_KEY.tasks_move)
		-- FIXME: This never prints
		ya.dbg(changes)
	end
end

return M
