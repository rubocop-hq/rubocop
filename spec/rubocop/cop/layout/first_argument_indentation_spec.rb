# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::FirstArgumentIndentation, :config do
  let(:cop_config) do
    {
      'EnforcedStyle' => style,
      'AllowMethodDefinitionArgument' => allow_method_definition_argument
    }
  end

  let(:other_cops) do
    {
      'Layout/IndentationWidth' => {
        'Width' => indentation_width
      }
    }
  end

  let(:allow_method_definition_argument) { false }

  shared_examples 'common behavior' do
    context 'when IndentationWidth:Width is 2' do
      let(:indentation_width) { 2 }

      it 'registers an offense and corrects an over-indented first argument' do
        expect_offense(<<~RUBY)
          run(
              :foo,
              ^^^^ Indent the first argument one step more than the start of the previous line.
              bar: 3
          )
        RUBY

        expect_correction(<<~RUBY)
          run(
            :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects an over-indented first argument on an alphanumeric method name' do
        expect_offense(<<~RUBY)
          self.run(
              :foo,
              ^^^^ Indent the first argument one step more than the start of the previous line.
              bar: 3
          )
        RUBY

        expect_correction(<<~RUBY)
          self.run(
            :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects an over-indented first argument on a pipe method name' do
        expect_offense(<<~RUBY)
          self.|(
              :foo,
              ^^^^ Indent the first argument one step more than the start of the previous line.
              bar: 3
          )
        RUBY

        expect_correction(<<~RUBY)
          self.|(
            :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects an over-indented first argument on a plus sign method name' do
        expect_offense(<<~RUBY)
          self.+(
              :foo,
              ^^^^ Indent the first argument one step more than the start of the previous line.
              bar: 3
          )
        RUBY

        expect_correction(<<~RUBY)
          self.+(
            :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects an under-indented first argument' do
        expect_offense(<<~RUBY)
          run(
           :foo,
           ^^^^ Indent the first argument one step more than the start of the previous line.
              bar: 3
          )
        RUBY

        expect_correction(<<~RUBY)
          run(
            :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects lines ' \
        'affected by another offense' do
        expect_offense(<<~RUBY)
          foo(
           bar(
           ^^^^ Indent the first argument one step more than the start of the previous line.
            7
            ^ Bad indentation of the first argument.
          )
          )
        RUBY

        # The first `)` Will be corrected by IndentationConsistency.
        expect_correction(<<~RUBY, loop: false)
          foo(
            bar(
             7
           )
          )
        RUBY
      end

      context 'when using safe navigation operator' do
        it 'registers an offense and corrects an under-indented 1st argument' do
          expect_offense(<<~RUBY)
            receiver&.run(
             :foo,
             ^^^^ Indent the first argument one step more than the start of the previous line.
                bar: 3
            )
          RUBY

          expect_correction(<<~RUBY)
            receiver&.run(
              :foo,
                bar: 3
            )
          RUBY
        end
      end

      context 'for assignment' do
        it 'accepts a correctly indented first argument and does not care ' \
           'about the second argument' do
          expect_no_offenses(<<~RUBY)
            x = run(
              :foo,
                bar: 3
            )
          RUBY
        end

        context 'with line break' do
          it 'accepts a correctly indented first argument' do
            expect_no_offenses(<<~RUBY)
              x =
                run(
                  :foo)
            RUBY
          end

          it 'registers an offense and corrects ' \
            'an under-indented first argument' do
            expect_offense(<<~RUBY)
              @x =
                run(
                :foo)
                ^^^^ Indent the first argument one step more than the start of the previous line.
            RUBY

            expect_correction(<<~RUBY)
              @x =
                run(
                  :foo)
            RUBY
          end
        end
      end

      it 'accepts a first argument that is not preceded by a line break' do
        expect_no_offenses(<<~RUBY)
          run :foo,
              bar: 3
        RUBY
      end

      context 'when the receiver contains a line break' do
        it 'accepts a correctly indented first argument' do
          expect_no_offenses(<<~RUBY)
            puts x.
              merge(
                b: 2
              )
          RUBY
        end

        it 'registers an offense and corrects ' \
          'an over-indented first argument' do
          expect_offense(<<~RUBY)
            puts x.
              merge(
                  b: 2
                  ^^^^ Indent the first argument one step more than the start of the previous line.
              )
          RUBY

          expect_correction(<<~RUBY)
            puts x.
              merge(
                b: 2
              )
          RUBY
        end

        it 'accepts a correctly indented first argument preceded by an ' \
           'empty line' do
          expect_no_offenses(<<~RUBY)
            puts x.
              merge(

                b: 2
              )
          RUBY
        end

        context 'when preceded by a comment line' do
          it 'accepts a correctly indented first argument' do
            expect_no_offenses(<<~RUBY)
              puts x.
                merge( # EOL comment
                  # comment
                  b: 2
                )
            RUBY
          end

          it 'registers an offense and corrects ' \
            'an under-indented first argument' do
            expect_offense(<<~RUBY)
              puts x.
                merge(
                # comment
                b: 2
                ^^^^ Indent the first argument one step more than the start of the previous line (not counting the comment).
                )
            RUBY

            expect_correction(<<~RUBY)
              puts x.
                merge(
                # comment
                  b: 2
                )
            RUBY
          end
        end
      end

      it 'accepts method calls with no arguments' do
        expect_no_offenses(<<~RUBY)
          run()
          run_again
        RUBY
      end

      it 'accepts operator calls' do
        expect_no_offenses(<<~RUBY)
          params = default_cfg.keys - %w(Description) -
                   cfg.keys
        RUBY
      end

      it 'does not view []= as an outer method call' do
        expect_no_offenses(<<~RUBY)
          @subject_results[subject] = original.update(
            mutation_results: (dup << mutation_result),
            tests:            test_result.tests
          )
        RUBY
      end

      it 'does not view chained call as an outer method call' do
        expect_no_offenses(<<~'RUBY')
          A = Regexp.union(
            /[A-Za-z_][A-Za-z\d_]*[!?=]?/,
            *AST::Types::OPERATOR_METHODS.map(&:to_s)
          ).freeze
        RUBY
      end
    end

    context 'when IndentationWidth:Width is 4' do
      let(:indentation_width) { 4 }

      it 'registers an offense and corrects an over-indented first argument' do
        expect_offense(<<~RUBY)
          run(
                  :foo,
                  ^^^^ Indent the first argument one step more than the start of the previous line.
              bar: 3)
        RUBY

        expect_correction(<<~RUBY)
          run(
              :foo,
              bar: 3)
        RUBY
      end
    end

    context 'when indentation width is overridden for this cop only' do
      let(:cop_config) do
        {
          'EnforcedStyle'    => style,
          'IndentationWidth' => 4
        }
      end

      it 'accepts a correctly indented first argument' do
        expect_no_offenses(<<~RUBY)
          run(
              :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects an over-indented first argument' do
        expect_offense(<<~RUBY)
          run(
                  :foo,
                  ^^^^ Indent the first argument one step more than the start of the previous line.
              bar: 3)
        RUBY

        expect_correction(<<~RUBY)
          run(
              :foo,
              bar: 3)
        RUBY
      end
    end

    context 'when `AllowMethodDefinitionArgument: false`' do
      let(:allow_method_definition_argument) { false }

      it 'registers and corrects an offense when the first argument is a method definition' do
        expect_offense(<<~'RUBY')
          memoize \
          def do_something
          ^^^^^^^^^^^^^^^^ Indent the first argument one step more than the start of the previous line.
          end
        RUBY

        expect_correction(<<~'RUBY')
          memoize \
            def do_something
            end
        RUBY
      end

      it 'registers and corrects an offense when the first argument is a class method definition' do
        expect_offense(<<~'RUBY')
          memoize \
          def self.do_something
          ^^^^^^^^^^^^^^^^^^^^^ Indent the first argument one step more than the start of the previous line.
          end
        RUBY

        expect_correction(<<~'RUBY')
          memoize \
            def self.do_something
            end
        RUBY
      end

      it 'registers and corrects an offense when the first argument is a class method definition and ' \
         'wrapped in the method itself' do
        expect_offense(<<~'RUBY')
          memoize \
          helper_method \
          ^^^^^^^^^^^^^^^ Indent the first argument one step more than the start of the previous line.
          def self.do_something
          ^^^^^^^^^^^^^^^^^^^^^ Bad indentation of the first argument.
          end
        RUBY

        expect_correction(<<~'RUBY')
          memoize \
            helper_method \
              def self.do_something
              end
        RUBY
      end
    end

    context 'when `AllowMethodDefinitionArgument: true`' do
      let(:allow_method_definition_argument) { true }

      it 'does not register an offense when the first argument is a method definition' do
        expect_no_offenses(<<~'RUBY')
          memoize \
          def do_something
          end
        RUBY
      end

      it 'does not register an offense when the first argument is a class method definition' do
        expect_no_offenses(<<~'RUBY')
          memoize \
          def self.do_something
          end
        RUBY
      end

      it 'does not register an offense when the first argument is a class method definition and ' \
         'wrapped in the method itself' do
        expect_no_offenses(<<~'RUBY')
          memoize \
          helper_method \
          def self.do_something
          end
        RUBY
      end
    end
  end

  context 'when EnforcedStyle is special_for_inner_method_call' do
    let(:style) { 'special_for_inner_method_call' }
    let(:indentation_width) { 2 }

    include_examples 'common behavior'

    context 'for method calls within method calls' do
      context 'with outer parentheses' do
        it 'registers an offense and corrects ' \
          'an over-indented first argument' do
          expect_offense(<<~RUBY)
            run(:foo, defaults.merge(
                                    bar: 3))
                                    ^^^^^^ Indent the first argument one step more than `defaults.merge(`.
          RUBY

          expect_correction(<<~RUBY)
            run(:foo, defaults.merge(
                        bar: 3))
          RUBY
        end
      end

      context 'without outer parentheses' do
        it 'accepts a first argument with special indentation' do
          expect_no_offenses(<<~RUBY)
            run :foo, defaults.merge(
                        bar: 3)
          RUBY
        end
      end
    end
  end

  context 'when EnforcedStyle is ' \
          'special_for_inner_method_call_in_parentheses' do
    let(:style) { 'special_for_inner_method_call_in_parentheses' }
    let(:indentation_width) { 2 }

    include_examples 'common behavior'

    context 'for method calls within method calls' do
      context 'with outer parentheses' do
        it 'registers an offense and corrects ' \
          'an over-indented first argument' do
          expect_offense(<<~RUBY)
            run(:foo, defaults.merge(
                                    bar: 3))
                                    ^^^^^^ Indent the first argument one step more than `defaults.merge(`.
          RUBY

          expect_correction(<<~RUBY)
            run(:foo, defaults.merge(
                        bar: 3))
          RUBY
        end

        it 'registers an offense and corrects ' \
          'an under-indented first argument' do
          expect_offense(<<~RUBY)
            run(:foo, defaults.
                      merge(
              bar: 3))
              ^^^^^^ Indent the first argument one step more than the start of the previous line.
          RUBY

          expect_correction(<<~RUBY)
            run(:foo, defaults.
                      merge(
                        bar: 3))
          RUBY
        end

        it 'accepts a correctly indented first argument in interpolation' do
          expect_no_offenses(<<~'RUBY')
            puts %(
              <p>
                #{Array(
                  42
                )}
              </p>
            )
          RUBY
        end

        it 'accepts a correctly indented first argument with fullwidth ' \
           'characters' do
          expect_no_offenses(<<~RUBY)
            puts('Ｒｕｂｙ', f(
                               a))
          RUBY
        end
      end

      context 'without outer parentheses' do
        it 'accepts a first argument with consistent style indentation' do
          expect_no_offenses(<<~RUBY)
            run :foo, defaults.merge(
              bar: 3)
          RUBY
        end
      end
    end
  end

  context 'when EnforcedStyle is consistent' do
    let(:style) { 'consistent' }
    let(:indentation_width) { 2 }

    include_examples 'common behavior'

    context 'for method calls within method calls' do
      it 'registers an offense and corrects an over-indented first argument' do
        expect_offense(<<~RUBY)
          run(:foo, defaults.merge(
                      bar: 3))
                      ^^^^^^ Indent the first argument one step more than the start of the previous line.
        RUBY

        expect_correction(<<~RUBY)
          run(:foo, defaults.merge(
            bar: 3))
        RUBY
      end

      it 'accepts first argument indented relative to previous line' do
        expect_no_offenses(<<~RUBY)
          @diagnostics.process(Diagnostic.new(
            :error, :token, { :token => name }, location))
        RUBY
      end
    end
  end

  context 'when EnforcedStyle is consistent_relative_to_receiver' do
    let(:style) { 'consistent_relative_to_receiver' }

    context 'when IndentationWidth:Width is 2' do
      let(:indentation_width) { 2 }

      it 'registers an offense and corrects an over-indented first argument' do
        expect_offense(<<~RUBY)
          run(
              :foo,
              ^^^^ Indent the first argument one step more than `run(`.
              bar: 3
          )
        RUBY

        expect_correction(<<~RUBY)
          run(
            :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects an under-indented first argument' do
        expect_offense(<<~RUBY)
          run(
           :foo,
           ^^^^ Indent the first argument one step more than `run(`.
              bar: 3
          )
        RUBY

        expect_correction(<<~RUBY)
          run(
            :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects lines affected by other offenses' do
        expect_offense(<<~RUBY)
          foo(
           bar(
           ^^^^ Indent the first argument one step more than `foo(`.
            7
            ^ Bad indentation of the first argument.
          )
          )
        RUBY

        # The first `)` Will be corrected by IndentationConsistency.
        expect_correction(<<~RUBY, loop: false)
          foo(
            bar(
             7
           )
          )
        RUBY
      end

      context 'for assignment' do
        it 'register an offense and corrects a correctly indented first ' \
          'argument and does not care about the second argument' do
          expect_offense(<<~RUBY)
            x = run(
              :foo,
              ^^^^ Indent the first argument one step more than `run(`.
                bar: 3
            )
          RUBY

          expect_correction(<<~RUBY)
            x = run(
                  :foo,
                bar: 3
            )
          RUBY
        end

        context 'with line break' do
          it 'accepts a correctly indented first argument' do
            expect_no_offenses(<<~RUBY)
              x =
                run(
                  :foo)
            RUBY
          end

          it 'registers an offense and corrects ' \
            'an under-indented first argument' do
            expect_offense(<<~RUBY)
              @x =
                run(
                :foo)
                ^^^^ Indent the first argument one step more than `run(`.
            RUBY

            expect_correction(<<~RUBY)
              @x =
                run(
                  :foo)
            RUBY
          end
        end
      end

      it 'accepts a first argument that is not preceded by a line break' do
        expect_no_offenses(<<~RUBY)
          run :foo,
              bar: 3
        RUBY
      end

      it 'does not register an offense when argument has expected indent width and ' \
         'the method is preceded by splat' do
        expect_no_offenses(<<~RUBY)
          [
            item,
            *do_something(
              arg)
          ]
        RUBY
      end

      it 'does not register an offense when argument has expected indent width and ' \
         'the method is preceded by double splat' do
        expect_no_offenses(<<~RUBY)
          [
            item,
            **do_something(
              arg)
          ]
        RUBY
      end

      context 'when the receiver contains a line break' do
        it 'accepts a correctly indented first argument' do
          expect_no_offenses(<<~RUBY)
            puts x.
              merge(
                b: 2
              )
          RUBY
        end

        it 'registers an offense and corrects an over-indented 1st argument' do
          expect_offense(<<~RUBY)
            puts x.
              merge(
                  b: 2
                  ^^^^ Indent the first argument one step more than the start of the previous line.
              )
          RUBY

          expect_correction(<<~RUBY)
            puts x.
              merge(
                b: 2
              )
          RUBY
        end

        it 'accepts a correctly indented first argument preceded by an ' \
           'empty line' do
          expect_no_offenses(<<~RUBY)
            puts x.
              merge(

                b: 2
              )
          RUBY
        end

        context 'when preceded by a comment line' do
          it 'accepts a correctly indented first argument' do
            expect_no_offenses(<<~RUBY)
              puts x.
                merge( # EOL comment
                  # comment
                  b: 2
                )
            RUBY
          end

          it 'registers an offense and corrects ' \
            'an under-indented first argument' do
            expect_offense(<<~RUBY)
              puts x.
                merge(
                # comment
                b: 2
                ^^^^ Indent the first argument one step more than the start of the previous line (not counting the comment).
                )
            RUBY

            expect_correction(<<~RUBY)
              puts x.
                merge(
                # comment
                  b: 2
                )
            RUBY
          end
        end
      end

      it 'accepts method calls with no arguments' do
        expect_no_offenses(<<~RUBY)
          run()
          run_again
        RUBY
      end

      it 'accepts operator calls' do
        expect_no_offenses(<<~RUBY)
          params = default_cfg.keys - %w(Description) -
                   cfg.keys
        RUBY
      end

      it 'does not view []= as an outer method call' do
        expect_no_offenses(<<~RUBY)
          @subject_results[subject] = original.update(
                                        mutation_results: (dup << mutation_result),
                                        tests:            test_result.tests
          )
        RUBY
      end

      it 'does not view chained call as an outer method call' do
        expect_no_offenses(<<~'RUBY')
          A = Regexp.union(
                /[A-Za-z_][A-Za-z\d_]*[!?=]?/,
                *AST::Types::OPERATOR_METHODS.map(&:to_s)
              ).freeze
        RUBY
      end
    end

    context 'when IndentationWidth:Width is 4' do
      let(:indentation_width) { 4 }

      it 'registers an offense and corrects an over-indented first argument' do
        expect_offense(<<~RUBY)
          run(
                  :foo,
                  ^^^^ Indent the first argument one step more than `run(`.
              bar: 3)
        RUBY

        expect_correction(<<~RUBY)
          run(
              :foo,
              bar: 3)
        RUBY
      end
    end

    context 'when indentation width is overridden for this cop only' do
      let(:indentation_width) { nil }
      let(:cop_config) do
        {
          'EnforcedStyle'    => style,
          'IndentationWidth' => 4
        }
      end

      it 'accepts a correctly indented first argument' do
        expect_no_offenses(<<~RUBY)
          run(
              :foo,
              bar: 3
          )
        RUBY
      end

      it 'registers an offense and corrects an over-indented first argument' do
        expect_offense(<<~RUBY)
          run(
                  :foo,
                  ^^^^ Indent the first argument one step more than `run(`.
              bar: 3)
        RUBY

        expect_correction(<<~RUBY)
          run(
              :foo,
              bar: 3)
        RUBY
      end
    end

    context 'for method calls within method calls' do
      let(:indentation_width) { 2 }

      context 'with outer parentheses' do
        it 'registers an offense and corrects an over-indented 1st argument' do
          expect_offense(<<~RUBY)
            run(:foo, defaults.merge(
                                    bar: 3))
                                    ^^^^^^ Indent the first argument one step more than `defaults.merge(`.
          RUBY

          expect_correction(<<~RUBY)
            run(:foo, defaults.merge(
                        bar: 3))
          RUBY
        end

        it 'indents all relative to the receiver' do
          expect_no_offenses(<<~RUBY)
            foo = run(
                    :foo, defaults.merge(
                            bar: 3)
                  )
          RUBY

          expect_no_offenses(<<~RUBY)
            MyClass.my_method(a_hash.merge(
                                hello: :world,
                                some: :hash,
                                goes: :here
                              ), other_arg)
          RUBY

          expect_no_offenses(<<~RUBY)
            foo = bar * run(
                          :foo, defaults.merge(
                                  bar: 3)
                        )
          RUBY
        end
      end

      context 'without outer parentheses' do
        it 'accepts a first argument with special indentation' do
          expect_no_offenses(<<~RUBY)
            run :foo, defaults.merge(
                        bar: 3)
          RUBY
        end

        it 'indents all relative to the receiver' do
          expect_no_offenses(<<~RUBY)
            foo = run :foo, defaults.merge(
                              bar: 3)
          RUBY

          expect_no_offenses(<<~RUBY)
            foo = bar * run(
                          :foo, defaults.merge(
                                  bar: 3))
          RUBY
        end
      end
    end
  end
end
