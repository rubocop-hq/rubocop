# encoding: utf-8

require 'backports/2.0.0/array/bsearch'
require 'rainbow'
require 'English'
require 'parser/current'
require 'ast/sexp'
require 'powerpack'

require 'rubocop/cop/util'
require 'rubocop/cop/variable_inspector'
require 'rubocop/cop/offence'
require 'rubocop/cop/cop'
require 'rubocop/cop/commissioner'
require 'rubocop/cop/corrector'

require 'rubocop/cop/lint/assignment_in_condition'
require 'rubocop/cop/lint/block_alignment'
require 'rubocop/cop/lint/empty_ensure'
require 'rubocop/cop/lint/end_alignment'
require 'rubocop/cop/lint/end_in_method'
require 'rubocop/cop/lint/ensure_return'
require 'rubocop/cop/lint/eval'
require 'rubocop/cop/lint/handle_exceptions'
require 'rubocop/cop/lint/literal_in_condition'
require 'rubocop/cop/lint/loop'
require 'rubocop/cop/lint/rescue_exception'
require 'rubocop/cop/lint/shadowing_outer_local_variable'
require 'rubocop/cop/lint/unreachable_code'
require 'rubocop/cop/lint/unused_local_variable'
require 'rubocop/cop/lint/void'

require 'rubocop/cop/style/access_control'
require 'rubocop/cop/style/alias'
require 'rubocop/cop/style/align_parameters'
require 'rubocop/cop/style/and_or'
require 'rubocop/cop/style/ascii_comments'
require 'rubocop/cop/style/ascii_identifiers'
require 'rubocop/cop/style/attr'
require 'rubocop/cop/style/avoid_class_vars'
require 'rubocop/cop/style/avoid_for'
require 'rubocop/cop/style/avoid_global_vars'
require 'rubocop/cop/style/avoid_perl_backrefs'
require 'rubocop/cop/style/avoid_perlisms'
require 'rubocop/cop/style/begin_block'
require 'rubocop/cop/style/block_comments'
require 'rubocop/cop/style/block_nesting'
require 'rubocop/cop/style/blocks'
require 'rubocop/cop/style/character_literal'
require 'rubocop/cop/style/case_equality'
require 'rubocop/cop/style/case_indentation'
require 'rubocop/cop/style/class_and_module_camel_case'
require 'rubocop/cop/style/class_methods'
require 'rubocop/cop/style/collection_methods'
require 'rubocop/cop/style/colon_method_call'
require 'rubocop/cop/style/comment_annotation'
require 'rubocop/cop/style/constant_name'
require 'rubocop/cop/style/def_parentheses'
require 'rubocop/cop/style/documentation'
require 'rubocop/cop/style/dot_position'
require 'rubocop/cop/style/empty_line_between_defs'
require 'rubocop/cop/style/empty_lines'
require 'rubocop/cop/style/empty_literal'
require 'rubocop/cop/style/encoding'
require 'rubocop/cop/style/end_block'
require 'rubocop/cop/style/end_of_line'
require 'rubocop/cop/style/favor_join'
require 'rubocop/cop/style/favor_modifier'
require 'rubocop/cop/style/favor_sprintf'
require 'rubocop/cop/style/favor_unless_over_negated_if'
require 'rubocop/cop/style/hash_syntax'
require 'rubocop/cop/style/if_then_else'
require 'rubocop/cop/style/if_with_semicolon'
require 'rubocop/cop/style/multiline_if_then'
require 'rubocop/cop/style/one_line_conditional'
require 'rubocop/cop/style/lambda'
require 'rubocop/cop/style/leading_comment_space'
require 'rubocop/cop/style/line_continuation'
require 'rubocop/cop/style/line_length'
require 'rubocop/cop/style/method_and_variable_snake_case'
require 'rubocop/cop/style/method_call_parentheses'
require 'rubocop/cop/style/method_length'
require 'rubocop/cop/style/not'
require 'rubocop/cop/style/numeric_literals'
require 'rubocop/cop/style/op_method'
require 'rubocop/cop/style/parameter_lists'
require 'rubocop/cop/style/parentheses_around_condition'
require 'rubocop/cop/style/proc'
require 'rubocop/cop/style/reduce_arguments'
require 'rubocop/cop/style/redundant_begin'
require 'rubocop/cop/style/redundant_return'
require 'rubocop/cop/style/redundant_self'
require 'rubocop/cop/style/regexp_literal'
require 'rubocop/cop/style/rescue_modifier'
require 'rubocop/cop/style/semicolon'
require 'rubocop/cop/style/single_line_methods'
require 'rubocop/cop/style/space_after_comma_etc'
require 'rubocop/cop/style/space_after_control_keyword'
require 'rubocop/cop/style/string_literals'
require 'rubocop/cop/style/surrounding_space'
require 'rubocop/cop/style/symbol_array'
require 'rubocop/cop/style/symbol_name'
require 'rubocop/cop/style/tab'
require 'rubocop/cop/style/ternary_operator'
require 'rubocop/cop/style/trailing_whitespace'
require 'rubocop/cop/style/trivial_accessors'
require 'rubocop/cop/style/unless_else'
require 'rubocop/cop/style/variable_interpolation'
require 'rubocop/cop/style/when_then'
require 'rubocop/cop/style/while_until_do'
require 'rubocop/cop/style/word_array'

require 'rubocop/cop/rails/validation'

require 'rubocop/formatter/base_formatter'
require 'rubocop/formatter/simple_text_formatter'
require 'rubocop/formatter/emacs_style_formatter'
require 'rubocop/formatter/clang_style_formatter'
require 'rubocop/formatter/progress_formatter'
require 'rubocop/formatter/json_formatter'
require 'rubocop/formatter/file_list_formatter'
require 'rubocop/formatter/formatter_set'

require 'rubocop/config'
require 'rubocop/config_store'
require 'rubocop/target_finder'
require 'rubocop/token'
require 'rubocop/processed_source'
require 'rubocop/source_parser'
require 'rubocop/cli'
require 'rubocop/version'
