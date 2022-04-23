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

	socket: NNG_REPLY_SOCKET

feature {NONE} -- Initialization

	make
		do
			make_thread
			create socket
		end

feature -- Daemon class settings

	Daemon_name: STRING = "ebk-director"

	Default_config_file: STRING = "ebk-director.conf"
			-- Default configuration file name for the Director Daemon

	Default_nng_socket_path: STRING = "inproc://ebk-director"

feature {NONE} -- Initialization

	execute
			-- Initialize and launch application
		do
			socket.open
			socket.listen (Default_nng_socket_path)	--TODO  !!
			socket.receive_async (agent message_received)

			-- TODO decide what happens here, awaiting message arrival ...

			print ("Director exit ...%N")
		end

	message_received
		do

		end

end
