note
	description: "EBK_GUI -- Client for GUI elements"
	author: "Howard Thomson"
	date: "$22-Apr-2022$"

class
	EBK_GUI

create
	make

feature -- Attributes

	ev_app: EV_APPLICATION

	ebk_window: EV_TITLED_WINDOW

feature -- Creation

	make
		do
			create ev_app
			create ebk_window
			ebk_window.set_minimum_size (100, 100)
			add_to_main_window
			ebk_window.show
			ev_app.launch
		end

	add_to_main_window
		local
			l_colour: EV_COLOR
			l_frame: EV_FRAME
		do
			create l_colour.make_with_rgb (1, 0, 0)
			ebk_window.set_background_color (l_colour)
			create l_frame
			ebk_window.extend (l_frame)
		--	l_subwindow.set_size (ebk_window.width - 4, ebk_window.height - 4)
			l_frame.set_border_width (4)
		--	l_frame.set_

			ebk_window.close_request_actions.extend (agent req_close_window)
		end

	req_close_window
		do
			ebk_window.destroy
			ev_app.destroy
--			print ("Exit the GUI%N")
		end

end
