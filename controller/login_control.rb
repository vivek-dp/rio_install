module Decor_Standards
	def self.load_login
		dialog = UI::HtmlDialog.new({:dialog_title=>"RioSTD Login", :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :width=>600, :height=>700, :style=>UI::HtmlDialog::STYLE_DIALOG})
		html_path = File.join(WEBDIALOG_PATH, 'load_login.html')
		dialog.set_file(html_path)
		dialog.set_position(0, 80)
		dialog.show

		dialog.add_action_callback("loginval"){|a, b|
			spval = b.split(",")
			user_auth = RioDbLib::authenticate_aws_user spval[0], spval[1]
			if user_auth == true
				RioAwsDownload::download_component_list
				visible = 1
				$rio_logged_in = true
			elsif user_auth == false
				visible = 0
			end
			jslog = "validateLog("+visible.to_s+")"
			dialog.execute_script(jslog)
		}

		dialog.add_action_callback("checkonline"){|a, b|
			if Sketchup.is_online == true
				online = 1
			elsif Sketchup.is_online == false
				online = 0
			end
			jsonline = "passStatus("+online.to_s+")"
			dialog.execute_script(jsonline)
		}

		dialog.add_action_callback("openapp"){|a, b|
			dialog.close
			self.decor_index()
		}
	end
end