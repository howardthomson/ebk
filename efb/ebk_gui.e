note
	description: "EBK_GUI -- Client for GUI elements"
	author: "Howard Thomson"
	date: "$22-Apr-2022$"

	TODO: "[
		Asynchronous receipt of NNG messages needed ...
	]"

class
	EBK_GUI

create
	make

feature -- Attributes

	ev_app: EV_APPLICATION

	ebk_window: EV_TITLED_WINDOW

feature -- Creation

	make (a_ui_thread: EBK_UI_THREAD)
		do
			create ev_app
			create ebk_window
			ebk_window.set_minimum_size (100, 100)
			add_to_main_window
			ebk_window.show
			ev_app.launch


			print ("ebk_window.is_destroyed: " + ebk_window.is_destroyed.out + "%N")
			print ("Return from ev_app.launch ... %N")
		end

	add_to_main_window
		local
			l_colour: EV_COLOR
			l_frame: EV_FRAME
			l_vbox: EV_VERTICAL_BOX
			l_button: EV_BUTTON
		do
			create l_colour.make_with_rgb (1, 0, 0)
			ebk_window.set_background_color (l_colour)
			create l_frame
			ebk_window.extend (l_frame)
			l_frame.set_border_width (4)

			create l_vbox; l_frame.extend (l_vbox)

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

			ebk_window.close_request_actions.extend (agent req_close_window)
		end

	req_close_window
		do
			ebk_window.destroy
			ev_app.process_events
			ev_app.destroy
			print ("Close GUI requested ...%N")
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

end
