# frozen_string_literal: true

module RuboCop
  module Cop
    # Identifier of all cops containing a department and cop name.
    #
    # All cops are identified by their badge. For example, the badge for
    # `RuboCop::Cop::Layout::IndentationStyle` is `Layout/IndentationStyle`.
    # Badges can be parsed as either `Department/CopName` or just `CopName` to
    # allow for badge references in source files that omit the department for
    # RuboCop to infer.
    class Badge
      def self.for(class_name)
        parts = class_name.split('::')
        name_deep_enough = parts.length >= 4
        new(name_deep_enough ? parts[2..-1] : parts.last(2))
      end

      def self.parse(identifier)
        new(identifier.split('/'))
      end

      def initialize(class_name_parts)
        department_parts = class_name_parts[0...-1]
        @department = (department_parts.join('/').to_sym unless department_parts.empty?)
        @cop_name = class_name_parts.last
      end

      attr_reader :department, :cop_name

      def ==(other)
        hash == other.hash
      end
      alias eql? ==

      def hash
        [department, cop_name].hash
      end

      def match?(other)
        cop_name == other.cop_name && (!qualified? || department == other.department)
      end

      def to_s
        @to_s ||= qualified? ? "#{department}/#{cop_name}" : cop_name
      end

      def qualified?
        !department.nil?
      end

      def with_department(department)
        self.class.new([department.to_s.split('/'), cop_name].flatten)
      end
    end
  end
end
