require "#{File.dirname(__FILE__)}/devbox"
$LOAD_PATH << "#{Devbox.tools_root}/lib"

require "generate_global_project_identifier"
require "command_dispatcher"
require "dependency_registry"
require "finder"
require "plugin_file_finder"
require "logger"
require "shell"
require "git"
require "caches/file_cache"

plugin_directories = [
  "#{Devbox.root}/plugins",
  Devbox.tools_root,
]

plugin_directories << "#{Devbox.tools_root}/test/plugins" if ENV["DEVBOX_TEST"]

PluginFileFinder.new(plugin_directories).plugin_files.each do |plugin_path|
  if Devbox.debug?
    puts "Loading #{plugin_path}"
  end

  require plugin_path
end
