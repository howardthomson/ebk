note
	description: "ebk Command message to the Director"
	author: "Howard Thomson"
	date: "$16-May-20022$"

	TODO: "[
		Figure out how, and where, the appropriate Eiffel class object is created
		on message receipt. How does this integrate with generic message facilities
		such as message encryption/decryption, authentication etc
	]"

class
	EBK_DIR_CMND_MESSAGE

inherit
	EBK_MESSAGE

create
	make_scan_directory,
	make_on_arrival

feature -- Attributes

	scan_path: STRING

	host_selected: STRING

feature -- Creation

	make_scan_directory (a_path: STRING; a_host: STRING)
			-- Scan directory tree at 'a_path' on the host
			-- identified by 'a_host'
		do
			scan_path := a_path
			host_selected := a_host
			serialize
		end

	make_on_arrival
			-- Create from a serialized received message
		do
			scan_path := once_default_string
			host_selected := once_default_string
		end

feature -- Serialization / Deserialization


	Dir_cmnd_scan_directory: INTEGER = 1

	serialize
		do
			smrr.set_for_writing
			smrr.write_integer_32 (Dir_cmnd_scan_directory)
			smrr.write_string_8 (scan_path)
			smrr.write_string_8 (host_selected)
		end

	deserialize
		do
			smrr.set_for_reading
			check smrr.read_integer_32 = Dir_cmnd_scan_directory end
			scan_path := smrr.read_immutable_string_8
			host_selected := smrr.read_immutable_string_8
			--?????
		end

end
