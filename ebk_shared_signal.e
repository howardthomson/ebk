note
	description: "Summary description for {EBK_SHARED_SIGNAL}."
	author: "Howard Thomson"
	date: "$29-Apr-2022$"

class
	EBK_SHARED_SIGNAL

feature -- Signal ...

	setup_signal_handling
		local
			l_signal_handler: EBK_SIGNAL
		do
			l_signal_handler := timer_ref.item
		end

	timer_ref: CELL [ EBK_SIGNAL ]
		local
			l_signal_handler: EBK_SIGNAL
		once
			create l_signal_handler.make
			create Result.put (l_signal_handler)
			l_signal_handler.handle_signal ({EBK_SIGNAL}.SIGINT, agent handle_sigint)
		end

	handle_sigint
		do
			signalled.put (True)
		end

	signalled: CELL [ BOOLEAN ]
		once ("process")
			create Result.put (False)
		end

end
