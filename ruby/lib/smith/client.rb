require 'smith'
require 'logger'
require 'faye'
require 'ostruct'

Dir["#{Smith.root}/lib/smith/client/**/*.rb"].each { |f| require(f) }

module Smith
  module Client

    class << self
      attr_accessor :logger
    end

    module_function

    def server_url
      ENV['SERVER_URL']
    end

    def registration_info_file
      ENV['REGISTRATION_INFO_FILE']
    end

    def print_settings_file
      ENV['PRINT_SETTINGS_FILE']
    end

    def aws_access_key_id
      ENV['AWS_ACCESS_KEY_ID']
    end

    def aws_secret_access_key
      ENV['AWS_SECRET_ACCESS_KEY']
    end

    def s3_log_bucket
      ENV['S3_LOG_BUCKET']
    end

    def api_version
      'v1'
    end

    def log_info(message)
      logger.info(message) if logger
    end

    def log_error(message)
      logger.error(message) if logger
    end

    def log_debug(message)
      logger.debug(message) if logger
    end

    def log_warn(message)
      logger.warn(message) if logger
    end

    def enable_logging(logdev = nil, formatter = nil)
      # Flush stdout immediately if using STDOUT as logdev
      STDOUT.sync = true if logdev.nil?
      self.logger = Logger.new(logdev || STDOUT)
      logger.progname = 'smith-client'
      logger.formatter = formatter if formatter
    end

    def enable_faye_logging(logdev = nil)
      # Flush stdout immediately if using STDOUT as logdev
      STDOUT.sync = true if logdev.nil?
      Faye.logger = Logger.new(logdev || STDOUT)
      Faye.logger.level = Logger::INFO
    end

    def start
      EventLoop.new(OpenStruct.new, 60).start
    end

  end
end
