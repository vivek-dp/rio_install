module Decor_Standards
	DECORPOT_MENU = UI.menu('Plugins').add_item('RioSTD'){
   	if $rio_logged_in == true
   		self.decor_index()
   	else
   		self.load_login
   	end
	}
end