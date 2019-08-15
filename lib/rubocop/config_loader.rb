# frozen_string_literal: true

require 'yaml'
require 'pathname'

module RuboCop
  # Raised when a RuboCop configuration file is not found.
  class ConfigNotFoundError < Error
  end

  # This class represents the configuration of the RuboCop application
  # and all its cops. A Config is associated with a YAML configuration
  # file from which it was read. Several different Configs can be used
  # during a run of the rubocop program, if files in several
  # directories are inspected.
  class ConfigLoader
    DOTFILE = '.rubocop.yml'
    XDG_CONFIG = 'config.yml'
    RUBOCOP_HOME = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
    DEFAULT_FILE = File.join(RUBOCOP_HOME, 'config', 'default.yml')
    AUTO_GENERATED_FILE = '.rubocop_todo.yml'

    class << self
      include FileFinder

      attr_accessor :debug, :auto_gen_config, :ignore_parent_exclusion,
                    :options_config
      attr_writer :default_configuration

      alias debug? debug
      alias auto_gen_config? auto_gen_config
      alias ignore_parent_exclusion? ignore_parent_exclusion

      def clear_options
        @debug = @auto_gen_config = @options_config = nil
        FileFinder.root_level = nil
      end

      def load_file(file)
        path = File.absolute_path(file.is_a?(RemoteConfig) ? file.file : file)

        hash = load_yaml_configuration(path)

        # Resolve requires first in case they define additional cops
        resolver.resolve_requires(path, hash)

        add_missing_namespaces(path, hash)

        resolver.resolve_inheritance_from_gems(hash, hash.delete('inherit_gem'))
        resolver.resolve_inheritance(path, hash, file, debug?)

        hash.delete('inherit_from')

        Config.create(hash, path)
      end

      def add_missing_namespaces(path, hash)
        hash.keys.each do |key|
          q = Cop::Cop.qualified_cop_name(key, path)
          next if q == key

          hash[q] = hash.delete(key)
        end
      end

      # Return a recursive merge of two hashes. That is, a normal hash merge,
      # with the addition that any value that is a hash, and occurs in both
      # arguments, will also be merged. And so on.
      def merge(base_hash, derived_hash)
        resolver.merge(base_hash, derived_hash)
      end

      # Returns the path of .rubocop.yml searching upwards in the
      # directory structure starting at the given directory where the
      # inspected file is. If no .rubocop.yml is found there, the
      # user's home directory is checked. If there's no .rubocop.yml
      # there either, the path to the default file is returned.
      def configuration_file_for(target_dir)
        find_project_dotfile(target_dir) ||
          find_user_dotfile ||
          find_user_xdg_config ||
          DEFAULT_FILE
      end

      def configuration_from_file(config_file)
        config = load_file(config_file)
        return config if config_file == DEFAULT_FILE

        if ignore_parent_exclusion?
          print 'Ignoring AllCops/Exclude from parent folders' if debug?
        else
          add_excludes_from_files(config, config_file)
        end
        merge_with_default(config, config_file)
      end

      def add_excludes_from_files(config, config_file)
        found_files =
          find_files_upwards(DOTFILE, config_file) +
          [find_user_dotfile, find_user_xdg_config].compact

        return if found_files.empty?
        return if PathUtil.relative_path(found_files.last) ==
                  PathUtil.relative_path(config_file)

        print 'AllCops/Exclude ' if debug?
        config.add_excludes_from_higher_level(load_file(found_files.last))
      end

      def default_configuration
        @default_configuration ||= begin
          print 'Default ' if debug?
          load_file(DEFAULT_FILE)
        end
      end

      # Merges the given configuration with the default one. If
      # AllCops:DisabledByDefault is true, it changes the Enabled params so
      # that only cops from user configuration are enabled.
      # If AllCops::EnabledByDefault is true, it changes the Enabled params
      # so that only cops explicitly disabled in user configuration are
      # disabled.
      def merge_with_default(config, config_file, unset_nil: true)
        resolver.merge_with_default(config, config_file, unset_nil: unset_nil)
      end

      def add_inheritance_from_auto_generated_file
        file_string = " #{AUTO_GENERATED_FILE}"

        config_file = options_config || DOTFILE

        if File.exist?(config_file)
          files = Array(load_yaml_configuration(config_file)['inherit_from'])

          return if files.include?(AUTO_GENERATED_FILE)

          files.unshift(AUTO_GENERATED_FILE)
          file_string = "\n  - " + files.join("\n  - ") if files.size > 1
          rubocop_yml_contents = existing_configuration(config_file)
        end

        write_config_file(config_file, file_string, rubocop_yml_contents)

        puts "Added inheritance from `#{AUTO_GENERATED_FILE}` in `#{DOTFILE}`."
      end

      private

      def find_project_dotfile(target_dir)
        find_file_upwards(DOTFILE, target_dir)
      end

      def find_user_dotfile
        return unless ENV.key?('HOME')

        file = File.join(Dir.home, DOTFILE)
        return file if File.exist?(file)
      end

      def find_user_xdg_config
        xdg_config_home = expand_path(ENV.fetch('XDG_CONFIG_HOME', '~/.config'))
        xdg_config = File.join(xdg_config_home, 'rubocop', XDG_CONFIG)
        return xdg_config if File.exist?(xdg_config)
      end

      def expand_path(path)
        File.expand_path(path)
      rescue ArgumentError
        # Could happen because HOME or ID could not be determined. Fall back on
        # using the path literally in that case.
        path
      end

      def existing_configuration(config_file)
        IO.read(config_file, encoding: Encoding::UTF_8)
          .sub(/^inherit_from: *[^\n]+/, '')
          .sub(/^inherit_from: *(\n *- *[^\n]+)+/, '')
      end

      def write_config_file(file_name, file_string, rubocop_yml_contents)
        File.open(file_name, 'w') do |f|
          f.write "inherit_from:#{file_string}\n"
          f.write "\n#{rubocop_yml_contents}" if rubocop_yml_contents =~ /\S/
        end
      end

      def resolver
        @resolver ||= ConfigLoaderResolver.new
      end

      def load_yaml_configuration(absolute_path)
        yaml_code = read_file(absolute_path)
        check_duplication(yaml_code, absolute_path)
        hash = yaml_safe_load(yaml_code, absolute_path) || {}

        puts "configuration from #{absolute_path}" if debug?

        unless hash.is_a?(Hash)
          raise(TypeError, "Malformed configuration in #{absolute_path}")
        end

        hash
      end

      def check_duplication(yaml_code, absolute_path)
        smart_path = PathUtil.smart_path(absolute_path)
        YAMLDuplicationChecker.check(yaml_code, absolute_path) do |key1, key2|
          value = key1.value
          # .start_line is only available since ruby 2.5 / psych 3.0
          message = if key1.respond_to? :start_line
                      line1 = key1.start_line + 1
                      line2 = key2.start_line + 1
                      "#{smart_path}:#{line1}: " \
                      "`#{value}` is concealed by line #{line2}"
                    else
                      "#{smart_path}: " \
                        "`#{value}` is concealed by duplicate"
                    end
          warn Rainbow(message).yellow
        end
      end

      # Read the specified file, or exit with a friendly, concise message on
      # stderr. Care is taken to use the standard OS exit code for a "file not
      # found" error.
      def read_file(absolute_path)
        IO.read(absolute_path, encoding: Encoding::UTF_8)
      rescue Errno::ENOENT
        raise ConfigNotFoundError,
              "Configuration file not found: #{absolute_path}"
      end

      def yaml_safe_load(yaml_code, filename)
        if defined?(SafeYAML) && SafeYAML.respond_to?(:load)
          SafeYAML.load(yaml_code, filename,
                        whitelisted_tags: %w[!ruby/regexp])
        # Ruby 2.6+
        elsif Gem::Version.new(Psych::VERSION) >= Gem::Version.new('3.1.0')
          YAML.safe_load(
            yaml_code,
            permitted_classes: [Regexp, Symbol],
            permitted_symbols: [],
            aliases: false,
            filename: filename
          )
        else
          YAML.safe_load(yaml_code, [Regexp, Symbol], [], false, filename)
        end
      end
    end

    # Initializing class ivars
    clear_options
  end
end
