note
	description: "File Pathname component"
	author: "Howard Thomson"
	date: "24 July 2011"

class EFB_PATH_COMPONENT

inherit

	HASHABLE

create

	make, make_with_parent

feature -- Attributes

	path_component: STRING
			-- Component of a file pathname

	parent: like Current
			-- Previous component, if non-Void

feature {NONE}

	cached_filename: detachable STRING

feature -- Creation

	make (a_path: STRING)
		do
			path_component := a_path
		end

	make_with_parent (a_path: STRING; a_parent: EFB_PATH_COMPONENT)
		do
			path_component := a_path
			parent := a_parent
		end

feature -- Queries

	--	Derive full pathname from:
	--		component_1 + "/"	[1, n1+1]
	--		component_2 + "/"
	--		component_3

	filename: STRING
			-- Full file pathname, derived from its components
		local
			l_count: INTEGER
			l_pos: INTEGER
			l_item: like Current
			l_item_count: INTEGER
		do
			if attached cached_filename as cf then
				Result := cf
			else
					-- Calculate size of filename
				from l_item := Current until l_item = Void loop
					l_count := l_count + l_item.path_component.count
					l_item := l_item.parent
					if l_item /= Void then
							-- Allow for path separator
						l_count := l_count + 1
					end
				end
					-- Allocate result space
				create Result.make_filled (' ', l_count)
					-- Copy components and path separators to Result
				from
						-- TODO
					l_item := Current
					l_pos := l_count + 1
				until
					l_item = Void
				loop
						-- Copy component to Result
					l_item_count := l_item.path_component.count
					Result.subcopy (l_item.path_component, 1, l_item_count, l_pos - l_item_count)
					l_pos := l_pos - l_item_count
					l_item := l_item.parent
					if l_item /= Void then
						l_pos := l_pos - 1
						Result.put ('/', l_pos)
					end
				end
			--	create cached_filename.make_from_string (Result)
				cached_filename := Result
			end
		end

feature -- hash_code

	hash_code: INTEGER
			-- Hash code value
		local
			l_item: like Current
			i, nb: INTEGER
			l_area: SPECIAL [CHARACTER_8]
		do
			Result := internal_hash_code
			if Result = 0 then
					-- The magic number `8388593' below is the greatest prime lower than
					-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
				from l_item := Current until l_item = Void loop
					from
						i := 0
						nb := l_item.path_component.count
						l_area := l_item.path_component.area
					until
						i = nb
					loop
						Result := ((Result \\ 8388593) |<< 8) + l_area.item (i).code
						i := i + 1
					end
					l_item := l_item.parent
				end
				internal_hash_code := Result
			end
		end

	internal_hash_code: INTEGER
			-- Cache for hash_code

end
