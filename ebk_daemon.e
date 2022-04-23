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
end
