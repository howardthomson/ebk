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
		do
			create l_message.make
			l_message.serialize
			l_message.send (gui_thread.gui_request_socket)
		end
end
