note
	description	: "Root class for this application."
	author		: "Generated by the New Vision2 Application Wizard."
	date		: "$Date: 2011/2/6 9:42:59 $"
	revision	: "1.0.0"

	TODO: "[
		Adapt for daemon / separate thread startup ...
			GUI thread [c.f. Bacula Bat]
			Coordinator thread [c.f. Bacula Director]
			File access thrad [c.f. Bacula Client]
			Data store thread [c.f. Bacula Store]
	]"

class
	EBK_UI_THREAD

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

	Daemon_name: STRING = "ebk-GUI"

	Default_config_file: STRING = "ebk-gui.conf"
			-- Default configuration file name for the GUI Daemon

	Default_nng_socket_path: STRING = "inproc://ebk-gui"

feature {NONE} -- Initialization

	execute
			-- Initialize and launch application
		local
			gui: EBK_GUI
		do
			socket.open
			socket.dial (Default_nng_socket_path)
			create gui.make (Current)
		end

end -- class APPLICATION