# frozen_string_literal: true

module RuboCop
  # Handles caching of configurations and association of inspected
  # ruby files to configurations.
  class ConfigStore
    def initialize
      # @options_config stores a config that is specified in the command line.
      # This takes precedence over configs located in any directories
      @options_config = nil

      # @path_cache maps directories to configuration paths. We search
      # for .rubocop.yml only if we haven't already found it for the
      # given directory.
      @path_cache = {}

      # @object_cache maps configuration file paths to
      # configuration objects so we only need to load them once.
      @object_cache = {}
    end

    def options_config=(options_config)
      loaded_config = ConfigLoader.load_file(options_config)
      @options_config = ConfigLoader.merge_with_default(loaded_config,
                                                        options_config)
    end

    def force_default_config!
      @options_config = ConfigLoader.default_configuration
    end

    def for(file_or_dir)
      return @options_config if @options_config

      dir = if File.directory?(file_or_dir)
              file_or_dir
            else
              File.dirname(file_or_dir)
            end
      @path_cache[dir] ||= ConfigLoader.configuration_file_for(dir)
      path = @path_cache[dir]
      @object_cache[path] ||= begin
        print "For #{dir}: " if ConfigLoader.debug?
        ConfigLoader.configuration_from_file(path)
      end
    end
  end
end
