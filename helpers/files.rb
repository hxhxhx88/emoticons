require 'fileutils'

def ensure_can_write_file(path)
    # Create intermidate directories if necessory
    dirname = File.dirname(path)
    unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
    end
end
