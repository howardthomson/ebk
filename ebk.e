note
	description: "ebk application root class"
	author: "Howard Thomson"
	date: "$19-Apr-2022$"

	TODO: "[
		Threads to create, dependent on command line and/or configuration files:
			1/ GUI		-- Display thread	EBK_GUI
			2/ DKVFS	-- Storage thread	EBK_DKVFS
			3/ FD		-- File daemon		EBK_FD
			4/ DIR		-- Director 		EBK_DIR
	]"
class
	EBK

inherit
	THREAD_CONTROL
	EXECUTION_ENVIRONMENT
		rename arguments as ise_arguments end
	KL_SHARED_EXCEPTIONS
	KL_SHARED_ARGUMENTS

create
	make

feature {NONE} -- Initialization

	error_handler: UT_ERROR_HANDLER
			-- Error handler

	gui_option: AP_FLAG
		-- Enable GUI

	store_option: AP_FLAG
		-- Enable DKVFS Store

	file_daemon_option: AP_FLAG
		-- Enable EBK_FD File Daemon

	director_option: AP_FLAG
		-- Enable EBK_DIR Director

-- Tests

	all_tests_option: AP_FLAG
		-- Run all tests

	nng_test_option: AP_FLAG
		-- Run nng messaging tests

	dkvfs_test_option: AP_FLAG
		-- Run dkvfs tests

	libuv_test_option: AP_FLAG
		-- Run libuv tests


--	gui: EBK_GUI
--	store_d: EBK_STORE
--	file_d: EBK_FILE
--	director_d: EBK_DIRECTOR

	nng_test: detachable NNG_TEST

	dkvfs_test: detachable DKVFS

	libuv_test: detachable UV_TEST

--	libsodium_test: LIBSODIUM_TEST

	make
		do
			Arguments.set_program_name ("ebk")
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
			l_nng_test: NNG_TEST

		do
			create a_parser.make
			a_parser.set_application_description ("Eiffel Backup / File Browser.")

				-- Setup optional arguments
				-- GUI option
			create gui_option.make_with_long_form ("gui")
			gui_option.set_description ("Start the GUI interface")
			a_parser.options.force_last (gui_option)

				-- Storage Daemon option
			create store_option.make_with_long_form ("sd")
			store_option.set_description ("Start the Storage Daemon: DKVFS")
			a_parser.options.force_last (store_option)

				-- File Daemon option
			create file_daemon_option.make_with_long_form ("fd")
			file_daemon_option.set_description ("Start the File Daemon: EBK_FD")
			a_parser.options.force_last (file_daemon_option)

				-- Director Daemon option
			create director_option.make_with_long_form ("dir")
			director_option.set_description ("Start the Director Daemon: EBK_DIR")
			a_parser.options.force_last (director_option)

				-- TEST: Run all tests
			create all_tests_option.make_with_long_form ("all-tests")
			all_tests_option.set_description ("Run tests all libraries ...")
			a_parser.options.force_last (all_tests_option)

				-- TEST: nng messaging library
			create nng_test_option.make_with_long_form ("nng-test")
			nng_test_option.set_description ("Run tests for the nng messaging library")
			a_parser.options.force_last (nng_test_option)

				-- TEST: dkvfs library
			create dkvfs_test_option.make_with_long_form ("dkvfs-test")
			dkvfs_test_option.set_description ("Run tests for the dkvfs library")
			a_parser.options.force_last (dkvfs_test_option)

				-- TEST: libuv library
			create libuv_test_option.make_with_long_form ("libuv-test")
			libuv_test_option.set_description ("Run tests for the libuv library")
			a_parser.options.force_last (libuv_test_option)

				-- Parse arguments
			a_parser.parse_arguments

			if gui_option.was_found then
--!!			create gui.make; gui.launch
			end
			if store_option.was_found then
--!!			create store_d.make; store_d.launch
			end
			if file_daemon_option.was_found then
--!!			create file_d.make; file_d.launch
			end
			if director_option.was_found then
--!!			create director_d.make; director_d.launch
			end
				-- Option: Test the nng messaging library
			if nng_test_option.was_found then
				create l_nng_test.make;
			--	l_nng_test.launch;
				nng_test := l_nng_test
			end
				-- Option: Test the DKVFS library
			if dkvfs_test_option.was_found then
				create dkvfs_test.make; --	dkvfs_test.launch
			end
				-- Option: test the libuv library
			if libuv_test_option.was_found then
				create libuv_test.make; --	libuv_test.launch
			end
			join_all
		end


--			if a_parser.parameters.count /= 0 then
--					-- No paths to report on ...
--				error_handler.report_info_message (a_parser.help_option.full_usage_instruction (a_parser))
--				Exceptions.die (1)
--			else

					-- Command + arguments ...
--				create efb_tree.make
--				from i := 1 until i > a_parser.parameters.count loop
--					efb_tree.add_root (a_parser.parameters @ i)
--					i := i + 1
--				end


end