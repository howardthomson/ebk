note
	description: "Test Director communications ..."
	author: "Howard Thomson"
	date: "1-May-2022"

class
	DIR_COMMS_TEST

inherit
	EBK_SHARED_CONFIGURATION

create
	make

feature -- Attributes



feature -- Creation

	make (a_gui_thread: EBK_UI_THREAD)
		local
			l_message: EBK_TEST_SEND
		do
			create l_message.make

		end
end
