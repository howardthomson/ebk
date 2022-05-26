note
	description: "Summary description for {EBK_RECEIVER}."
	author: "Howard Thomson"
	date: "$19-May-2022$"

	extended_description: "[
		This class receives NNG_MESSAGEs, deserializes the initial selector bytes, and creates
		the matching descendant of EBK_MESSAGE to process the message.
	]"

	TODO: "[
		Decide where decryption and authentication, using libsodium, fit into the messaging system.
	]"

class
	EBK_RECEIVER

create
	make

feature -- Creation

	make
		do

		end

	Ebk_msg_request_scan: INTEGER = 1

	receive (a_message: NNG_MESSAGE)
		local
			l_message_type_id: INTEGER_32
			l_ebk_message: EBK_MESSAGE
		do
			l_message_type_id := a_message.managed_pointer.read_integer_32 (0)
			inspect l_message_type_id
			when Ebk_msg_request_scan then
				create {EBK_DIR_CMND_MESSAGE} l_ebk_message.make_on_arrival
			else
				check False end
			end
			if attached l_ebk_message as msg then
				msg.deserialize
				msg.execute
			end
		end
end
