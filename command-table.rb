require 'csv'
require 'open3'
require 'logger'

COMMAND, *FILES = *ARGV

logger = Logger.new(STDERR)
csv_string = CSV.generate{|csv|
  csv << ['', *FILES]
  FILES.each{|file1|
    line = [file1]
    FILES.each{|file2|
      command = COMMAND.gsub(/\$1/, file1).gsub(/\$2/, file2)
      logger.info command
      result, status = Open3.capture2e(command)
      unless status.success?
        logger.warn [status, result]
      end
      line << result
    }
    csv << line
  }
}

puts csv_string
