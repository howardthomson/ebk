# ebk
Eiffel Backup, and associated functionality

Note: This is ALL work in progress as at 25-March 2022 !!

The implementation language is Eiffel, with additional C code as needed.

The project executable is 'ebk', and that includes [in Bacula terminology]
the file-daemon, storage-daemon, director-daemon, gui-frontend and key/value store.

Dependencies:

	eiffel-nng: Eiffel wrapping of the nanomsg messaging system at nng.nanomsg.org

	eiffel-libsodium: Eiffel wrapping of Sodium for encryption etc at libsodium.gitbook.io

	eiffel-dkvs: Custom [distributed] key/value store
		
