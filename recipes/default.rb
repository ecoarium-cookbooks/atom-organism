#
# Cookbook Name:: atom-organism
# Recipe:: default
#

require 'pathname'

include_recipe 'atom'

node[:atom_organism][:packages].each{|atom_package|
  atom_apm atom_package
}

organism_directory = File.expand_path('../files/default/organism', File.dirname(__FILE__))

Dir.glob("#{organism_directory}/**/*"){|io_object|
  relative_path_io_object = Pathname.new(io_object).relative_path_from(Pathname.new(organism_directory)).to_s
  target_path = "#{$WORKSPACE_SETTINGS[:paths][:project][:workspace][:settings][:organisms][:home]}/atom/#{relative_path_io_object}"

  if File.directory?(io_object)
    directory target_path do
      recursive true
      owner ENV['USER']
    end
  else
    cookbook_file target_path do
      source relative_path_io_object
      owner ENV['USER']
    end
  end
}
