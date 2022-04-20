note
	description : "efb_command application root class"
	date        : "$Date$"
	revision    : "$Revision$"

	todo: "[
		Rather than generating a hash of every file, group all relevant files by file-size,
		select groups with more than one file (!), and then hash larger files, and directly
		compare smaller files ...
		
		Non-searchable directories
		Non-readable files
		Do not follow symbolic links !!!!

		Need a depth first combined hash of data content of sub-trees

		Need a common name store, to identify same-name directories, and
		same-name files ...

		Split full filenames into path components, with link to parent object ...
			Share parent path components to conserve memory ...

		Cache per-directory summaries, with last-modified times ...
	]"

class
	EFB_COMMAND

inherit
	KL_SHARED_ARGUMENTS
	KL_SHARED_EXCEPTIONS

create
	make

feature -- Attributes

	efb_tree: EFB_FILE_TREE
			-- The Directory tree processor

	error_handler: UT_ERROR_HANDLER
			-- Error handler

	file_hash: HASH_FILE_SHA1
			-- SHA1 file content hashing processor

	hash_table: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
			-- Table SHA1 hashes to filenames

	file_table: DS_HASH_TABLE [DS_HASH_SET [EFB_PATH_COMPONENT], INTEGER]
			-- Table of file paths, keyed on file-size

feature {NONE} -- Initialization

	make
		do
			Arguments.set_program_name ("efb_command")
			create file_table.make_default
			create file_hash.make
			create hash_table.make_default
			create error_handler.make_standard
			parse_arguments
				-- Process the selected directory trees
			process_directory_trees
			io.input.read_line
		end

feature -- Argument processing

	parse_arguments
		local
			a_parser: AP_PARSER
	--		a_list: AP_ALTERNATIVE_OPTIONS_LIST
	--		an_error: AP_ERROR
			i: INTEGER
		do
			create a_parser.make
			a_parser.set_application_description ("File browser / processor command.")

				-- Setup optional arguments
			-- TODO
				-- Parse arguments
			a_parser.parse_arguments
			if a_parser.parameters.count = 0 then
					-- No paths to report on ...
				error_handler.report_info_message (a_parser.help_option.full_usage_instruction (a_parser))
				Exceptions.die (1)
			else
				create efb_tree.make
				from i := 1 until i > a_parser.parameters.count loop
					efb_tree.add_root (a_parser.parameters @ i)
					i := i + 1
				end
			end
		end

feature -- Filesystem scanning

	process_directory_trees
			-- For each of the specified directories, process all files
			-- and sub-directories of that directory root.
		do
			efb_tree.set_report_agent (agent report_filepath)
			efb_tree.scan_files
print ("Scan files done ...%N")
			report_duplicates
		end

	hash_string_count: INTEGER
			-- Count of bytes of hash strings

	filename_count: INTEGER
			-- Count of filename characters

	report_filename_count: INTEGER
			-- Count of filenames reported

	report_filepath (a_path: EFB_PATH_COMPONENT; a_path_status: FILE_INFO)
				-- Fill file_table, keyed on file size
		local
			l_filename: STRING
			l_size: INTEGER
			l_hash_set: DS_HASH_SET [EFB_PATH_COMPONENT]
		do
			l_filename := a_path.filename
			l_size := a_path_status.size
			if l_size /= 0 then
				if not file_table.has (l_size) then
						-- Create new file-size group
					create l_hash_set.make_default
					l_hash_set.force_new (a_path)
					file_table.force_new (l_hash_set, l_size)
				else
						-- Add path to file-size group
					l_hash_set := file_table.item (l_size)
					l_hash_set.force_new (a_path)
				end
			end
		end

	report_duplicates
			-- Report duplicate files found during directory tree scan
		local
			l_file_table_cursor: DS_HASH_TABLE_CURSOR [ DS_HASH_SET [EFB_PATH_COMPONENT], INTEGER]
			l_file_set: DS_HASH_SET [ EFB_PATH_COMPONENT ]
			l_file_set_cursor: DS_HASH_SET_CURSOR [ EFB_PATH_COMPONENT ]
		do
				-- TODO
			print ("Hashing possible duplicates ...%N")
			l_file_table_cursor := file_table.new_cursor
			from l_file_table_cursor.start until l_file_table_cursor.after loop
				l_file_set := l_file_table_cursor.item
				if l_file_set.count >= 2 then
					l_file_set_cursor := l_file_set.new_cursor
					from l_file_set_cursor.start until l_file_set_cursor.after loop
						hash_a_filepath (l_file_set_cursor.item)
						l_file_set_cursor.forth
					end
				end
				l_file_table_cursor.forth
			end
			print ("Reporting hash duplicates ...%N")
			report_hash_duplicates
			print ("Report end ...%N")
		end

	hash_a_filepath (a_path: EFB_PATH_COMPONENT)
		local
			l_hash_string: STRING
			l_hash_set: DS_HASH_SET [STRING]
			l_filename: STRING
		do
			l_filename := a_path.filename
			file_hash.process_a_file (l_filename)
			l_hash_string := file_hash.hash_string
			if not hash_table.has (l_hash_string) then
				create l_hash_set.make_default
				l_hash_set.force_new (l_filename)
				hash_table.force_new (l_hash_set, l_hash_string)
					-- Update counts
				hash_string_count := hash_string_count + 20
				filename_count := filename_count + l_filename.count
			else
					-- Found identical files ...
				l_hash_set := hash_table.item (l_hash_string)
				l_hash_set.force_new (l_filename)
--print ("Found an identical file: "); print (l_filename); print (once "%N")
					-- Update counts
				filename_count := filename_count + l_filename.count
			end
			report_filename_count := report_filename_count + 1
		--	if (report_filename_count \\ 1000) = 0 then
				print (once "Last reported: ")
				print (l_filename)
				print (once "%N")
		--	end
		end

	report_hash_duplicates
		local
			l_hash_table_cursor: DS_HASH_TABLE_CURSOR [ DS_HASH_SET [STRING], STRING]
			l_hash_set: DS_HASH_SET [ STRING ]
			l_hash_set_cursor: DS_HASH_SET_CURSOR [ STRING ]
			l_filename: STRING
		do
			l_hash_table_cursor := hash_table.new_cursor
			from l_hash_table_cursor.start until l_hash_table_cursor.after loop
				l_hash_set := l_hash_table_cursor.item
				if l_hash_set.count > 1 then
						-- Two or more identical files ...
					l_hash_set_cursor := l_hash_set.new_cursor
					from l_hash_set_cursor.start until l_hash_set_cursor.after loop
						l_filename := l_hash_set_cursor.item
						print (l_filename); print (once "%N")
						l_hash_set_cursor.forth
					end
					print (once "%N")
				end
				l_hash_table_cursor.forth
			end
		end

end
