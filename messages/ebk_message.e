note
	description: "Serialized Message -- for transit using NNG"
	author: "Howard Thomson"
	date: "$14-Apr-2022$"

	TODO: "[
		In order to be able to serialize this class using Eiffel's standard
		serialalization classes, ensure that only attributes that are part of
		the required message are declared and used in this class, and it's decendants
	]"

deferred class
	EBK_MESSAGE

feature

	make
		do
--			default_create
--			make_reader_writer
		end

feature {NNG_SOCKET}

	serialize
		deferred
		end

	deserialize
		deferred
		end

feature

	smrr: SED_MEMORY_READER_WRITER
		once
			create Result.make
		end

	send (a_socket: NNG_SOCKET)
		local
			l_nng_msg: NNG_MESSAGE
		do
--			smrr.set_for_writing
--			serialize
			create l_nng_msg.make_from_memory_reader_writer (smrr)
			a_socket.send (l_nng_msg)
		end
end
