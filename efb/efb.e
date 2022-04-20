note
	description: "EFB -- Eiffel File Browser"
	author: "Howard Thomson"
	date: "8-July-2021"

class
	EFB

inherit

	THREAD_CONTROL
	EXECUTION_ENVIRONMENT
		rename arguments as ise_arguments end
	KL_SHARED_EXCEPTIONS
	KL_SHARED_ARGUMENTS

create
	make

feature -- Attributes

	gui_option: AP_FLAG

	error_handler: UT_ERROR_HANDLER
			-- Error handler

--	gui: EBK_GUI
--	store: EBK_STORE
--	file: EBK_FILE
--	director: EBK_DIRECTOR

	make
		do
			Arguments.set_program_name ("efb")
			create error_handler.make_standard
			parse_arguments

		end

feature -- Argument processing

	parse_arguments
		local
			a_parser: AP_PARSER
	--		a_list: AP_ALTERNATIVE_OPTIONS_LIST
	--		an_error: AP_ERROR
			i: INTEGER
		do
			create a_parser.make
			a_parser.set_application_description ("File browser / processor command.")

				-- Setup optional arguments
			create gui_option.make_with_long_form ("gui")
			gui_option.set_description ("Start the GUI interface")
			a_parser.options.force_last (gui_option)

				-- Parse arguments
			a_parser.parse_arguments
--			if a_parser.parameters.count = 0 then
--					-- No paths to report on ...
--				error_handler.report_info_message (a_parser.help_option.full_usage_instruction (a_parser))
--				Exceptions.die (1)
--			else
			if gui_option.was_found then
--				create gui.make; gui.launch
			else
					-- Command + arguments ...
--				create efb_tree.make
--				from i := 1 until i > a_parser.parameters.count loop
--					efb_tree.add_root (a_parser.parameters @ i)
--					i := i + 1
--				end
			end
			join_all
		end

end
