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
      source "organism/#{relative_path_io_object}"
      owner ENV['USER']
    end
  end
}

atom_home = "#{ENV['HOME']}/.atom"

execute "correct_ownership_of_atom_home" do
  command "chown -R #{ENV['USER']} #{atom_home}"
  not_if {
    !::File.exist?(atom_home) and IO.popen("find #{atom_home} ! -user #{ENV['USER']}").readlines.empty?
  }
end
