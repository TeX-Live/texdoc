shared_context "messages" do
  # the aliases to access outputs
  let(:stdout) { last_command_started.stdout.gsub("\r", "") }
  let(:stderr) { last_command_started.stderr.gsub("\r", "") }

  # functions for output line genaration
  def error_line msg
    return "texdoc error: #{msg}"
  end

  def warning_line msg
    return "texdoc warning: #{msg}"
  end

  def info_line msg
    return "texdoc info: #{msg}"
  end

  def debug_line cat, msg=""
    if msg.empty?
      return "texdoc debug-#{cat}:"
    else
      return "texdoc debug-#{cat}: #{msg}"
    end
  end

  # shorthands
  def set_from_cl_line config, opt
    debug_line "config",
      "Setting \"#{config}\" from command-line option \"#{opt}\""
  end

  def ignore_from_cl_line config, opt
    debug_line "config",
      "Ignoring \"#{config}\" from command-line option \"#{opt}\""
  end

  def set_from_env_line config, env
    debug_line "config",
      "Setting \"#{config}\" from environment variable \"#{env}\""
  end

  def ignore_from_env_line config, env
    debug_line "config",
      "Ignoring \"#{config}\" from environment variable \"#{env}\""
  end

  def set_from_file_line config, file
    debug_line "config",
      "Setting \"#{config}\" in file \"#{normalize_path(file)}\""
  end

  def ignore_from_file_line config, file
    debug_line "config",
      "Ignoring \"#{config}\" in file \"#{normalize_path(file)}\""
  end
end
