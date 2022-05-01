note
	description: "Summary description for {EBK_CONFIGURATION}."
	author: "Howard Thomson"
	date: "1-May-2022"

	TODO: "[
		Addresses for:
			Director request and reply socket
			GUI request and reply sockets
			FD request and reply sockets
			SD request and reply sockets
	]"

class
	EBK_CONFIGURATION

create
	make

feature -- Attributes

	dir_request_socket_address: STRING
	dir_reply_socket_address: STRING

	gui_request_socket_address: STRING
	gui_reply_socket_address: STRING

	fd_request_socket_address: STRING
	fd_reply_socket_address: STRING

	sd_request_socket_address: STRING
	sd_reply_socket_address: STRING


feature

	make
		do
			set_defaults
		end

	set_defaults
			-- Set configuration to default values
		do
		--	check TODO: False end
			dir_request_socket_address := "inproc://dir-request"
			dir_reply_socket_address := "inproc://dir-reply"

			gui_request_socket_address := "inproc://gui-request"
			gui_reply_socket_address := "inproc://gui-reply"

			fd_request_socket_address := "inproc://fd-request"
			fd_reply_socket_address := "inproc://fd-reply"

			sd_request_socket_address := "inproc://sd-request"
			sd_reply_socket_address := "inproc://sd-reply"

		end


end
