note
	description: "Summary description for {SMG_TEST_SEND}."
	author: "Howard Thomson"
	date: "$14-Apr-2022$"

	TODO: "[
		Decide on how the appropriate class is going to be chosen for deserialztion
		on the nng_message receiving end ...
	]"

class
	EBK_TEST_SEND

inherit
	EBK_MESSAGE

create
	make

feature {NNG_SOCKET} -- Send/receive serialization/deserialization

	serialize
		do
				-- Set for writing
			set_for_writing
			write_integer_32 (t1)
			write_integer_64 (t2)
	--		write_
		end

	deserialize
		do
			set_for_reading
		end

feature -- Attributes

	t1: INTEGER_32

	t2: INTEGER_64

--	t3: STRING

end
