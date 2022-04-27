note
	description: "Summary description for {EFB_FILE_TREE}."
	author: "Howard Thomson"
	date: "6 Feb 2011"


class
	EFB_FILE_TREE

inherit
	EFB_FILE_TREE_DEF

create
	make

feature -- Attributes

	report_agent: detachable PROCEDURE [ TUPLE [ EFB_PATH_COMPONENT, FILE_INFO ]]

feature -- Creation

	make
		do
			create local_roots.make
		end

feature

	add_root (a_root: STRING)
			-- Add a directory to the set of roots to scan
		do
				-- TODO
				-- Check that the argument is not a descendant, or ancestor, of any
				-- of the existing roots; either do not add incompatible argument and
				-- provide last_root_valid: BOOLEAN query, or have a valid_roots: BOOLEAN
				-- query for the root set.
			local_roots.extend (a_root)
		end

-- TODO, scan_files
--	Split local_roots into groups based on the distinct 'disks' on the local system.
--	Scan file trees sequentially within groups, in parallel for distinct groups ...	

	scan_files
		local
			l_ftw: EFB_FTW
		do
			if attached report_agent as l_ra then



				create l_ftw.make
				from
					local_roots.start
				until
					local_roots.after
				loop
					l_ftw.reset (local_roots.item)
					l_ftw.scan (l_ra)
					local_roots.forth
				end
			end
		end

--	kl_file: KL_BINARY_INPUT_FILE

--	report_file (a_filepath: EFB_PATH_COMPONENT; a_path_status: FILE_INFO)
--		do
--			create {KL_BINARY_INPUT_FILE} kl_file.make (a_filepath.filename)
--			if kl_file.is_readable then
--				if report_agent /= Void then
--					report_agent.call ([a_filepath, a_path_status])
--				end
--			else
--				print ("Non-readable file: "); print (a_filepath.filename); print (once "%N")
--			end
--		end

--	report_file (a_filepath: EFB_PATH_COMPONENT; a_path_status: FILE_INFO)
--		do
--			report_agent.call ([a_filepath, a_path_status])
--		end


	set_report_agent (an_agent: like report_agent)
		do
			report_agent := an_agent
		end

end
