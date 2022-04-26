note
	description: "Summary description for {EBK_STORE}."
	author: "Howard Thomson"
	date: "$Date$"

class
	EBK_STORE

inherit
	EBK_DAEMON
	THREAD
		rename
			make as make_thread,
			sleep as thread_sleep
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_thread
		end

feature -- Daemon class settings

	Daemon_name: STRING = "ebk-store"

	Default_config_file: STRING = "ebk-store.conf"
			-- Default configuration file name for the GUI Daemon

	Default_nng_socket_path: STRING = "inproc://ebk-store"

feature {NONE} -- Initialization

	read_configuration
		do
		end

	open_sockets
		do
--			director_socket.open
--			director_socket.dial (Default_nng_socket_path)
--			director_socket.receive_async (agent do_nothing)
		end

	uv_loop_startup
		do

		end

	daemon_exit
		do
			print ("Store-daemon (" + "" + ") exit ...%N")
		end

end -- EBK_STORE
