note
	description: "Test Director communications ..."
	author: "Howard Thomson"
	date: "1-May-2022"

class
	DIR_COMMS_TEST

inherit
	EBK_SHARED_CONFIGURATION
	THREAD
		rename make as make_thread end

create
	make

feature -- Attributes

	gui_thread: EBK_UI_THREAD

feature -- Creation

	make (a_gui_thread: EBK_UI_THREAD)
		do
			make_thread
			gui_thread := a_gui_thread
		end

	execute
		local
			l_message: EBK_TEST_SEND
			l_socket: NNG_REQUEST_SOCKET
		do
			l_socket := gui_thread.gui_request_socket

			l_socket.open
			l_socket.set_send_timeout (1_000)
			l_socket.dial (config.gui_request_socket_address)
				print("socket.dialled ...%N")
			create l_message.make
			l_message.serialize

			print ("Message size {DIR_COMMS_TEST} = " + l_message.smrr.count.out + "%N")
			l_message.send (l_socket)
				print ("Message sent ...%N")

			if l_socket.last_error /= 0 then
				print ("socket.last_error = " + l_socket.last_error.out + "%N")
			end
			l_socket.close
		end
end
