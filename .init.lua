local ts_utils = require('nvim-treesitter.ts_utils')

function run_code_block()
	local node = ts_utils.get_node_at_cursor()

	-- Traverse up the tree to find the 'translation_unit'
	while node and node:type() ~= 'translation_unit' do
		node = node:parent()
	end

	if node then
		print ("RUNNING")
		-- Get the range of the node
		local start_row, start_col, end_row, end_col = node:range()
		-- Extract the text from the range
		local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
		local code = table.concat(lines, "\n")

		-- Write the code to `test.cpp`
		local temp_file = vim.fn.getcwd() .. "/test.cpp"
		local file = io.open(temp_file, "w")
		file:write(code)
		file:close()

		-- Run `build.sh` in an interactive terminal
		vim.cmd("split | set nonu nornu | term ./build.sh")
	else
		print("No code block found!")
	end
end

-- Bind the function to a key (e.g., <leader>r)
vim.api.nvim_set_keymap('n', '<leader>r', ':lua run_code_block()<CR>', { noremap = true, silent = true })
