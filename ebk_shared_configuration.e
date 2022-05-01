note
	description: "Shared configuration for EBK"
	author: "Howard Thomson"
	date: "1-May-2022"

class
	EBK_SHARED_CONFIGURATION

feature
	config: EBK_CONFIGURATION
		once ("process")
			create Result.make
		end

end
