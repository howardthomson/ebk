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

inherit
--	NNG_MESSAGE
--		rename
--			append_integer_32 as append_integer_32_nng,
--			write_integer_32 as write_integer_32_nng,
--			trim_integer_32	as trim_integer_32_nng
--		end

	SED_MEMORY_READER_WRITER	-- Move to a 'once' routine ?
		rename
			make as make_reader_writer,
			count as sed_count
		undefine
--			default_create
		end

feature

	make
		do
			default_create
			make_reader_writer
		end

feature {NNG_SOCKET}

	serialize
		deferred
		end

	deserialize
		deferred
		end

end
