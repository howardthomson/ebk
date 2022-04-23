note
	description: "Summary description for {EBK_FILE}."
	author: "Howard Thomson"
	date: "$22/Apr/2022$"

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

	socket: NNG_REQUEST_SOCKET

feature {NONE} -- Initialization

	make
		do
			make_thread
			create socket
		end

feature -- Daemon class settings

	Daemon_name: STRING = "ebk-file"

	Default_config_file: STRING = "ebk-file.conf"
			-- Default configuration file name for the GUI Daemon

	Default_nng_socket_path: STRING = "inproc://ebk-file"

feature {NONE} -- Initialization

	execute
			-- Initialize and launch application
		do
			socket.open
			socket.dial (Default_nng_socket_path)
			socket.receive_async (agent do_nothing)
			print ("File-daemon exit ...%N")
		end

end -- EBK_FILE
