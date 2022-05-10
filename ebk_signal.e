note
	description: "Signal handling for 'ebk'"
	author: "Howard Thomson"
	date: "$28-Apr-2022$"

	extended_description: "[
		Memory is allocated for:
			2* struct sigaction
			Pointer to Current
			Pointer to Eiffel callback routine
	]"

	TODO: "[
		There can currently only be ONE instance of EBK_SIGNAL, as
		the C code has to store the address of Current and the address
		of the Eiffel routine to call back. The call to sigaction() only
		provides a signal number -- nothing else ...
		
		Win32 signal handling -- completely different ?
		
		Handle signals other than SIGINT ...
	]"

class
	EBK_SIGNAL

inherit
	MEMORY_STRUCTURE
		rename
			make as make_memory_structure,
			item as allocated_memory_address,
			structure_size as allocated_memory_size
		end

create
	make

feature -- Setup

	make
		do
			make_memory_structure
			callback_procedure := agent do_nothing
		end

	callback_procedure: PROCEDURE

	item_a: POINTER
		do
			Result := allocated_memory_address
		end

	item_b: POINTER
		do
			Result := allocated_memory_address + c_structure_size
		end

	allocated_memory_size: INTEGER
		do
			Result := 2 * c_structure_size
		end

feature --

	handle_signal (a_signal: INTEGER; a_signal_handler: PROCEDURE)
		local
			ret: INTEGER
		do
			callback_procedure := a_signal_handler
				-- Clear the argument sigaction
			item_a.memory_set (0, c_structure_size)
				-- Set sa_handler ...
			ebk_set_signal_handler (item_a, $Current, $c_callback)
				-- Call the system sigaction() routine
			ret := c_sigaction (a_signal, item_a, default_pointer)
		end

	set_callback (a_callback: PROCEDURE)
		do
			callback_procedure := a_callback
		end

feature -- Externals

	ebk_set_signal_handler (p_sigaction: POINTER; p_current: POINTER; a_eiffel_callback: POINTER)
		external "C signature (void *, void *, void *)"
		end

	c_callback
		do
			callback_procedure.apply
		end

	c_sigaction (a_signal_no: INTEGER; p_sigaction, p_old_sigaction: POINTER): INTEGER
		external "C inline use <signal.h>"
		alias "[
				sigaction ((int)$a_signal_no,
						(struct sigaction *) $p_sigaction,
						(struct sigaction *) $p_old_sigaction)
				]"
		end

	c_structure_size: INTEGER
		external "C inline use <signal.h>"
		alias "sizeof (struct sigaction)"
		end

	SIGINT: INTEGER
		external "C inline use <signal.h>"
		alias
			"SIGINT"
		end

end
