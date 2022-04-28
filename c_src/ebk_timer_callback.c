#include <signal.h>
#include <stdio.h>
#include <eif_hector.h>

void *ebk_c_callback_routine_address;
	/* Address of Eiffel routine to call back */

static void *ebk_c_callback_current_address;
	/* Address of Eiffel 'Current' for callback */

void ebk_c_signal_handler(int signal)
{
	void (*eiffel_func)(void *Current);

	eiffel_func = ebk_c_callback_routine_address;
	(eiffel_func)(eif_access(ebk_c_callback_current_address));
}


void ebk_set_signal_handler (struct sigaction *p_sigaction, void *p_current, void *p_callback_routine)
{
	p_sigaction->sa_handler = &ebk_c_signal_handler;
	ebk_c_callback_current_address = eif_protect(p_current);
	ebk_c_callback_routine_address = p_callback_routine;
}
