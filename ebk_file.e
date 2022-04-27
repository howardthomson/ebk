note
	description: "Summary description for {EBK_FILE}."
	author: "Howard Thomson"
	date: "$22/Apr/2022$"

	TODO: "[
		For testing, need two local FD theads ...
	]"

class
	EBK_FILE

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

	director_socket: NNG_REQUEST_SOCKET
		-- Socket to contact the Director

	receive_socket: NNG_REPLY_SOCKET
		-- Socket to respond to contact from others ...

	identity: STRING

	uv_loop: UV_LOOP
		-- libuv main execution loop

	timer: UV_TIMER
		-- Heartbeat timer

	timer_count: INTEGER_64

	uv_check: UV_CHECK
		-- Check for incoming messages ...

	uv_async: UV_ASYNC

feature {NONE} -- Initialization

	make (an_ident: STRING)
		do
			make_thread
			create director_socket
			create receive_socket
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

	Daemon_name: STRING = "ebk-file"

	Default_config_file: STRING = "ebk-file.conf"
			-- Default configuration file name for the GUI Daemon

	Default_nng_socket_path: STRING = "inproc://ebk-file"

feature {NONE} -- Initialization

	read_configuration
		do
		end

	open_sockets
		do
			director_socket.open
			director_socket.dial (Default_nng_socket_path)
			director_socket.receive_async (agent do_nothing)
		end

	uv_loop_startup
		do
			timer.start_timer (30, 1_000, agent timer_callback)
			uv_check.start (agent check_callback)
			uv_loop.uv_run ({UV_RUN_MODES}.uv_run_default)
		end

	daemon_exit
		do
			report ("File-daemon (" + "" + ") exit ...%N")
		end

feature -- Callback routines

	timer_callback
		do
			timer_count := timer_count + 1
			report ("fd -- timer callback (" + identity + "): " + timer_count.out + "%N")
			if timer_count >= 20 then
				timer.stop_timer
			end
		end

	check_callback
		do
			report ("fd -- check callback%N")
		end

end -- EBK_FILE
