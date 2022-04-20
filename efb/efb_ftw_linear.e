note
	description: "File Tree Walker in LINEAR form"
	author: "Howard Thomson"
	date: "14-Feb-2022"
	revision: "$Revision$"

class
	EFB_FTW_LINEAR

create
	make

feature -- Attributes

	root_path: EFB_PATH_COMPONENT	-- STRING
			-- Path of the current directory root for this tree

--	report_agent: PROCEDURE [ANY, tuple [EFB_PATH_COMPONENT]]
--		-- agent to report filenames to

	path_status: FILE_INFO
			-- 'stat' info for assigned path

	directory_stack: DS_ARRAYED_STACK [ EFB_PATH_COMPONENT ]
			-- Pushdown stack of to-be-processed directory paths

feature -- Creation

	make
		do
			create path_status.make
			create directory_stack.make_default
		end

--	reset (a_path: STRING)
--			-- Re-target to a_path, which should be a directory
--		require
--			non_void_path: a_path /= Void
--		do
--			create root_path.make (a_path)
--		end

--	scan (an_agent: PROCEDURE [ANY, tuple [EFB_PATH_COMPONENT, like path_status] ])
--		do
--			report_agent := an_agent
--			scan_recursive
--		end


	start
		do

		end

	forth
		do

		end

	item
		do

		end

	after: BOOLEAN
		do

		end


	scan_recursive
			-- Recurse down directory tree
			-- Process all non-subdirectory entries first, before processing subdirectories
		local
			l_directory: KL_DIRECTORY
			l_directory_count: INTEGER
			i: INTEGER
			l_path: EFB_PATH_COMPONENT	--STRING
			l_saved_root_path: EFB_PATH_COMPONENT	--STRING
		do
			create l_directory.make (root_path.filename)
			l_directory_count := directory_stack.count
			l_directory.do_all (agent process_item)
			l_saved_root_path := root_path
			from
				i := directory_stack.count
			until
				i <= l_directory_count
			loop
				l_path := directory_stack.item
				directory_stack.remove
				root_path := l_path
				scan_recursive
				i := i - 1
			end
			root_path := l_saved_root_path
		end

	process_item (an_item: STRING)
		local
			l_path: EFB_PATH_COMPONENT
		do
			create l_path.make_with_parent (an_item, root_path)
			path_status.update (l_path.filename)
			if not path_status.exists then
				print (once "Item vanished .... ")
				print (l_path); print (once "%N")
			else
				if path_status.is_symlink then
			--		report_agent.call ([l_path])
					print ("Symlink: "); print (l_path.filename); print (once "%N")
				elseif path_status.is_directory then
					push_directory (l_path)
				elseif path_status.is_plain then
--					report_agent.call ([l_path, path_status])
				else
					print ("Other 'file': "); print (l_path); print ("%N")
				end
			end
		end

	push_directory (a_directory_path: EFB_PATH_COMPONENT)
			-- Remember directory path for processing after files etc
		do
			-- TODO
			-- print (once "Directory: "); print (a_directory_path); print (once "%N")
			directory_stack.force (a_directory_path)
		end

end
