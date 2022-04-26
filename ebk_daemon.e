note
	description: "EBK_DAEMON -- Parent to daemon threads"
	author: "Howard Thomson"
	date: "$22/Apr-2022$"

	TODO: "[
		The messaging network addresses need to be shared between
		both sides of each message channel.
	]"

deferred class
	EBK_DAEMON

feature

	Daemon_name: STRING deferred end

	Default_config_file: STRING deferred end

	Default_nng_socket_path: STRING deferred end

feature -- Execution

	execute
		do
			read_configuration
			open_sockets
			uv_loop_startup
			daemon_exit
		end

	read_configuration
		deferred
		end

	open_sockets
		deferred
		end

	uv_loop_startup
		deferred
		end

	daemon_exit
		deferred
		end

end
