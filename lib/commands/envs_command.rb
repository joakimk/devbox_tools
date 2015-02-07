require "envs_at_login"

class EnvsCommand < Command
  def initialize(project_dependencies, envs_at_login)
    @project_dependencies = project_dependencies
    @envs_at_login = envs_at_login
  end

  def list
    {
      "envs" => "Prints the project's environment variables"
    }
  end

  def run(_name, output = STDOUT)
    new_envs_since_logged_in.each do |name, _|
      output.puts "unset #{name}"
    end

    envs_to_set.each do |name, value|
      output.puts "export #{name}=#{value.inspect}"
    end
  end

  private

  private

  def new_envs_since_logged_in
    ENV.to_hash.reject { |k, v| envs_at_login.keys.include?(k) }
  end

  def envs_to_set
    envs = envs_at_login.dup

    project_dependencies.each do |dependency|
      envs = dependency.environment_variables(envs.dup)
    end

    envs
  end

  attr_reader :project_dependencies, :envs_at_login
end

project_dependencies = DependencyRegistry.dependencies_used_by_the_current_project
envs_at_login = EnvsAtLogin.call
command = EnvsCommand.new(project_dependencies, envs_at_login)
CommandDispatcher.register(command)