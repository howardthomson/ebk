note
	description: "Summary description for {EBK_GUI_UV_LOOP}."
	author: "Howard Thomson"
	date: "$8-May-20022$"

class
	EBK_GUI_UV_LOOP

inherit
	EBK_DAEMON

	THREAD
		rename
			make as make_thread,
			sleep as thread_sleep
		end

create
	make

feature -- Attributes

--	gui_reply_socket: NNG_REPLY_SOCKET
--		-- Respond to GUI client

--	fd_reply_socket: NNG_REPLY_SOCKET
--		-- Respond to File Daemon initiated comms

--	fd_request_socket: NNG_REQUEST_SOCKET
--		-- File Daemon contact socket

	exit_signalled: BOOLEAN

	identity: STRING

	uv_loop: UV_LOOP
		-- libuv main execution loop

	timer: UV_TIMER
		-- Heartbeat timer

	timer_count: INTEGER_64

	uv_check: UV_CHECK
		-- Check for incoming messages ...

	uv_async: UV_ASYNC

	ev_app: detachable EV_APPLICATION

	set_ev_application (an_ev_application: EV_APPLICATION)
		do
			ev_app := an_ev_application
		end

feature {NONE} -- Initialization

	make (an_ident: STRING)
		do
			make_thread
--			create gui_reply_socket
--			create fd_reply_socket
--			create fd_request_socket
			create identity.make_from_string (an_ident)
				-- The default uv_loop structure
			create uv_loop.make_default
				-- The heartbeat timer
			timer := uv_loop.new_timer
				-- Receive message check
			uv_check := uv_loop.new_check
				-- Async handle for loop wakeup on message receipt
			uv_async := uv_loop.new_async
		end

feature -- Daemon class settings

	Daemon_name: STRING = "ebk-gui-uv_loop"

	Default_config_file: STRING = "ebk-director.conf"
			-- Default configuration file name for the Director Daemon

	Default_nng_socket_path: STRING = "inproc://ebk-director"

feature {NONE} -- Initialization

	read_configuration
		do
		end

	open_sockets
		do
--			gui_reply_socket.open
--			gui_reply_socket.listen (config.gui_request_socket_address)
--			gui_reply_socket.set_receive_timeout (100)

--			gui_reply_socket.receive_async (agent gui_message_received)

--			director_socket.open
--			director_socket.dial (Default_nng_socket_path)
--			director_socket.receive_async (agent do_nothing)
		end

	uv_loop_startup
		do
			timer.start_timer (30, 1_000, agent timer_callback)
			uv_check.start (agent check_callback)
			uv_loop.uv_run ({UV_RUN_MODES}.uv_run_default)
		end

	daemon_exit
		do
			report ("GUI uv_loop exit ...%N")
		end

feature -- Callbacks

	timer_callback
		do
			if attached ev_app as app then
				if not app.is_destroyed then
					app.do_once_on_idle (agent gui_do_once_on_idle)
				end
			end
		end

	gui_do_once_on_idle
		do
			print ("GUI Idle print action ...%N")
		end

	check_callback
		do
			if signalled.item then
				uv_loop.uv_stop
				report ("gui: uv_stop called ...%N")
			end
		end


end
