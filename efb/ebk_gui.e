note
	description: "EBK_GUI -- Client for GUI elements"
	author: "Howard Thomson"
	date: "$22-Apr-2022$"

	TODO: "[
		Asynchronous receipt of NNG messages needed ...
		
		Coordinate with other UI thread when closing the GUI ...


	]"

class
	EBK_GUI

inherit
	EBK_SHARED_CONFIGURATION

create
	make

feature -- Attributes

	ev_app: EV_APPLICATION

	ebk_window: EV_TITLED_WINDOW

	ui_thread: EBK_UI_THREAD

feature -- Creation

	make (a_ui_thread: EBK_UI_THREAD)
		local
			w: like ebk_window
			l_screen: EV_SCREEN
		do
			ui_thread := a_ui_thread
			create ev_app
			a_ui_thread.gui_uv_loop.set_ev_application (ev_app)
			create ebk_window
			ebk_window.set_minimum_size (100, 100)
			w := ebk_window
			create l_screen
				-- Centre the window
			ebk_window.set_position (
				(l_screen.width // 2) - (w.width // 2),
				(l_screen.height // 2) - (w.height // 2))
			add_to_main_window
			ebk_window.show
			ev_app.launch
		end

	add_to_main_window
		local
			l_colour: EV_COLOR
			l_frame: EV_FRAME
			l_vbox: EV_VERTICAL_BOX
			l_button: EV_BUTTON
			l_notebook: EV_NOTEBOOK
		do
			create l_colour.make_with_rgb (1, 0, 0)
			ebk_window.set_background_color (l_colour)
			create l_frame
			ebk_window.extend (l_frame)
			l_frame.set_border_width (4)
			create l_notebook
			l_frame.extend (l_notebook)

			add_tests_tab ("Tests ...", l_notebook)
			add_tree_tab ("FD Tree", l_notebook)
		end

	add_tests_tab (a_tab_name: STRING; a_notebook: EV_NOTEBOOK)
		local
	--		l_colour: EV_COLOR
	--		l_frame: EV_FRAME
			l_vbox: EV_VERTICAL_BOX
			l_button: EV_BUTTON
		do
			create l_vbox; a_notebook.extend (l_vbox)
			a_notebook.set_item_text (l_vbox, a_tab_name)

			create l_button; l_vbox.extend (l_button)
			l_button.set_text ("nng-test")
			l_button.select_actions.extend (agent run_nng_test)

			create l_button; l_vbox.extend (l_button)
			l_button.set_text ("libuv-test")
			l_button.select_actions.extend (agent run_libuv_test)

			create l_button; l_vbox.extend (l_button)
			l_button.set_text ("libsodium-test")
			l_button.select_actions.extend (agent run_libsodium_test)

			create l_button; l_vbox.extend (l_button)
			l_button.set_text ("dkvfs-test")
			l_button.select_actions.extend (agent run_dkvfs_test)

			create l_button; l_vbox.extend (l_button)
			l_button.set_text ("dir-comms-test")
			l_button.select_actions.extend (agent run_dir_comms_test)

-- TEMP: First initiation of a directory scan ...
			create l_button; l_vbox.extend (l_button)
			l_button.set_text ("Request directory scan")
			l_button.select_actions.extend (agent request_directory_scan)



			ebk_window.close_request_actions.extend (agent req_close_window)
		end

	add_tree_tab (a_tab_name: STRING; a_notebook: EV_NOTEBOOK)
		local
			l_tree: EV_TREE
		do
			create l_tree
			a_notebook.extend (l_tree)
			a_notebook.set_item_text (l_tree, "FD Tree")
		end

	request_directory_scan
		require

		local
			l_msg: EBK_DIR_CMND_MESSAGE
		do
			if ui_thread.gui_request_socket.is_open then
				print ("Send scan req msg to Director%N")
				create l_msg.make_scan_directory (".", "")
				l_msg.send (ui_thread.gui_request_socket)
			else
				print ("Not connected to Director ...%N")
			end
		end



	req_close_window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text ("Close the GUI ?")
			question_dialog.show_modal_to_window (ebk_window)

			if attached question_dialog.selected_button as sb
			and then sb.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
					-- Destroy the window
				ebk_window.destroy
				ev_app.process_events
				ev_app.destroy
			end
		end

feature -- Run tests

	nng_test: detachable NNG_TEST

	dkvfs_test: detachable DKVFS

	libuv_test: detachable UV_TEST

	libsodium_test: detachable LIBSODIUM_TEST

	run_nng_test
		do
				-- Test the nng messaging library
			create nng_test.make
		end

	run_libuv_test
		local
			l_test: UV_TEST
		do
				-- Test the libuv library
			create l_test.make;	l_test.launch; libuv_test := l_test
		end

	run_libsodium_test
		local
			l_test: LIBSODIUM_TEST
		do
				-- Test the libsodium library
			create l_test.make; --	l_test.launch			
		end

	run_dkvfs_test
		local
			l_test: DKVFS
		do
				-- Test the DKVFS library: PASS [but doesn't do very much!]
			create l_test.make; --	l_test.launch			
		end

	dir_comms_test: detachable DIR_COMMS_TEST

	run_dir_comms_test
		local
			l_test: DIR_COMMS_TEST
		do
			create l_test.make (ui_thread); l_test.launch
			dir_comms_test := l_test
		end
end
