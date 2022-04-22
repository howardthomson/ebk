note
	description: "Summary description for {EBK_DIRECTOR}."
	author: "Howard Thomson"
	date: "$Date$"

class
	EBK_DIRECTOR

inherit
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

	Daemon_name: STRING = "ebk-director"

	Default_config_file: STRING = "ebk-director.conf"
			-- Default configuration file name for the Director Daemon

	Default_nng_socket_path: STRING = "inproc://ebk-director"

feature {NONE} -- Initialization

	execute
			-- Initialize and launch application
		do
		end

end
