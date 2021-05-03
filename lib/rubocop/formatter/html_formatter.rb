# frozen_string_literal: true

require 'cgi'
require 'erb'
require 'ostruct'
require 'base64'
require_relative 'text_util'

module RuboCop
  module Formatter
    # This formatter saves the output as an html file.
    class HTMLFormatter < BaseFormatter
      ELLIPSES = '<span class="extra-code">...</span>'
      TEMPLATE_PATH = File.expand_path('../../../assets/output.html.erb', __dir__)

      Color = Struct.new(:red, :green, :blue, :alpha) do
        def to_s
          "rgba(#{values.join(', ')})"
        end

        def fade_out(amount)
          dup.tap { |color| color.alpha -= amount }
        end
      end

      def initialize(output, options = {})
        super
        @files = []
        @summary = OpenStruct.new(offense_count: 0)
      end

      attr_reader :files, :summary

      def started(target_files)
        summary.target_files = target_files
      end

      def file_finished(file, offenses)
        files << OpenStruct.new(path: file, offenses: offenses)
        summary.offense_count += offenses.count
      end

      def finished(inspected_files)
        summary.inspected_files = inspected_files

        render_html
      end

      def render_html
        context = ERBContext.new(files, summary)

        template = File.read(TEMPLATE_PATH, encoding: Encoding::UTF_8)

        # The following condition is workaround for until Ruby 2.6 is released.
        # https://github.com/ruby/ruby/commit/cc777d09f44fa909a336ba14f3aa802ffe16e010
        erb = if RUBY_VERSION >= '2.6'
                ERB.new(template, trim_mode: '-')
              else
                ERB.new(template, nil, '-')
              end
        html = erb.result(context.binding)

        output.write html
      end

      # This class provides helper methods used in the ERB template.
      class ERBContext
        include PathUtil
        include TextUtil

        SEVERITY_COLORS = {
          refactor:   Color.new(0xED, 0x9C, 0x28, 1.0),
          convention: Color.new(0xED, 0x9C, 0x28, 1.0),
          warning:    Color.new(0x96, 0x28, 0xEF, 1.0),
          error:      Color.new(0xD2, 0x32, 0x2D, 1.0),
          fatal:      Color.new(0xD2, 0x32, 0x2D, 1.0)
        }.freeze

        LOGO_IMAGE_PATH = File.expand_path('../../../assets/logo.png', __dir__)

        def initialize(files, summary)
          @files = files.sort_by(&:path)
          @summary = summary
        end

        attr_reader :files, :summary

        # Make Kernel#binding public.
        # rubocop:disable Lint/UselessMethodDefinition
        def binding
          super
        end
        # rubocop:enable Lint/UselessMethodDefinition

        def decorated_message(offense)
          offense.message.gsub(/`(.+?)`/) { "<code>#{Regexp.last_match(1)}</code>" }
        end

        def highlighted_source_line(offense)
          source_before_highlight(offense) +
            hightlight_source_tag(offense) +
            source_after_highlight(offense) +
            possible_ellipses(offense.location)
        end

        def hightlight_source_tag(offense)
          "<span class=\"highlight #{offense.severity}\">" \
            "#{escape(offense.highlighted_area.source)}" \
            '</span>'
        end

        def source_before_highlight(offense)
          source_line = offense.location.source_line
          escape(source_line[0...offense.highlighted_area.begin_pos])
        end

        def source_after_highlight(offense)
          source_line = offense.location.source_line
          escape(source_line[offense.highlighted_area.end_pos..-1])
        end

        def possible_ellipses(location)
          location.first_line == location.last_line ? '' : " #{ELLIPSES}"
        end

        def escape(string)
          CGI.escapeHTML(string)
        end

        def base64_encoded_logo_image
          image = File.read(LOGO_IMAGE_PATH, binmode: true)
          Base64.encode64(image)
        end
      end
    end
  end
end
