RIO_ROOT_PATH = File.join(File.dirname(__FILE__))
SUPPORT_PATH = File.join(File.dirname(__FILE__))
CONTROL_PATH = File.join(SUPPORT_PATH, 'controller')
WEBDIALOG_PATH   = File.join(SUPPORT_PATH, 'webpages/html')
SKETCHUP_CONSOLE.show

begin
 require 'mysql'
rescue LoadError
 Gem::install 'ruby-mysql'
end

begin
 require "sqlite3"
rescue LoadError
 Gem::install 'sqlite3'
end

begin
 require "aws-sdk"
rescue LoadError
 Gem::install 'aws-sdk'
end


def z
	comp=Sketchup.active_model.selection[0]
	point = comp.transformation.origin
	vector = Geom::Vector3d.new(0,0,1)
	angle = 90.degrees
	transformation = Geom::Transformation.rotation(point, vector, angle)
	comp.transform!(transformation)
end

Sketchup.active_model.definitions['Chris'].instances.each{|x| x.visible=false}

module Decor_Standards
	path = File.dirname(__FILE__)
	cont_path = File.join(path, 'controller')

	Sketchup::require File.join(cont_path, 'login_control.rb')
	Sketchup::require File.join(cont_path, 'load_toolbar.rb')
	Sketchup::require File.join(cont_path, 'working_drawing.rb')
	Sketchup::require File.join(cont_path, 'aws_database.rb')
	Sketchup::require File.join(cont_path, 'aws_downloader.rb')
	Sketchup::require File.join(cont_path, 'dp_core.rb')
	Sketchup::require File.join(cont_path, 'add_attribute.rb')
	Sketchup::require File.join(cont_path, 'create_comp.rb')
	Sketchup::require File.join(cont_path, 'home_file.rb')
	Sketchup::require File.join(cont_path, 'export_html.rb')
	Sketchup::require File.join(cont_path, 'dp_core.rb')
	Sketchup::require File.join(cont_path, 'color_picker.rb')
	
	DP::create_layers
end

puts "test2"