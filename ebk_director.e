note
	description: "Summary description for {EBK_DIRECTOR}."
	author: "Howard Thomson"
	date: "22/Apr-2022"

	TODO: "[
		Use UV_LOOP
	]"

class
	EBK_DIRECTOR

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

	gui_socket: NNG_REPLY_SOCKET
		-- Respond to GUI client

	fd_reply_socket: NNG_REPLY_SOCKET
		-- Respond to File Daemon initiated comms

	fd_request_socket: NNG_REQUEST_SOCKET
		-- File Daemon contact socket

	exit_signalled: BOOLEAN

feature {NONE} -- Initialization

	make
		do
			make_thread
			create gui_socket
			create fd_reply_socket
			create fd_request_socket
		end

feature -- Daemon class settings

	Daemon_name: STRING = "ebk-director"

	Default_config_file: STRING = "ebk-director.conf"
			-- Default configuration file name for the Director Daemon

	Default_nng_socket_path: STRING = "inproc://ebk-director"

feature {NONE} -- Initialization

--	execute
--			-- Initialize and launch application
--		do
--			gui_socket.open
--			gui_socket.listen (Default_nng_socket_path)	--TODO  !!
--			gui_socket.receive_async (agent gui_message_received)



--			-- TODO decide what happens here, awaiting message arrival ...

--		end

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
			print ("Director exit ...%N")
		end

	gui_message_received
		do

		end

end
