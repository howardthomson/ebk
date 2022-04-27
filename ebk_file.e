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

			scan_local_directory -- TEMP!!!

			if timer_count >= 2 then
				uv_loop.uv_stop
			end
		end

	check_callback
		do
			report ("fd -- check callback%N")
		end

	scan_local_directory
		local
			l_file_tree: EFB_FILE_TREE
		do
			create l_file_tree.make
			l_file_tree.add_root (".")
			l_file_tree.set_report_agent (agent per_file_callback)
			l_file_tree.scan_files
		end

	per_file_callback (a_filepath: EFB_PATH_COMPONENT; a_path_status: FILE_INFO)
		do
			process_a_file (a_filepath.filename)
		end

	process_a_file (a_name: STRING) is
			-- Process a 'normal' data file
		local
			l_raw_file: RAW_FILE
			l_buffer: MANAGED_POINTER
			l_hash: SODIUM_GENERIC_HASH
			l_last_read_count: INTEGER
		do
		--	l_buffer := file_buffer
			create l_buffer.make (4096)
			create l_hash

			create l_raw_file.make_open_read (a_name)
			from
				l_hash.hash_init
				l_raw_file.start
			until
				l_raw_file.after
			loop
				l_raw_file.read_to_managed_pointer (l_buffer, 0, 4096)
				l_last_read_count := l_raw_file.bytes_read
				if l_last_read_count = 4096 then
					l_hash.hash_update (l_buffer)
				elseif l_last_read_count > 0 then
					l_hash.hash_update_partial (l_buffer, l_last_read_count)
				end
			end
			l_hash.hash_final
			l_raw_file.close

			print (l_hash.as_hex_string)
			print (": hash of " + a_name + "%N")
		end




end -- EBK_FILE
