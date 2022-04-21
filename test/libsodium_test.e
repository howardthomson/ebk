note
	description: "eiffel-libsodium application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	LIBSODIUM_TEST

inherit
	ARGUMENTS

	LIBSODIUM_SHARED
	THREAD_CONTROL

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			if crypt.init_successful then
				print ("Crypto initialised OK !%N")
			end
			print_version
			print_constants
			test
			test_password_hash
			test_generic_hash
			test_key_exchange
		end

	print_version
		do
			print ("Version: " + crypt.version_string + "%N")
		end

	print_constants
		do
				-- LIBSODIUM_AUTH_API
			print_constant ("auth_keybytes", crypt.crypto_auth_keybytes)
			print_constant ("auth_bytes", crypt.crypto_auth_bytes)

				-- LIBSODIUM_BOX_API
			print_constant ("crypt.secretbox_keybytes", crypt.crypto_secretbox_keybytes)
			print_constant ("crypt.secretbox_noncebytes", crypt.crypto_secretbox_noncebytes)
			print_constant ("crypt.secretbox_macbytes", crypt.crypto_secretbox_macbytes)

				--	LIBSODIUM_CORE_API
			-- Nothing to report her ...

				--	LIBSODIUM_HASH_API
			print_constant ("crypt.crypto_hash_bytes", crypt.crypto_hash_bytes)

				--	LIBSODIUM_KDF_API
			print_constant ("crypto_kdf_bytes_max", crypt.crypto_kdf_bytes_max )
			print_constant ("crypto_kdf_bytes_min", crypt.crypto_kdf_bytes_min )
			print_constant ("crypto_kdf_contextbytes", crypt.crypto_kdf_contextbytes )
			print_constant ("crypto_kdf_keybytes", crypt.crypto_kdf_keybytes )

				--	LIBSODIUM_KX_API
			print_constant ("crypto_kx_publickeybytes", crypt.crypto_kx_publickeybytes )
			print_constant ("crypto_kx_secretkeybytes", crypt.crypto_kx_secretkeybytes )
			print_constant ("crypto_kx_seedbytes", crypt.crypto_kx_seedbytes )
			print_constant ("crypto_kx_sessionkeybytes", crypt.crypto_kx_sessionkeybytes )

				--	LIBSODIUM_PWHASH_API
			print_constant ("crypto_pwhash_bytes_max", crypt.crypto_pwhash_bytes_max )
			print_constant ("crypto_pwhash_bytes_min", crypt.crypto_pwhash_bytes_min )
			print_constant ("crypto_pwhash_saltbytes", crypt.crypto_pwhash_saltbytes )
			print_constant ("crypto_pwhash_passwd_max", crypt.crypto_pwhash_passwd_max )
			print_constant ("crypto_pwhash_passwd_min", crypt.crypto_pwhash_passwd_min )

				--	LIBSODIUM_RANDOMBYTES_API
			print_constant ("randombytes_seedbytes", crypt.randombytes_seedbytes )

				--	LIBSODIUM_SCALARMULT_API
			print_constant ("crypto_scalarmult_bytes", crypt.crypto_scalarmult_bytes )
			print_constant ("crypto_scalarmult_scalarbytes", crypt.crypto_scalarmult_scalarbytes )

				--	LIBSODIUM_SECRETBOX_API
			print_constant ("crypto_secretbox_keybytes", crypt.crypto_secretbox_keybytes )
			print_constant ("crypto_secretbox_macbytes", crypt.crypto_secretbox_macbytes )
			print_constant ("crypto_secretbox_messagebytes_max", crypt.crypto_secretbox_messagebytes_max )
			print_constant ("crypto_secretbox_noncebytes", crypt.crypto_secretbox_noncebytes )
			print_constant ("crypto_secretbox_zerobytes", crypt.crypto_secretbox_zerobytes )

				--	LIBSODIUM_SHORTHASH_API
			print_constant ("crypto_shorthash_bytes", crypt.crypto_shorthash_bytes )
			print_constant ("crypto_shorthash_keybytes", crypt.crypto_shorthash_keybytes )

				--	LIBSODIUM_SIGN_API
			print_constant ("crypto_sign_bytes", crypt.crypto_sign_bytes )
			print_constant ("crypto_sign_publickeybytes", crypt.crypto_sign_publickeybytes )
			print_constant ("crypto_sign_seedbytes", crypt.crypto_sign_seedbytes )
			print_constant ("crypto_sign_statebytes", crypt.crypto_sign_statebytes )

				--	LIBSODIUM_STREAM_API
			print_constant ("crypto_stream_keybytes", crypt.crypto_stream_keybytes )
			print_constant ("crypto_stream_messagebytes_max", crypt.crypto_stream_messagebytes_max )
			print_constant ("crypto_stream_noncebytes", crypt.crypto_stream_noncebytes )

				--	LIBSODIUM_UTILS_API
			-- No constants here ...

				--	LIBSODIUM_VERSION_API
			-- See print_version ...
		end

	print_constant (a_name: STRING; a_value: INTEGER)
		do
			print (a_name); print (": ")
			if a_value < 0 then
				print ("UNKNOWN ...")
			else
				print (a_value.out)
			end
			print ("%N")
		end

feature -- Routine tests

	test_message: STRING_8 = "This is a test message ..."

	test
		local
			l_string: STRING_8
			l_msg: SODIUM_MESSAGE
			l_key: SODIUM_KEY
			l_nonce: SODIUM_NONCE
			l_encrypted: SODIUM_ENCRYPTED
			l_decrypted: SODIUM_MESSAGE
			l_success: BOOLEAN
		do
			l_string := test_message
				-- Create message from test string
			create l_msg.make_from_string (l_string)

				-- Create and initialize key
			create l_key

				-- Create and initialize nonce
			create l_nonce

				-- Create encrypted message ...
			create l_encrypted.make_from_message (l_msg, l_nonce, l_key)

				-- (Re)Create the decrypted message
			create l_decrypted.make_from_encrypted (l_encrypted, l_nonce, l_key)

				-- Compare message with encrypted/decrypted message ...
			l_success := crypt.compare (l_decrypted, l_msg)

				-- Report on the success/failure of this test ...
			if l_success then
				l_string := "Encrypt/Decrypt test succeeded ...%N"
			else
				l_string := "Encrypt/Decrypt test failed ...%N"
			end
			print (l_string)

		end

	test_password_hash
		local
			l_password: STRING
			l_salt: SODIUM_SALT
			l_pwhash: SODIUM_PASSWORD_HASH
		do
			l_password := "Test password hash storage"
			create l_salt
			create l_pwhash.make_store (l_password, l_salt)
			if l_pwhash.verify (l_password) then
				print ("Password verification OK%N")
			end
		end

	test_generic_hash
		local
--			mp: MANAGED_POINTER
--			l_input: MANAGED_POINTER
			l_hash: SODIUM_GENERIC_HASH
			l_key: SODIUM_KEY
		do
--			create mp.make (current.crypt.crypto_generichash_bytes)
--			create l_input.make_from_pointer (a_ptr: POINTER, n: INTEGER_32)
--			crypt.crypto_generichash (mp.item, mp.count, l_input, l_input.count, default_pointer, 0)

			create l_hash
			create l_key
			l_hash.hash (l_key)
			print ("Hex result: " + l_hash.as_hex_string + "%N")
		end

	test_key_exchange
		do

		end



feature

end
