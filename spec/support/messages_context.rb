shared_context "messages" do
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
end
