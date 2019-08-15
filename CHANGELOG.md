# Change log

## master (unreleased)

### New features

* [#7274](https://github.com/rubocop-hq/rubocop/issues/7274): Add new `Lint/SendWithMixinArgument` cop. ([@koic][])

### Bug fixes

* [#7256](https://github.com/rubocop-hq/rubocop/issues/7256): Fix an error of `Style/RedundantParentheses` on method calls where the first argument begins with a hash literal. ([@halfwhole][])
* [#7263](https://github.com/rubocop-hq/rubocop/issues/7263): Make `Layout/SpaceInsideArrayLiteralBrackets` properly handle tab-indented arrays. ([@buehmann][])
* [#7252](https://github.com/rubocop-hq/rubocop/issues/7252): Prevent infinite loops by making `Layout/SpaceInsideStringInterpolation` skip over interpolations that start or end with a line break. ([@buehmann][])
* [#7262](https://github.com/rubocop-hq/rubocop/issues/7262): `Lint/FormatParameterMismatch` did not recognize named format sequences like `%.2<name>f` where the name appears after some modifiers. ([@buehmann][])
* [#7253](https://github.com/rubocop-hq/rubocop/issues/7253): Fix an error for `Lint/NumberConversion` when `#to_i` called without a receiver. ([@koic][])
* [#7271](https://github.com/rubocop-hq/rubocop/issues/7271), [#6498](https://github.com/rubocop-hq/rubocop/issues/6498): Fix an interference between `Style/TrailingCommaIn*Literal` and `Layout/Multiline*BraceLayout` for arrays and hashes. ([@buehmann][])
* [#7286](https://github.com/rubocop-hq/rubocop/pull/7286): Treat `begin`-`end` blocks like `do`-`end` blocks in `Layout/BlockAlignment`. ([@fphilipe][])

### Changes

* [#7275](https://github.com/rubocop-hq/rubocop/issues/7275): Make `Style/VariableName` aware argument names when invoking a method. ([@koic][])

## 0.74.0 (2019-07-31)

### New features

* [#7219](https://github.com/rubocop-hq/rubocop/issues/7219): Support auto-correct for `Lint/ErbNewArguments`. ([@koic][])

### Bug fixes

* [#7217](https://github.com/rubocop-hq/rubocop/pull/7217): Make `Style/TrailingMethodEndStatement` work on more than the first `def`. ([@buehmann][])
* [#7190](https://github.com/rubocop-hq/rubocop/issues/7190): Support lower case drive letters on Windows. ([@jonas054][])
* Fix the auto-correction of `Lint/UnneededSplatExpansion` when the splat expansion of `Array.new` with a block is assigned to a variable. ([@rrosenblum][])
* [#5628](https://github.com/rubocop-hq/rubocop/issues/5628): Fix an error of `Layout/SpaceInsideStringInterpolation` on interpolations with multiple statements. ([@buehmann][])
* [#7128](https://github.com/rubocop-hq/rubocop/issues/7128): Make `Metrics/LineLength` aware of shebang. ([@koic][])
* [#6861](https://github.com/rubocop-hq/rubocop/issues/6861): Fix a false positive for `Layout/IndentationWidth` when using `EnforcedStyle: outdent` of `Layout/AccessModifierIndentation`. ([@koic][])
* [#7235](https://github.com/rubocop-hq/rubocop/issues/7235): Fix an error where `Style/ConditionalAssignment` would swallow a nested `if` condition. ([@buehmann][])
* [#7242](https://github.com/rubocop-hq/rubocop/issues/7242): Make `Style/ConstantVisibility` work on non-trivial class and module bodies. ([@buehmann][])

### Changes

* [#5265](https://github.com/rubocop-hq/rubocop/issues/5265): Improved `Layout/ExtraSpacing` cop to handle nested consecutive assignments. ([@jfelchner][])
* [#7215](https://github.com/rubocop-hq/rubocop/issues/7215): Make it clear what's wrong in the message from `Style/GuardClause`. ([@jonas054][])
* [#7245](https://github.com/rubocop-hq/rubocop/pull/7245): Make cops detect string interpolations in more contexts: inside of backticks, regular expressions, and symbols. ([@buehmann][])

## 0.73.0 (2019-07-16)

### New features

* Add `AllowDoxygenCommentStyle` configuration on `Layout/LeadingCommentSpace`. ([@anthony-robin][])
* [#7114](https://github.com/rubocop-hq/rubocop/pull/7114): Add `MultilineWhenThen` cop. ([@okuramasafumi][])
* [#4127](https://github.com/rubocop-hq/rubocop/pull/4127): Add `--disable-uncorrectable` flag to generate `rubocop:disable` comments. ([@vergenzt][], [@jonas054][])

### Bug fixes

* [#7170](https://github.com/rubocop-hq/rubocop/issues/7170): Fix a false positive for `Layout/RescueEnsureAlignment` when def line is preceded with `private_class_method`. ([@tatsuyafw][])
* [#7186](https://github.com/rubocop-hq/rubocop/issues/7186): Fix a false positive for `Style/MixinUsage` when using inside multiline block and `if` condition is after `include`. ([@koic][])
* [#7099](https://github.com/rubocop-hq/rubocop/issues/7099): Fix an error of `Layout/RescueEnsureAlignment` on assigned blocks. ([@tatsuyafw][])
* [#5088](https://github.com/rubocop-hq/rubocop/issues/5088): Fix an error of `Layout/MultilineMethodCallIndentation` on method chains inside an argument. ([@buehmann][])
* [#4719](https://github.com/rubocop-hq/rubocop/issues/4719): Make `Layout/Tab` detect tabs between string literals. ([@buehmann][])
* [#7203](https://github.com/rubocop-hq/rubocop/pull/7203): Fix an infinite loop error for `Layout/SpaceInsideBlockBraces` when `EnforcedStyle: no_space` with `SpaceBeforeBlockParameters: false` are set in multiline block. ([@koic][])
* [#6653](https://github.com/rubocop-hq/rubocop/issues/6653): Fix a bug where `Layout/IndentHeredoc` would remove empty lines when autocorrecting heredocs. ([@buehmann][])

### Changes

* [#7181](https://github.com/rubocop-hq/rubocop/pull/7181): Sort analyzed file alphabetically. ([@pocke][])
* [#7188](https://github.com/rubocop-hq/rubocop/pull/7188): Include inspected file location in auto-correction error. ([@pocke][])

## 0.72.0 (2019-06-25)

### New features

* [#7137](https://github.com/rubocop-hq/rubocop/issues/7137): Add new `Gemspec/RubyVersionGlobalsUsage` cop. ([@malyshkosergey][])
* [#7150](https://github.com/rubocop-hq/rubocop/pull/7150): Add `AllowIfModifier` option to `Style/IfInsideElse` cop. ([@koic][])
* [#7153](https://github.com/rubocop-hq/rubocop/pull/7153): Add new cop `Style/FloatDivision` that checks coercion. ([@tejasbubane][])

### Bug fixes

* [#7121](https://github.com/rubocop-hq/rubocop/pull/7121): Fix `Style/TernaryParentheses` cop to allow safe navigation operator without parentheses. ([@timon][])
* [#7063](https://github.com/rubocop-hq/rubocop/issues/7063): Fix autocorrect in `Style/TernaryParentheses` cop. ([@parkerfinch][])
* [#7106](https://github.com/rubocop-hq/rubocop/issues/7106): Fix an error for `Lint/NumberConversion` when `#to_i` called on a variable on a hash. ([@koic][])
* [#7107](https://github.com/rubocop-hq/rubocop/issues/7107): Fix parentheses offence for numeric arguments with an operator in `Style/MethodCallWithArgsParentheses`. ([@gsamokovarov][])
* [#7119](https://github.com/rubocop-hq/rubocop/pull/7119): Fix cache with non UTF-8 offense message. ([@pocke][])
* [#7118](https://github.com/rubocop-hq/rubocop/pull/7118): Fix `Style/WordArray` with `encoding: binary` magic comment and non-ASCII string. ([@pocke][])
* [#7159](https://github.com/rubocop-hq/rubocop/issues/7159): Fix an error for `Lint/DuplicatedKey` when using endless range. ([@koic][])
* [#7151](https://github.com/rubocop-hq/rubocop/issues/7151): Fix `Style/WordArray` to also consider words containing hyphens. ([@fwitzke][])
* [#6893](https://github.com/rubocop-hq/rubocop/issues/6893): Handle implicit rescue correctly in `Naming/RescuedExceptionsVariableName`. ([@pocke][], [@anthony-robin][])
* [#7165](https://github.com/rubocop-hq/rubocop/issues/7165): Fix an auto-correct error for `Style/ConditionalAssignment` when without `else` branch'. ([@koic][])
* [#7171](https://github.com/rubocop-hq/rubocop/issues/7171): Fix an error for `Style/SafeNavigation` when using `unless nil?` as a safeguarded'. ([@koic][])
* [#7130](https://github.com/rubocop-hq/rubocop/pull/7130): Skip autocorrect in `Style/FormatString` if second argument to `String#%` is a variable. ([@tejasbubane][])
* [#7171](https://github.com/rubocop-hq/rubocop/issues/7171): Fix an error for `Style/SafeNavigation` when using `unless nil?` as a safeguarded'. ([@koic][])

### Changes

* [#5976](https://github.com/rubocop-hq/rubocop/issues/5976): Remove Rails cops. ([@koic][])
* [#5976](https://github.com/rubocop-hq/rubocop/issues/5976): Remove `rubocop -R/--rails` option. ([@koic][])
* [#7113](https://github.com/rubocop-hq/rubocop/pull/7113): Rename `EnforcedStyle: rails` to `EnabledStyle: indented_internal_methods` for `Layout/IndentationConsistency`. ([@koic][])

## 0.71.0 (2019-05-30)

### New features

* [#7084](https://github.com/rubocop-hq/rubocop/pull/7084): Permit to specify TargetRubyVersion 2.7. ([@koic][])
* [#7092](https://github.com/rubocop-hq/rubocop/pull/7092): Node patterns can now use `*`, `+` and `?` for repetitions.  ([@marcandre][])

### Bug fixes

* [#7066](https://github.com/rubocop-hq/rubocop/issues/7066): Fix `Layout/AlignHash` when mixed Hash styles are used. ([@rmm5t][])
* [#7073](https://github.com/rubocop-hq/rubocop/issues/7073): Fix false positive in `Naming/RescuedExceptionsVariableName` cop. ([@tejasbubane][])
* [#7090](https://github.com/rubocop-hq/rubocop/pull/7090): Fix `Layout/EmptyLinesAroundBlockBody` for multi-line method calls. ([@eugeneius][])
* [#6936](https://github.com/rubocop-hq/rubocop/issues/6936): Fix `Layout/MultilineMethodArgumentLineBreaks` when bracket hash assignment on multiple lines. ([@maxh][])
* Mark `Layout/HeredocArgumentClosingParenthesis` incompatible with `Style/TrailingCommaInArguments`. ([@maxh][])

### Changes

* [#5976](https://github.com/rubocop-hq/rubocop/issues/5976): Warn for Rails Cops. ([@koic][])
* [#5976](https://github.com/rubocop-hq/rubocop/issues/5976): Warn for `rubocop -R/--rails` option. ([@koic][])
* [#7078](https://github.com/rubocop-hq/rubocop/issues/7078): Mark `Lint/PercentStringArray` as unsafe. ([@mikegee][])

## 0.70.0 (2019-05-21)

### New features

* [#6649](https://github.com/rubocop-hq/rubocop/pull/6649): `Layout/AlignHash` supports list of options. ([@stoivo][])
* Add `IgnoreMethodPatterns` config option to `Style/MethodCallWithArgsParentheses`. ([@tejasbubane][])
* [#7059](https://github.com/rubocop-hq/rubocop/pull/7059): Add `EnforcedStyle` to `Layout/EmptyLinesAroundAccessModifier`. ([@koic][])
* [#7052](https://github.com/rubocop-hq/rubocop/issues/7052): Add `AllowComments` option to ` Lint/HandleExceptions`. ([@tejasbubane][])

### Bug fixes

* [#7013](https://github.com/rubocop-hq/rubocop/pull/7013): Respect DisabledByDefault for custom cops. ([@XrXr][])
* [#7043](https://github.com/rubocop-hq/rubocop/issues/7043): Prevent RDoc error when installing RuboCop 0.69.0 on Ubuntu. ([@koic][])
* [#7023](https://github.com/rubocop-hq/rubocop/issues/7023): Autocorrection for `Lint/NumberConversion`. ([@Bhacaz][])

### Changes

* [#6359](https://github.com/rubocop-hq/rubocop/issues/6359): Mark `Style/PreferredHashMethods` as unsafe. ([@tejasbubane][])

## 0.69.0 (2019-05-13)

### New features

* Add support for subclassing using `Class.new` to `Lint/InheritException`. ([@houli][])
* [#6779](https://github.com/rubocop-hq/rubocop/issues/6779): Add new cop `Style/NegatedUnless` that checks for unless with negative condition. ([@tejasbubane][])

### Bug fixes

* [#6900](https://github.com/rubocop-hq/rubocop/issues/6900): Fix `Rails/TimeZone` autocorrect `Time.current` to `Time.zone.now`. ([@vfonic][])
* [#6900](https://github.com/rubocop-hq/rubocop/issues/6900): Fix `Rails/TimeZone` to prefer `Time.zone.#{method}` over other acceptable corrections. ([@vfonic][])
* [#7007](https://github.com/rubocop-hq/rubocop/pull/7007): Fix `Style/BlockDelimiters` with `braces_for_chaining` style false positive, when chaining using safe navigation. ([@Darhazer][])
* [#6880](https://github.com/rubocop-hq/rubocop/issues/6880): Fix `.rubocop` file parsing. ([@hoshinotsuyoshi][])
* [#5782](https://github.com/rubocop-hq/rubocop/issues/5782): Do not autocorrect `Lint/UnifiedInteger` if `TargetRubyVersion < 2.4`. ([@lavoiesl][])
* [#6387](https://github.com/rubocop-hq/rubocop/issues/6387): Prevent `Lint/NumberConversion` from reporting error with `Time`/`DateTime`. ([@tejasbubane][])
* [#6980](https://github.com/rubocop-hq/rubocop/issues/6980): Fix `Style/StringHashKeys` to allow string as keys for hash arguments to gsub methods. ([@tejasbubane][])
* [#6969](https://github.com/rubocop-hq/rubocop/issues/6969): Fix a false positive with block methods in `Style/InverseMethods`. ([@dduugg][])
* [#6729](https://github.com/rubocop-hq/rubocop/pull/6729): Handle array spread for `change_column_default` in `Rails/ReversibleMigration` cop. ([@tejasbubane][])
* [#7033](https://github.com/rubocop-hq/rubocop/issues/7033): Fix an error for `Layout/EmptyLineAfterGuardClause` when guard clause is a ternary operator. ([@koic][])

### Changes

* [#6945](https://github.com/rubocop-hq/rubocop/issues/6945): Drop support for Ruby 2.2. ([@koic][])
* [#6945](https://github.com/rubocop-hq/rubocop/issues/6945): Set default `EnforcedStyle` to `squiggly` option for `Layout/IndentHeredoc` and `auto_detection` option is removed. ([@koic][])
* [#6945](https://github.com/rubocop-hq/rubocop/issues/6945): Set default `EnforcedStyle` to `always` option for `Style/FrozenStringLiteralComment` and `when_needed` option is removed. ([@koic][])
* [#7027](https://github.com/rubocop-hq/rubocop/pull/7027): Allow `unicode/display_width` dependency version 1.6.0. ([@tagliala][])

## 0.68.1 (2019-04-30)

### Bug fixes

* [#6993](https://github.com/rubocop-hq/rubocop/pull/6993): Allowing for empty if blocks, preventing `Style/SafeNavigation` from crashing. ([@RicardoTrindade][])
* [#6995](https://github.com/rubocop-hq/rubocop/pull/6995): Fix an incorrect auto-correct for `Style/RedundantParentheses` when enclosed in parentheses at `while-post` or `until-post`. ([@koic][])
* [#6996](https://github.com/rubocop-hq/rubocop/pull/6996): Fix a false positive for `Style/RedundantFreeze` when freezing the result of `String#*`. ([@bquorning][])
* [#6998](https://github.com/rubocop-hq/rubocop/pull/6998): Fix autocorrect of `Naming/RescuedExceptionsVariableName` to also rename all references to the variable. ([@Darhazer][])
* [#6992](https://github.com/rubocop-hq/rubocop/pull/6992): Fix unknown default configuration for `Layout/IndentFirstParameter` cop. ([@drenmi][])
* [#6972](https://github.com/rubocop-hq/rubocop/issues/6972): Fix a false positive for `Style/MixinUsage` when using inside block and `if` condition is after `include`. ([@koic][])
* [#6738](https://github.com/rubocop-hq/rubocop/issues/6738): Prevent auto-correct conflict of `Style/Next` and `Style/SafeNavigation`. ([@hoshinotsuyoshi][])
* [#6847](https://github.com/rubocop-hq/rubocop/pull/6847): Fix `Style/BlockDelimiters` to properly check if the node is chained when `braces_for_chaining` is set. ([@att14][])

### Bug fixes

* Replace `Time.zone.current` with `Time.zone.today` on `Rails::Date` cop message. ([@vfonic][])

## 0.68.0 (2019-04-29)

### New features

* [#6973](https://github.com/rubocop-hq/rubocop/pull/6973): Add `always_braces` to `Style/BlockDelimiter`. ([@iGEL][])
* [#6841](https://github.com/rubocop-hq/rubocop/issues/6841): Node patterns can now match children in any order using `<>`. ([@marcandre][])
* [#6928](https://github.com/rubocop-hq/rubocop/pull/6928): Add `--init` option for generate `.rubocop.yml` file in the current directory. ([@koic][])
* Add new `Layout/HeredocArgumentClosingParenthesis` cop. ([@maxh][])
* [#6895](https://github.com/rubocop-hq/rubocop/pull/6895): Add support for XDG config home for user-config. ([@Mange][], [@tejasbubane][])
* Add initial autocorrection support to `Metrics/LineLength`. ([@maxh][])
* Add `Layout/IndentFirstParameter`. ([@maxh][])
* [#6974](https://github.com/rubocop-hq/rubocop/issues/6974): Make `Layout/FirstMethodArgumentLineBreak` aware of calling using `super`. ([@koic][])
* Add new `Lint/HeredocMethodCallPosition` cop. ([@maxh][])


### Bug fixes

* Do not annotate message with cop name in JSON output. ([@elebow][])
* [#6914](https://github.com/rubocop-hq/rubocop/issues/6914): Fix an error for `Rails/RedundantAllowNil` when with interpolations. ([@Blue-Pix][])
* [#6888](https://github.com/rubocop-hq/rubocop/issues/6888): Fix an error for `Rails/ActiveRecordOverride ` when no `parent_class` present. ([@diachini][])
* [#6941](https://github.com/rubocop-hq/rubocop/issues/6941): Add missing absence validations to `Rails/Validation`. ([@jmanian][])
* [#6926](https://github.com/rubocop-hq/rubocop/issues/6926): Allow nil values to unset config defaults. ([@dduugg][])
* [#6946](https://github.com/rubocop-hq/rubocop/pull/6946): Allow `Rails/ReflectionClassName` to use string interpolation for `class_name`. ([@r7kamura][])
* [#6778](https://github.com/rubocop-hq/rubocop/issues/6778): Fix a false positive in `Style/HashSyntax` cop when a hash key is an interpolated string and EnforcedStyle is ruby19_no_mixed_keys. ([@tatsuyafw][])
* [#6902](https://github.com/rubocop-hq/rubocop/issues/6902): Fix a bug where `Naming/RescuedExceptionsVariableName` would handle an only first rescue for multiple rescue groups. ([@tatsuyafw][])
* [#6860](https://github.com/rubocop-hq/rubocop/issues/6860): Prevent auto-correct conflict of `Style/InverseMethods` and `Style/Not`. ([@hoshinotsuyoshi][])
* [#6935](https://github.com/rubocop-hq/rubocop/issues/6935): `Layout/AccessModifierIndentation` should ignore access modifiers that apply to specific methods. ([@deivid-rodriguez][])
* [#6956](https://github.com/rubocop-hq/rubocop/issues/6956): Prevent auto-correct confliction of `Lint/Lambda` and `Lint/UnusedBlockArgument`. ([@koic][])
* [#6915](https://github.com/rubocop-hq/rubocop/issues/6915): Fix false positive in `Style/SafeNavigation` when a modifier if is safe guarding a method call being passed to `break`, `fail`, `next`, `raise`, `return`, `throw`, and `yield`. ([@rrosenblum][])
* [#6822](https://github.com/rubocop-hq/rubocop/issues/6822): Fix Lint/LiteralInInterpolation autocorrection for single quotes. ([@hoshinotsuyoshi][])
* [#6985](https://github.com/rubocop-hq/rubocop/issues/6985): Fix an incorrect auto-correct for `Lint/LiteralInInterpolation` if contains array percent literal. ([@yakout][])
* [#7003](https://github.com/rubocop-hq/rubocop/pull/7003): Fix an incorrect auto-correct for `Style/InverseMethods` when using `BasicObject#!`. ([@koic][])

### Changes

* [#6966](https://github.com/rubocop-hq/rubocop/pull/6966): Mark Rails/TimeZone as unsafe. ([@vfonic][])
* [#5977](https://github.com/rubocop-hq/rubocop/issues/5977): Remove Performance cops. ([@koic][])
* Add auto-correction to `Naming/RescuedExceptionsVariableName`. ([@anthony-robin][])
* [#6903](https://github.com/rubocop-hq/rubocop/issues/6903): Handle variables prefixed with `_` in `Naming/RescuedExceptionsVariableName` cop. ([@anthony-robin][])
* [#6917](https://github.com/rubocop-hq/rubocop/issues/6917): Bump Bundler dependency to >= 1.15.0. ([@koic][])
* Add `--auto-gen-only-exclude` to the command outputted in `rubocop_todo.yml` if the option is specified. ([@dvandersluis][])
* [#6887](https://github.com/rubocop-hq/rubocop/pull/6887): Allow `Lint/UnderscorePrefixedVariableName` cop to be configured to allow use of block keyword args. ([@dduugg][])
* [#6885](https://github.com/rubocop-hq/rubocop/pull/6885): Revert adding psych >= 3.1 as runtime dependency. ([@andreaseger][])
* Rename `Layout/FirstParameterIndentation` to `Layout/IndentFirstArgument`. ([@maxh][])
* Extract method call argument alignment behavior from `Layout/AlignParameters` into `Layout/AlignArguments`. ([@maxh][])
* Rename `IndentArray` and `IndentHash` to `IndentFirstArrayElement` and `IndentFirstHashElement`. ([@maxh][])

## 0.67.2 (2019-04-05)

### Bug fixes

* [#6882](https://github.com/rubocop-hq/rubocop/issues/6882): Fix an error for `Rails/RedundantAllowNil` when not using both `allow_nil` and `allow_blank`. ([@koic][])

## 0.67.1 (2019-04-04)

### Changes

* [#6881](https://github.com/rubocop-hq/rubocop/pull/6881): Set default `PreferredName` to `e` for `Naming/RescuedExceptionsVariableName`. ([@koic][])

## 0.67.0 (2019-04-04)

### New features

* [#5184](https://github.com/rubocop-hq/rubocop/issues/5184): Add new multiline element line break cops. ([@maxh][])
* Add new cop `Rails/ActiveRecordOverride` that checks for overriding Active Record methods instead of using callbacks. ([@elebow][])
* Add new cop `Rails/RedundantAllowNil` that checks for cases when `allow_blank` makes `allow_nil` unnecessary in model validations. ([@elebow][])
* Add new `Naming/RescuedExceptionsVariableName` cop. ([@AdrienSldy][])

### Bug fixes

* [#6761](https://github.com/rubocop-hq/rubocop/issues/6761): Make `Naming/UncommunicativeMethodParamName` account for param names prefixed with underscores. ([@thomthom][])
* [#6855](https://github.com/rubocop-hq/rubocop/pull/6855): Fix an exception in `Rails/RedundantReceiverInWithOptions` when the body is empty. ([@ericsullivan][])
* [#6856](https://github.com/rubocop-hq/rubocop/pull/6856): Fix auto-correction for `Style/BlockComments` when the file is missing a trailing blank line. ([@ericsullivan][])
* [#6858](https://github.com/rubocop-hq/rubocop/issues/6858): Fix an incorrect auto-correct for `Lint/ToJSON` when there are no `to_json` arguments. ([@koic][])
* [#6865](https://github.com/rubocop-hq/rubocop/pull/6865): Fix deactivated `StyleGuideBaseURL` for `Layout/ClassStructure`. ([@aeroastro][])
* [#6868](https://github.com/rubocop-hq/rubocop/pull/6868): Fix `Rails/LinkToBlank` auto-correct bug when using symbol for target. ([@r7kamura][])
* [#6869](https://github.com/rubocop-hq/rubocop/pull/6869): Fix false positive for `Rails/LinkToBlank` when rel is a symbol value. ([@r7kamura][])
* Add `IncludedMacros` param to default rubocop config for `Style/MethodCallWithArgsParentheses`. ([@maxh][])
* [#6785](https://github.com/rubocop-hq/rubocop/issues/6785): Do not register an offense for `Rails/Present` or `Rails/Blank` in an `unless else` context when `Style/UnlessElse` is enabled. ([@rrosenblum][])

### Changes

* [#6854](https://github.com/rubocop-hq/rubocop/pull/6854): Mark Rails/LexicallyScopedActionFilter as unsafe and document risks. ([@urbanautomaton][])
* [#5977](https://github.com/rubocop-hq/rubocop/issues/5977): Warn for Performance Cops. ([@koic][])
* [#6637](https://github.com/rubocop-hq/rubocop/issues/6637): Move `LstripRstrip` from `Performance` to `Style` department and rename it to `Strip`. ([@anuja-joshi][])
* [#6875](https://github.com/rubocop-hq/rubocop/pull/6875): Mention block form of `Struct.new` in ` Style/StructInheritance`. ([@XrXr][])
* [#6871](https://github.com/rubocop-hq/rubocop/issues/6871): Move `Performance/RedundantSortBy`, `Performance/UnneededSort` and `Performance/Sample` to the Style department. ([@bbatsov][])

## 0.66.0 (2019-03-18)

### New features

* [#6393](https://github.com/rubocop-hq/rubocop/issues/6393): Add `AllowBracesOnProceduralOneLiners` option to fine-tune `Style/BlockDelimiter`'s semantic mode. ([@davearonson][])
* [#6383](https://github.com/rubocop-hq/rubocop/issues/6383): Add `AllowBeforeTrailingComments` option on `Layout/ExtraSpacing` cop. ([@davearonson][])
* New cop `Lint/SafeNavigationWithEmpty` checks for `foo&.empty?` in conditionals. ([@rspeicher][])
* Add new `Style/ConstantVisibility` cop for enforcing visibility declarations of class and module constants. ([@drenmi][])
* [#6378](https://github.com/rubocop-hq/rubocop/issues/6378): Add `Lint/ToJSON` cop to enforce an argument when overriding `#to_json`. ([@allcentury][])
* [#6346](https://github.com/rubocop-hq/rubocop/issues/6346): Add auto-correction to `Rails/TimeZone`. ([@dcluna][])
* [#6840](https://github.com/rubocop-hq/rubocop/issues/6840): Node patterns now allow unlimited elements after `...`. ([@marcandre][])

### Bug fixes

* [#4321](https://github.com/rubocop-hq/rubocop/pull/4321): Fix false offense for `Style/RedundantSelf` when the method is also defined on `Kernel`. ([@mikegee][])
* [#6821](https://github.com/rubocop-hq/rubocop/pull/6821): Fix false negative for `Rails/LinkToBlank` when `_blank` is a symbol. ([@Intrepidd][])
* [#6699](https://github.com/rubocop-hq/rubocop/issues/6699): Fix infinite loop for `Layout/IndentationWidth` and `Layout/IndentationConsistency` when bad modifier indentation before good method definition. ([@koic][])
* [#6777](https://github.com/rubocop-hq/rubocop/issues/6777): Fix a false positive for `Style/TrivialAccessors` when using trivial reader/writer methods at the top level. ([@koic][])
* [#6799](https://github.com/rubocop-hq/rubocop/pull/6799): Fix errors for `Style/ConditionalAssignment`, `Style/IdenticalConditionalBranches`, `Lint/ElseLayout`, and `Layout/IndentationWidth` with empty braces. ([@pocke][])
* [#6802](https://github.com/rubocop-hq/rubocop/pull/6802): Fix auto-correction for `Style/SymbolArray` with array contains interpolation when `EnforcedStyle` is `brackets`. ([@pocke][])
* [#6797](https://github.com/rubocop-hq/rubocop/pull/6797): Fix false negative for Layout/SpaceAroundBlockParameters on block parameter with parens. ([@pocke][])
* [#6798](https://github.com/rubocop-hq/rubocop/pull/6798): Fix infinite loop for `Layout/SpaceAroundBlockParameters` with `EnforcedStyleInsidePipes: :space`. ([@pocke][])
* [#6803](https://github.com/rubocop-hq/rubocop/pull/6803): Fix error for `Style/NumericLiterals` on a literal that contains spaces. ([@pocke][])
* [#6801](https://github.com/rubocop-hq/rubocop/pull/6801): Fix auto-correction for `Style/Lambda` with no-space argument. ([@pocke][])
* [#6804](https://github.com/rubocop-hq/rubocop/pull/6804): Fix auto-correction of `Style/NumericLiterals` on numeric literal with exponent. ([@pocke][])
* [#6800](https://github.com/rubocop-hq/rubocop/issues/6800): Fix an incorrect auto-correct for `Rails/Validation` when method arguments are enclosed in parentheses. ([@koic][])
* [#6808](https://github.com/rubocop-hq/rubocop/issues/6808): Prevent false positive in `Naming/ConstantName` when assigning a frozen range. ([@drenmi][])
* Fix the calculation of `Metrics/AbcSize`. Comparison methods and `else` branches add to the comparison count. ([@rrosenblum][])
* [#6791](https://github.com/rubocop-hq/rubocop/pull/6791): Allow `Rails/ReflectionClassName` to use symbol argument for `class_name`. ([@unasuke][])
* [#5465](https://github.com/rubocop-hq/rubocop/issues/5465): Fix `Layout/ClassStructure` to allow grouping macros by their visibility. ([@gprado][])
* [#6461](https://github.com/rubocop-hq/rubocop/pull/6461): Restrict `Ctrl-C` handling to RuboCop's loop and simplify it to a single phase. ([@deivid-rodriguez][])

### Changes

* Add `$stdout`/`$stderr` and `STDOUT`/`STDERR` method calls to `Rails/Output`. ([@elebow][])
* [#6688](https://github.com/rubocop-hq/rubocop/pull/6688): Add `iterator?` to deprecated methods and prefer `block_given?` instead. ([@tejasbubane][])
* [#6806](https://github.com/rubocop-hq/rubocop/pull/6806): Remove `powerpack` dependency. ([@dduugg][])
* [#6810](https://github.com/rubocop-hq/rubocop/pull/6810): Exclude gemspec file by default for `Metrics/BlockLength` cop. ([@koic][])
* [#6813](https://github.com/rubocop-hq/rubocop/pull/6813): Allow unicode/display_width dependency version 1.5.0. ([@tagliala][])
* Make `Style/RedundantFreeze` aware of methods that will produce frozen objects. ([@rrosenblum][])
* [#6675](https://github.com/rubocop-hq/rubocop/issues/6675): Avoid printing deprecation warnings about constants. ([@elmasantos][])
* [#6746](https://github.com/rubocop-hq/rubocop/issues/6746): Avoid offense on `$stderr.puts` with no arguments. ([@luciamo][])
* Replace md5 with sha1 for FIPS compliance. ([@dirtyharrycallahan][])

## 0.65.0 (2019-02-19)

### New features

* [#6126](https://github.com/rubocop-hq/rubocop/pull/6126): Add an experimental strict mode to `Style/MutableConstant` that will freeze all constants, rather than just literals. ([@rrosenblum][])
* Add `IncludedMacros` to `Style/MethodCallWithArgsParentheses` to allow including specific macros when `IgnoreMacros` is true. ([@maxh][])

### Bug fixes

* [#6765](https://github.com/rubocop-hq/rubocop/pull/6765): Fix false positives in keyword arguments for `Style/MethodCallWithArgsParentheses` `omit_parentheses`. ([@gsamokovarov][])
* [#6763](https://github.com/rubocop-hq/rubocop/pull/6763): Fix false positives in range literals for `Style/MethodCallWithArgsParentheses` `omit_parentheses`. ([@gsamokovarov][])
* [#6748](https://github.com/rubocop-hq/rubocop/issues/6748): Fix `Style/RaiseArgs` auto-correction breaking in contexts that require parentheses. ([@drenmi][])
* [#6751](https://github.com/rubocop-hq/rubocop/issues/6751): Prevent `Style/OneLineConditional` from breaking on `retry` and `break` keywords. ([@drenmi][])
* [#6755](https://github.com/rubocop-hq/rubocop/issues/6755): Prevent `Style/TrailingCommaInArgument` from breaking when a safe method call is chained on the offending method. ([@drenmi][], [@hoshinotsuyoshi][])

### Changes

* [#6766](https://github.com/rubocop-hq/rubocop/pull/6766): Drop support for Ruby 2.2.0 and 2.2.1. ([@pocke][])
* [#6733](https://github.com/rubocop-hq/rubocop/pull/6733): Warn duplicated keys in `.rubocop.yml`. ([@pocke][])
* [#6613](https://github.com/rubocop-hq/rubocop/pull/6613): Mark `Style/ModuleFunction` as `SafeAutocorrect: false` and disable autocorrect by default. ([@dduugg][])

## 0.64.0 (2019-02-10)

### New features

* [#6704](https://github.com/rubocop-hq/rubocop/pull/6704): Add new `Rails/ReflectionClassName` cop. ([@Bhacaz][])
* [#6643](https://github.com/rubocop-hq/rubocop/pull/6643): Support `AllowParenthesesInCamelCaseMethod` option on `Style/MethodCallWithArgsParentheses` `omit_parentheses`. ([@dazuma][])

### Bug fixes

* [#6254](https://github.com/rubocop-hq/rubocop/issues/6254): Fix `Layout/RescueEnsureAlignment` for non-local assignments. ([@marcotc][])
* [#6648](https://github.com/rubocop-hq/rubocop/issues/6648): Fix auto-correction of `Style/EmptyLiteral` when `Hash.new` is passed as the first argument to `super`. ([@rrosenblum][])
* [#6351](https://github.com/rubocop-hq/rubocop/pull/6351): Fix a false positive for `Layout/ClosingParenthesisIndentation` when first argument is multiline. ([@antonzaytsev][])
* [#6689](https://github.com/rubocop-hq/rubocop/pull/6689): Support more complex argument patterns on `Rails/Validation` auto-correction. ([@r7kamura][])
* [#6668](https://github.com/rubocop-hq/rubocop/issues/6668): Fix autocorrection for `Style/UnneededCondition` when conditional has the `unless` form. ([@mvz][])
* [#6382](https://github.com/rubocop-hq/rubocop/issues/6382): Fix `Layout/IndentationWidth` with `Layout/EndAlignment` set to start_of_line. ([@dischorde][], [@siegfault][], [@mhelmetag][])
* [#6710](https://github.com/rubocop-hq/rubocop/issues/6710): Fix `Naming/MemoizedInstanceVariableName` on method starts with underscore. ([@pocke][])
* [#6722](https://github.com/rubocop-hq/rubocop/issues/6722): Fix an error for `Style/OneLineConditional` when `then` branch has no body. ([@koic][])
* [#6702](https://github.com/rubocop-hq/rubocop/pull/6702): Fix `TrailingComma` regression where heredoc with commas caused false positives. ([@abrom][])
* [#6737](https://github.com/rubocop-hq/rubocop/issues/6737): Fix an incorrect auto-correct for `Rails/LinkToBlank` when `link_to` method arguments are enclosed in parentheses. ([@koic][])
* [#6720](https://github.com/rubocop-hq/rubocop/issues/6720): Fix detection of `:native` line ending for `Layout/EndOfLine` on JRuby. ([@enkessler][])

### Changes

* [#6597](https://github.com/rubocop-hq/rubocop/issues/6597): `Style/LineEndConcatenation` is now known to be unsafe for auto-correct. ([@jaredbeck][])
* [#6725](https://github.com/rubocop-hq/rubocop/issues/6725): Mark `Style/SymbolProc` as unsafe for auto-correct. ([@drenmi][])
* [#6708](https://github.com/rubocop-hq/rubocop/issues/6708): Make `Style/CommentedKeyword` allow the `:yields:` RDoc comment. ([@bquorning][])
* [#6749](https://github.com/rubocop-hq/rubocop/pull/6749): Make some cops aware of safe navigation operator. ([@hoshinotsuyoshi][])

## 0.63.1 (2019-01-22)

### Bug fixes

* [#6678](https://github.com/rubocop-hq/rubocop/issues/6678): Fix `Lint/DisjunctiveAssignmentInConstructor` when it finds an empty constructor. ([@rmm5t][])
* Do not attempt to auto-correct mass assignment or optional assignment in `Rails/RelativeDateConstant`. ([@rrosenblum][])
* Fix auto-correction of `Style/WordArray` and `Style/SymbolArray` when all elements are on separate lines and there is a trailing comment after the closing bracket. ([@rrosenblum][])
* Fix an exception that occurs when auto-correcting `Layout/ClosingParenthesesIndentation` when there are no arguments. ([@rrosenblum][])

## 0.63.0 (2019-01-16)

### New features

* [#6604](https://github.com/rubocop-hq/rubocop/pull/6604): Add auto-correct support to `Rails/LinkToBlank`. ([@Intrepidd][])
* [#6660](https://github.com/rubocop-hq/rubocop/pull/6660): Add new `Rails/IgnoredSkipActionFilterOption` cop. ([@wata727][])
* [#6363](https://github.com/rubocop-hq/rubocop/issues/6363): Allow `Style/YodaCondition` cop to be configured to enforce yoda conditions. ([@tejasbubane][])
* [#6150](https://github.com/rubocop-hq/rubocop/issues/6150): Add support to enforce disabled cops to be executed. ([@roooodcastro][])
* [#6596](https://github.com/rubocop-hq/rubocop/pull/6596): Add new `Rails/BelongsTo` cop with auto-correct for Rails >= 5. ([@petehamilton][])

### Bug fixes

* [#6627](https://github.com/rubocop-hq/rubocop/pull/6627): Fix handling of hashes in trailing comma. ([@abrom][])
* [#6638](https://github.com/rubocop-hq/rubocop/pull/6638): Fix `Rails/LinkToBlank` dectection to allow `rel: 'noreferer`. ([@fwininger][])
* [#6623](https://github.com/rubocop-hq/rubocop/pull/6623): Fix heredoc detection in trailing comma. ([@palkan][])
* [#6100](https://github.com/rubocop-hq/rubocop/issues/6100): Fix a false positive in `Naming/ConstantName` cop when rhs is a conditional expression. ([@tatsuyafw][])
* [#6526](https://github.com/rubocop-hq/rubocop/issues/6526): Fix a wrong line highlight in `Lint/ShadowedException` cop. ([@tatsuyafw][])
* [#6617](https://github.com/rubocop-hq/rubocop/issues/6617): Prevent traversal error on infinite ranges. ([@drenmi][])
* [#6625](https://github.com/rubocop-hq/rubocop/issues/6625): Revert the "auto-exclusion of files ignored by git" feature. ([@bbatsov][])
* [#4460](https://github.com/rubocop-hq/rubocop/issues/4460): Fix the determination of unsafe auto-correct in `Style/TernaryParentheses`. ([@jonas054][])
* [#6651](https://github.com/rubocop-hq/rubocop/issues/6651): Fix auto-correct issue in `Style/RegexpLiteral` cop when there is string interpolation. ([@roooodcastro][])
* [#6670](https://github.com/rubocop-hq/rubocop/issues/6670): Fix a false positive for `Style/SafeNavigation` when a method call safeguarded with a negative check for the object. ([@koic][])
* [#6633](https://github.com/rubocop-hq/rubocop/issues/6633): Fix `Lint/SafeNavigation` complaining about use of `to_d`. ([@tejasbubane][])
* [#6575](https://github.com/rubocop-hq/rubocop/issues/6575): Fix `Naming/PredicateName` suggesting invalid rename. ([@tejasbubane][])
* [#6673](https://github.com/rubocop-hq/rubocop/issues/6673): Fix `Style/DocumentationMethod` cop to recognize documentation comments for `def` inline with `module_function`. ([@tejasbubane][])
* [#6648](https://github.com/rubocop-hq/rubocop/issues/6648): Fix auto-correction of `Style/EmptyLiteral` when `Hash.new` is passed as the first argument to `super`. ([@rrosenblum][])

### Changes

* [#6607](https://github.com/rubocop-hq/rubocop/pull/6607): Improve CLI usage message for --stdin option. ([@jaredbeck][])
* [#6641](https://github.com/rubocop-hq/rubocop/issues/6641): Specify `Performance/RangeInclude` as unsafe because `Range#include?` and `Range#cover?` are not equivalent. ([@koic][])
* [#6636](https://github.com/rubocop-hq/rubocop/pull/6636): Move `FlipFlop` cop from `Style` to `Lint` department because flip-flop is deprecated since Ruby 2.6.0. ([@koic][])
* [#6661](https://github.com/rubocop-hq/rubocop/pull/6661): Abandon making frozen string literals default for Ruby 3.0. ([@koic][])

## 0.62.0 (2019-01-01)

### New features

* [#6580](https://github.com/rubocop-hq/rubocop/pull/6580): New cop `Rails/LinkToBlank` checks for `link_to` calls with `target: '_blank'` and no `rel: 'noopener'`. ([@Intrepidd][])
* [#6586](https://github.com/rubocop-hq/rubocop/issues/6586): New cop `Style/DisjunctiveAssignmentInConstructor` checks constructors for disjunctive assignments that should be plain assignments. ([@jaredbeck][])

### Bug fixes

* [#6560](https://github.com/rubocop-hq/rubocop/issues/6560): Consider file count, not offense count, for `--exclude-limit` in combination with `--auto-gen-only-exclude`. ([@jonas054][])
* [#4229](https://github.com/rubocop-hq/rubocop/issues/4229): Fix unexpected Style/HashSyntax consistency offence. ([@timon][])
* [#6500](https://github.com/rubocop-hq/rubocop/issues/6500): Add offense to use `in_time_zone` instead of deprecated `to_time_in_current_zone`. ([@nadiyaka][])
* [#6577](https://github.com/rubocop-hq/rubocop/pull/6577): Prevent Rails/Blank cop from adding offense when define the blank method. ([@jonatas][])
* [#6554](https://github.com/rubocop-hq/rubocop/issues/6554): Prevent Layout/RescueEnsureAlignment cop from breaking on block assignment when assignment is on a separate line. ([@timmcanty][])
* [#6343](https://github.com/rubocop-hq/rubocop/pull/6343): Optimise `--auto-gen-config` when `Metrics/LineLength` cop is disabled. ([@tom-lord][])
* [#6389](https://github.com/rubocop-hq/rubocop/pull/6389): Fix false negative for `Style/TrailingCommaInHashLiteral`/`Style/TrailingCommaInArrayLiteral` when there is a comment in the last line. ([@bayandin][])
* [#6566](https://github.com/rubocop-hq/rubocop/issues/6566): Fix false positive for `Layout/EmptyLinesAroundAccessModifier` when at the end of specifying a superclass is missing blank line. ([@koic][])
* [#6571](https://github.com/rubocop-hq/rubocop/issues/6571): Fix a false positive for `Layout/TrailingCommaInArguments` when a line break before a method call and `EnforcedStyleForMultiline` is set to `consistent_comma`. ([@koic][])
* [#6573](https://github.com/rubocop-hq/rubocop/pull/6573): Make `Layout/AccessModifierIndentation` work for dynamic module or class definitions. ([@deivid-rodriguez][])
* [#6562](https://github.com/rubocop-hq/rubocop/pull/6562): Fix a false positive for `Style/MethodCallWithArgsParentheses` `omit_parentheses` enforced style after safe navigation call. ([@gsamokovarov][])
* [#6570](https://github.com/rubocop-hq/rubocop/pull/6570): Fix a false positive for `Style/MethodCallWithArgsParentheses` `omit_parentheses` enforced style while splatting the result of a method invocation. ([@gsamokovarov][])
* [#6598](https://github.com/rubocop-hq/rubocop/pull/6598): Fix a false positive for `Style/MethodCallWithArgsParentheses` `omit_parentheses` enforced style for calls with regexp slash literals argument. ([@gsamokovarov][])
* [#6598](https://github.com/rubocop-hq/rubocop/pull/6598): Fix a false positive for `Style/MethodCallWithArgsParentheses` `omit_parentheses` enforced style for default argument value calls. ([@gsamokovarov][])
* [#6598](https://github.com/rubocop-hq/rubocop/pull/6598): Fix a false positive for `Style/MethodCallWithArgsParentheses` `omit_parentheses` enforced style for argument calls with braced blocks. ([@gsamokovarov][])
* [#6594](https://github.com/rubocop-hq/rubocop/pull/6594): Fix a false positive for `Rails/OutputSafety` when the receiver is a non-interpolated string literal. ([@amatsuda][])
* [#6574](https://github.com/rubocop-hq/rubocop/pull/6574): Fix `Style/AccessModifierIndentation` not handling arbitrary blocks. ([@deivid-rodriguez][])
* [#6370](https://github.com/rubocop-hq/rubocop/issues/6370): Fix the enforcing style from `extend self` into `module_function` when there are private methods. ([@Ruffeng][])

### Changes

* [#595](https://github.com/rubocop-hq/rubocop/issues/595): Exclude files ignored by `git`. ([@AlexWayfer][])
* [#6429](https://github.com/rubocop-hq/rubocop/issues/6429): Fix autocorrect in Rails/Validation to not wrap hash options with braces in an extra set of braces. ([@bquorning][])
* [#6533](https://github.com/rubocop-hq/rubocop/issues/6533): Improved warning message for unrecognized cop parameters to include Supported parameters. ([@MagedMilad][])

## 0.61.1 (2018-12-06)

### Bug fixes

* [#6550](https://github.com/rubocop-hq/rubocop/issues/6550): Prevent Layout/RescueEnsureAlignment cop from breaking on assigned begin-end. ([@drenmi][])

## 0.61.0 (2018-12-05)

### New features

* [#6457](https://github.com/rubocop-hq/rubocop/pull/6457): Support inner slash correction on `Style/RegexpLiteral`. ([@r7kamura][])
* [#6475](https://github.com/rubocop-hq/rubocop/pull/6475): Support brace correction on `Style/Lambda`. ([@r7kamura][])
* [#6469](https://github.com/rubocop-hq/rubocop/pull/6469): Enforce no parentheses style in the `Style/MethodCallWithArgsParentheses` cop. ([@gsamokovarov][])
* New cop `Performance/OpenStruct` checks for `OpenStruct.new` calls. ([@xlts][])

### Bug fixes

* [#6433](https://github.com/rubocop-hq/rubocop/issues/6433): Fix Ruby 2.5 `Layout/RescueEnsureAlignment` error on assigned blocks. ([@gmcgibbon][])
* [#6405](https://github.com/rubocop-hq/rubocop/issues/6405): Fix a false positive for `Lint/UselessAssignment` when using a variable in a module name. ([@itsWill][])
* [#5934](https://github.com/rubocop-hq/rubocop/issues/5934): Handle the combination of `--auto-gen-config` and `--config FILE` correctly. ([@jonas054][])
* [#5970](https://github.com/rubocop-hq/rubocop/issues/5970): Make running `--auto-gen-config` in a subdirectory work. ([@jonas054][])
* [#6412](https://github.com/rubocop-hq/rubocop/issues/6412): Fix an `unknown keywords` error when using `Psych.safe_load` with Ruby 2.6.0-preview2. ([@koic][])
* [#6436](https://github.com/rubocop-hq/rubocop/pull/6436): Fix exit status code to be 130 when rubocop is interrupted. ([@deivid-rodriguez][])
* [#6443](https://github.com/rubocop-hq/rubocop/pull/6443): Fix an incorrect autocorrect for `Style/BracesAroundHashParameters` when the opening brace is before the first hash element at same line. ([@koic][])
* [#6445](https://github.com/rubocop-hq/rubocop/pull/6445): Treat `yield` and `super` like regular method calls in `Style/AlignHash`. ([@mvz][])
* [#3301](https://github.com/rubocop-hq/rubocop/issues/3301): Don't suggest or make semantic changes to the code in `Style/InfiniteLoop`. ([@jonas054][])
* [#3586](https://github.com/rubocop-hq/rubocop/issues/3586): Handle single argument spanning multiple lines in `Style/TrailingCommaInArguments`. ([@jonas054][])
* [#6478](https://github.com/rubocop-hq/rubocop/pull/6478): Fix EmacsComment#encoding to match the `coding` variable. ([@akihiro17][])
* Don't show "unrecognized parameter" warning for `inherit_mode` parameter to individual cop configurations. ([@maxh][])
* [#6449](https://github.com/rubocop-hq/rubocop/pull/6449): Fix a false negative for `Layout/IndentationWidth` when setting `EnforcedStyle: rails` of `Layout/IndentationConsistency` and method definition indented to access modifier in a singleton class. ([@koic][])
* [#6482](https://github.com/rubocop-hq/rubocop/issues/6482): Fix a false positive for `Lint/FormatParameterMismatch` when using (digit)$ flag. ([@koic][])
* [#6489](https://github.com/rubocop-hq/rubocop/issues/6489): Fix an error for `Style/UnneededCondition` when `if` condition and `then` branch are the same and it has no `else` branch. ([@koic][])
* Fix NoMethodError for `Style/FrozenStringLiteral` when a file contains only a shebang. ([@takaram][])
* [#6511](https://github.com/rubocop-hq/rubocop/issues/6511): Fix an incorrect auto-correct for `Style/EmptyCaseCondition` when used as an argument of a method. ([@koic][])
* [#6509](https://github.com/rubocop-hq/rubocop/issues/6509): Fix an incorrect auto-correct for `Style/RaiseArgs` when an exception object is assigned to a local variable. ([@koic][])
* [#6534](https://github.com/rubocop-hq/rubocop/issues/6534): Fix a false positive for `Lint/UselessAccessModifier` when using `private_class_method`. ([@dduugg][])
* [#6545](https://github.com/rubocop-hq/rubocop/issues/6545): Fix a regression where `Performance/RedundantMerge` raises an error on a sole double splat argument passed to `merge!`. ([@mmedal][])
* [#6360](https://github.com/rubocop-hq/rubocop/issues/6360): Detect bad indentation in `if` nodes even if the first branch is empty. ([@bquorning][])

### Changes

* [#6492](https://github.com/rubocop-hq/rubocop/issues/6492): Auto-correct chunks of comment lines in `Layout/CommentIndentation` to avoid unnecessary iterations for `rubocop -a`. ([@jonas054][])
* Fix `--auto-gen-config` when individual cops have regexp literal exclude paths. ([@maxh][])

## 0.60.0 (2018-10-26)

### New features

* [#5980](https://github.com/rubocop-hq/rubocop/issues/5980): Add `--safe` and `--safe-auto-correct` options. ([@Darhazer][])
* [#4156](https://github.com/rubocop-hq/rubocop/issues/4156): Add command line option `--auto-gen-only-exclude`. ([@Ana06][], [@jonas054][])
* [#6386](https://github.com/rubocop-hq/rubocop/pull/6386): Add `VersionAdded` meta data to config/default.yml when running `rake new_cop`. ([@koic][])
* [#6395](https://github.com/rubocop-hq/rubocop/pull/6395): Permit to specify TargetRubyVersion 2.6. ([@koic][])
* [#6392](https://github.com/rubocop-hq/rubocop/pull/6392): Add `Whitelist` config to `Rails/SkipsModelValidations` rule. ([@DiscoStarslayer][])

### Bug fixes

* [#6330](https://github.com/rubocop-hq/rubocop/issues/6330): Fix an error for `Rails/ReversibleMigration` when using variable assignment. ([@koic][], [@scottmatthewman][])
* [#6331](https://github.com/rubocop-hq/rubocop/issues/6331): Fix a false positive for `Style/RedundantFreeze` and a false negative for `Style/MutableConstant` when assigning a regexp object to a constant. ([@koic][])
* [#6334](https://github.com/rubocop-hq/rubocop/pull/6334): Fix a false negative for `Style/RedundantFreeze` when assigning a range object to a constant. ([@koic][])
* [#5538](https://github.com/rubocop-hq/rubocop/issues/5538): Fix false negatives in modifier cops when line length cop is disabled. ([@drenmi][])
* [#6340](https://github.com/rubocop-hq/rubocop/pull/6340): Fix an error for `Rails/ReversibleMigration` when block argument is empty. ([@koic][])
* [#6274](https://github.com/rubocop-hq/rubocop/issues/6274): Fix "[Corrected]" message being displayed even when nothing has been corrected. ([@jekuta][])
* [#6380](https://github.com/rubocop-hq/rubocop/pull/6380): Allow use of a hyphen-separated frozen string literal in Emacs style magic comment. ([@y-yagi][])
* Fix and improve `LineLength` cop for tab-indented code. ([@AlexWayfer][])

### Changes

* [#3727](https://github.com/rubocop-hq/rubocop/issues/3727): Enforce single spaces for `key` option in `Layout/AlignHash` cop. ([@albaer][])
* [#6321](https://github.com/rubocop-hq/rubocop/pull/6321): Fix run of RuboCop when cache directory is not writable. ([@Kevinrob][])

## 0.59.2 (2018-09-24)

### New features

* Update `Style/MethodCallWithoutArgsParentheses` to highlight the closing parentheses in additition to the opening parentheses. ([@rrosenblum][])

### Bug fixes

* [#6266](https://github.com/rubocop-hq/rubocop/issues/6266): Fix a false positive for `Rails/HasManyOrHasOneDependent` when using associations of Active Resource. ([@tejasbubane][], [@koic][])
* [#6296](https://github.com/rubocop-hq/rubocop/issues/6296): Fix an auto-correct error for `Style/For` when setting `EnforcedStyle: each` and `for` dose not have `do` or semicolon. ([@autopp][])
* [#6300](https://github.com/rubocop-hq/rubocop/pull/6300): Fix a false positive for `Layout/EmptyLineAfterGuardClause` when guard clause including heredoc. ([@koic][])
* [#6287](https://github.com/rubocop-hq/rubocop/pull/6287): Fix `AllowURI` option for `Metrics/LineLength` cop with disabled `Layut/Tab` cop. ([@AlexWayfer][])
* [#5338](https://github.com/rubocop-hq/rubocop/pull/5338): Move checking of class- and module defining blocks from `Metrics/BlockLength` into the respective length cops. ([@drenmi][])
* [#2841](https://github.com/rubocop-hq/rubocop/pull/2841): Fix `Style/ZeroLengthPredicate` false positives when inspecting `Tempfile`, `StringIO`, and `File::Stat` objects. ([@drenmi][])
* [#6305](https://github.com/rubocop-hq/rubocop/pull/6305): Fix infinite loop for `Layout/EmptyLinesAroundAccessModifier` and `Layout/EmptyLinesAroundAccessModifier` when specifying a superclass that breaks the line. ([@koic][])
* [#6007](https://github.com/rubocop-hq/rubocop/pull/6007): Fix false positive in `Style/IfUnlessModifier` when using named capture. ([@drenmi][])
* [#6311](https://github.com/rubocop-hq/rubocop/pull/6311): Prevent `Style/Semicolon` from breaking on single line if-then-else in assignment. ([@drenmi][])
* [#6315](https://github.com/rubocop-hq/rubocop/pull/6315): Fix an error for `Rails/HasManyOrHasOneDependent` when an Active Record model does not have any relations. ([@koic][])
* [#6316](https://github.com/rubocop-hq/rubocop/issues/6316): Fix an auto-correct error for `Style/For` when setting `EnforcedStyle: each` with range provided to the `for` loop without a `do` keyword or semicolon and without enclosing parenthesis. ([@lukasz-wojcik][])
* [#6326](https://github.com/rubocop-hq/rubocop/issues/6326): Fix an alignment source for `Layout/RescueEnsureAlignment` when using inline access modifier. ([@andrew-aladev][])

### Changes

* [#6286](https://github.com/rubocop-hq/rubocop/pull/6286): Allow exclusion of certain methods for `Metrics/MethodLength`. ([@akanoi][])

## 0.59.1 (2018-09-15)

### Bug fixes

* [#6267](https://github.com/rubocop-hq/rubocop/pull/6267): Fix undefined method 'method_name' for `Rails/FindEach`. ([@Knack][])
* [#6278](https://github.com/rubocop-hq/rubocop/pull/6278): Fix false positive for `Naming/FileName` when investigating gemspecs. ([@kddeisz][])
* [#6256](https://github.com/rubocop-hq/rubocop/pull/6256): Fix false positive for `Naming/FileName` when investigating dotfiles. ([@sinsoku][])
* [#6242](https://github.com/rubocop-hq/rubocop/pull/6242): Fix `Style/EmptyCaseCondition` auto-correction removes comment between `case` and first `when`. ([@koic][])
* [#6261](https://github.com/rubocop-hq/rubocop/pull/6261): Fix undefined method error for `Style/RedundantBegin` when calling `super` with a block. ([@eitoball][])
* [#6263](https://github.com/rubocop-hq/rubocop/issues/6263): Fix an error `Layout/EmptyLineAfterGuardClause` when guard clause is after heredoc including string interpolation. ([@koic][])
* [#6281](https://github.com/rubocop-hq/rubocop/pull/6281): Fix false negative in `Style/MultilineMethodSignature`. ([@drenmi][])
* [#6264](https://github.com/rubocop-hq/rubocop/issues/6264): Fix an incorrect autocorrect for `Layout/EmptyLineAfterGuardClause` cop when `if` condition is after heredoc. ([@koic][])

### Changes

* [#6272](https://github.com/rubocop-hq/rubocop/pull/6272): Make `Lint/UnreachableCode` detect `exit`, `exit!` and `abort`. ([@hoshinotsuyoshi][])
* [#6295](https://github.com/rubocop-hq/rubocop/pull/6295): Exclude `#===` from `Naming/BinaryOperatorParameterName`. ([@zverok][])
* Add `+` to allowed file names of `Naming/FileName`. ([@yensaki][])
* [#5303](https://github.com/rubocop-hq/rubocop/issues/5303): Extract `PercentLiteralCorrector` class from `PercentLiteral` mixin. ([@ryanhageman][])

## 0.59.0 (2018-09-09)

### New features

* [#6109](https://github.com/rubocop-hq/rubocop/pull/6109): Add new `Bundler/GemComment` cop. ([@sunny][])
* [#6148](https://github.com/rubocop-hq/rubocop/pull/6148): Add `IgnoredMethods` option to `Style/NumericPredicate` cop. ([@AlexWayfer][])
* [#6174](https://github.com/rubocop-hq/rubocop/pull/6174): Add `--display-only-fail-level-offenses` to only output offenses at or above the fail level. ([@robotdana][])
* Add autocorrect to `Style/For`. ([@rrosenblum][])
* [#6173](https://github.com/rubocop-hq/rubocop/pull/6173): Add `AllowImplicitReturn` option to `Rails/SaveBang` cop. ([@robotdana][])
* [#6218](https://github.com/rubocop-hq/rubocop/pull/6218): Add `comparison` style to `Style/NilComparison`. ([@khiav223577][])
* Add new `Style/MultilineMethodSignature` cop. ([@drenmi][])
* [#6234](https://github.com/rubocop-hq/rubocop/pull/6234): Add `Performance/ChainArrayAllocation` cop. ([@schneems][])
* [#6136](https://github.com/rubocop-hq/rubocop/pull/6136): Add remote url in remote url download error message. ([@ShockwaveNN][])
* [#5659](https://github.com/rubocop-hq/rubocop/issues/5659): Make `Layout/EmptyLinesAroundClassBody` aware of specifying a superclass that breaks the line. ([@koic][])

### Bug fixes

* [#6107](https://github.com/rubocop-hq/rubocop/pull/6107): Fix indentation of multiline postfix conditionals. ([@jaredbeck][])
* [#6140](https://github.com/rubocop-hq/rubocop/pull/6140): Fix `Style/DateTime` not detecting `#to_datetime`. It can be configured to allow this. ([@bdewater][])
* [#6132](https://github.com/rubocop-hq/rubocop/issues/6132): Fix a false negative for `Naming/FileName` when `Include` of `AllCops` is the default setting. ([@koic][])
* [#4115](https://github.com/rubocop-hq/rubocop/issues/4115): Fix false positive for unary operations in `Layout/MultilineOperationIndentation`. ([@jonas054][])
* [#6127](https://github.com/rubocop-hq/rubocop/issues/6127): Fix an error for `Layout/ClosingParenthesisIndentation` when method arguments are empty with newlines. ([@tatsuyafw][])
* [#6152](https://github.com/rubocop-hq/rubocop/pull/6152): Fix a false negative for `Layout/AccessModifierIndentation` when using access modifiers with arguments within nested classes. ([@gmalette][])
* [#6124](https://github.com/rubocop-hq/rubocop/issues/6124): Fix `Style/IfUnlessModifier` cop for disabled `Layout/Tab` cop when there is no `IndentationWidth` config. ([@AlexWayfer][])
* [#6133](https://github.com/rubocop-hq/rubocop/pull/6133): Fix `AllowURI` option of `Metrics/LineLength` cop for files with tabs indentation. ([@AlexWayfer][])
* [#6164](https://github.com/rubocop-hq/rubocop/issues/6164): Fix incorrect autocorrect for `Style/UnneededCondition` when using operator method higher precedence than `||`. ([@koic][])
* [#6138](https://github.com/rubocop-hq/rubocop/issues/6138): Fix a false positive for assigning a block local variable in `Lint/ShadowedArgument`. ([@jonas054][])
* [#6022](https://github.com/rubocop-hq/rubocop/issues/6022): Fix `Layout/MultilineHashBraceLayout` and `Layout/MultilineArrayBraceLayout` auto-correct syntax error when there is a comment on the last element. ([@bacchir][])
* [#6175](https://github.com/rubocop-hq/rubocop/issues/6175): Fix `Style/BracesAroundHashParameters` auto-correct syntax error when there is a trailing comma. ([@bacchir][])
* [#6192](https://github.com/rubocop-hq/rubocop/issues/6192): Make `Style/RedundantBegin` aware of stabby lambdas. ([@drenmi][])
* [#6208](https://github.com/rubocop-hq/rubocop/pull/6208): Ignore assignment methods in `Naming/PredicateName`. ([@sunny][])
* [#6196](https://github.com/rubocop-hq/rubocop/issues/6196): Fix incorrect autocorrect for `Style/EmptyCaseCondition` when using `return` in `when` clause and assigning the return value of `case`. ([@koic][])
* [#6142](https://github.com/rubocop-hq/rubocop/issues/6142): Ignore keyword arguments in `Rails/Delegate`. ([@sunny][])
* [#6240](https://github.com/rubocop-hq/rubocop/issues/6240): Fix an auto-correct error for `Style/WordArray` when setting `EnforcedStyle: brackets` and using string interpolation in `%W` literal. ([@koic][])
* [#6202](https://github.com/rubocop-hq/rubocop/issues/6202): Fix infinite loop when auto-correcting `Lint/RescueEnsureAlignment` when `end` is misaligned. The alignment and message are now based on the beginning position rather than the `end` position. ([@rrosenblum][])
* [#6199](https://github.com/rubocop-hq/rubocop/issues/6199): Don't recommend `Date` usage in `Style/DateTime`. ([@deivid-rodriguez][])

### Changes

* [#6161](https://github.com/rubocop-hq/rubocop/pull/6161): Add scope methods to `Rails/FindEach` cop. Makes the cop also check for the following scopes: `eager_load`, `includes`, `joins`, `left_joins`, `left_outer_joins`, `preload`, `references`, and `unscoped`. ([@repinel][])
* [#6137](https://github.com/rubocop-hq/rubocop/pull/6137): Allow `db` to allowed names of `Naming/UncommunicativeMethodParamName` cop in default config. ([@mkenyon][])
* Update the highlighting of `Lint/DuplicateMethods` to include the method name. ([@rrosenblum][])
* [#6057](https://github.com/rubocop-hq/rubocop/issues/6057): Return 0 when running `rubocop --auto-gen-conf` if the todo file is successfully created even if there are offenses. ([@MagedMilad][])
* [#4301](https://github.com/rubocop-hq/rubocop/issues/4301): Turn off autocorrect for `Rails/RelativeDateConstant` by default. ([@koic][])
* [#4832](https://github.com/rubocop-hq/rubocop/issues/4832): Change the path pattern (`*`) to match the hidden file. ([@koic][])
* `Style/For` now highlights the entire statement rather than just the keyword. ([@rrosenblum][])
* Disable `Performance/CaseWhenSplat` and its auto-correction by default. ([@rrosenblum][])
* [#6235](https://github.com/rubocop-hq/rubocop/pull/6235): Enable `Layout/EmptyLineAfterGuardClause` cop by default. ([@koic][])
* [#6199](https://github.com/rubocop-hq/rubocop/pull/6199): `Style/DateTime` has been moved to disabled by default. ([@deivid-rodriguez][])

## 0.58.2 (2018-07-23)

### New features

* [#6105](https://github.com/rubocop-hq/rubocop/issues/6105): Support `{a,b}` file name globs in `Exclude` and `Include` config. ([@mikeyhew][])

### Bug fixes

* [#6103](https://github.com/rubocop-hq/rubocop/pull/6103): Fix a false positive for `Layout/IndentationWidth` when multiple modifiers are used in a block and a method call is made at end of the block. ([@koic][])
* [#6084](https://github.com/rubocop-hq/rubocop/issues/6084): Fix `Naming/MemoizedInstanceVariableName` cop to allow methods to have leading underscores. ([@kenman345][])
* [#6098](https://github.com/rubocop-hq/rubocop/issues/6098): Fix an error for `Layout/ClassStructure` when there is a comment in the macro method to be auto-correct. ([@koic][])
* [#6115](https://github.com/rubocop-hq/rubocop/issues/6115): Fix a false positive for `Lint/OrderedMagicComments` when using `{ encoding: Encoding::SJIS }` hash object after `frozen_string_literal` magic comment. ([@koic][])

### Changes

* [#6116](https://github.com/rubocop-hq/rubocop/pull/6116): Add `ip` to allowed names of `Naming/UncommunicativeMethodParamName` cop in default config. ([@nijikon][])

## 0.58.1 (2018-07-10)

### Bug fixes

* [#6071](https://github.com/rubocop-hq/rubocop/issues/6071): Fix auto-correct `Style/MethodCallWithArgsParentheses` when arguments are method calls. ([@maxh][])
* Fix `Style/RedundantParentheses` with hash literal as first argument to `super`. ([@maxh][])
* [#6086](https://github.com/rubocop-hq/rubocop/issues/6086): Fix an error for `Gemspec/OrderedDependencies` when using method call to gem names in gemspec. ([@koic][])
* [#6089](https://github.com/rubocop-hq/rubocop/issues/6089): Make `Rails/BulkChangeTable` aware of variable table name. ([@wata727][])
* [#6088](https://github.com/rubocop-hq/rubocop/issues/6088): Fix an error for `Layout/MultilineAssignmentLayout` cop when using multi-line block defines on separate lines. ([@koic][])
* [#6092](https://github.com/rubocop-hq/rubocop/issues/6092): Don't use the broken parser 2.5.1.1 version. ([@bbatsov][])

## 0.58.0 (2018-07-07)

### New features

* [#5973](https://github.com/rubocop-hq/rubocop/issues/5973): Add new `Style/IpAddresses` cop. ([@dvandersluis][])
* [#5843](https://github.com/rubocop-hq/rubocop/issues/5843): Add configuration options to `Naming/MemoizedInstanceVariableName` cop to allow leading underscores. ([@leklund][])
* [#5843](https://github.com/rubocop-hq/rubocop/issues/5843): Add `EnforcedStyleForLeadingUnderscores` to `Naming/MemoizedInstanceVariableName` cop to allow leading underscores. ([@leklund][])
* `Performance/Sample` will now register an offense when using `shuffle` followed by `at` or `slice`. ([@rrosenblum][])

### Bug fixes

* [#5987](https://github.com/rubocop-hq/rubocop/issues/5987): Suppress errors when using ERB template in Rails/BulkChangeTable. ([@wata727][])
* [#4878](https://github.com/rubocop-hq/rubocop/issues/4878): Fix false positive in `Layout/IndentationWidth` when multiple modifiers and def are on the same line. ([@tatsuyafw][])
* [#5966](https://github.com/rubocop-hq/rubocop/issues/5966): Fix a false positive for `Layout/ClosingHeredocIndentation` when heredoc content is outdented compared to the closing. ([@koic][])
* Fix auto-correct support check for custom cops on --auto-gen-config. ([@r7kamura][])
* Fix exception that occurs when auto-correcting a modifier if statement in `Style/UnneededCondition`. ([@rrosenblum][])
* [#6025](https://github.com/rubocop-hq/rubocop/pull/6025): Fix an incorrect auto-correct for `Lint/UnneededCondition` when using if_branch in `else` branch. ([@koic][])
* [#6029](https://github.com/rubocop-hq/rubocop/issues/6029): Fix a false positive for `Lint/ShadowedArgument` when reassigning to splat variable. ([@koic][])
* [#6035](https://github.com/rubocop-hq/rubocop/issues/6035): Fix error on autocorrection when `Layout/LeadingBlankLines` is the first cop to act. ([@Vasfed][])
* [#6036](https://github.com/rubocop-hq/rubocop/issues/6036): Make `Rails/BulkChangeTable` aware of string table name. ([@wata727][])
* [#5467](https://github.com/rubocop-hq/rubocop/issues/5467): Fix a false negative for `Style/MultipleComparison` when multiple comparison is not part of a conditional. ([@koic][])
* [#6042](https://github.com/rubocop-hq/rubocop/pull/6042): Fix `Lint/RedundantWithObject` error on missing parameter to `each_with_object`. ([@Vasfed][])
* [#6056](https://github.com/rubocop-hq/rubocop/pull/6056): Support string timestamps in `Rails/CreateTableWithTimestamps` cop. ([@drn][])
* [#6052](https://github.com/rubocop-hq/rubocop/issues/6052): Fix a false positive for `Style/SymbolProc` when using  block with adding a comma after the sole argument. ([@koic][])
* [#2743](https://github.com/rubocop-hq/rubocop/issues/2743): Support `<<` as a kind of assignment operator in `Layout/EndAlignment`. ([@jonas054][])
* [#6067](https://github.com/rubocop-hq/rubocop/issues/6067): Prevent auto-correct error for `Performance/InefficientHashSearch` when a method by itself and `include?` method are method chaining. ([@koic][])

### Changes

* [#6006](https://github.com/rubocop-hq/rubocop/pull/6006): Remove `rake repl` task. ([@koic][])
* [#5990](https://github.com/rubocop-hq/rubocop/pull/5990): Drop support for MRI 2.1. ([@drenmi][])
* [#3299](https://github.com/rubocop-hq/rubocop/issues/3299): `Lint/UselessAccessModifier` now warns when `private_class_method` is used without arguments. ([@Darhazer][])
* [#6026](https://github.com/rubocop-hq/rubocop/pull/6026): Exclude `refine` by default from `Metrics/BlockLength` cop. ([@kddeisz][])
* [#4882](https://github.com/rubocop-hq/rubocop/issues/4882): Use `IndentationWidth` of `Layout/Tab` for other cops. ([@AlexWayfer][])

## 0.57.2 (2018-06-12)

### Bug fixes

* [#5968](https://github.com/rubocop-hq/rubocop/issues/5968): Prevent `Layout/ClosingHeredocIndentation` from raising an error on `<<` heredocs. ([@dvandersluis][])
* [#5965](https://github.com/rubocop-hq/rubocop/issues/5965): Prevent `Layout/ClosingHeredocIndentation` from raising an error on heredocs containing only a newline. ([@drenmi][])
* Prevent a crash in `Layout/IndentationConsistency` cop triggered by an empty expression string interpolation. ([@alexander-lazarov][])
* [#5951](https://github.com/rubocop-hq/rubocop/issues/5951): Prevent `Style/MethodCallWithArgsParentheses` from raising an error in certain cases. ([@drenmi][])

## 0.57.1 (2018-06-07)

### Bug fixes

* [#5963](https://github.com/rubocop-hq/rubocop/issues/5963): Allow Performance/ReverseEach to apply to any receiver. ([@dvandersluis][])
* [#5917](https://github.com/rubocop-hq/rubocop/issues/5917): Fix erroneous warning for `inherit_mode` directive. ([@jonas054][])
* [#5380](https://github.com/rubocop-hq/rubocop/issues/5380): Fix false negative in `Layout/IndentationWidth` when an access modifier section has an invalid indentation body. ([@tatsuyafw][])
* [#5909](https://github.com/rubocop-hq/rubocop/pull/5909): Even when a module has no public methods, `Layout/IndentationConsistency` should still register an offense for private methods. ([@jaredbeck][])
* [#5958](https://github.com/rubocop-hq/rubocop/issues/5958): Handle empty method body in `Rails/BulkChangeTable`. ([@wata727][])
* [#5954](https://github.com/rubocop-hq/rubocop/issues/5954): Make `Style/UnneededCondition` cop accepts a case of condition and `if_branch` are same when using `elsif` branch. ([@koic][])

## 0.57.0 (2018-06-06)

### New features

* [#5881](https://github.com/rubocop-hq/rubocop/pull/5881): Add new `Rails/BulkChangeTable` cop. ([@wata727][])
* [#5444](https://github.com/rubocop-hq/rubocop/pull/5444): Add new `Style/AccessModifierDeclarations` cop. ([@brandonweiss][])
* [#5803](https://github.com/rubocop-hq/rubocop/issues/5803): Add new `Style/UnneededCondition` cop. ([@balbesina][])
* [#5406](https://github.com/rubocop-hq/rubocop/issues/5406): Add new `Layout/ClosingHeredocIndentation` cop. ([@siegfault][])
* [#5823](https://github.com/rubocop-hq/rubocop/issues/5823): Add new `slashes` style to `Rails/FilePath` since Ruby accepts forward slashes even on Windows. ([@sunny][])
* New cop `Layout/LeadingBlankLines` checks for empty lines at the beginning of a file. ([@rrosenblum][])

### Bug fixes

* [#5897](https://github.com/rubocop-hq/rubocop/issues/5897): Fix `Style/SymbolArray` and `Style/WordArray` not working on arrays of size 1. ([@TikiTDO][])
* [#5894](https://github.com/rubocop-hq/rubocop/pull/5894): Fix `Rails/AssertNot` to allow it to have failure message. ([@koic][])
* [#5888](https://github.com/rubocop-hq/rubocop/issues/5888): Do not register an offense for `headers` or `env` keyword arguments in `Rails/HttpPositionalArguments`. ([@rrosenblum][])
* Fix the indentation of autocorrected closing squiggly heredocs. ([@garettarrowood][])
* [#5908](https://github.com/rubocop-hq/rubocop/pull/5908): Fix `Style/BracesAroundHashParameters` auto-correct going past the end of the file when the closing curly brace is on the last line of a file. ([@EiNSTeiN-][])
* Fix a bug where `Style/FrozenStringLiteralComment` would be added to the second line if the first line is empty. ([@rrosenblum][])
* [#5914](https://github.com/rubocop-hq/rubocop/issues/5914): Make `Layout/SpaceInsideReferenceBrackets` aware of `no_space` when using nested reference brackets. ([@koic][])
* [#5799](https://github.com/rubocop-hq/rubocop/issues/5799): Fix false positive in `Style/MixinGrouping` when method named `include` accepts block. ([@Darhazer][])

### Changes

* [#5937](https://github.com/rubocop-hq/rubocop/pull/5937): Add new `--fix-layout/-x` command line alias. ([@scottmatthewman][])
* [#5887](https://github.com/rubocop-hq/rubocop/issues/5887): Remove `Lint/SplatKeywordArguments` cop. ([@koic][])
* [#5761](https://github.com/rubocop-hq/rubocop/pull/5761): Add `httpdate` to accepted `Rails/TimeZone` methods. ([@cupakromer][])
* [#5899](https://github.com/rubocop-hq/rubocop/pull/5899): Add `xmlschema` to accepted `Rails/TimeZone` methods. ([@koic][])
* [#5906](https://github.com/rubocop-hq/rubocop/pull/5906): Move REPL command from `rake repl` task to `bin/console` command. ([@koic][])
* [#5917](https://github.com/rubocop-hq/rubocop/issues/5917): Let `inherit_mode` work for default configuration too. ([@jonas054][])
* [#5929](https://github.com/rubocop-hq/rubocop/pull/5929): Stop including string extensions from `unicode/display_width`. ([@nroman-stripe][])

## 0.56.0 (2018-05-14)

### New features

* [#5848](https://github.com/rubocop-hq/rubocop/pull/5848): Add new `Performance/InefficientHashSearch` cop. ([@JacobEvelyn][])
* [#5801](https://github.com/rubocop-hq/rubocop/pull/5801): Add new `Rails/RefuteMethods` cop. ([@koic][])
* [#5805](https://github.com/rubocop-hq/rubocop/pull/5805): Add new `Rails/AssertNot` cop. ([@composerinteralia][])
* [#4136](https://github.com/rubocop-hq/rubocop/issues/4136): Allow more robust `Layout/ClosingParenthesisIndentation` detection including method chaining. ([@jfelchner][])
* [#5699](https://github.com/rubocop-hq/rubocop/pull/5699): Add `consistent_relative_to_receiver` style option to `Layout/FirstParameterIndentation`. ([@jfelchner][])
* [#5821](https://github.com/rubocop-hq/rubocop/pull/5821): Support `AR::Migration#up_only` for `Rails/ReversibleMigration` cop. ([@koic][])
* [#5800](https://github.com/rubocop-hq/rubocop/issues/5800): Don't show a stracktrace for invalid command-line params. ([@shanecav84][])
* [#5845](https://github.com/rubocop-hq/rubocop/pull/5845): Add new `Lint/ErbNewArguments` cop. ([@koic][])
* [#5871](https://github.com/rubocop-hq/rubocop/pull/5871): Add new `Lint/SplatKeywordArguments` cop. ([@koic][])
* [#4247](https://github.com/rubocop-hq/rubocop/issues/4247): Remove hard-coded file patterns and use only `Include`, `Exclude` and the new `RubyInterpreters` parameters for file selection. ([@jonas054][])

### Bug fixes

* Fix bug in `Style/EmptyMethod` which concatenated the method name and first argument if no method def parentheses are used. ([@thomasbrus][])
* [#5819](https://github.com/rubocop-hq/rubocop/issues/5819): Fix `Rails/SaveBang` when using negated if. ([@Edouard-chin][])
* [#5286](https://github.com/rubocop-hq/rubocop/issues/5286): Fix `Lint/SafeNavigationChain` not detecting chained operators after block. ([@Darhazer][])
* Fix bug where `Lint/SafeNavigationConsistency` registers multiple offenses for the same method call. ([@rrosenblum][])
* [#5713](https://github.com/rubocop-hq/rubocop/issues/5713): Fix `Style/CommentAnnotation` reporting only the first of multiple consecutive offending lines. ([@svendittmer][])
* [#5791](https://github.com/rubocop-hq/rubocop/issues/5791): Fix exception in `Lint/SafeNavigationConsistency` when there is code around the condition. ([@rrosenblum][])
* [#5784](https://github.com/rubocop-hq/rubocop/issues/5784): Fix a false positive for `Rails/HasManyOrHasOneDependent` when using nested `with_options`. ([@koic][])
* [#4666](https://github.com/rubocop-hq/rubocop/issues/4666): `--stdin` always treats input as Ruby source irregardless of filename. ([@PointlessOne][])
* Fix auto-correction for `Style/MethodCallWithArgsParentheses` adding extra parentheses if the method argument was already parenthesized. ([@dvandersluis][])
* [#5668](https://github.com/rubocop-hq/rubocop/issues/5668): Fix an issue where files with unknown extensions, listed in `AllCops/Include` were not inspected when passing the file name as an option. ([@drenmi][])
* [#5809](https://github.com/rubocop-hq/rubocop/issues/5809): Fix exception `Lint/PercentStringArray` and `Lint/PercentSymbolArray` when the inspected file is binary encoded. ([@akhramov][])
* [#5840](https://github.com/rubocop-hq/rubocop/issues/5840): Do not register an offense for methods that `nil` responds to in `Lint/SafeNavigationConsistency`. ([@rrosenblum][])
* [#5862](https://github.com/rubocop-hq/rubocop/issues/5862): Fix an incorrect auto-correct for `Lint/LiteralInInterpolation` if contains numbers. ([@koic][])
* [#5868](https://github.com/rubocop-hq/rubocop/pull/5868): Fix `Rails/CreateTableWithTimestamps` when using hash options. ([@wata727][])
* [#5708](https://github.com/rubocop-hq/rubocop/issues/5708): Fix exception in `Lint/UnneededCopEnableDirective` for instruction '# rubocop:enable **all**'. ([@balbesina][])
* Fix auto-correction of `Rails/HttpPositionalArgumnets` to use `session` instead of `header`. ([@rrosenblum][])

### Changes

* Split `Style/MethodMissing` into two cops, `Style/MethodMissingSuper` and `Style/MissingRespondToMissing`. ([@rrosenblum][])
* [#5757](https://github.com/rubocop-hq/rubocop/issues/5757): Add `AllowInMultilineConditions` option to `Style/ParenthesesAroundCondition` cop. ([@Darhazer][])
* [#5806](https://github.com/rubocop-hq/rubocop/issues/5806): Fix `Layout/SpaceInsideReferenceBrackets` when assigning a reference bracket to a reference bracket. ([@joshuapinter][])
* [#5082](https://github.com/rubocop-hq/rubocop/issues/5082): Allow caching together with `--auto-correct`. ([@jonas054][])
* Add `try!` to the list of whitelisted methods for `Lint/SafeNavigationChain` and `Style/SafeNavigation`. ([@rrosenblum][])
* [#5886](https://github.com/rubocop-hq/rubocop/pull/5886): Move `Style/EmptyLineAfterGuardClause` cop to `Layout` department. ([@koic][])

## 0.55.0 (2018-04-16)

### New features

* [#5753](https://github.com/rubocop-hq/rubocop/pull/5753): Add new `Performance/UnneededSort` cop. ([@parkerfinch][])
* Add new `Lint/SafeNavigationConsistency` cop. ([@rrosenblum][])

### Bug fixes

* [#5759](https://github.com/rubocop-hq/rubocop/pull/5759): Fix `Performance/RegexpMatch` cop not correcting negated match operator. ([@bdewater][])
* [#5726](https://github.com/rubocop-hq/rubocop/issues/5726): Fix false positive for `:class_name` option in Rails/InverseOf cop. ([@bdewater][])
* [#5686](https://github.com/rubocop-hq/rubocop/issues/5686): Fix a regression for `Style/SymbolArray` and `Style/WordArray` for multiline Arrays. ([@istateside][])
* [#5730](https://github.com/rubocop-hq/rubocop/pull/5730): Stop `Rails/InverseOf` cop allowing `inverse_of: nil` to opt-out. ([@bdewater][])
* [#5561](https://github.com/rubocop-hq/rubocop/issues/5561): Fix `Lint/ShadowedArgument` false positive with shorthand assignments. ([@akhramov][])
* [#5403](https://github.com/rubocop-hq/rubocop/issues/5403): Fix `Naming/HeredocDelimiterNaming` blacklist patterns. ([@mcfisch][])
* [#4298](https://github.com/rubocop-hq/rubocop/issues/4298): Fix auto-correction of `Performance/RegexpMatch` to produce code that safe guards against the receiver being `nil`. ([@rrosenblum][])
* [#5738](https://github.com/rubocop-hq/rubocop/issues/5738): Make `Rails/HttpStatus` ignoring hash order to fix false negative. ([@pocke][])
* [#5720](https://github.com/rubocop-hq/rubocop/pull/5720): Fix false positive for `Style/EmptyLineAfterGuardClause` when guard clause is after heredoc. ([@koic][])
* [#5760](https://github.com/rubocop-hq/rubocop/pull/5760): Fix incorrect offense location for `Style/EmptyLineAfterGuardClause` when guard clause is after heredoc argument. ([@koic][])
* [#5764](https://github.com/rubocop-hq/rubocop/pull/5764): Fix `Style/Unpackfirst` false positive of `unpack('h*').take(1)`. ([@parkerfinch][])
* [#5766](https://github.com/rubocop-hq/rubocop/issues/5766): Update `Style/FrozenStringLiteralComment` auto-correction to insert a new line between the comment and the code. ([@rrosenblum][])
* [#5551](https://github.com/rubocop-hq/rubocop/issues/5551): Fix `Lint/Void` not detecting void context in blocks with single expression. ([@Darhazer][])

### Changes

* [#5752](https://github.com/rubocop-hq/rubocop/pull/5752): Add `String#delete_{prefix,suffix}` to Lint/Void cop. ([@bdewater][])
* [#5734](https://github.com/rubocop-hq/rubocop/pull/5734): Add `by`, `on`, `in` and `at` to allowed names of `Naming/UncommunicativeMethodParamName` cop in default config. ([@AlexWayfer][])
* [#5666](https://github.com/rubocop-hq/rubocop/issues/5666): Add spaces as an `EnforcedStyle` option to `Layout/SpaceInsideParens`, allowing you to enforce spaces inside of parentheses. ([@joshuapinter][])
* [#4257](https://github.com/rubocop-hq/rubocop/issues/4257): Allow specifying module name in `Metrics/BlockLength`'s `ExcludedMethods` configuration option. ([@akhramov][])
* [#4753](https://github.com/rubocop-hq/rubocop/issues/4753): Add `IgnoredMethods` option to `Style/MethodCallWithoutArgsParentheses` cop. ([@Darhazer][])
* [#4517](https://github.com/rubocop-hq/rubocop/issues/4517): Add option to allow trailing whitespaces inside heredoc strings. ([@Darhazer][])
* [#5652](https://github.com/rubocop-hq/rubocop/issues/5652): Make `Style/OptionHash` aware of implicit parameter passing to super. ([@Wei-LiangChew][])
* [#5451](https://github.com/rubocop-hq/rubocop/issues/5451): When using --auto-gen-config, do not output offenses unless the --output-offenses flag is also passed. ([@drewpterry][])

## 0.54.0 (2018-03-21)

### New features

* [#5597](https://github.com/rubocop-hq/rubocop/pull/5597): Add new `Rails/HttpStatus` cop. ([@anthony-robin][])
* [#5643](https://github.com/rubocop-hq/rubocop/pull/5643): Add new `Style/UnpackFirst` cop. ([@bdewater][])

### Bug fixes

* [#5744](https://github.com/rubocop-hq/rubocop/pull/5744): Teach `Performance/StartWith` and `EndWith` cops to look for `Regexp#match?`. ([@bdewater][])
* [#5683](https://github.com/rubocop-hq/rubocop/issues/5683): Fix message for `Naming/UncommunicativeXParamName` cops. ([@jlfaber][])
* [#5680](https://github.com/rubocop-hq/rubocop/issues/5680): Fix `Layout/ElseAlignment` for `rescue/else/ensure` inside `do/end` blocks. ([@YukiJikumaru][])
* [#5642](https://github.com/rubocop-hq/rubocop/pull/5642): Fix `Style/Documentation` `:nodoc:` for compact-style nested modules/classes. ([@ojab][])
* [#5648](https://github.com/rubocop-hq/rubocop/issues/5648): Suggest valid memoized instance variable for predicate method. ([@satyap][])
* [#5670](https://github.com/rubocop-hq/rubocop/issues/5670): Suggest valid memoized instance variable for bang method. ([@pocke][])
* [#5623](https://github.com/rubocop-hq/rubocop/pull/5623): Fix `Bundler/OrderedGems` when a group includes duplicate gems. ([@colorbox][])
* [#5633](https://github.com/rubocop-hq/rubocop/pull/5633): Fix broken `--fail-fast`. ([@mmyoji][])
* [#5630](https://github.com/rubocop-hq/rubocop/issues/5630): Fix false positive for `Style/FormatStringToken` when using placeholder arguments in `format` method. ([@koic][])
* [#5651](https://github.com/rubocop-hq/rubocop/pull/5651): Fix NoMethodError when specified config file that does not exist. ([@onk][])
* [#5647](https://github.com/rubocop-hq/rubocop/pull/5647): Fix encoding method of RuboCop::MagicComment::SimpleComment. ([@htwroclau][])
* [#5619](https://github.com/rubocop-hq/rubocop/issues/5619): Do not register an offense in `Style/InverseMethods` when comparing constants with `<`, `>`, `<=`, or `>=`. If the code is being used to determine class hierarchy, the correction might not be accurate. ([@rrosenblum][])
* [#5641](https://github.com/rubocop-hq/rubocop/issues/5641): Disable `Style/TrivialAccessors` auto-correction for `def` with `private`. ([@pocke][])
* Fix bug where `Style/SafeNavigation` does not auto-correct all chained methods resulting in a `Lint/SafeNavigationChain` offense. ([@rrosenblum][])
* [#5436](https://github.com/rubocop-hq/rubocop/issues/5436): Allow empty kwrest args in `UncommunicativeName` cops. ([@pocke][])
* [#5674](https://github.com/rubocop-hq/rubocop/issues/5674): Fix auto-correction of `Layout/EmptyComment` when the empty comment appears on the same line as code. ([@rrosenblum][])
* [#5679](https://github.com/rubocop-hq/rubocop/pull/5679): Fix a false positive for `Style/EmptyLineAfterGuardClause` when guard clause is before `rescue` or `ensure`. ([@koic][])
* [#5694](https://github.com/rubocop-hq/rubocop/issues/5694): Match Rails versions with multiple digits when reading the TargetRailsVersion from the bundler lock files. ([@roberts1000][])
* [#5700](https://github.com/rubocop-hq/rubocop/pull/5700): Fix a false positive for `Style/EmptyLineAfterGuardClause` when guard clause is before `else`. ([@koic][])
* Fix false positive in `Naming/ConstantName` when using conditional assignment. ([@drenmi][])

### Changes

* [#5626](https://github.com/rubocop-hq/rubocop/pull/5626): Change `Naming/UncommunicativeMethodParamName` add `to` to allowed names in default config. ([@unused][])
* [#5640](https://github.com/rubocop-hq/rubocop/issues/5640): Warn about user configuration overriding other user configuration only with `--debug`. ([@jonas054][])
* [#5637](https://github.com/rubocop-hq/rubocop/issues/5637): Fix error for `Layout/SpaceInsideArrayLiteralBrackets` when contains an array literal as an argument after a heredoc is started. ([@koic][])
* [#5610](https://github.com/rubocop-hq/rubocop/issues/5610): Use `gems.locked` or `Gemfile.lock` to determine the best `TargetRubyVersion` when it is not specified in the config. ([@roberts1000][])
* [#5390](https://github.com/rubocop-hq/rubocop/issues/5390): Allow exceptions to `Style/InlineComment` for inline comments which enable or disable rubocop cops. ([@jfelchner][])
* Add progress bar to offenses formatter. ([@drewpterry][])
* [#5498](https://github.com/rubocop-hq/rubocop/issues/5498): Correct `IndentHeredoc` message for Ruby 2.3 when using `<<~` operator with invalid indentation. ([@hamada14][])

## 0.53.0 (2018-03-05)

### New features

* [#3666](https://github.com/rubocop-hq/rubocop/issues/3666): Add new `Naming/UncommunicativeBlockParamName` cop. ([@garettarrowood][])
* [#3666](https://github.com/rubocop-hq/rubocop/issues/3666): Add new `Naming/UncommunicativeMethodParamName` cop. ([@garettarrowood][])
* [#5356](https://github.com/rubocop-hq/rubocop/issues/5356): Add new `Lint/UnneededCopEnableDirective` cop. ([@garettarrowood][])
* [#5248](https://github.com/rubocop-hq/rubocop/pull/5248): Add new `Lint/BigDecimalNew` cop. ([@koic][])
* Add new `Style/TrailingBodyOnClass` cop. ([@garettarrowood][])
* Add new `Style/TrailingBodyOnModule` cop. ([@garettarrowood][])
* [#3394](https://github.com/rubocop-hq/rubocop/issues/3394): Add new `Style/TrailingCommaInArrayLiteral` cop. ([@garettarrowood][])
* [#3394](https://github.com/rubocop-hq/rubocop/issues/3394): Add new `Style/TrailingCommaInHashLiteral` cop. ([@garettarrowood][])
* [#5319](https://github.com/rubocop-hq/rubocop/pull/5319): Add new `Security/Open` cop. ([@mame][])
* Add `EnforcedStyleForEmptyBrackets` configuration to `Layout/SpaceInsideReferenceBrackets`.([@garettarrowood][])
* [#5050](https://github.com/rubocop-hq/rubocop/issues/5050): Add auto-correction to `Style/ModuleFunction`. ([@garettarrowood][])
* [#5358](https://github.com/rubocop-hq/rubocop/pull/5358):  `--no-auto-gen-timestamp` CLI option suppresses the inclusion of the date and time it was generated in auto-generated config. ([@dominicsayers][])
* [#4274](https://github.com/rubocop-hq/rubocop/issues/4274): Add new `Layout/EmptyComment` cop. ([@koic][])
* [#4477](https://github.com/rubocop-hq/rubocop/issues/4477): Add new configuration directive: `inherit_mode` for merging arrays. ([@leklund][])
* [#5532](https://github.com/rubocop-hq/rubocop/pull/5532): Include `.axlsx` file by default. ([@georf][])
* [#5490](https://github.com/rubocop-hq/rubocop/issues/5490): Add new `Lint/OrderedMagicComments` cop. ([@koic][])
* [#4008](https://github.com/rubocop-hq/rubocop/issues/4008): Add new `Style/ExpandPathArguments` cop. ([@koic][])
* [#4812](https://github.com/rubocop-hq/rubocop/issues/4812): Add `beginning_only` and `ending_only` style options to `Layout/EmptyLinesAroundClassBody` cop. ([@jmks][])
* [#5591](https://github.com/rubocop-hq/rubocop/pull/5591): Include `.arb` file by default. ([@deivid-rodriguez][])
* [#5473](https://github.com/rubocop-hq/rubocop/issues/5473): Use `gems.locked` or `Gemfile.lock` to determine the best `TargetRailsVersion` when it is not specified in the config. ([@roberts1000][])
* Add new `Naming/MemoizedInstanceVariableName` cop. ([@satyap][])
* [#5376](https://github.com/rubocop-hq/rubocop/issues/5376): Add new `Style/EmptyLineAfterGuardClause` cop. ([@unkmas][])
* Add new `Rails/ActiveRecordAliases` cop. ([@elebow][])

### Bug fixes

* [#4105](https://github.com/rubocop-hq/rubocop/issues/4105): Fix `Lint/IndentationWidth` when `Lint/EndAlignment` is configured with `start_of_line`. ([@brandonweiss][])
* [#5453](https://github.com/rubocop-hq/rubocop/issues/5453): Fix erroneous downcase in `Performance/Casecmp` auto-correction. ([@walinga][])
* [#5343](https://github.com/rubocop-hq/rubocop/issues/5343): Fix offense detection in `Style/TrailingMethodEndStatement`. ([@garettarrowood][])
* [#5334](https://github.com/rubocop-hq/rubocop/issues/5334): Fix semicolon removal for `Style/TrailingBodyOnMethodDefinition` autocorrection. ([@garettarrowood][])
* [#5350](https://github.com/rubocop-hq/rubocop/issues/5350): Fix `Metric/LineLength` false offenses for URLs in double quotes. ([@garettarrowood][])
* [#5333](https://github.com/rubocop-hq/rubocop/issues/5333): Fix `Layout/EmptyLinesAroundArguments` false positives for inline access modifiers. ([@garettarrowood][])
* [#5339](https://github.com/rubocop-hq/rubocop/issues/5339): Fix `Layout/EmptyLinesAroundArguments` false positives for multiline heredoc arguments. ([@garettarrowood][])
* [#5383](https://github.com/rubocop-hq/rubocop/issues/5383): Fix `Rails/Presence` false detection of receiver for locally defined `blank?` & `present?` methods. ([@garettarrowood][])
* [#5314](https://github.com/rubocop-hq/rubocop/issues/5314): Fix false positives for `Lint/NestedPercentLiteral` when percent characters are nested. ([@asherkach][])
* [#5357](https://github.com/rubocop-hq/rubocop/issues/5357): Fix `Lint/InterpolationCheck` false positives on escaped interpolations. ([@pocke][])
* [#5409](https://github.com/rubocop-hq/rubocop/issues/5409): Fix multiline indent for `Style/SymbolArray` and `Style/WordArray` autocorrect. ([@flyerhzm][])
* [#5393](https://github.com/rubocop-hq/rubocop/issues/5393): Fix `Rails/Delegate`'s false positive with a method call with arguments. ([@pocke][])
* [#5348](https://github.com/rubocop-hq/rubocop/issues/5348): Fix false positive for `Style/SafeNavigation` when safe guarding more comparison methods. ([@rrosenblum][])
* [#4889](https://github.com/rubocop-hq/rubocop/issues/4889): Auto-correcting `Style/SafeNavigation` will add safe navigation to all methods in a method chain. ([@rrosenblum][])
* [#5287](https://github.com/rubocop-hq/rubocop/issues/5287): Do not register an offense in `Style/SafeNavigation` if there is an unsafe method used in a method chain. ([@rrosenblum][])
* [#5401](https://github.com/rubocop-hq/rubocop/issues/5401): Fix `Style/RedundantReturn` to trigger when begin-end, rescue, and ensure blocks present. ([@asherkach][])
* [#5426](https://github.com/rubocop-hq/rubocop/issues/5426): Make `Rails/InverseOf` accept `inverse_of: nil` to opt-out. ([@wata727][])
* [#5448](https://github.com/rubocop-hq/rubocop/issues/5448): Improve `Rails/LexicallyScopedActionFilter`. ([@wata727][])
* [#3947](https://github.com/rubocop-hq/rubocop/issues/3947): Fix false positive for `Rails/FilePath` when using `Rails.root.join` in string interpolation of argument. ([@koic][])
* [#5479](https://github.com/rubocop-hq/rubocop/issues/5479): Fix false positives for `Rails/Presence` when using with `elsif`. ([@wata727][])
* [#5427](https://github.com/rubocop-hq/rubocop/pull/5427): Fix exception when executing from a different drive on Windows. ([@orgads][])
* [#5429](https://github.com/rubocop-hq/rubocop/issues/5429): Detect tabs other than indentation by `Layout/Tab`. ([@pocke][])
* [#5496](https://github.com/rubocop-hq/rubocop/pull/5496): Fix a false positive of `Style/FormatStringToken` with unrelated `format` call. ([@pocke][])
* [#5503](https://github.com/rubocop-hq/rubocop/issues/5503): Fix `Rails/CreateTableWithTimestamps` false positive when using `to_proc` syntax. ([@wata727][])
* [#5512](https://github.com/rubocop-hq/rubocop/issues/5512): Improve `Lint/Void` to detect `Kernel#tap` as method that ignores the block's value. ([@untitaker][])
* [#5520](https://github.com/rubocop-hq/rubocop/issues/5520): Fix `Style/RedundantException` auto-correction does not keep parenthesization. ([@dpostorivo][])
* [#5524](https://github.com/rubocop-hq/rubocop/issues/5524): Return the instance based on the new type when calls `RuboCop::AST::Node#updated`. ([@wata727][])
* [#5527](https://github.com/rubocop-hq/rubocop/issues/5527): Avoid behavior-changing corrections in `Style/SafeNavigation`. ([@jonas054][])
* [#5539](https://github.com/rubocop-hq/rubocop/pull/5539): Fix compilation error and ruby code generation when passing args to funcall and predicates. ([@Edouard-chin][])
* [#4669](https://github.com/rubocop-hq/rubocop/issues/4669): Use binary file contents for cache key so changing EOL characters invalidates the cache. ([@jonas054][])
* [#3947](https://github.com/rubocop-hq/rubocop/issues/3947): Fix false positive for `Performance::RegexpMatch` when using `MatchData` before guard clause. ([@koic][])
* [#5515](https://github.com/rubocop-hq/rubocop/issues/5515): Fix `Style/EmptyElse` autocorrect for nested if and case statements. ([@asherkach][])
* [#5582](https://github.com/rubocop-hq/rubocop/issues/5582): Fix `end` alignment for variable assignment with line break after `=` in `Layout/EndAlignment`. ([@jonas054][])
* [#5602](https://github.com/rubocop-hq/rubocop/pull/5602): Fix false positive for `Style/ColonMethodCall` when using Java package namespace. ([@koic][])
* [#5603](https://github.com/rubocop-hq/rubocop/pull/5603): Fix falsy offense for `Style/RedundantSelf` with pseudo variables. ([@pocke][])
* [#5547](https://github.com/rubocop-hq/rubocop/issues/5547): Fix auto-correction of of `Layout/BlockEndNewline` when there is top level code outside of a class. ([@rrosenblum][])
* [#5599](https://github.com/rubocop-hq/rubocop/issues/5599): Fix the suggestion being used by `Lint/NumberConversion` to use base 10 with Integer. ([@rrosenblum][])
* [#5534](https://github.com/rubocop-hq/rubocop/issues/5534): Fix `Style/EachWithObject` auto-correction leaves an empty line. ([@flyerhzm][])
* Fix `Layout/EmptyLinesAroundAccessModifier` false-negative when next string after access modifier started with end. ([@unkmas][])

### Changes

* [#5589](https://github.com/rubocop-hq/rubocop/issues/5589): Remove `Performance/HashEachMethods` cop as it no longer provides a performance benefit. ([@urbanautomaton][])
* [#3394](https://github.com/rubocop-hq/rubocop/issues/3394): Remove `Style/TrailingCommmaInLiteral` in favor of two new cops. ([@garettarrowood][])
* Rename `Lint/UnneededDisable` to `Lint/UnneededCopDisableDirective`. ([@garettarrowood][])
* [#5365](https://github.com/rubocop-hq/rubocop/pull/5365): Add `*.gemfile` to Bundler cop target. ([@sue445][])
* [#4477](https://github.com/rubocop-hq/rubocop/issues/4477): Warn when user configuration overrides other user configuration. ([@jonas054][])
* [#5240](https://github.com/rubocop-hq/rubocop/pull/5240): Make `Style/StringHashKeys` to accepts environment variables. ([@pocke][])
* [#5395](https://github.com/rubocop-hq/rubocop/pull/5395): Always exit 2 when specified configuration file does not exist. ([@pocke][])
* [#5402](https://github.com/rubocop-hq/rubocop/pull/5402): Remove undefined `ActiveSupport::TimeZone#strftime` method from defined dangerous methods of `Rails/TimeZone` cop. ([@koic][])
* [#4704](https://github.com/rubocop-hq/rubocop/issues/4704): Move `Lint/EndAlignment`, `Lint/DefEndAlignment`, `Lint/BlockAlignment`, and `Lint/ConditionPosition` to the `Layout` namespace. ([@bquorning][])
* [#5283](https://github.com/rubocop-hq/rubocop/issues/5283): Change file path output by `Formatter::JSONFormatter` from relative path to smart path. ([@koic][])
* `Style/SafeNavigation` will now register an offense for methods that `nil` responds to. ([@rrosenblum][])
* [#5542](https://github.com/rubocop-hq/rubocop/pull/5542): Exclude `.git/` by default. ([@pocke][])
* Tell Read the Docs to build downloadable docs. ([@eostrom][])
* Change `Style/SafeNavigation` to no longer register an offense for method chains exceeding 2 methods. ([@rrosenblum][])
* Remove auto-correction from `Lint/SafeNavigationChain`. ([@rrosenblum][])
* Change the highlighting of `Lint/SafeNavigationChain` to highlight the entire method chain beyond the safe navigation portion. ([@rrosenblum][])

## 0.52.1 (2017-12-27)

### Bug fixes

* [#5241](https://github.com/rubocop-hq/rubocop/issues/5241): Fix an error for `Layout/AlignHash` when using a hash including only a keyword splat. ([@wata727][])
* [#5245](https://github.com/rubocop-hq/rubocop/issues/5245): Make `Style/FormatStringToken` to allow regexp token. ([@pocke][])
* [#5224](https://github.com/rubocop-hq/rubocop/pull/5224): Fix false positives for `Layout/EmptyLinesAroundArguments` operating on blocks. ([@garettarrowood][])
* [#5234](https://github.com/rubocop-hq/rubocop/issues/5234): Fix a false positive for `Rails/HasManyOrHasOneDependent` when using `class_name` option. ([@koic][])
* [#5273](https://github.com/rubocop-hq/rubocop/issues/5273): Fix `Style/EvalWithLocation` reporting bad line offset. ([@pocke][])
* [#5228](https://github.com/rubocop-hq/rubocop/issues/5228): Handle overridden `Metrics/LineLength:Max` for `--auto-gen-config`. ([@jonas054][])
* [#5226](https://github.com/rubocop-hq/rubocop/issues/5226): Suppress false positives for `Rails/RedundantReceiverInWithOptions` when including another receiver in `with_options`. ([@wata727][])
* [#5259](https://github.com/rubocop-hq/rubocop/pull/5259): Fix false positives in `Style/CommentedKeyword`. ([@garettarrowood][])
* [#5238](https://github.com/rubocop-hq/rubocop/pull/5238): Fix error when #present? or #blank? is used in if or unless modifier. ([@eitoball][])
* [#5261](https://github.com/rubocop-hq/rubocop/issues/5261): Fix a false positive for `Style/MixinUsage` when using inside class or module. ([@koic][])
* [#5289](https://github.com/rubocop-hq/rubocop/issues/5289): Fix `Layout/SpaceInsideReferenceBrackets` and `Layout/SpaceInsideArrayLiteralBrackets` configuration conflicts. ([@garettarrowood][])
* [#4444](https://github.com/rubocop-hq/rubocop/issues/4444): Fix `Style/AutoResourceCleanup` shouldn't flag `File.open(...).close`. ([@dpostorivo][])
* [#5278](https://github.com/rubocop-hq/rubocop/pull/5278): Fix deprecation check to use `loaded_path` in warning. ([@chrishulton][])
* [#5293](https://github.com/rubocop-hq/rubocop/issues/5293): Fix a regression for `Rails/HasManyOrHasOneDependent` when using a option of `has_many` or `has_one` association. ([@koic][])
* [#5223](https://github.com/rubocop-hq/rubocop/issues/5223): False offences in :unannotated Style/FormatStringToken. ([@nattfodd][])
* [#5258](https://github.com/rubocop-hq/rubocop/issues/5258): Fix incorrect autocorrection for `Rails/Presence` when the else block is multiline. ([@wata727][])
* [#5297](https://github.com/rubocop-hq/rubocop/pull/5297): Improve inspection for `Rails/InverseOf` when including `through` or `polymorphic` options. ([@wata727][])
* [#5281](https://github.com/rubocop-hq/rubocop/issues/5281): Fix issue where `--auto-gen-config` might fail on invalid YAML. ([@bquorning][])
* [#5313](https://github.com/rubocop-hq/rubocop/issues/5313): Fix `Style/HashSyntax` from stripping quotes off of symbols during autocorrection for ruby22+. ([@garettarrowood][])
* [#5315](https://github.com/rubocop-hq/rubocop/issues/5315): Fix a false positive of `Layout/RescueEnsureAlignment` in Ruby 2.5. ([@pocke][])
* [#5236](https://github.com/rubocop-hq/rubocop/issues/5236): Fix false positives for `Rails/InverseOf` when using `with_options`. ([@wata727][])
* [#5291](https://github.com/rubocop-hq/rubocop/issues/5291): Fix multiline indent for `Style/BracesAroundHashParameters` autocorrect. ([@flyerhzm][])
* [#3318](https://github.com/rubocop-hq/rubocop/issues/3318): Look for `.ruby-version` in parent directories. ([@ybiquitous][])

### Changes

* [#5300](https://github.com/rubocop-hq/rubocop/pull/5300): Display correction candidate if an incorrect cop name is given. ([@yhirano55][])
* [#5233](https://github.com/rubocop-hq/rubocop/pull/5233): Remove `Style/ExtendSelf` cop. ([@pocke][])
* [#5221](https://github.com/rubocop-hq/rubocop/issues/5221): Change `Layout/SpaceBeforeBlockBraces`'s `EnforcedStyleForEmptyBraces` from `no_space` to `space`. ([@garettarrowood][])
* [#3558](https://github.com/rubocop-hq/rubocop/pull/3558): Create `Corrector` classes and move all `autocorrect` methods out of mixin Modules. ([@garettarrowood][])
* [#3437](https://github.com/rubocop-hq/rubocop/issues/3437): Add new `Lint/NumberConversion` cop. ([@albertpaulp][])

## 0.52.0 (2017-12-12)

### New features

* [#5101](https://github.com/rubocop-hq/rubocop/pull/5101): Allow to specify `TargetRubyVersion` 2.5. ([@walf443][])
* [#1575](https://github.com/rubocop-hq/rubocop/issues/1575): Add new `Layout/ClassStructure` cop that checks whether definitions in a class are in the configured order. This cop is disabled by default. ([@jonatas][])
* New cop `Rails/InverseOf` checks for association arguments that require setting the `inverse_of` option manually. ([@bdewater][])
* [#4811](https://github.com/rubocop-hq/rubocop/issues/4811): Add new `Layout/SpaceInsideReferenceBrackets` cop. ([@garettarrowood][])
* [#4811](https://github.com/rubocop-hq/rubocop/issues/4811): Add new `Layout/SpaceInsideArrayLiteralBrackets` cop. ([@garettarrowood][])
* [#4252](https://github.com/rubocop-hq/rubocop/issues/4252): Add new `Style/TrailingBodyOnMethodDefinition` cop. ([@garettarrowood][])
* Add new `Style/TrailingMethodEndStatment` cop. ([@garettarrowood][])
* [#5074](https://github.com/rubocop-hq/rubocop/issues/5074): Add Layout/EmptyLinesAroundArguments cop. ([@garettarrowood][])
* [#4650](https://github.com/rubocop-hq/rubocop/issues/4650): Add new `Style/StringHashKeys` cop. ([@donjar][])
* [#1583](https://github.com/rubocop-hq/rubocop/issues/1583): Add a quiet formatter. ([@drenmi][])
* Add new `Style/RandomWithOffset` cop. ([@donjar][])
* [#4892](https://github.com/rubocop-hq/rubocop/issues/4892): Add new `Lint/ShadowedArgument` cop and remove argument shadowing detection from `Lint/UnusedBlockArgument` and `Lint/UnusedMethodArgument`. ([@akhramov][])
* [#4674](https://github.com/rubocop-hq/rubocop/issues/4674): Add a new `Lint/MissingCopEnableDirective` cop. ([@tdeo][])
* Add new `Rails/EnvironmentComparison` cop. ([@tdeo][])
* Add `AllowedChars` option to `Style/AsciiComments` cop. ([@hedgesky][])
* [#5031](https://github.com/rubocop-hq/rubocop/pull/5031): Add new `Style/EmptyBlockParameter` and `Style/EmptyLambdaParameter` cops. ([@pocke][])
* [#5057](https://github.com/rubocop-hq/rubocop/pull/5057): Add new `Gemspec/RequiredRubyVersion` cop. ([@koic][])
* [#5087](https://github.com/rubocop-hq/rubocop/pull/5087): Add new `Gemspec/RedundantAssignment` cop. ([@koic][])
* Add `unannotated` option to `Style/FormatStringToken` cop. ([@drenmi][])
* [#5077](https://github.com/rubocop-hq/rubocop/pull/5077): Add new `Rails/CreateTableWithTimestamps` cop. ([@wata727][])
* Add new `Style/ColonMethodDefinition` cop. ([@rrosenblum][])
* Add new `Style/ExtendSelf` cop. ([@drenmi][])
* [#5185](https://github.com/rubocop-hq/rubocop/pull/5185): Add new `Rails/RedundantReceiverInWithOptions` cop. ([@koic][])
* [#5177](https://github.com/rubocop-hq/rubocop/pull/5177): Add new `Rails/LexicallyScopedActionFilter` cop. ([@wata727][])
* [#5173](https://github.com/rubocop-hq/rubocop/pull/5173): Add new `Style/EvalWithLocation` cop. ([@pocke][])
* [#5208](https://github.com/rubocop-hq/rubocop/pull/5208): Add new `Rails/Presence` cop. ([@wata727][])
* Allow auto-correction of ClassAndModuleChildren. ([@siegfault][], [@melch][])

### Bug fixes

* [#5096](https://github.com/rubocop-hq/rubocop/issues/5096): Fix incorrect detection and autocorrection of multiple extend/include/prepend. ([@marcandre][])
* [#5219](https://github.com/rubocop-hq/rubocop/issues/5219): Fix incorrect empty line detection for block arguments in `Layout/EmptyLinesAroundArguments`. ([@garettarrowood][])
* [#4662](https://github.com/rubocop-hq/rubocop/issues/4662): Fix incorrect indent level detection when first line of heredoc is blank. ([@sambostock][])
* [#5016](https://github.com/rubocop-hq/rubocop/issues/5016): Fix a false positive for `Style/ConstantName` with constant names using non-ASCII capital letters with accents. ([@timrogers][])
* [#4866](https://github.com/rubocop-hq/rubocop/issues/4866): Prevent `Layout/BlockEndNewline` cop from introducing trailing whitespaces. ([@bgeuken][])
* [#3396](https://github.com/rubocop-hq/rubocop/issues/3396): Concise error when config. file not found. ([@jaredbeck][])
* [#4881](https://github.com/rubocop-hq/rubocop/issues/4881): Fix a false positive for `Performance/HashEachMethods` when unused argument(s) exists in other blocks. ([@pocke][])
* [#4883](https://github.com/rubocop-hq/rubocop/pull/4883): Fix auto-correction for `Performance/HashEachMethods`. ([@pocke][])
* [#4896](https://github.com/rubocop-hq/rubocop/pull/4896): Fix Style/DateTime wrongly triggered on classes `...::DateTime`. ([@dpostorivo][])
* [#4938](https://github.com/rubocop-hq/rubocop/pull/4938): Fix behavior of `Lint/UnneededDisable`, which was returning offenses even after being disabled in a comment. ([@tdeo][])
* [#4887](https://github.com/rubocop-hq/rubocop/pull/4887): Add undeclared configuration option `EnforcedStyleForEmptyBraces` for `Layout/SpaceBeforeBlockBraces` cop. ([@drenmi][])
* [#4987](https://github.com/rubocop-hq/rubocop/pull/4987): Skip permission check when using stdin option. ([@mtsmfm][])
* [#4909](https://github.com/rubocop-hq/rubocop/issues/4909): Make `Rails/HasManyOrHasOneDependent` aware of multiple associations in `with_options`. ([@koic][])
* [#4794](https://github.com/rubocop-hq/rubocop/issues/4794): Fix an error in `Layout/MultilineOperationIndentation` when an operation spans multiple lines and contains a ternary expression. ([@rrosenblum][])
* [#4885](https://github.com/rubocop-hq/rubocop/issues/4885): Fix false offense detected by `Style/MixinUsage` cop. ([@koic][])
* [#3363](https://github.com/rubocop-hq/rubocop/pull/3363): Fix `Style/EmptyElse` autocorrection removes comments from branches. ([@dpostorivo][])
* [#5025](https://github.com/rubocop-hq/rubocop/issues/5025): Fix error with Layout/MultilineMethodCallIndentation cop and lambda.(...). ([@dpostorivo][])
* [#4781](https://github.com/rubocop-hq/rubocop/issues/4781): Prevent `Style/UnneededPercentQ` from breaking on strings that are concated with backslash. ([@pocke][])
* [#4363](https://github.com/rubocop-hq/rubocop/issues/4363): Fix `Style/PercentLiteralDelimiters` incorrectly automatically modifies escaped percent literal delimiter. ([@koic][])
* [#5053](https://github.com/rubocop-hq/rubocop/issues/5053): Fix `Naming/ConstantName` false offense on assigning to a nonoffensive assignment. ([@garettarrowood][])
* [#5019](https://github.com/rubocop-hq/rubocop/pull/5019): Fix auto-correct for `Style/HashSyntax` cop when hash is used as unspaced argument. ([@drenmi][])
* [#5052](https://github.com/rubocop-hq/rubocop/pull/5052): Improve accuracy of `Style/BracesAroundHashParameters` auto-correction. ([@garettarrowood][])
* [#5059](https://github.com/rubocop-hq/rubocop/issues/5059): Fix a false positive for `Style/MixinUsage` when `include` call is a method argument. ([@koic][])
* [#5071](https://github.com/rubocop-hq/rubocop/pull/5071): Fix a false positive in `Lint/UnneededSplatExpansion`, when `Array.new` resides in an array literal. ([@akhramov][])
* [#4071](https://github.com/rubocop-hq/rubocop/issues/4071): Prevent generating wrong code by Style/ColonMethodCall and Style/RedundantSelf. ([@pocke][])
* [#5089](https://github.com/rubocop-hq/rubocop/issues/5089): Fix false positive for `Style/SafeNavigation` when safe guarding arithmetic operation or assignment. ([@tiagotex][])
* [#5099](https://github.com/rubocop-hq/rubocop/pull/5099): Prevent `Style/MinMax` from breaking on implicit receivers. ([@drenmi][])
* [#5079](https://github.com/rubocop-hq/rubocop/issues/5079): Fix false positive for `Style/SafeNavigation` when safe guarding comparisons. ([@tiagotex][])
* [#5075](https://github.com/rubocop-hq/rubocop/issues/5075): Fix auto-correct for `Style/RedundantParentheses` cop when unspaced ternary is present. ([@tiagotex][])
* [#5155](https://github.com/rubocop-hq/rubocop/issues/5155): Fix a false negative for `Naming/ConstantName` cop when using frozen object assignment. ([@koic][])
* Fix a false positive in `Style/SafeNavigation` when the right hand side is negated. ([@rrosenblum][])
* [#5128](https://github.com/rubocop-hq/rubocop/issues/5128): Fix `Bundler/OrderedGems` when gems are references from variables (ignores them in the sorting). ([@tdeo][])

### Changes

* [#4848](https://github.com/rubocop-hq/rubocop/pull/4848): Exclude lambdas and procs from `Metrics/ParameterLists`. ([@reitermarkus][])
* [#5120](https://github.com/rubocop-hq/rubocop/pull/5120):  Improve speed of RuboCop::PathUtil#smart_path. ([@walf443][])
* [#4888](https://github.com/rubocop-hq/rubocop/pull/4888): Improve offense message of `Style/StderrPuts`. ([@jaredbeck][])
* [#4886](https://github.com/rubocop-hq/rubocop/issues/4886): Fix false offense for Style/CommentedKeyword. ([@michniewicz][])
* [#4977](https://github.com/rubocop-hq/rubocop/pull/4977): Make `Lint/RedundantWithIndex` cop aware of offset argument. ([@koic][])
* [#2679](https://github.com/rubocop-hq/rubocop/issues/2679): Handle dependencies to `Metrics/LineLength: Max` when generating `.rubocop_todo.yml`. ([@jonas054][])
* [#4943](https://github.com/rubocop-hq/rubocop/pull/4943): Make cop generator compliant with the repo's rubocop config. ([@tdeo][])
* [#5011](https://github.com/rubocop-hq/rubocop/pull/5011): Remove `SupportedStyles` from "Configuration parameters" in `.rubocop_todo.yml`. ([@pocke][])
* `Lint/RescueWithoutErrorClass` has been replaced by `Style/RescueStandardError`. ([@rrosenblum][])
* [#4811](https://github.com/rubocop-hq/rubocop/issues/4811): Remove `Layout/SpaceInsideBrackets` in favor of two new configurable cops. ([@garettarrowood][])
* [#5042](https://github.com/rubocop-hq/rubocop/pull/5042): Make offense locations of metrics cops to contain whole a method. ([@pocke][])
* [#5044](https://github.com/rubocop-hq/rubocop/pull/5044): Add last_line and last_column into outputs of the JSON formatter. ([@pocke][])
* [#4633](https://github.com/rubocop-hq/rubocop/issues/4633): Make metrics cops aware of `define_method`. ([@pocke][])
* [#5037](https://github.com/rubocop-hq/rubocop/pull/5037): Make display cop names to enable by default. ([@pocke][])
* [#4449](https://github.com/rubocop-hq/rubocop/issues/4449): Make `Layout/IndentHeredoc` aware of line length. ([@pocke][])
* [#5146](https://github.com/rubocop-hq/rubocop/pull/5146): Make `--show-cops` option aware of `--force-default-config`. ([@pocke][])
* [#3001](https://github.com/rubocop-hq/rubocop/issues/3001): Add configuration to `Lint/MissingCopEnableDirective` cop. ([@tdeo][])
* [#4932](https://github.com/rubocop-hq/rubocop/issues/4932): Do not fail if configuration contains `Lint/Syntax` cop with the same settings as the default. ([@tdeo][])
* [#5175](https://github.com/rubocop-hq/rubocop/pull/5175): Make Style/RedundantBegin aware of do-end block in Ruby 2.5. ([@pocke][])

## 0.51.0 (2017-10-18)

### New features

* [#4791](https://github.com/rubocop-hq/rubocop/pull/4791): Add new `Rails/UnknownEnv` cop. ([@pocke][])
* [#4690](https://github.com/rubocop-hq/rubocop/issues/4690): Add new `Lint/UnneededRequireStatement` cop. ([@koic][])
* [#4813](https://github.com/rubocop-hq/rubocop/pull/4813): Add new `Style/StderrPuts` cop. ([@koic][])
* [#4796](https://github.com/rubocop-hq/rubocop/pull/4796): Add new `Lint/RedundantWithObject` cop. ([@koic][])
* [#4663](https://github.com/rubocop-hq/rubocop/issues/4663): Add new `Style/CommentedKeyword` cop. ([@donjar][])
* Add `IndentationWidth` configuration for `Layout/Tab` cop. ([@rrosenblum][])
* [#4854](https://github.com/rubocop-hq/rubocop/pull/4854): Add new `Lint/RegexpAsCondition` cop. ([@pocke][])
* [#4862](https://github.com/rubocop-hq/rubocop/pull/4862): Add `MethodDefinitionMacros` option to `Naming/PredicateName` cop. ([@koic][])
* [#4874](https://github.com/rubocop-hq/rubocop/pull/4874): Add new `Gemspec/OrderedDependencies` cop. ([@sue445][])
* [#4840](https://github.com/rubocop-hq/rubocop/pull/4840): Add new `Style/MixinUsage` cop. ([@koic][])
* [#1952](https://github.com/rubocop-hq/rubocop/issues/1952): Add new `Style/DateTime` cop. ([@dpostorivo][])
* [#4727](https://github.com/rubocop-hq/rubocop/issues/4727): Make `Lint/Void` check for nonmutating methods as well. ([@donjar][])

### Bug fixes

* [#3312](https://github.com/rubocop-hq/rubocop/issues/3312): Make `Rails/Date` Correct false positive on `#to_time` for strings ending in UTC-"Z".([@erikdstock][])
* [#4741](https://github.com/rubocop-hq/rubocop/issues/4741): Make `Style/SafeNavigation` correctly exclude methods called without dot. ([@drenmi][])
* [#4740](https://github.com/rubocop-hq/rubocop/issues/4740): Make `Lint/RescueWithoutErrorClass` aware of modifier form `rescue`. ([@drenmi][])
* [#4745](https://github.com/rubocop-hq/rubocop/issues/4745): Make `Style/SafeNavigation` ignore negated continuations. ([@drenmi][])
* [#4732](https://github.com/rubocop-hq/rubocop/issues/4732): Prevent `Performance/HashEachMethods` from registering an offense when `#each` follows `#to_a`. ([@drenmi][])
* [#4730](https://github.com/rubocop-hq/rubocop/issues/4730): False positive on Lint/InterpolationCheck. ([@koic][])
* [#4751](https://github.com/rubocop-hq/rubocop/issues/4751): Prevent `Rails/HasManyOrHasOneDependent` cop from registering offense if `:through` option was specified. ([@smakagon][])
* [#4737](https://github.com/rubocop-hq/rubocop/issues/4737): Fix ReturnInVoidContext cop when `return` is in top scope. ([@frodsan][])
* [#4776](https://github.com/rubocop-hq/rubocop/issues/4776): Non utf-8 magic encoding comments are now respected. ([@deivid-rodriguez][])
* [#4241](https://github.com/rubocop-hq/rubocop/issues/4241): Prevent `Rails/Blank` and `Rails/Present` from breaking when there is no explicit receiver. ([@rrosenblum][])
* [#4814](https://github.com/rubocop-hq/rubocop/issues/4814): Prevent `Rails/Blank` from breaking on send with an argument. ([@pocke][])
* [#4759](https://github.com/rubocop-hq/rubocop/issues/4759): Make `Naming/HeredocDelimiterNaming` and `Naming/HeredocDelimiterCase` aware of more delimiter patterns. ([@drenmi][])
* [#4823](https://github.com/rubocop-hq/rubocop/issues/4823): Make `Lint/UnusedMethodArgument` and `Lint/UnusedBlockArgument` aware of overriding assignments. ([@akhramov][])
* [#4830](https://github.com/rubocop-hq/rubocop/issues/4830): Prevent `Lint/BooleanSymbol` from truncating symbol's value in the message when offense is located in the new syntax hash. ([@akhramov][])
* [#4747](https://github.com/rubocop-hq/rubocop/issues/4747): Fix `Rails/HasManyOrHasOneDependent` cop incorrectly flags `with_options` blocks. ([@koic][])
* [#4836](https://github.com/rubocop-hq/rubocop/issues/4836): Make `Rails/OutputSafety` aware of safe navigation operator. ([@drenmi][])
* [#4843](https://github.com/rubocop-hq/rubocop/issues/4843): Make `Lint/ShadowedException` cop aware of same system error code. ([@koic][])
* [#4757](https://github.com/rubocop-hq/rubocop/issues/4757): Make `Style/TrailingUnderscoreVariable` work for nested assignments. ([@donjar][])
* [#4597](https://github.com/rubocop-hq/rubocop/pull/4597): Fix `Style/StringLiterals` cop not registering an offense on single quoted strings containing an escaped single quote when configured to use double quotes. ([@promisedlandt][])
* [#4850](https://github.com/rubocop-hq/rubocop/issues/4850): `Lint/UnusedMethodArgument` respects `IgnoreEmptyMethods` setting by ignoring unused method arguments for singleton methods. ([@jmks][])
* [#2040](https://github.com/rubocop-hq/rubocop/issues/2040): Document how to write a custom cop. ([@jonatas][])

### Changes

* [#4746](https://github.com/rubocop-hq/rubocop/pull/4746): The `Lint/InvalidCharacterLiteral` cop has been removed since it was never being actually triggered. ([@deivid-rodriguez][])
* [#4789](https://github.com/rubocop-hq/rubocop/pull/4789): Analyzing code that needs to support MRI 1.9 is no longer supported. ([@deivid-rodriguez][])
* [#4582](https://github.com/rubocop-hq/rubocop/issues/4582): `Severity` and other common parameters can be configured on department level. ([@jonas054][])
* [#4787](https://github.com/rubocop-hq/rubocop/pull/4787): Analyzing code that needs to support MRI 2.0 is no longer supported. ([@deivid-rodriguez][])
* [#4787](https://github.com/rubocop-hq/rubocop/pull/4787): RuboCop no longer installs on MRI 2.0. ([@deivid-rodriguez][])
* [#4266](https://github.com/rubocop-hq/rubocop/issues/4266): Download the inherited config files of a remote file from the same remote. ([@tdeo][])
* [#4853](https://github.com/rubocop-hq/rubocop/pull/4853): Make `Lint/LiteralInCondition` cop aware of `!` and `not`. ([@pocke][])
* [#4864](https://github.com/rubocop-hq/rubocop/pull/4864): Rename `Lint/LiteralInCondition` to `Lint/LiteralAsCondition`. ([@pocke][])

## 0.50.0 (2017-09-14)

### New features

* [#4464](https://github.com/rubocop-hq/rubocop/pull/4464): Add `EnforcedStyleForEmptyBraces` parameter to `Layout/SpaceBeforeBlockBraces` cop. ([@palkan][])
* [#4453](https://github.com/rubocop-hq/rubocop/pull/4453): New cop `Style/RedundantConditional` checks for conditionals that return true/false. ([@petehamilton][])
* [#4448](https://github.com/rubocop-hq/rubocop/pull/4448): Add new `TapFormatter`. ([@cyberdelia][])
* [#4467](https://github.com/rubocop-hq/rubocop/pull/4467): Add new `Style/HeredocDelimiters` cop(Note: This cop was renamed to `Naming/HeredocDelimiterNaming`). ([@drenmi][])
* [#4153](https://github.com/rubocop-hq/rubocop/issues/4153): New cop `Lint/ReturnInVoidContext` checks for the use of a return with a value in a context where it will be ignored. ([@harold-s][])
* [#4506](https://github.com/rubocop-hq/rubocop/pull/4506): Add auto-correct support to `Lint/ScriptPermission`. ([@rrosenblum][])
* [#4514](https://github.com/rubocop-hq/rubocop/pull/4514): Add configuration options to `Style/YodaCondition` to support checking all comparison operators or equality operators only. ([@smakagon][])
* [#4515](https://github.com/rubocop-hq/rubocop/pull/4515): Add new `Lint/BooleanSymbol` cop. ([@droptheplot][])
* [#4535](https://github.com/rubocop-hq/rubocop/pull/4535): Make `Rails/PluralizationGrammar` use singular methods for `-1` / `-1.0`. ([@promisedlandt][])
* [#4541](https://github.com/rubocop-hq/rubocop/pull/4541): Add new `Rails/HasManyOrHasOneDependent` cop. ([@oboxodo][])
* [#4552](https://github.com/rubocop-hq/rubocop/pull/4552): Add new `Style/Dir` cop. ([@drenmi][])
* [#4548](https://github.com/rubocop-hq/rubocop/pull/4548): Add new `Style/HeredocDelimiterCase` cop(Note: This cop is renamed to `Naming/HeredocDelimiterCase`). ([@drenmi][])
* [#2943](https://github.com/rubocop-hq/rubocop/pull/2943): Add new `Lint/RescueWithoutErrorClass` cop. ([@drenmi][])
* [#4568](https://github.com/rubocop-hq/rubocop/pull/4568): Fix autocorrection for `Style/TrailingUnderscoreVariable`. ([@smakagon][])
* [#4586](https://github.com/rubocop-hq/rubocop/pull/4586): Add new `Performance/UnfreezeString` cop. ([@pocke][])
* [#2976](https://github.com/rubocop-hq/rubocop/issues/2976): Add `Whitelist` configuration option to `Style/NestedParenthesizedCalls` cop. ([@drenmi][])
* [#3965](https://github.com/rubocop-hq/rubocop/issues/3965): Add new `Style/OrAssignment` cop. ([@donjar][])
* [#4655](https://github.com/rubocop-hq/rubocop/pull/4655): Make `rake new_cop` create parent directories if they do not already exist. ([@highb][])
* [#4368](https://github.com/rubocop-hq/rubocop/issues/4368): Make `Performance/HashEachMethod` inspect send nodes with any receiver. ([@gohdaniel15][])
* [#4508](https://github.com/rubocop-hq/rubocop/issues/4508): Add new `Style/ReturnNil` cop. ([@donjar][])
* [#4629](https://github.com/rubocop-hq/rubocop/issues/4629): Add Metrics/MethodLength cop for `define_method`. ([@jekuta][])
* [#4702](https://github.com/rubocop-hq/rubocop/pull/4702): Add new `Lint/UriEscapeUnescape` cop. ([@koic][])
* [#4696](https://github.com/rubocop-hq/rubocop/pull/4696): Add new `Performance/UriDefaultParser` cop. ([@koic][])
* [#4694](https://github.com/rubocop-hq/rubocop/pull/4694): Add new `Lint/UriRegexp` cop. ([@koic][])
* [#4711](https://github.com/rubocop-hq/rubocop/pull/4711): Add new `Style/MinMax` cop. ([@drenmi][])
* [#4720](https://github.com/rubocop-hq/rubocop/pull/4720): Add new `Bundler/InsecureProtocolSource` cop. ([@koic][])
* [#4708](https://github.com/rubocop-hq/rubocop/pull/4708): Add new `Lint/RedundantWithIndex` cop. ([@koic][])
* [#4480](https://github.com/rubocop-hq/rubocop/pull/4480): Add new `Lint/InterpolationCheck` cop. ([@GauthamGoli][])
* [#4628](https://github.com/rubocop-hq/rubocop/issues/4628): Add new `Lint/NestedPercentLiteral` cop. ([@asherkach][])

### Bug fixes

* [#4709](https://github.com/rubocop-hq/rubocop/pull/4709): Use cached remote config on network failure. ([@kristjan][])
* [#4688](https://github.com/rubocop-hq/rubocop/pull/4688): Accept yoda condition which isn't commutative. ([@fujimura][])
* [#4676](https://github.com/rubocop-hq/rubocop/issues/4676): Make `Style/RedundantConditional` cop work with elsif. ([@akhramov][])
* [#4656](https://github.com/rubocop-hq/rubocop/issues/4656): Modify `Style/ConditionalAssignment` autocorrection to work with unbracketed arrays. ([@akhramov][])
* [#4615](https://github.com/rubocop-hq/rubocop/pull/4615): Don't consider `<=>` a comparison method. ([@iGEL][])
* [#4664](https://github.com/rubocop-hq/rubocop/pull/4664): Fix typos in Rails/HttpPositionalArguments. ([@JoeCohen][])
* [#4618](https://github.com/rubocop-hq/rubocop/pull/4618): Fix `Lint/FormatParameterMismatch` false positive if format string includes `%%5B` (CGI encoded left bracket). ([@barthez][])
* [#4604](https://github.com/rubocop-hq/rubocop/pull/4604): Fix `Style/LambdaCall` to autocorrect `obj.call` to `obj.`. ([@iGEL][])
* [#4443](https://github.com/rubocop-hq/rubocop/pull/4443): Prevent `Style/YodaCondition` from breaking `not LITERAL`. ([@pocke][])
* [#4434](https://github.com/rubocop-hq/rubocop/issues/4434): Prevent bad auto-correct in `Style/Alias` for non-literal arguments. ([@drenmi][])
* [#4451](https://github.com/rubocop-hq/rubocop/issues/4451): Make `Style/AndOr` cop aware of comparison methods. ([@drenmi][])
* [#4457](https://github.com/rubocop-hq/rubocop/pull/4457): Fix false negative in `Lint/Void` with initialize and setter methods. ([@pocke][])
* [#4418](https://github.com/rubocop-hq/rubocop/issues/4418): Register an offense in `Style/ConditionalAssignment` when the assignment line is the longest line, and it does not exceed the max line length. ([@rrosenblum][])
* [#4491](https://github.com/rubocop-hq/rubocop/issues/4491): Prevent bad auto-correct in `Style/EmptyElse` for nested `if`. ([@pocke][])
* [#4485](https://github.com/rubocop-hq/rubocop/pull/4485): Handle 304 status for remote config files. ([@daniloisr][])
* [#4529](https://github.com/rubocop-hq/rubocop/pull/4529): Make `Lint/UnreachableCode` aware of `if` and `case`. ([@pocke][])
* [#4469](https://github.com/rubocop-hq/rubocop/issues/4469): Include permissions in file cache. ([@pocke][])
* [#4270](https://github.com/rubocop-hq/rubocop/issues/4270): Fix false positive in `Performance/RegexpMatch` for named captures. ([@pocke][])
* [#4525](https://github.com/rubocop-hq/rubocop/pull/4525): Fix regexp for checking comment config of `rubocop:disable all` in `Lint/UnneededDisable`. ([@meganemura][])
* [#4555](https://github.com/rubocop-hq/rubocop/issues/4555): Make `Style/VariableName` aware of optarg, kwarg and other arguments. ([@pocke][])
* [#4481](https://github.com/rubocop-hq/rubocop/issues/4481): Prevent `Style/WordArray` and `Style/SymbolArray` from registering offenses where percent arrays don't work. ([@drenmi][])
* [#4447](https://github.com/rubocop-hq/rubocop/issues/4447): Prevent `Layout/EmptyLineBetweenDefs` from removing too many lines. ([@drenmi][])
* [#3892](https://github.com/rubocop-hq/rubocop/issues/3892): Make `Style/NumericPredicate` ignore numeric comparison of global variables. ([@drenmi][])
* [#4101](https://github.com/rubocop-hq/rubocop/issues/4101): Skip auto-correct for literals with trailing comment and chained method call in `Layout/Multiline*BraceLayout`. ([@jonas054][])
* [#4518](https://github.com/rubocop-hq/rubocop/issues/4518): Fix bug where `Style/SafeNavigation` does not register an offense when there are chained method calls. ([@rrosenblum][])
* [#3040](https://github.com/rubocop-hq/rubocop/issues/3040): Ignore safe navigation in `Rails/Delegate`. ([@cgriego][])
* [#4587](https://github.com/rubocop-hq/rubocop/pull/4587): Fix false negative for void unary operators in `Lint/Void` cop. ([@pocke][])
* [#4589](https://github.com/rubocop-hq/rubocop/issues/4589): Fix false positive in `Performance/RegexpMatch` cop for `=~` is in a class method. ([@pocke][])
* [#4578](https://github.com/rubocop-hq/rubocop/issues/4578): Fix false positive in `Lint/FormatParameterMismatch` for format with "asterisk" (`*`) width and precision. ([@smakagon][])
* [#4285](https://github.com/rubocop-hq/rubocop/issues/4285): Make `Lint/DefEndAlignment` aware of multiple modifiers. ([@drenmi][])
* [#4634](https://github.com/rubocop-hq/rubocop/issues/4634): Handle heredoc that contains empty lines only in `Layout/IndentHeredoc` cop. ([@pocke][])
* [#4646](https://github.com/rubocop-hq/rubocop/issues/4646): Make `Lint/Debugger` aware of `Kernel` and cbase. ([@pocke][])
* [#4643](https://github.com/rubocop-hq/rubocop/issues/4643): Modify `Style/InverseMethods` to not register a separate offense for an inverse method nested inside of the block of an inverse method offense. ([@rrosenblum][])
* [#4593](https://github.com/rubocop-hq/rubocop/issues/4593): Fix false positive in `Rails/SaveBang` when `save/update_attribute` is used with a `case` statement. ([@theRealNG][])
* [#4322](https://github.com/rubocop-hq/rubocop/issues/4322): Fix Style/MultilineMemoization from autocorrecting to invalid ruby. ([@dpostorivo][])
* [#4722](https://github.com/rubocop-hq/rubocop/pull/4722): Fix `rake new_cop` problem that doesn't add `require` line. ([@koic][])
* [#4723](https://github.com/rubocop-hq/rubocop/issues/4723): Fix `RaiseArgs` auto-correction issue for `raise` with 3 arguments. ([@smakagon][])

### Changes

* [#4470](https://github.com/rubocop-hq/rubocop/issues/4470): Improve the error message for `Lint/AssignmentInCondition`. ([@brandonweiss][])
* [#4553](https://github.com/rubocop-hq/rubocop/issues/4553): Add `node_modules` to default excludes. ([@iainbeeston][])
* [#4445](https://github.com/rubocop-hq/rubocop/pull/4445): Make `Style/Encoding` cop enabled by default. ([@deivid-rodriguez][])
* [#4452](https://github.com/rubocop-hq/rubocop/pull/4452): Add option to `Rails/Delegate` for enforcing the prefixed method name case. ([@klesse413][])
* [#4493](https://github.com/rubocop-hq/rubocop/pull/4493): Make `Lint/Void` cop aware of `Enumerable#each` and `for`. ([@pocke][])
* [#4492](https://github.com/rubocop-hq/rubocop/pull/4492): Make `Lint/DuplicateMethods` aware of `alias` and `alias_method`. ([@pocke][])
* [#4478](https://github.com/rubocop-hq/rubocop/issues/4478): Fix confusing message of `Performance/Caller` cop. ([@pocke][])
* [#4543](https://github.com/rubocop-hq/rubocop/pull/4543): Make `Lint/DuplicateMethods` aware of `attr_*` methods. ([@pocke][])
* [#4550](https://github.com/rubocop-hq/rubocop/pull/4550): Mark `RuboCop::CLI#run` as a public API. ([@yujinakayama][])
* [#4551](https://github.com/rubocop-hq/rubocop/pull/4551): Make `Performance/Caller` aware of `caller_locations`. ([@pocke][])
* [#4547](https://github.com/rubocop-hq/rubocop/pull/4547): Rename `Style/HeredocDelimiters` to `Style/HeredocDelimiterNaming`. ([@drenmi][])
* [#4157](https://github.com/rubocop-hq/rubocop/issues/4157): Enhance offense message for `Style/RedudantReturn` cop. ([@gohdaniel15][])
* [#4521](https://github.com/rubocop-hq/rubocop/issues/4521): Move naming related cops into their own `Naming` department. ([@drenmi][])
* [#4600](https://github.com/rubocop-hq/rubocop/pull/4600): Make `Style/RedundantSelf` aware of arguments of a block. ([@Envek][])
* [#4658](https://github.com/rubocop-hq/rubocop/issues/4658): Disable auto-correction for `Performance/TimesMap` by default. ([@Envek][])

## 0.49.1 (2017-05-29)

### Bug fixes

* [#4411](https://github.com/rubocop-hq/rubocop/issues/4411): Handle properly safe navigation in `Style/YodaCondition`. ([@bbatsov][])
* [#4412](https://github.com/rubocop-hq/rubocop/issues/4412): Handle properly literal comparisons in `Style/YodaCondition`. ([@bbatsov][])
* Handle properly class variables and global variables in `Style/YodaCondition`. ([@bbatsov][])
* [#4392](https://github.com/rubocop-hq/rubocop/issues/4392): Fix the auto-correct of `Style/Next` when the `end` is misaligned. ([@rrosenblum][])
* [#4407](https://github.com/rubocop-hq/rubocop/issues/4407): Prevent `Performance/RegexpMatch` from blowing up on `match` without arguments. ([@pocke][])
* [#4414](https://github.com/rubocop-hq/rubocop/issues/4414): Handle pseudo-assignments in `for` loops in `Style/ConditionalAssignment`. ([@bbatsov][])
* [#4419](https://github.com/rubocop-hq/rubocop/issues/4419): Handle combination `AllCops: DisabledByDefault: true` and `Rails: Enabled: true`. ([@jonas054][])
* [#4422](https://github.com/rubocop-hq/rubocop/issues/4422): Fix missing space in message for `Style/MultipleComparison`. ([@timrogers][])
* [#4420](https://github.com/rubocop-hq/rubocop/issues/4420): Ensure `Style/EmptyMethod` honours indentation when auto-correcting. ([@drenmi][])
* [#4442](https://github.com/rubocop-hq/rubocop/pull/4442): Prevent `Style/WordArray` from breaking on strings that aren't valid UTF-8. ([@pocke][])
* [#4441](https://github.com/rubocop-hq/rubocop/pull/4441): Prevent `Layout/SpaceAroundBlockParameters` from breaking on lambda. ([@pocke][])

### Changes

* [#4436](https://github.com/rubocop-hq/rubocop/pull/4436): Display 'Running parallel inspection' only with --debug. ([@pocke][])

## 0.49.0 (2017-05-24)

### New features

* [#117](https://github.com/rubocop-hq/rubocop/issues/117): Add `--parallel` option for running RuboCop in multiple processes or threads. ([@jonas054][])
* Add auto-correct support to `Style/MixinGrouping`. ([@rrosenblum][])
* [#4236](https://github.com/rubocop-hq/rubocop/issues/4236): Add new `Rails/ApplicationJob` and `Rails/ApplicationRecord` cops. ([@tjwp][])
* [#4078](https://github.com/rubocop-hq/rubocop/pull/4078): Add new `Performance/Caller` cop. ([@alpaca-tc][])
* [#4314](https://github.com/rubocop-hq/rubocop/pull/4314): Check slow hash accessing in `Array#sort` by `Performance/CompareWithBlock`. ([@pocke][])
* [#3438](https://github.com/rubocop-hq/rubocop/issues/3438): Add new `Style/FormatStringToken` cop. ([@backus][])
* [#4342](https://github.com/rubocop-hq/rubocop/pull/4342): Add new `Lint/ScriptPermission` cop. ([@yhirano55][])
* [#4145](https://github.com/rubocop-hq/rubocop/issues/4145): Add new `Style/YodaCondition` cop. ([@smakagon][])
* [#4403](https://github.com/rubocop-hq/rubocop/pull/4403): Add public API `Cop.autocorrect_incompatible_with` for specifying other cops that should not autocorrect together. ([@backus][])
* [#4354](https://github.com/rubocop-hq/rubocop/pull/4354): Add autocorrect to `Style/FormatString`. ([@hoshinotsuyoshi][])
* [#4021](https://github.com/rubocop-hq/rubocop/pull/4021): Add new `Style/MultipleComparison` cop. ([@dabroz][])
* New `Lint/RescueType` cop. ([@rrosenblum][])
* [#4328](https://github.com/rubocop-hq/rubocop/issues/4328): Add `--ignore-parent-exclusion` flag to ignore AllCops/Exclude inheritance. ([@nelsonjr][])

### Changes

* [#4262](https://github.com/rubocop-hq/rubocop/pull/4262): Add new `MinSize` configuration to `Style/SymbolArray`, consistent with the same configuration in `Style/WordArray`. ([@scottmatthewman][])
* [#3400](https://github.com/rubocop-hq/rubocop/issues/3400): Remove auto-correct support from Lint/Debugger. ([@ilansh][])
* [#4278](https://github.com/rubocop-hq/rubocop/pull/4278): Move all cops dealing with whitespace into a new department called `Layout`. ([@jonas054][])
* [#4320](https://github.com/rubocop-hq/rubocop/pull/4320): Update `Rails/OutputSafety` to disallow wrapping `raw` or `html_safe` with `safe_join`. ([@klesse413][])
* [#4336](https://github.com/rubocop-hq/rubocop/issues/4336): Store `rubocop_cache` in safer directories. ([@jonas054][])
* [#4361](https://github.com/rubocop-hq/rubocop/pull/4361): Use relative path for offense message in `Lint/DuplicateMethods`. ([@pocke][])
* [#4385](https://github.com/rubocop-hq/rubocop/pull/4385): Include `.jb` file by default. ([@pocke][])

### Bug fixes

* [#4265](https://github.com/rubocop-hq/rubocop/pull/4265): Require a space before first argument of a method call in `Style/SpaceBeforeFirstArg` cop. ([@cjlarose][])
* [#4237](https://github.com/rubocop-hq/rubocop/pull/4237): Fix false positive in `Lint/AmbiguousBlockAssociation` cop for lambdas. ([@smakagon][])
* [#4242](https://github.com/rubocop-hq/rubocop/issues/4242): Add `Capfile` to the list of known Ruby filenames. ([@bbatsov][])
* [#4240](https://github.com/rubocop-hq/rubocop/issues/4240): Handle `||=` in `Rails/RelativeDateConstant`. ([@bbatsov][])
* [#4241](https://github.com/rubocop-hq/rubocop/issues/4241): Prevent `Rails/Blank` and `Rails/Present` from breaking when there is no explicit receiver. ([@rrosenblum][])
* [#4249](https://github.com/rubocop-hq/rubocop/issues/4249): Handle multiple assignment in `Rails/RelativeDateConstant`. ([@bbatsov][])
* [#4250](https://github.com/rubocop-hq/rubocop/issues/4250): Improve a bit the Ruby code detection config. ([@bbatsov][])
* [#4283](https://github.com/rubocop-hq/rubocop/issues/4283): Fix `Style/EmptyCaseCondition` autocorrect bug - when first `when` branch includes comma-delimited alternatives. ([@ilansh][])
* [#4268](https://github.com/rubocop-hq/rubocop/issues/4268): Handle end-of-line comments when autocorrecting Style/EmptyLinesAroundAccessModifier. ([@vergenzt][])
* [#4275](https://github.com/rubocop-hq/rubocop/issues/4275): Prevent `Style/MethodCallWithArgsParentheses` from blowing up on `yield`. ([@drenmi][])
* [#3969](https://github.com/rubocop-hq/rubocop/issues/3969): Handle multiline method call alignment for arguments to methods. ([@jonas054][])
* [#4304](https://github.com/rubocop-hq/rubocop/pull/4304): Allow enabling whole departments when `DisabledByDefault` is `true`. ([@jonas054][])
* [#4264](https://github.com/rubocop-hq/rubocop/issues/4264): Prevent `Rails/SaveBang` from blowing up when using the assigned variable in a hash. ([@drenmi][])
* [#4310](https://github.com/rubocop-hq/rubocop/pull/4310): Treat paths containing invalid byte sequences as non-matches. ([@mclark][])
* [#4063](https://github.com/rubocop-hq/rubocop/issues/4063): Fix Rails/ReversibleMigration misdetection. ([@gprado][])
* [#4339](https://github.com/rubocop-hq/rubocop/pull/4339): Fix false positive in `Security/Eval` cop for multiline string lietral. ([@pocke][])
* [#4339](https://github.com/rubocop-hq/rubocop/pull/4339): Fix false negative in `Security/Eval` cop for `Binding#eval`. ([@pocke][])
* [#4327](https://github.com/rubocop-hq/rubocop/issues/4327): Prevent `Layout/SpaceInsidePercentLiteralDelimiters` from registering offenses on execute-strings. ([@drenmi][])
* [#4371](https://github.com/rubocop-hq/rubocop/issues/4371): Prevent `Style/MethodName` from complaining about unary operator definitions. ([@drenmi][])
* [#4366](https://github.com/rubocop-hq/rubocop/issues/4366): Prevent `Performance/RedundantMerge` from blowing up on double splat arguments. ([@drenmi][])
* [#4352](https://github.com/rubocop-hq/rubocop/issues/4352): Fix the auto-correct of `Style/AndOr` when Enumerable accessors (`[]`) are used. ([@rrosenblum][])
* [#4393](https://github.com/rubocop-hq/rubocop/issues/4393): Prevent `Style/InverseMethods` from registering an offense for methods that are double negated. ([@rrosenblum][])
* [#4394](https://github.com/rubocop-hq/rubocop/issues/4394): Prevent some cops from breaking on safe navigation operator. ([@drenmi][])
* [#4260](https://github.com/rubocop-hq/rubocop/issues/4260): Prevent `Rails/SkipsModelValidations` from registering an offense for `FileUtils.touch`. ([@rrosenblum][])

## 0.48.1 (2017-04-03)

### Changes

* [#4219](https://github.com/rubocop-hq/rubocop/issues/4219): Add a link to style guide for `Style/IndentationConsistency` cop. ([@pocke][])
* [#4168](https://github.com/rubocop-hq/rubocop/issues/4168): Removed `-n` option. ([@sadovnik][])
* [#4039](https://github.com/rubocop-hq/rubocop/pull/4039): Change `Style/PercentLiteralDelimiters` default configuration to match Style Guide update. ([@drenmi][])
* [#4235](https://github.com/rubocop-hq/rubocop/pull/4235): Improved copy of offense message in `Lint/AmbiguousBlockAssociation` cop. ([@smakagon][])

### Bug fixes

* [#4171](https://github.com/rubocop-hq/rubocop/pull/4171): Prevent `Rails/Blank` from breaking when RHS of `or` is a naked falsiness check. ([@drenmi][])
* [#4189](https://github.com/rubocop-hq/rubocop/pull/4189): Make `Lint/AmbiguousBlockAssociation` aware of lambdas passed as arguments. ([@drenmi][])
* [#4179](https://github.com/rubocop-hq/rubocop/pull/4179): Prevent `Rails/Blank` from breaking when LHS of `or` is a naked falsiness check. ([@rrosenblum][])
* [#4172](https://github.com/rubocop-hq/rubocop/pull/4172): Fix false positives in `Style/MixinGrouping` cop. ([@drenmi][])
* [#4185](https://github.com/rubocop-hq/rubocop/pull/4185): Make `Lint/NestedMethodDefinition` aware of `#*_exec` class of methods. ([@drenmi][])
* [#4197](https://github.com/rubocop-hq/rubocop/pull/4197): Fix false positive in `Style/RedundantSelf` cop with parallel assignment. ([@drenmi][])
* [#4199](https://github.com/rubocop-hq/rubocop/issues/4199): Fix incorrect auto correction in `Style/SymbolArray` and `Style/WordArray` cop. ([@pocke][])
* [#4218](https://github.com/rubocop-hq/rubocop/pull/4218): Make `Lint/NestedMethodDefinition` aware of class shovel scope. ([@drenmi][])
* [#4198](https://github.com/rubocop-hq/rubocop/pull/4198): Make `Lint/AmbguousBlockAssociation` aware of operator methods. ([@drenmi][])
* [#4152](https://github.com/rubocop-hq/rubocop/pull/4152): Make `Style/MethodCallWithArgsParentheses` not require parens on setter methods. ([@drenmi][])
* [#4226](https://github.com/rubocop-hq/rubocop/pull/4226): Show in `--help` output that `--stdin` takes a file name argument. ([@jonas054][])
* [#4217](https://github.com/rubocop-hq/rubocop/pull/4217): Fix false positive in `Rails/FilePath` cop with non string argument. ([@soutaro][])
* [#4106](https://github.com/rubocop-hq/rubocop/pull/4106): Make `Style/TernaryParentheses` unsafe autocorrect detector aware of literals and constants. ([@drenmi][])
* [#4228](https://github.com/rubocop-hq/rubocop/pull/4228): Fix false positive in `Lint/AmbiguousBlockAssociation` cop. ([@smakagon][])
* [#4234](https://github.com/rubocop-hq/rubocop/pull/4234): Fix false positive in `Rails/RelativeDate` for lambdas and procs. ([@smakagon][])

## 0.48.0 (2017-03-26)

### New features

* [#4107](https://github.com/rubocop-hq/rubocop/pull/4107): New `TargetRailsVersion` configuration parameter can be used to specify which version of Rails the inspected code is intended to run on. ([@maxbeizer][])
* [#4104](https://github.com/rubocop-hq/rubocop/pull/4104): Add `prefix` and `postfix` styles to `Style/NegatedIf`. ([@brandonweiss][])
* [#4083](https://github.com/rubocop-hq/rubocop/pull/4083): Add new configuration `NumberOfEmptyLines` for `Style/EmptyLineBetweenDefs`. ([@dorian][])
* [#4045](https://github.com/rubocop-hq/rubocop/pull/4045): Add new configuration `Strict` for `Style/NumericLiteral` to make the change to this cop in 0.47.0 configurable. ([@iGEL][])
* [#4005](https://github.com/rubocop-hq/rubocop/issues/4005): Add new `AllCops/EnabledByDefault` option. ([@betesh][])
* [#3893](https://github.com/rubocop-hq/rubocop/issues/3893): Add a new configuration, `IncludeActiveSupportAliases`, to `Performance/DoublStartEndWith`. This configuration will check for ActiveSupport's `starts_with?` and `ends_with?`. ([@rrosenblum][])
* [#3889](https://github.com/rubocop-hq/rubocop/pull/3889): Add new `Style/EmptyLineAfterMagicComment` cop. ([@backus][])
* [#3800](https://github.com/rubocop-hq/rubocop/issues/3800): Make `Style/EndOfLine` configurable with `lf`, `crlf`, and `native` (default) styles. ([@jonas054][])
* [#3936](https://github.com/rubocop-hq/rubocop/issues/3936): Add new `Style/MixinGrouping` cop. ([@drenmi][])
* [#4003](https://github.com/rubocop-hq/rubocop/issues/4003): Add new `Rails/RelativeDateConstant` cop. ([@sinsoku][])
* [#3984](https://github.com/rubocop-hq/rubocop/pull/3984): Add new `Style/EmptyLinesAroundBeginBody` cop. ([@pocke][])
* [#3995](https://github.com/rubocop-hq/rubocop/pull/3995): Add new `Style/EmptyLinesAroundExceptionHandlingKeywords` cop. ([@pocke][])
* [#4019](https://github.com/rubocop-hq/rubocop/pull/4019): Make configurable `Style/MultilineMemoization` cop. ([@pocke][])
* [#4018](https://github.com/rubocop-hq/rubocop/pull/4018): Add autocorrect `Lint/EmptyEnsure` cop. ([@pocke][])
* [#4028](https://github.com/rubocop-hq/rubocop/pull/4028): Add new `Style/IndentHeredoc` cop. ([@pocke][])
* [#3931](https://github.com/rubocop-hq/rubocop/issues/3931): Add new `Lint/AmbiguousBlockAssociation` cop. ([@smakagon][])
* Add new `Style/InverseMethods` cop. ([@rrosenblum][])
* [#4038](https://github.com/rubocop-hq/rubocop/pull/4038): Allow `default` key in the `Style/PercentLiteralDelimiters` cop config to set all preferred delimiters. ([@kddeisz][])
* Add `IgnoreMacros` option to `Style/MethodCallWithArgsParentheses`. ([@drenmi][])
* [#3937](https://github.com/rubocop-hq/rubocop/issues/3937): Add new `Rails/ActiveSupportAliases` cop. ([@tdeo][])
* Add new `Rails/Blank` cop. ([@rrosenblum][])
* Add new `Rails/Present` cop. ([@rrosenblum][])
* [#4004](https://github.com/rubocop-hq/rubocop/issues/4004): Allow not treating comment lines as group separators in `Bundler/OrderedGems` cop. ([@konto-andrzeja][])

### Changes

* [#4100](https://github.com/rubocop-hq/rubocop/issues/4100): Rails/SaveBang should flag `update_attributes`. ([@andriymosin][])
* [#4083](https://github.com/rubocop-hq/rubocop/pull/4083): `Style/EmptyLineBetweenDefs` doesn't allow more than one empty line between method definitions by default (see `NumberOfEmptyLines`). ([@dorian][])
* [#3997](https://github.com/rubocop-hq/rubocop/pull/3997): Include all ruby files by default and exclude non-ruby files. ([@dorian][])
* [#4012](https://github.com/rubocop-hq/rubocop/pull/4012): Mark `foo[:bar]` as not complex in `Style/TernaryParentheses` cop with `require_parentheses_when_complex` style. ([@onk][])
* [#3915](https://github.com/rubocop-hq/rubocop/issues/3915): Make configurable whitelist for `Lint/SafeNavigationChain` cop. ([@pocke][])
* [#3944](https://github.com/rubocop-hq/rubocop/issues/3944): Allow keyword arguments in `Style/RaiseArgs` cop. ([@mikegee][])
* Add auto-correct to `Performance/DoubleStartEndWith`. ([@rrosenblum][])
* [#3951](https://github.com/rubocop-hq/rubocop/pull/3951): Make `Rails/Date` cop to register an offence for a string without timezone. ([@sinsoku][])
* [#4020](https://github.com/rubocop-hq/rubocop/pull/4020): Fixed `new_cop.rake` suggested path. ([@dabroz][])
* [#4055](https://github.com/rubocop-hq/rubocop/pull/4055): Add parameters count to offense message for `Metrics/ParameterLists` cop. ([@pocke][])
* [#4081](https://github.com/rubocop-hq/rubocop/pull/4081): Allow `Marshal.load` if argument is a `Marshal.dump` in `Security/MarshalLoad` cop. ([@droptheplot][])
* [#4124](https://github.com/rubocop-hq/rubocop/issues/4124): Make `Style/SymbolArray` cop to enable by default. ([@pocke][])
* [#3331](https://github.com/rubocop-hq/rubocop/issues/3331): Change `Style/MultilineMethodCallIndentation` `indented_relative_to_receiver` to indent relative to the receiver and not relative to the caller. ([@jfelchner][])
* [#4137](https://github.com/rubocop-hq/rubocop/pull/4137): Allow lines to be exempted from `IndentationWidth` by regex. ([@jfelchner][])

### Bug fixes

* [#4007](https://github.com/rubocop-hq/rubocop/pull/4007): Skip `Rails/SkipsModelValidations` for methods that don't accept arguments. ([@dorian][])
* [#3923](https://github.com/rubocop-hq/rubocop/issues/3923): Allow asciibetical sorting in `Bundler/OrderedGems`. ([@mikegee][])
* [#3855](https://github.com/rubocop-hq/rubocop/issues/3855): Make `Lint/NonLocalExitFromIterator` aware of method definitions. ([@drenmi][])
* [#2643](https://github.com/rubocop-hq/rubocop/issues/2643): Allow uppercase and dashes in `MagicComment`. ([@mikegee][])
* [#3959](https://github.com/rubocop-hq/rubocop/issues/3959): Don't wrap "percent arrays" with extra brackets when autocorrecting `Style/MutableConstant`. ([@mikegee][])
* [#3978](https://github.com/rubocop-hq/rubocop/pull/3978): Fix false positive in `Performance/RegexpMatch` with `English` module. ([@pocke][])
* [#3242](https://github.com/rubocop-hq/rubocop/issues/3242): Ignore `Errno::ENOENT` during cache cleanup from `File.mtime` too. ([@mikegee][])
* [#3958](https://github.com/rubocop-hq/rubocop/issues/3958): `Style/SpaceInsideHashLiteralBraces` doesn't add and offence when checking an hash where a value is a left brace string (e.g. { k: '{' }). ([@nodo][])
* [#4006](https://github.com/rubocop-hq/rubocop/issues/4006): Prevent `Style/WhileUntilModifier` from breaking on a multiline modifier. ([@drenmi][])
* [#3345](https://github.com/rubocop-hq/rubocop/issues/3345): Allow `Style/WordArray`'s `WordRegex` configuration value to be an instance of `String`. ([@mikegee][])
* [#4013](https://github.com/rubocop-hq/rubocop/pull/4013): Follow redirects for RemoteConfig. ([@buenaventure][])
* [#3917](https://github.com/rubocop-hq/rubocop/issues/3917): Rails/FilePath Match nodes in a method call only once. ([@unmanbearpig][])
* [#3673](https://github.com/rubocop-hq/rubocop/issues/3673): Fix regression on `Style/RedundantSelf` when assigning to same local variable. ([@bankair][])
* [#4047](https://github.com/rubocop-hq/rubocop/issues/4047): Allow `find_zone` and `find_zone!` methods in `Rails/TimeZone`. ([@attilahorvath][])
* [#3457](https://github.com/rubocop-hq/rubocop/issues/3457): Clear a warning and prevent new warnings. ([@mikegee][])
* [#4066](https://github.com/rubocop-hq/rubocop/issues/4066): Register an offense in `Lint/ShadowedException` when an exception is shadowed and there is an implicit begin. ([@rrosenblum][])
* [#4001](https://github.com/rubocop-hq/rubocop/issues/4001): Lint/UnneededDisable of Metrics/LineLength that isn't unneeded. ([@wkurniawan07][])
* [#3960](https://github.com/rubocop-hq/rubocop/issues/3960): Let `Include`/`Exclude` paths in all files beginning with `.rubocop` be relative to the configuration file's directory and not to the current directory. ([@jonas054][])
* [#4049](https://github.com/rubocop-hq/rubocop/pull/4049): Bugfix for `Style/EmptyLiteral` cop. ([@ota42y][])
* [#4112](https://github.com/rubocop-hq/rubocop/pull/4112): Fix false positives about double quotes in `Style/StringLiterals`, `Style/UnneededCapitalW` and `Style/UnneededPercentQ` cops. ([@pocke][])
* [#4109](https://github.com/rubocop-hq/rubocop/issues/4109): Fix incorrect auto correction in `Style/SelfAssignment` cop. ([@pocke][])
* [#4110](https://github.com/rubocop-hq/rubocop/issues/4110): Fix incorrect auto correction in `Style/BracesAroundHashParameters` cop. ([@musialik][])
* [#4084](https://github.com/rubocop-hq/rubocop/issues/4084): Fix incorrect auto correction in `Style/TernaryParentheses` cop. ([@musialik][])
* [#4102](https://github.com/rubocop-hq/rubocop/issues/4102): Fix `Security/JSONLoad`, `Security/MarshalLoad` and `Security/YAMLLoad` cops patterns not matching ::Const. ([@musialik][])
* [#3580](https://github.com/rubocop-hq/rubocop/issues/3580): Handle combinations of `# rubocop:disable all` and `# rubocop:disable SomeCop`. ([@jonas054][])
* [#4124](https://github.com/rubocop-hq/rubocop/issues/4124): Fix auto correction bugs in `Style/SymbolArray` cop. ([@pocke][])
* [#4128](https://github.com/rubocop-hq/rubocop/issues/4128): Prevent `Style/CaseIndentation` cop from registering offenses on single-line case statements. ([@drenmi][])
* [#4143](https://github.com/rubocop-hq/rubocop/issues/4143): Prevent `Style/IdenticalConditionalBranches` from registering offenses when a case statement has an empty when. ([@dpostorivo][])
* [#4160](https://github.com/rubocop-hq/rubocop/pull/4160): Fix a regression where `UselessAssignment` cop may not properly detect useless assignments when there's only a single conditional expression in the top level scope. ([@yujinakayama][])
* [#4162](https://github.com/rubocop-hq/rubocop/pull/4162): Fix a false negative in `UselessAssignment` cop with nested conditionals. ([@yujinakayama][])

## 0.47.1 (2017-01-18)

### Bug fixes

* [#3911](https://github.com/rubocop-hq/rubocop/issues/3911): Prevent a crash in `Performance/RegexpMatch` cop with module definition. ([@pocke][])
* [#3908](https://github.com/rubocop-hq/rubocop/issues/3908): Prevent `Style/AlignHash` from breaking on a keyword splat when using enforced `table` style. ([@drenmi][])
* [#3918](https://github.com/rubocop-hq/rubocop/issues/3918): Prevent `Rails/EnumUniqueness` from breaking on a non-literal hash value. ([@drenmi][])
* [#3914](https://github.com/rubocop-hq/rubocop/pull/3914): Fix department resolution for third party cops required through configuration. ([@backus][])
* [#3846](https://github.com/rubocop-hq/rubocop/issues/3846): `NodePattern` works for hyphenated node types. ([@alexdowad][])
* [#3922](https://github.com/rubocop-hq/rubocop/issues/3922): Prevent `Style/NegatedIf` from breaking on negated ternary. ([@drenmi][])
* [#3915](https://github.com/rubocop-hq/rubocop/issues/3915): Fix a false positive in `Lint/SafeNavigationChain` cop with `try` method. ([@pocke][])

## 0.47.0 (2017-01-16)

### New features

* [#3822](https://github.com/rubocop-hq/rubocop/pull/3822): Add `Rails/FilePath` cop. ([@iguchi1124][])
* [#3821](https://github.com/rubocop-hq/rubocop/pull/3821): Add `Security/YAMLLoad` cop. ([@cyberdelia][])
* [#3816](https://github.com/rubocop-hq/rubocop/pull/3816): Add `Security/MarshalLoad` cop. ([@cyberdelia][])
* [#3757](https://github.com/rubocop-hq/rubocop/pull/3757): Add Auto-Correct for `Bundler/OrderedGems` cop. ([@pocke][])
* `Style/FrozenStringLiteralComment` now supports the style `never` that will remove the `frozen_string_literal` comment. ([@rrosenblum][])
* [#3795](https://github.com/rubocop-hq/rubocop/pull/3795): Add `Lint/MultipleCompare` cop. ([@pocke][])
* [#3772](https://github.com/rubocop-hq/rubocop/issues/3772): Allow exclusion of certain methods for `Metrics/BlockLength`. ([@NobodysNightmare][])
* [#3804](https://github.com/rubocop-hq/rubocop/pull/3804): Add new `Lint/SafeNavigationChain` cop. ([@pocke][])
* [#3670](https://github.com/rubocop-hq/rubocop/pull/3670): Add `CountBlocks` boolean option to `Metrics/BlockNesting`. It allows blocks to be counted towards the nesting limit. ([@georgyangelov][])
* [#2992](https://github.com/rubocop-hq/rubocop/issues/2992): Add a configuration to `Style/ConditionalAssignment` to toggle offenses for ternary expressions. ([@rrosenblum][])
* [#3824](https://github.com/rubocop-hq/rubocop/pull/3824): Add new `Performance/RegexpMatch` cop. ([@pocke][])
* [#3825](https://github.com/rubocop-hq/rubocop/pull/3825): Add new `Rails/SkipsModelValidations` cop. ([@rahulcs][])
* [#3737](https://github.com/rubocop-hq/rubocop/issues/3737): Add new `Style/MethodCallWithArgsParentheses` cop. ([@dominh][])
* Renamed `MethodCallParentheses` to `MethodCallWithoutArgsParentheses`. ([@dominh][])
* [#3854](https://github.com/rubocop-hq/rubocop/pull/3854): Add new `Rails/ReversibleMigration` cop. ([@sue445][])
* [#3872](https://github.com/rubocop-hq/rubocop/pull/3872): Detect `String#%` with hash literal. ([@backus][])
* [#2731](https://github.com/rubocop-hq/rubocop/issues/2731): Allow configuration of method calls that create methods for `Lint/UselessAccessModifier`. ([@pat][])

### Changes

* [#3820](https://github.com/rubocop-hq/rubocop/pull/3820): Rename `Lint/Eval` to `Security/Eval`. ([@cyberdelia][])
* [#3725](https://github.com/rubocop-hq/rubocop/issues/3725): Disable `Style/SingleLineBlockParams` by default. ([@tejasbubane][])
* [#3765](https://github.com/rubocop-hq/rubocop/pull/3765): Add a validation for supported styles other than EnforcedStyle. `AlignWith`, `IndentWhenRelativeTo` and `EnforcedMode` configurations are renamed. ([@pocke][])
* [#3782](https://github.com/rubocop-hq/rubocop/pull/3782): Add check for `add_reference` method by `Rails/NotNullColumn` cop. ([@pocke][])
* [#3761](https://github.com/rubocop-hq/rubocop/pull/3761): Update `Style/RedundantFreeze` message from `Freezing immutable objects is pointless.` to `Do not freeze immutable objects, as freezing them has no effect.`. ([@lucasuyezu][])
* [#3753](https://github.com/rubocop-hq/rubocop/issues/3753): Change error message of `Bundler/OrderedGems` to mention `Alphabetize Gems`. ([@tejasbubane][])
* [#3802](https://github.com/rubocop-hq/rubocop/pull/3802): Ignore case when checking Gemfile order. ([@breckenedge][])
* Add missing examples in `Lint` cops documentation. ([@enriikke][])
* Make `Style/EmptyMethod` cop aware of class methods. ([@drenmi][])
* [#3871](https://github.com/rubocop-hq/rubocop/pull/3871): Add check for void `defined?` and `self` by `Lint/Void` cop. ([@pocke][])
* Allow ignoring methods in `Style/BlockDelimiters` when using any style. ([@twe4ked][])

### Bug fixes

* [#3751](https://github.com/rubocop-hq/rubocop/pull/3751): Avoid crash in `Rails/EnumUniqueness` cop. ([@pocke][])
* [#3766](https://github.com/rubocop-hq/rubocop/pull/3766): Avoid crash in `Style/ConditionalAssignment` cop with masgn. ([@pocke][])
* [#3770](https://github.com/rubocop-hq/rubocop/pull/3770): `Style/RedundantParentheses` Don't flag raised to a power negative numeric literals, since removing the parentheses would change the meaning of the expressions. ([@amogil][])
* [#3750](https://github.com/rubocop-hq/rubocop/issues/3750): Register an offense in `Style/ConditionalAssignment` when the assignment spans multiple lines. ([@rrosenblum][])
* [#3775](https://github.com/rubocop-hq/rubocop/pull/3775): Avoid crash in `Style/HashSyntax` cop with an empty hash. ([@pocke][])
* [#3783](https://github.com/rubocop-hq/rubocop/pull/3783): Maintain parentheses in `Rails/HttpPositionalArguments` when methods are defined with them. ([@kevindew][])
* [#3786](https://github.com/rubocop-hq/rubocop/pull/3786): Avoid crash `Style/ConditionalAssignment` cop with mass assign method. ([@pocke][])
* [#3749](https://github.com/rubocop-hq/rubocop/pull/3749): Detect corner case of `Style/NumericLitterals`. ([@kamaradclimber][])
* [#3788](https://github.com/rubocop-hq/rubocop/pull/3788): Prevent bad auto-correct in `Style/Next` when block has nested conditionals. ([@drenmi][])
* [#3807](https://github.com/rubocop-hq/rubocop/pull/3807): Prevent `Style/Documentation` and `Style/DocumentationMethod` from mistaking RuboCop directives for class documentation. ([@drenmi][])
* [#3815](https://github.com/rubocop-hq/rubocop/pull/3815): Fix false positive in `Style/IdenticalConditionalBranches` cop when branches have same line at leading. ([@pocke][])
* Fix false negative in `Rails/HttpPositionalArguments` where offense would go undetected if one of the request parameter names matched one of the special keyword arguments. ([@deivid-rodriguez][])
* Fix false negative in `Rails/HttpPositionalArguments` where offense would go undetected if the `:format` keyword was used with other non-special keywords. ([@deivid-rodriguez][])
* [#3406](https://github.com/rubocop-hq/rubocop/issues/3406): Enable cops if Enabled is not explicitly set to false. ([@metcalf][])
* Fix `Lint/FormatParameterMismatch` for splatted last argument. ([@zverok][])
* [#3853](https://github.com/rubocop-hq/rubocop/pull/3853): Fix false positive in `RedundantParentheses` cop with multiple expression. ([@pocke][])
* [#3870](https://github.com/rubocop-hq/rubocop/pull/3870): Avoid crash in `Rails/HttpPositionalArguments`. ([@pocke][])
* [#3869](https://github.com/rubocop-hq/rubocop/pull/3869): Prevent `Lint/FormatParameterMismatch` from breaking when `#%` is passed an empty array. ([@drenmi][])
* [#3879](https://github.com/rubocop-hq/rubocop/pull/3879): Properly handle Emacs and Vim magic comments for `FrozenStringLiteralComment`. ([@backus][])
* [#3736](https://github.com/rubocop-hq/rubocop/issues/3736): Fix to remove accumulator return value by auto-correction in `Style/EachWithObject`. ([@pocke][])

## 0.46.0 (2016-11-30)

### New features

* [#3600](https://github.com/rubocop-hq/rubocop/issues/3600): Add new `Bundler/DuplicatedGem` cop. ([@jmks][])
* [#3624](https://github.com/rubocop-hq/rubocop/pull/3624): Add new configuration option `empty_lines_special` to `Style/EmptyLinesAroundClassBody` and `Style/EmptyLinesAroundModuleBody`. ([@legendetm][])
* Add new `Style/EmptyMethod` cop. ([@drenmi][])
* `Style/EmptyLiteral` will now auto-correct `Hash.new` when it is the first argument being passed to a method. The arguments will be wrapped with parenthesis. ([@rrosenblum][])
* [#3713](https://github.com/rubocop-hq/rubocop/pull/3713): Respect `DisabledByDefault` in parent configs. ([@aroben][])
* New cop `Rails/EnumUniqueness` checks for duplicate values defined in enum config. ([@olliebennett][])
* New cop `Rails/EnumUniqueness` checks for duplicate values defined in enum config hash. ([@olliebennett][])
* [#3451](https://github.com/rubocop-hq/rubocop/issues/3451): Add new `require_parentheses_when_complex` style to `Style/TernaryParentheses` cop. ([@swcraig][])
* [#3600](https://github.com/rubocop-hq/rubocop/issues/3600): Add new `Bundler/OrderedGems` cop. ([@tdeo][])
* [#3479](https://github.com/rubocop-hq/rubocop/issues/3479): Add new configuration option `IgnoredPatterns` to `Metrics/LineLength`. ([@jonas054][])

### Changes

* The offense range for `Performance/FlatMap` now includes any parameters that are passed to `flatten`. ([@rrosenblum][])
* [#1747](https://github.com/rubocop-hq/rubocop/issues/1747): Update `Style/SpecialGlobalVars` messages with a reminder to `require 'English'`. ([@ivanovaleksey][])
* Checks `binding.irb` call by `Lint/Debugger` cop. ([@pocke][])
* [#3742](https://github.com/rubocop-hq/rubocop/pull/3742): Checks `min` and `max` call by `Performance/CompareWithBlock` cop. ([@pocke][])

### Bug fixes

* [#3662](https://github.com/rubocop-hq/rubocop/issues/3662): Fix the auto-correction of `Lint/UnneededSplatExpansion` when the splat expansion is inside of another array. ([@rrosenblum][])
* [#3699](https://github.com/rubocop-hq/rubocop/issues/3699): Fix false positive in `Style/VariableNumber` on variable names ending with an underscore. ([@bquorning][])
* [#3687](https://github.com/rubocop-hq/rubocop/issues/3687): Fix the fact that `Style/TernaryParentheses` cop claims to correct uncorrected offenses. ([@Ana06][])
* [#3568](https://github.com/rubocop-hq/rubocop/issues/3568): Fix `--auto-gen-config` behavior for `Style/VariableNumber`. ([@jonas054][])
* Add `format` as an acceptable keyword argument for `Rails/HttpPositionalArguments`. ([@aesthetikx][])
* [#3598](https://github.com/rubocop-hq/rubocop/issues/3598): In `Style/NumericPredicate`, don't report `x != 0` or `x.nonzero?` as the expressions have different values. ([@jonas054][])
* [#3690](https://github.com/rubocop-hq/rubocop/issues/3690): Do not register an offense for multiline braces with content in `Style/SpaceInsideBlockBraces`. ([@rrosenblum][])
* [#3746](https://github.com/rubocop-hq/rubocop/issues/3746): `Lint/NonLocalExitFromIterator` does not warn about `return` in a block which is passed to `Object#define_singleton_method`. ([@AlexWayfer][])

## 0.45.0 (2016-10-31)

### New features

* [#3615](https://github.com/rubocop-hq/rubocop/pull/3615): Add autocorrection for `Lint/EmptyInterpolation`. ([@pocke][])
* Make `PercentLiteralDelimiters` enforce delimiters around `%I()` too. ([@bronson][])
* [#3408](https://github.com/rubocop-hq/rubocop/issues/3408): Add check for repeated values in case conditionals. ([@swcraig][])
* [#3646](https://github.com/rubocop-hq/rubocop/pull/3646): Add new `Lint/EmptyWhen` cop. ([@drenmi][])
* [#3246](https://github.com/rubocop-hq/rubocop/issues/3246): Add list of all cops to the manual (generated automatically from a rake task). ([@sihu][])
* [#3647](https://github.com/rubocop-hq/rubocop/issues/3647): Add `--force-default-config` option. ([@jawshooah][])
* [#3570](https://github.com/rubocop-hq/rubocop/issues/3570): Add new `MultilineIfModifier` cop to avoid usage of if/unless-modifiers on multiline statements. ([@tessi][])
* [#3631](https://github.com/rubocop-hq/rubocop/issues/3631): Add new `Style/SpaceInLambdaLiteral` cop to check for spaces in lambda literals. ([@swcraig][])
* Add new `Lint/EmptyExpression` cop. ([@drenmi][])

### Bug fixes

* [#3553](https://github.com/rubocop-hq/rubocop/pull/3553): Make `Style/RedundantSelf` cop to not register an offence for `self.()`. ([@iGEL][])
* [#3474](https://github.com/rubocop-hq/rubocop/issues/3474): Make the `Rails/TimeZone` only analyze functions which have "Time" in the receiver. ([@b-t-g][])
* [#3607](https://github.com/rubocop-hq/rubocop/pull/3607): Fix `Style/RedundantReturn` cop for empty if body. ([@pocke][])
* [#3291](https://github.com/rubocop-hq/rubocop/issues/3291): Improve detection of `raw` and `html_safe` methods in `Rails/OutputSafety`. ([@lumeet][])
* Redundant return style now properly handles empty `when` blocks. ([@albus522][])
* [#3622](https://github.com/rubocop-hq/rubocop/pull/3622): Fix false positive for `Metrics/MethodLength` and `Metrics/BlockLength`. ([@meganemura][])
* [#3625](https://github.com/rubocop-hq/rubocop/pull/3625): Fix some cops errors when condition is empty brace. ([@pocke][])
* [#3468](https://github.com/rubocop-hq/rubocop/issues/3468): Fix bug regarding alignment inside `begin`..`end` block in `Style/MultilineMethodCallIndentation`. ([@jonas054][])
* [#3644](https://github.com/rubocop-hq/rubocop/pull/3644): Fix generation incorrect documentation. ([@pocke][])
* [#3637](https://github.com/rubocop-hq/rubocop/issues/3637): Fix Style/NonNilCheck crashing for ternary condition. ([@tejasbubane][])
* [#3654](https://github.com/rubocop-hq/rubocop/pull/3654): Add missing keywords for `Rails/HttpPositionalArguments`. ([@eitoball][])
* [#3652](https://github.com/rubocop-hq/rubocop/issues/3652): Avoid crash Rails/HttpPositionalArguments for lvar params when auto-correct. ([@pocke][])
* Fix bug in `Style/SafeNavigation` where there is a check for an object in an elsif statement with a method call on that object in the branch. ([@rrosenblum][])
* [#3660](https://github.com/rubocop-hq/rubocop/pull/3660): Fix false positive for Rails/SafeNavigation when without receiver. ([@pocke][])
* [#3650](https://github.com/rubocop-hq/rubocop/issues/3650): Fix `Style/VariableNumber` registering an offense for variables with double digit numbers. ([@rrosenblum][])
* [#3494](https://github.com/rubocop-hq/rubocop/issues/3494): Check `rails` style indentation also inside blocks in `Style/IndentationWidth`. ([@jonas054][])
* [#3676](https://github.com/rubocop-hq/rubocop/issues/3676): Ignore raw and html_safe invocations when wrapped inside a safe_join. ([@b-t-g][])

### Changes

* [#3601](https://github.com/rubocop-hq/rubocop/pull/3601): Change default args for `Style/SingleLineBlockParams`. This cop checks that `reduce` and `inject` use the variable names `a` and `e` for block arguments. These defaults are uncommunicative variable names and thus conflict with the ["Uncommunicative Variable Name" check in Reek](https://github.com/troessner/reek/blob/master/docs/Uncommunicative-Variable-Name.md). Default args changed to `acc` and `elem`.([@jessieay][])
* [#3645](https://github.com/rubocop-hq/rubocop/pull/3645): Fix bug with empty case when nodes in `Style/RedundantReturn`. ([@tiagocasanovapt][])
* [#3263](https://github.com/rubocop-hq/rubocop/issues/3263): Fix auto-correct of if statements inside of unless else statements in `Style/ConditionalAssignment`. ([@rrosenblum][])
* Bump default Ruby version to 2.1. ([@drenmi][])

## 0.44.1 (2016-10-13)

### Bug fixes

* Remove a debug `require`. ([@bbatsov][])

## 0.44.0 (2016-10-13)

### New features

* [#3560](https://github.com/rubocop-hq/rubocop/pull/3560): Add a configuration option `empty_lines_except_namespace` to `Style/EmptyLinesAroundClassBody` and `Style/EmptyLinesAroundModuleBody`. ([@legendetm][])
* [#3370](https://github.com/rubocop-hq/rubocop/issues/3370): Add new `Rails/HttpPositionalArguments` cop to check your Rails 5 test code for existence of positional args usage. ([@logicminds][])
* [#3510](https://github.com/rubocop-hq/rubocop/issues/3510): Add a configuration option, `ConvertCodeThatCanStartToReturnNil`, to `Style/SafeNavigation` to check for code that could start returning `nil` if safe navigation is used. ([@rrosenblum][])
* Add a new `AllCops/StyleGuideBaseURL` setting that allows the use of relative paths and/or fragments within each cop's `StyleGuide` setting, to make forking of custom style guides easier. ([@scottmatthewman][])
* [#3566](https://github.com/rubocop-hq/rubocop/issues/3566): Add new `Metric/BlockLength` cop to ensure blocks don't get too long. ([@savef][])
* [#3428](https://github.com/rubocop-hq/rubocop/issues/3428): Add support for configuring `Style/PreferredHashMethods` with either `short` or `verbose` style method names. ([@abrom][])
* [#3455](https://github.com/rubocop-hq/rubocop/issues/3455): Add new `Rails/DynamicFindBy` cop. ([@pocke][])
* [#3542](https://github.com/rubocop-hq/rubocop/issues/3542): Add a configuration option, `IgnoreCopDirectives`, to `Metrics/LineLength` to stop cop directives (`# rubocop:disable Metrics/AbcSize`) from being counted when considering line length. ([@jmks][])
* Add new `Rails/DelegateAllowBlank` cop. ([@connorjacobsen][])
* Add new `Style/MultilineMemoization` cop. ([@drenmi][])

### Bug fixes

* [#3103](https://github.com/rubocop-hq/rubocop/pull/3103): Make `Style/ExtraSpacing` cop register an offense for extra spaces present in single-line hash literals. ([@tcdowney][])
* [#3513](https://github.com/rubocop-hq/rubocop/pull/3513): Fix false positive in `Style/TernaryParentheses` for a ternary with ranges. ([@dreyks][])
* [#3520](https://github.com/rubocop-hq/rubocop/issues/3520): Fix regression causing `Lint/AssignmentInCondition` false positive. ([@savef][])
* [#3514](https://github.com/rubocop-hq/rubocop/issues/3514): Make `Style/VariableNumber` cop not register an offense when valid normal case variable names have an integer after the first `_`. ([@b-t-g][])
* [#3516](https://github.com/rubocop-hq/rubocop/issues/3516): Make `Style/VariableNumber` cop not register an offense when valid normal case variable names have an integer in the middle. ([@b-t-g][])
* [#3436](https://github.com/rubocop-hq/rubocop/issues/3436): Make `Rails/SaveBang` cop not register an offense when return value of a non-bang method is returned by the parent method. ([@coorasse][])
* [#3540](https://github.com/rubocop-hq/rubocop/issues/3540): Fix `Style/GuardClause` to register offense for instance and singleton methods. ([@tejasbubane][])
* [#3311](https://github.com/rubocop-hq/rubocop/issues/3311): Detect incompatibilities with the external encoding to prevent bad autocorrections in `Style/StringLiterals`. ([@deivid-rodriguez][])
* [#3499](https://github.com/rubocop-hq/rubocop/issues/3499): Ensure `Lint/UnusedBlockArgument` doesn't make recommendations that would change arity for methods defined using `#define_method`. ([@drenmi][])
* [#3430](https://github.com/rubocop-hq/rubocop/issues/3430): Fix exception in `Performance/RedundantMerge` when inspecting a `#merge!` with implicit receiver. ([@drenmi][])
* [#3411](https://github.com/rubocop-hq/rubocop/issues/3411): Avoid auto-correction crash for single `when` in `Performance/CaseWhenSplat`. ([@jonas054][])
* [#3286](https://github.com/rubocop-hq/rubocop/issues/3286): Allow `self.a, self.b = b, a` in `Style/ParallelAssignment`. ([@jonas054][])
* [#3419](https://github.com/rubocop-hq/rubocop/issues/3419): Report offense for `unless x.nil?` in `Style/NonNilCheck` if `IncludeSemanticChanges` is `true`. ([@jonas054][])
* [#3382](https://github.com/rubocop-hq/rubocop/issues/3382): Avoid auto-correction crash for multiple elsifs in `Style/EmptyElse`. ([@lumeet][])
* [#3334](https://github.com/rubocop-hq/rubocop/issues/3334): Do not register an offense for a literal space (`\s`) in `Style/UnneededCapitalW`. ([@rrosenblum][])
* [#3390](https://github.com/rubocop-hq/rubocop/issues/3390): Fix SaveBang cop for multiple conditional. ([@tejasbubane][])
* [#3577](https://github.com/rubocop-hq/rubocop/issues/3577): Fix `Style/RaiseArgs` not allowing compact raise with splatted args. ([@savef][])
* [#3578](https://github.com/rubocop-hq/rubocop/issues/3578): Fix safe navigation method call counting in `Metrics/AbcSize`. ([@savef][])
* [#3592](https://github.com/rubocop-hq/rubocop/issues/3592): Fix `Style/RedundantParentheses` for indexing with literals. ([@thegedge][])
* [#3597](https://github.com/rubocop-hq/rubocop/issues/3597): Fix the autocorrect of `Performance/CaseWhenSplat` when trying to rearange splat expanded variables to the end of a when condition. ([@rrosenblum][])

### Changes

* [#3512](https://github.com/rubocop-hq/rubocop/issues/3512): Change error message of `Lint/UnneededSplatExpansion` for array in method parameters. ([@tejasbubane][])
* [#3510](https://github.com/rubocop-hq/rubocop/issues/3510): Fix some issues with `Style/SafeNavigation`. Fix auto-correct of multiline if expressions, and do not register an offense for scenarios using `||` and ternary expression. ([@rrosenblum][])
* [#3503](https://github.com/rubocop-hq/rubocop/issues/3503): Change misleading message of `Style/EmptyLinesAroundAccessModifier`. ([@bquorning][])
* [#3407](https://github.com/rubocop-hq/rubocop/issues/3407): Turn off autocorrect for unsafe rules by default. ([@ptarjan][])
* [#3521](https://github.com/rubocop-hq/rubocop/issues/3521): Turn off autocorrect for `Security/JSONLoad` by default. ([@savef][])
* [#2903](https://github.com/rubocop-hq/rubocop/issues/2903): `Style/RedundantReturn` looks for redundant `return` inside conditional branches. ([@lumeet][])

## 0.43.0 (2016-09-19)

### New features

* [#3379](https://github.com/rubocop-hq/rubocop/issues/3379): Add table of contents at the beginning of HTML formatted output. ([@hedgesky][])
* [#2968](https://github.com/rubocop-hq/rubocop/issues/2968): Add new `Style/DocumentationMethod` cop. ([@sooyang][])
* [#3360](https://github.com/rubocop-hq/rubocop/issues/3360): Add `RequireForNonPublicMethods` configuration option to `Style/DocumentationMethod` cop. ([@drenmi][])
* Add new `Rails/SafeNavigation` cop to convert `try!` to `&.`. ([@rrosenblum][])
* [#3415](https://github.com/rubocop-hq/rubocop/pull/3415): Add new `Rails/NotNullColumn` cop. ([@pocke][])
* [#3167](https://github.com/rubocop-hq/rubocop/issues/3167): Add new `Style/VariableNumber` cop. ([@sooyang][])
* Add new style `no_mixed_keys` to `Style/HashSyntax` to only check for hashes with mixed keys. ([@daviddavis][])
* Allow including multiple configuration files from a single gem. ([@tjwallace][])
* Add check for `persisted?` method call when using a create method in `Rails/SaveBang`. ([@QuinnHarris][])
* Add new `Style/SafeNavigation` cop to convert method calls safeguarded by a non `nil` check for the object to `&.`. ([@rrosenblum][])
* Add new `Performance/SortWithBlock` cop to use `sort_by(&:foo)` instead of `sort { |a, b| a.foo <=> b.foo }`. ([@koic][])
* [#3492](https://github.com/rubocop-hq/rubocop/pull/3492): Add new `UnifiedInteger` cop. ([@pocke][])

### Bug fixes

* [#3383](https://github.com/rubocop-hq/rubocop/issues/3383): Fix the local variable reset issue with `Style/RedundantSelf` cop. ([@bankair][])
* [#3445](https://github.com/rubocop-hq/rubocop/issues/3445): Fix bad autocorrect for `Style/AndOr` cop. ([@mikezter][])
* [#3349](https://github.com/rubocop-hq/rubocop/issues/3349): Fix bad autocorrect for `Style/Lambda` cop. ([@metcalf][])
* [#3351](https://github.com/rubocop-hq/rubocop/issues/3351): Fix bad auto-correct for `Performance/RedundantMatch` cop. ([@annaswims][])
* [#3347](https://github.com/rubocop-hq/rubocop/issues/3347): Prevent infinite loop in `Style/TernaryParentheses` cop when used together with `Style/RedundantParentheses`. ([@drenmi][])
* [#3209](https://github.com/rubocop-hq/rubocop/issues/3209): Remove faulty line length check from `Style/GuardClause` cop. ([@drenmi][])
* [#3366](https://github.com/rubocop-hq/rubocop/issues/3366): Make `Style/MutableConstant` cop aware of splat assignments. ([@drenmi][])
* [#3372](https://github.com/rubocop-hq/rubocop/pull/3372): Fix RuboCop crash with empty brackets in `Style/Next` cop. ([@pocke][])
* [#3358](https://github.com/rubocop-hq/rubocop/issues/3358): Make `Style/MethodMissing` cop aware of class scope. ([@drenmi][])
* [#3342](https://github.com/rubocop-hq/rubocop/issues/3342): Fix error in `Lint/ShadowedException` cop if last rescue does not have parameter. ([@soutaro][])
* [#3380](https://github.com/rubocop-hq/rubocop/issues/3380): Fix false positive in `Style/TrailingUnderscoreVariable` cop. ([@drenmi][])
* [#3388](https://github.com/rubocop-hq/rubocop/issues/3388): Fix bug where `Lint/ShadowedException` would register an offense when rescuing different numbers of custom exceptions in multiple rescue groups. ([@rrosenblum][])
* [#3386](https://github.com/rubocop-hq/rubocop/issues/3386): Make `VariableForce` understand an empty RegExp literal as LHS to `=~`. ([@drenmi][])
* [#3421](https://github.com/rubocop-hq/rubocop/pull/3421): Fix clobbering `inherit_from` additions when not using Namespaces in the configs. ([@nicklamuro][])
* [#3425](https://github.com/rubocop-hq/rubocop/pull/3425): Fix bug for invalid bytes in UTF-8 in `Lint/PercentStringArray` cop. ([@pocke][])
* [#3374](https://github.com/rubocop-hq/rubocop/issues/3374): Make `SpaceInsideBlockBraces` and `SpaceBeforeBlockBraces` not depend on `BlockDelimiters` configuration. ([@jonas054][])
* Fix error in `Lint/ShadowedException` cop for higher number of rescue groups. ([@groddeck][])
* [#3456](https://github.com/rubocop-hq/rubocop/pull/3456): Don't crash on a multiline empty brace in `Style/MultilineMethodCallBraceLayout`. ([@pocke][])
* [#3423](https://github.com/rubocop-hq/rubocop/issues/3423): Checks if .rubocop is a file before parsing. ([@joejuzl][])
* [#3439](https://github.com/rubocop-hq/rubocop/issues/3439): Fix variable assignment check not working properly when a block is used in `Rails/SaveBang`. ([@QuinnHarris][])
* [#3401](https://github.com/rubocop-hq/rubocop/issues/3401): Read file contents in binary mode so `Style/EndOfLine` works on Windows. ([@jonas054][])
* [#3450](https://github.com/rubocop-hq/rubocop/issues/3450): Prevent `Style/TernaryParentheses` cop from making unsafe corrections. ([@drenmi][])
* [#3460](https://github.com/rubocop-hq/rubocop/issues/3460): Fix false positives in `Style/InlineComment` cop. ([@drenmi][])
* [#3485](https://github.com/rubocop-hq/rubocop/issues/3485): Make OneLineConditional cop not register offense for empty else. ([@tejasbubane][])
* [#3508](https://github.com/rubocop-hq/rubocop/pull/3508): Fix false negatives in `Rails/NotNullColumn`. ([@pocke][])
* [#3462](https://github.com/rubocop-hq/rubocop/issues/3462): Don't create MultilineMethodCallBraceLayout offenses for single-line method calls when receiver spans multiple lines. ([@maxjacobson][])

### Changes

* [#3341](https://github.com/rubocop-hq/rubocop/issues/3341): Exclude RSpec tests from inspection by `Style/NumericPredicate` cop. ([@drenmi][])
* Rename `Lint/UselessArraySplat` to `Lint/UnneededSplatExpansion`, and add functionality to check for unnecessary expansion of other literals. ([@rrosenblum][])
* No longer register an offense for splat expansion of an array literal in `Performance/CaseWhenSplat`. `Lint/UnneededSplatExpansion` now handles this behavior. ([@rrosenblum][])
* `Lint/InheritException` restricts inheriting from standard library subclasses of `Exception`. ([@metcalf][])
* No longer register an offense if the first line of code starts with `#\` in `Style/LeadingCommentSpace`. `config.ru` files consider such lines as options. ([@scottohara][])
* [#3292](https://github.com/rubocop-hq/rubocop/issues/3292): Remove `Performance/PushSplat` as it can produce code that is slower or even cause failure. ([@jonas054][])

## 0.42.0 (2016-07-25)

### New features

* [#3306](https://github.com/rubocop-hq/rubocop/issues/3306): Add autocorrection for `Style/EachWithObject`. ([@owst][])
* Add new `Style/TernaryParentheses` cop. ([@drenmi][])
* [#3136](https://github.com/rubocop-hq/rubocop/issues/3136): Add config for `UselessAccessModifier` so it can be made aware of ActiveSupport's `concerning` and `class_methods` methods. ([@maxjacobson][])
* [#3128](https://github.com/rubocop-hq/rubocop/issues/3128): Add new `Rails/SaveBang` cop. ([@QuinnHarris][])
* Add new `Style/NumericPredicate` cop. ([@drenmi][])

### Bug fixes

* [#3271](https://github.com/rubocop-hq/rubocop/issues/3271): Fix bad auto-correct for `Style/EachForSimpleLoop` cop. ([@drenmi][])
* [#3288](https://github.com/rubocop-hq/rubocop/issues/3288): Fix auto-correct of word and symbol arrays in `Style/ParallelAssignment` cop. ([@jonas054][])
* [#3307](https://github.com/rubocop-hq/rubocop/issues/3307): Fix exception when inspecting an operator assignment with `Style/MethodCallParentheses` cop. ([@drenmi][])
* [#3316](https://github.com/rubocop-hq/rubocop/issues/3316): Fix error for blocks without arguments in `Style/SingleLineBlockParams` cop. ([@owst][])
* [#3320](https://github.com/rubocop-hq/rubocop/issues/3320): Make `Style/OpMethod` aware of the backtick method. ([@drenmi][])
* Do not register an offense in `Lint/ShadowedException` when rescuing an exception built into Ruby before a custom exception. ([@rrosenblum][])

### Changes

* [#2645](https://github.com/rubocop-hq/rubocop/issues/2645): `Style/EmptyLiteral` no longer generates an offense for `String.new` when using frozen string literals. ([@drenmi][])
* [#3308](https://github.com/rubocop-hq/rubocop/issues/3308): Make `Lint/NextWithoutAccumulator` aware of nested enumeration. ([@drenmi][])
* Extend `Style/MethodMissing` cop to check for the conditions in the style guide. ([@drenmi][])
* [#3325](https://github.com/rubocop-hq/rubocop/issues/3325): Drop support for MRI 1.9.3. ([@drenmi][])
* Add support for MRI 2.4. ([@dvandersluis][])
* [#3256](https://github.com/rubocop-hq/rubocop/issues/3256): Highlight the closing brace in `Style/Multiline...BraceLayout` cops. ([@jonas054][])
* Always register an offense when rescuing `Exception` before or along with any other exception in `Lint/ShadowedException`. ([@rrosenblum][])

## 0.41.2 (2016-07-07)

### Bug fixes

* [#3248](https://github.com/rubocop-hq/rubocop/issues/3248): Support 'ruby-' prefix in `.ruby-version`. ([@tjwp][])
* [#3250](https://github.com/rubocop-hq/rubocop/pull/3250): Make regexp for cop names less restrictive in CommentConfig lines. ([@tjwp][])
* [#3261](https://github.com/rubocop-hq/rubocop/pull/3261): Prefer `TargetRubyVersion` to `.ruby-version`. ([@tjwp][])
* [#3249](https://github.com/rubocop-hq/rubocop/issues/3249): Account for `rescue nil` in `Style/ShadowedException`. ([@rrosenblum][])
* Modify the highlighting in `Style/ShadowedException` to be more useful. Highlight just `rescue` area. ([@rrosenblum][])
* [#3129](https://github.com/rubocop-hq/rubocop/issues/3129): Fix `Style/MethodCallParentheses` to work with multiple assignments. ([@tejasbubane][])
* [#3247](https://github.com/rubocop-hq/rubocop/issues/3247): Ensure whitespace after beginning of block in `Style/BlockDelimiters`. ([@tjwp][])
* [#2941](https://github.com/rubocop-hq/rubocop/issues/2941): Make sure `Lint/UnneededDisable` can do auto-correction. ([@jonas054][])
* [#3269](https://github.com/rubocop-hq/rubocop/pull/3269):  Fix `Lint/ShadowedException` to block arbitrary code execution. ([@pocke][])
* [#3266](https://github.com/rubocop-hq/rubocop/issues/3266): Handle empty parentheses in `Performance/RedundantBlockCall` auto-correct. ([@jonas054][])
* [#3272](https://github.com/rubocop-hq/rubocop/issues/3272): Add escape character missing to LITERAL_REGEX. ([@pocke][])
* [#3255](https://github.com/rubocop-hq/rubocop/issues/3255): Fix auto-correct for `Style/RaiseArgs` when constructing exception without arguments. ([@drenmi][])
* [#3294](https://github.com/rubocop-hq/rubocop/pull/3294): Allow to use `Time.zone_default`. ([@Tei][])
* [#3300](https://github.com/rubocop-hq/rubocop/issues/3300): Do not replace `%q()`s containing escaped non-backslashes. ([@owst][])

### Changes

* [#3230](https://github.com/rubocop-hq/rubocop/issues/3230): Improve highlighting for `Style/AsciiComments` cop. ([@drenmi][])
* Improve highlighting for `Style/AsciiIdentifiers` cop. ([@drenmi][])
* [#3265](https://github.com/rubocop-hq/rubocop/issues/3265): Include --no-offense-counts in .rubocop_todo.yml. ([@vergenzt][])

## 0.41.1 (2016-06-26)

### Bug fixes

* [#3245](https://github.com/rubocop-hq/rubocop/pull/3245): Fix `UniqBeforePluck` cop by solving difference of config name. ([@pocke][])

## 0.41.0 (2016-06-25)

### New features

* [#2956](https://github.com/rubocop-hq/rubocop/issues/2956): Prefer `.ruby-version` to `TargetRubyVersion`. ([@pclalv][])
* [#3095](https://github.com/rubocop-hq/rubocop/issues/3095): Add `IndentationWidth` configuration parameter for `Style/AlignParameters` cop. ([@alexdowad][])
* [#3066](https://github.com/rubocop-hq/rubocop/issues/3066): Add new `Style/ImplicitRuntimeError` cop which advises the use of an explicit exception class when raising an error. ([@alexdowad][])
* [#3018](https://github.com/rubocop-hq/rubocop/issues/3018): Add new `Style/EachForSimpleLoop` cop which advises the use of `Integer#times` for simple loops which iterate a fixed number of times. ([@alexdowad][])
* [#2595](https://github.com/rubocop-hq/rubocop/issues/2595): New `compact` style for `Style/SpaceInsideLiteralHashBraces`. ([@alexdowad][])
* [#2927](https://github.com/rubocop-hq/rubocop/issues/2927): Add autocorrect for `Rails/Validation` cop. ([@neodelf][])
* [#3135](https://github.com/rubocop-hq/rubocop/pull/3135): Add new `Rails/OutputSafety` cop. ([@josh][])
* [#3164](https://github.com/rubocop-hq/rubocop/pull/3164): Add [Fastlane](https://fastlane.tools/)'s Fastfile to the default Includes. ([@jules2689][])
* [#3173](https://github.com/rubocop-hq/rubocop/pull/3173): Make `Style/ModuleFunction` configurable with `module_function` and `extend_self` styles. ([@tjwp][])
* [#3105](https://github.com/rubocop-hq/rubocop/issues/3105): Add new `Rails/RequestReferer` cop. ([@giannileggio][])
* [#3200](https://github.com/rubocop-hq/rubocop/pull/3200): Add autocorrect for `Style/EachForSimpleLoop` cop. ([@tejasbubane][])
* [#3058](https://github.com/rubocop-hq/rubocop/issues/3058): Add new `Style/SpaceInsideArrayPercentLiteral` cop. ([@owst][])
* [#3058](https://github.com/rubocop-hq/rubocop/issues/3058): Add new `Style/SpaceInsidePercentLiteralDelimiters` cop. ([@owst][])
* [#3179](https://github.com/rubocop-hq/rubocop/pull/3179): Expose files to support testings Cops using RSpec. ([@tjwp][])
* [#3191](https://github.com/rubocop-hq/rubocop/issues/3191): Allow arbitrary comments after cop names in CommentConfig lines (e.g. rubocop:enable). ([@owst][])
* [#3165](https://github.com/rubocop-hq/rubocop/pull/3165): Add new `Lint/PercentStringArray` cop. ([@owst][])
* [#3165](https://github.com/rubocop-hq/rubocop/pull/3165): Add new `Lint/PercentSymbolArray` cop. ([@owst][])
* [#3177](https://github.com/rubocop-hq/rubocop/pull/3177): Add new `Style/NumericLiteralPrefix` cop. ([@tejasbubane][])
* [#1646](https://github.com/rubocop-hq/rubocop/issues/1646): Add configuration style `indented_relative_to_receiver` for `Style/MultilineMethodCallIndentation`. ([@jonas054][])
* New cop `Lint/ShadowedException` checks for the order which exceptions are rescued to avoid rescueing a less specific exception before a more specific exception. ([@rrosenblum][])
* [#3127](https://github.com/rubocop-hq/rubocop/pull/3127): New cop `Lint/InheritException` checks for error classes inheriting from `Exception`, and instead suggests `RuntimeError` or `StandardError`. ([@drenmi][])
* Add new `Performance/PushSplat` cop. ([@segiddins][])
* [#3089](https://github.com/rubocop-hq/rubocop/issues/3089): Add new `Rails/Exit` cop. ([@sgringwe][])
* [#3104](https://github.com/rubocop-hq/rubocop/issues/3104): Add new `Style/MethodMissing` cop. ([@haziqhafizuddin][])

### Bug fixes

* [#3005](https://github.com/rubocop-hq/rubocop/issues/3005): Symlink protection prevents use of caching in CI context. ([@urbanautomaton][])
* [#3037](https://github.com/rubocop-hq/rubocop/issues/3037): `Style/StringLiterals` understands that a bare '#', not '#@variable' or '#{interpolation}', does not require double quotes. ([@alexdowad][])
* [#2722](https://github.com/rubocop-hq/rubocop/issues/2722): `Style/ExtraSpacing` does not attempt to align an equals sign in an argument list with one in an assignment statement. ([@alexdowad][])
* [#3133](https://github.com/rubocop-hq/rubocop/issues/3133): `Style/MultilineMethodCallBraceLayout` does not register offenses for single-line calls. ([@alexdowad][])
* [#3170](https://github.com/rubocop-hq/rubocop/issues/3170): `Style/MutableConstant` does not infinite-loop when correcting an array with no brackets. ([@alexdowad][])
* [#3150](https://github.com/rubocop-hq/rubocop/issues/3150): Fix auto-correct for Style/MultilineArrayBraceLayout. ([@jspanjers][])
* [#3192](https://github.com/rubocop-hq/rubocop/pull/3192): Fix `Lint/UnusedBlockArgument`'s `IgnoreEmptyBlocks` parameter from being removed from configuration. ([@jfelchner][])
* [#3114](https://github.com/rubocop-hq/rubocop/issues/3114): Fix alignment `end` when auto-correcting `Style/EmptyElse`. ([@rrosenblum][])
* [#3120](https://github.com/rubocop-hq/rubocop/issues/3120): Fix `Lint/UselessAccessModifier` reporting useless access modifiers inside {Class,Module,Struct}.new blocks. ([@owst][])
* [#3125](https://github.com/rubocop-hq/rubocop/issues/3125): Fix `Rails/UniqBeforePluck` to ignore `uniq` with block. ([@tejasbubane][])
* [#3116](https://github.com/rubocop-hq/rubocop/issues/3116): `Style/SpaceAroundKeyword` allows `&.` method calls after `super` and `yield`. ([@segiddins][])
* [#3131](https://github.com/rubocop-hq/rubocop/issues/3131): Fix `Style/ZeroLengthPredicate` to ignore `size` and `length` variables. ([@tejasbubane][])
* [#3146](https://github.com/rubocop-hq/rubocop/pull/3146): Fix `NegatedIf` and `NegatedWhile` to ignore double negations. ([@natalzia-paperless][])
* [#3140](https://github.com/rubocop-hq/rubocop/pull/3140): `Style/FrozenStringLiteralComment` works with file doesn't have any tokens. ([@pocke][])
* [#3154](https://github.com/rubocop-hq/rubocop/issues/3154): Fix handling of `()` in `Style/RedundantParentheses`. ([@lumeet][])
* [#3155](https://github.com/rubocop-hq/rubocop/issues/3155): Fix `Style/SpaceAfterNot` reporting on the `not` keyword. ([@NobodysNightmare][])
* [#3160](https://github.com/rubocop-hq/rubocop/pull/3160): `Style/Lambda` fix whitespacing when auto-correcting unparenthesized arguments. ([@palkan][])
* [#2944](https://github.com/rubocop-hq/rubocop/issues/2944): Don't crash on strings that span multiple lines but only have one pair of delimiters in `Style/StringLiterals`. ([@jonas054][])
* [#3157](https://github.com/rubocop-hq/rubocop/issues/3157): Don't let `LineEndConcatenation` and `UnneededInterpolation` make changes to the same string during auto-correct. ([@jonas054][])
* [#3187](https://github.com/rubocop-hq/rubocop/issues/3187): Let `Style/BlockDelimiters` ignore blocks in *all* method arguments. ([@jonas054][])
* Modify `Style/ParallelAssignment` to use implicit begins when parallel assignment uses a `rescue` modifier and is the only thing in the method. ([@rrosenblum][])
* [#3217](https://github.com/rubocop-hq/rubocop/pull/3217): Fix output of ellipses for multi-line offense ranges in HTML formatter. ([@jonas054][])
* [#3207](https://github.com/rubocop-hq/rubocop/issues/3207): Auto-correct modifier `while`/`until` and `begin`..`end` + `while`/`until` in `Style/InfiniteLoop`. ([@jonas054][])
* [#3202](https://github.com/rubocop-hq/rubocop/issues/3202): Fix `Style/EmptyElse` registering wrong offenses and thus making RuboCop crash. ([@deivid-rodriguez][])
* [#3183](https://github.com/rubocop-hq/rubocop/issues/3183): Ensure `Style/SpaceInsideBlockBraces` reports offenses for multi-line blocks. ([@owst][])
* [#3017](https://github.com/rubocop-hq/rubocop/issues/3017): Fix `Style/StringLiterals` to register offenses on non-ascii strings. ([@deivid-rodriguez][])
* [#3056](https://github.com/rubocop-hq/rubocop/issues/3056): Fix `Style/StringLiterals` to register offenses on non-ascii strings. ([@deivid-rodriguez][])
* [#2986](https://github.com/rubocop-hq/rubocop/issues/2986): Fix `RedundantBlockCall` to not report calls that pass block arguments, or where the block has been overridden. ([@owst][])
* [#3223](https://github.com/rubocop-hq/rubocop/issues/3223): Return can take many arguments. ([@ptarjan][])
* [#3239](https://github.com/rubocop-hq/rubocop/pull/3239): Fix bug with --auto-gen-config and a file that does not exist. ([@meganemura][])
* [#3138](https://github.com/rubocop-hq/rubocop/issues/3138): Fix RuboCop crashing when config file contains utf-8 characters and external encoding is not utf-8. ([@deivid-rodriguez][])
* [#3175](https://github.com/rubocop-hq/rubocop/pull/3175): Generate 'Exclude' list for the cops with configurable enforced style to `.rubocop_todo.yml` if different styles are used. ([@flexoid][])
* [#3231](https://github.com/rubocop-hq/rubocop/pull/3231): Make `Rails/UniqBeforePluck` more conservative. ([@tjwp][])

### Changes

* [#3149](https://github.com/rubocop-hq/rubocop/pull/3149): Make `Style/HashSyntax` configurable to not report hash rocket syntax for symbols ending with ? or ! when using ruby19 style. ([@owst][])
* [#1758](https://github.com/rubocop-hq/rubocop/issues/1758): Let `Style/ClosingParenthesisIndentation` follow `Style/AlignParameters` configuration for method calls. ([@jonas054][])
* [#3224](https://github.com/rubocop-hq/rubocop/issues/3224): Rename `Style/DeprecatedHashMethods` to `Style/PreferredHashMethods`. ([@tejasbubane][])

## 0.40.0 (2016-05-09)

### New features

* [#2997](https://github.com/rubocop-hq/rubocop/pull/2997): `Performance/CaseWhenSplat` can now identify multiple offenses in the same branch and offenses that do not occur as the first argument. ([@rrosenblum][])
* [#2928](https://github.com/rubocop-hq/rubocop/issues/2928): `Style/NestedParenthesizedCalls` cop can auto-correct. ([@drenmi][])
* `Style/RaiseArgs` cop can auto-correct. ([@drenmi][])
* [#2993](https://github.com/rubocop-hq/rubocop/pull/2993): `Style/SpaceAfterColon` now checks optional keyword arguments. ([@owst][])
* [#3003](https://github.com/rubocop-hq/rubocop/pull/3003): Read command line options from `.rubocop` file and `RUBOCOP_OPTS` environment variable. ([@bolshakov][])
* [#2857](https://github.com/rubocop-hq/rubocop/issues/2857): `Style/MultilineArrayBraceLayout` enforced style is configurable and supports `symmetrical` and `new_line` options. ([@panthomakos][])
* [#2857](https://github.com/rubocop-hq/rubocop/issues/2857): `Style/MultilineHashBraceLayout` enforced style is configurable and supports `symmetrical` and `new_line` options. ([@panthomakos][])
* [#2857](https://github.com/rubocop-hq/rubocop/issues/2857): `Style/MultilineMethodCallBraceLayout` enforced style is configurable and supports `symmetrical` and `new_line` options. ([@panthomakos][])
* [#2857](https://github.com/rubocop-hq/rubocop/issues/2857): `Style/MultilineMethodDefinitionBraceLayout` enforced style is configurable and supports `symmetrical` and `new_line` options. ([@panthomakos][])
* [#3052](https://github.com/rubocop-hq/rubocop/pull/3052): `Style/MultilineArrayBraceLayout` enforced style supports `same_line` option. ([@panthomakos][])
* [#3052](https://github.com/rubocop-hq/rubocop/pull/3052): `Style/MultilineHashBraceLayout` enforced style supports `same_line` option. ([@panthomakos][])
* [#3052](https://github.com/rubocop-hq/rubocop/pull/3052): `Style/MultilineMethodCallBraceLayout` enforced style supports `same_line` option. ([@panthomakos][])
* [#3052](https://github.com/rubocop-hq/rubocop/pull/3052): `Style/MultilineMethodDefinitionBraceLayout` enforced style supports `same_line` option. ([@panthomakos][])
* [#3019](https://github.com/rubocop-hq/rubocop/issues/3019): Add new `Style/EmptyCaseCondition` cop. ([@owst][], [@rrosenblum][])
* [#3072](https://github.com/rubocop-hq/rubocop/pull/3072): Add new `Lint/UselessArraySplat` cop. ([@owst][])
* [#3022](https://github.com/rubocop-hq/rubocop/issues/3022): `Style/Lambda` enforced style supports `literal` option. ([@drenmi][])
* [#2909](https://github.com/rubocop-hq/rubocop/issues/2909): `Style/Lambda` enforced style supports `lambda` option. ([@drenmi][])
* [#3092](https://github.com/rubocop-hq/rubocop/pull/3092): Allow `Style/Encoding` to enforce using no encoding comments. ([@NobodysNightmare][])
* New cop `Rails/UniqBeforePluck` checks that `uniq` is used before `pluck`. ([@tjwp][])

### Bug fixes

* [#3112](https://github.com/rubocop-hq/rubocop/issues/3112): Fix `Style/ClassAndModuleChildren` for nested classes with explicit superclass. ([@jspanjers][])
* [#3032](https://github.com/rubocop-hq/rubocop/issues/3032): Fix autocorrecting parentheses for predicate methods without space before args. ([@graemeboy][])
* [#3000](https://github.com/rubocop-hq/rubocop/pull/3000): Fix encoding crash on HTML output. ([@gerrywastaken][])
* [#2983](https://github.com/rubocop-hq/rubocop/pull/2983): `Style/AlignParameters` message was clarified for `with_fixed_indentation` style. ([@dylanahsmith][])
* [#2314](https://github.com/rubocop-hq/rubocop/pull/2314): Ignore `UnusedBlockArgument` for keyword arguments. ([@volkert][])
* [#2975](https://github.com/rubocop-hq/rubocop/issues/2975): Make comment indentation before `)` consistent with comment indentation before `}` or `]`. ([@jonas054][])
* [#3010](https://github.com/rubocop-hq/rubocop/issues/3010): Fix double reporting/correction of spaces after ternary operator colons (now only reported by `Style/SpaceAroundOperators`, and not `Style/SpaceAfterColon` too). ([@owst][])
* [#3006](https://github.com/rubocop-hq/rubocop/issues/3006): Register an offense for calling `merge!` on a method on a variable inside `each_with_object` in `Performance/RedundantMerge`. ([@lumeet][], [@rrosenblum][])
* [#2886](https://github.com/rubocop-hq/rubocop/issues/2886): Custom cop changes now bust the cache. ([@ptarjan][])
* [#3043](https://github.com/rubocop-hq/rubocop/issues/3043): `Style/SpaceAfterNot` will now register an offense for a receiver that is wrapped in parentheses. ([@rrosenblum][])
* [#3039](https://github.com/rubocop-hq/rubocop/issues/3039): Accept `match` without a receiver in `Performance/EndWith`. ([@lumeet][])
* [#3039](https://github.com/rubocop-hq/rubocop/issues/3039): Accept `match` without a receiver in `Performance/StartWith`. ([@lumeet][])
* [#3048](https://github.com/rubocop-hq/rubocop/issues/3048): `Lint/NestedMethodDefinition` shouldn't flag methods defined on Structs. ([@owst][])
* [#2912](https://github.com/rubocop-hq/rubocop/issues/2912): Check whether a line is aligned with the following line if the preceding line is not an assignment. ([@akihiro17][])
* [#3036](https://github.com/rubocop-hq/rubocop/issues/3036): Don't let `Lint/UnneededDisable` inspect files that are excluded for the cop. ([@jonas054][])
* [#2874](https://github.com/rubocop-hq/rubocop/issues/2874): Fix bug when the closing parenthesis is preceded by a newline in array and hash literals in `Style/RedundantParentheses`. ([@lumeet][])
* [#3049](https://github.com/rubocop-hq/rubocop/issues/3049): Make `Lint/UselessAccessModifier` detect conditionally defined methods and correctly handle dynamically defined methods and singleton class methods. ([@owst][])
* [#3004](https://github.com/rubocop-hq/rubocop/pull/3004): Don't add `Style/Alias` offenses for use of `alias` in `instance_eval` blocks, since object instances don't respond to `alias_method`. ([@magni-][])
* [#3061](https://github.com/rubocop-hq/rubocop/pull/3061): Custom cops now show up in --show-cops. ([@ptarjan][])
* [#3088](https://github.com/rubocop-hq/rubocop/pull/3088): Ignore offenses that involve conflicting HEREDOCs in the `Style/Multiline*BraceLayout` cops. ([@panthomakos][])
* [#3083](https://github.com/rubocop-hq/rubocop/issues/3083): Do not register an offense for splat block args in `Style/SymbolProc`. ([@rrosenblum][])
* [#3063](https://github.com/rubocop-hq/rubocop/issues/3063): Don't auto-correct `a + \` into `a + \\` in `Style/LineEndConcatenation`. ([@jonas054][])
* [#3034](https://github.com/rubocop-hq/rubocop/issues/3034): Report offenses for `RuntimeError.new(msg)` in `Style/RedundantException`. ([@jonas054][])
* [#3016](https://github.com/rubocop-hq/rubocop/issues/3016): `Style/SpaceAfterComma` now uses `Style/SpaceInsideHashLiteralBraces`'s setting. ([@ptarjan][])

### Changes

* [#2995](https://github.com/rubocop-hq/rubocop/issues/2995): Removed deprecated path matching syntax. ([@gerrywastaken][])
* [#3025](https://github.com/rubocop-hq/rubocop/pull/3025): Removed deprecation warnings for `rubocop-todo.yml`. ([@ptarjan][])
* [#3028](https://github.com/rubocop-hq/rubocop/pull/3028): Add `define_method` to the default list of `IgnoredMethods` of `Style/SymbolProc`. ([@jastkand][])
* [#3064](https://github.com/rubocop-hq/rubocop/pull/3064): `Style/SpaceAfterNot` highlights the entire expression instead of just the exlamation mark. ([@rrosenblum][])
* [#3085](https://github.com/rubocop-hq/rubocop/pull/3085): Enable `Style/MultilineArrayBraceLayout` and `Style/MultilineHashBraceLayout` with the `symmetrical` style by default. ([@panthomakos][])
* [#3091](https://github.com/rubocop-hq/rubocop/pull/3091): Enable `Style/MultilineMethodCallBraceLayout` and `Style/MultilineMethodDefinitionBraceLayout` with the `symmetrical` style by default. ([@panthomakos][])
* [#1830](https://github.com/rubocop-hq/rubocop/pull/1830): `Style/PredicateName` now ignores the `spec/` directory, since there is a strong convention for using `have_*` and `be_*` helper methods in RSpec. ([@gylaz][])

## 0.39.0 (2016-03-27)

### New features

* `Performance/TimesMap` cop can auto-correct. ([@lumeet][])
* `Style/ZeroLengthPredicate` cop can auto-correct. ([@lumeet][])
* [#2828](https://github.com/rubocop-hq/rubocop/issues/2828): `Style/ConditionalAssignment` is now configurable to enforce assignment inside of conditions or to enforce assignment to conditions. ([@rrosenblum][])
* [#2862](https://github.com/rubocop-hq/rubocop/pull/2862): `Performance/Detect` and `Performance/Count` have a new configuration `SafeMode` that is defaulted to `true`. These cops have known issues with `Rails` and other ORM frameworks. With this default configuration, these cops will not run if the `Rails` cops are enabled. ([@rrosenblum][])
* `Style/IfUnlessModifierOfIfUnless` cop added. ([@amuino][])

### Bug fixes

* [#2948](https://github.com/rubocop-hq/rubocop/issues/2948): `Style/SpaceAroundKeyword` should allow `yield[n]` and `super[n]`. ([@laurelfan][])
* [#2950](https://github.com/rubocop-hq/rubocop/issues/2950): Fix auto-correcting cases in which precedence has changed in `Style/OneLineConditional`. ([@lumeet][])
* [#2947](https://github.com/rubocop-hq/rubocop/issues/2947): Fix auto-correcting `if-then` in `Style/Next`. ([@lumeet][])
* [#2904](https://github.com/rubocop-hq/rubocop/issues/2904): `Style/RedundantParentheses` doesn't flag `-(1.method)` or `+(1.method)`, since removing the parentheses would change the meaning of these expressions. ([@alexdowad][])
* [#2958](https://github.com/rubocop-hq/rubocop/issues/2958): `Style/MultilineMethodCallIndentation` doesn't fail when inspecting unary ops which span multiple lines. ([@alexdowad][])
* [#2959](https://github.com/rubocop-hq/rubocop/issues/2959): `Lint/LiteralInInterpolation` doesn't report offenses for iranges and eranges with non-literal endpoints. ([@alexdowad][])
* [#2960](https://github.com/rubocop-hq/rubocop/issues/2960): `Lint/AssignmentInCondition` catches method assignments (like `obj.attr = val`) in a condition. ([@alexdowad][])
* [#2871](https://github.com/rubocop-hq/rubocop/issues/2871): Second solution for possible encoding incompatibility when outputting an HTML report. ([@jonas054][])
* [#2967](https://github.com/rubocop-hq/rubocop/pull/2967): Fix auto-correcting of `===`, `<=`, and `>=` in `Style/ConditionalAssignment`. ([@rrosenblum][])
* [#2977](https://github.com/rubocop-hq/rubocop/issues/2977): Fix auto-correcting of `"#{$!}"` in `Style/SpecialGlobalVars`. ([@lumeet][])
* [#2935](https://github.com/rubocop-hq/rubocop/issues/2935): Make configuration loading work if `SafeYAML.load` is private. ([@jonas054][])

### Changes

* `require:` only does relative includes when it starts with a `.`. ([@ptarjan][])
* `Style/IfUnlessModifier` does not trigger if the body is another conditional. ([@amuino][])
* [#2963](https://github.com/rubocop-hq/rubocop/pull/2963): `Performance/RedundantMerge` will now register an offense inside of `each_with_object`. ([@rrosenblum][])

## 0.38.0 (2016-03-09)

### New features

* `Style/UnlessElse` cop can auto-correct. ([@lumeet][])
* [#2629](https://github.com/rubocop-hq/rubocop/pull/2629): Add a new public API method, `highlighted_area` to offense. This method returns the range of the highlighted portion of an offense. ([@rrosenblum][])
* `Style/OneLineConditional` cop can auto-correct. ([@lumeet][])
* [#2905](https://github.com/rubocop-hq/rubocop/issues/2905): `Style/ZeroLengthPredicate` flags code like `array.length < 1`, `1 > array.length`, and so on. ([@alexdowad][])
* [#2892](https://github.com/rubocop-hq/rubocop/issues/2892): `Lint/BlockAlignment` cop can be configured to be stricter. ([@ptarjan][])
* `Style/Not` is able to autocorrect in cases where parentheses must be added to preserve the meaning of an expression. ([@alexdowad][])
* `Style/Not` auto-corrects comparison expressions by removing `not` and using the opposite comparison. ([@alexdowad][])

### Bug fixes

* Add `require 'time'` to `remote_config.rb` to avoid "undefined method \`rfc2822'". ([@necojackarc][])
* Replace `Rake::TaskManager#last_comment` with `Rake::TaskManager#last_description` for Rake 11 compatibility. ([@tbrisker][])
* Fix false positive in `Style/TrailingCommaInArguments` & `Style/TrailingCommaInLiteral` cops with consistent_comma style. ([@meganemura][])
* [#2861](https://github.com/rubocop-hq/rubocop/pull/2861): Fix false positive in `Style/SpaceAroundKeyword` for `rescue(...`. ([@rrosenblum][])
* [#2832](https://github.com/rubocop-hq/rubocop/issues/2832): `Style/MultilineOperationIndentation` treats operations inside blocks inside other operations correctly. ([@jonas054][])
* [#2865](https://github.com/rubocop-hq/rubocop/issues/2865): Change `require:` in config to be relative to the `.rubocop.yml` file itself. ([@ptarjan][])
* [#2845](https://github.com/rubocop-hq/rubocop/issues/2845): Handle heredocs in `Style/MultilineLiteralBraceLayout` auto-correct. ([@jonas054][])
* [#2848](https://github.com/rubocop-hq/rubocop/issues/2848): Handle comments inside arrays in `Style/MultilineArrayBraceLayout` auto-correct. ([@jonas054][])
* `Style/TrivialAccessors` allows predicate methods by default. ([@alexdowad][])
* [#2869](https://github.com/rubocop-hq/rubocop/issues/2869): Offenses which occur in the body of a `when` clause with multiple arguments will not be missed. ([@alexdowad][])
* `Lint/UselessAccessModifier` recognizes method defs inside a `begin` block. ([@alexdowad][])
* [#2870](https://github.com/rubocop-hq/rubocop/issues/2870): `Lint/UselessAccessModifier` recognizes method definitions which are passed as an argument to a method call. ([@alexdowad][])
* [#2859](https://github.com/rubocop-hq/rubocop/issues/2859): `Style/RedundantParentheses` doesn't consider the parentheses in `(!receiver.method arg)` to be redundant, since they might change the meaning of an expression, depending on precedence. ([@alexdowad][])
* [#2852](https://github.com/rubocop-hq/rubocop/issues/2852): `Performance/Casecmp` doesn't flag uses of `downcase`/`upcase` which are not redundant. ([@alexdowad][])
* [#2850](https://github.com/rubocop-hq/rubocop/issues/2850): `Style/FileName` doesn't choke on empty files with spaces in their names. ([@alexdowad][])
* [#2834](https://github.com/rubocop-hq/rubocop/issues/2834): When configured as `ConsistentQuotesInMultiline: true`, `Style/StringLiterals` doesn't error out when inspecting a heredoc with differing indentation across multiple lines. ([@alexdowad][])
* [#2876](https://github.com/rubocop-hq/rubocop/issues/2876): `Style/ConditionalAssignment` behaves correctly when assignment statement uses a character which has a special meaning in a regex. ([@alexdowad][])
* [#2877](https://github.com/rubocop-hq/rubocop/issues/2877): `Style/SpaceAroundKeyword` doesn't flag `!super.method`, `!yield.method`, and so on. ([@alexdowad][])
* [#2631](https://github.com/rubocop-hq/rubocop/issues/2631): `Style/Encoding` can remove unneeded encoding comment when autocorrecting with `when_needed` style. ([@alexdowad][])
* [#2860](https://github.com/rubocop-hq/rubocop/issues/2860): Fix false positive in `Rails/Date` when `to_time` is chained with safe method. ([@palkan][])
* [#2898](https://github.com/rubocop-hq/rubocop/issues/2898): `Lint/NestedMethodDefinition` allows methods defined inside `Class.new(S)` blocks. ([@segiddins][])
* [#2894](https://github.com/rubocop-hq/rubocop/issues/2894): Fix auto-correct an unless with a comparison operator. ([@jweir][])
* [#2911](https://github.com/rubocop-hq/rubocop/issues/2911): `Style/ClassAndModuleChildren` doesn't flag nested class definitions, where the outer class has an explicit superclass (because such definitions can't be converted to `compact` style). ([@alexdowad][])
* [#2871](https://github.com/rubocop-hq/rubocop/issues/2871): Don't crash when offense messages are read back from cache with `ASCII-8BIT` encoding and output as HTML or JSON. ([@jonas054][])
* [#2901](https://github.com/rubocop-hq/rubocop/issues/2901): Don't crash when `ENV['HOME']` is undefined. ([@mikegee][])
* [#2627](https://github.com/rubocop-hq/rubocop/issues/2627): `Style/BlockDelimiters` does not flag blocks delimited by `{}` when a block call is the final value in a hash with implicit braces (one which is the last argument to an outer method call). ([@alexdowad][])

### Changes

* Update Rake to version 11. ([@tbrisker][])
* [#2629](https://github.com/rubocop-hq/rubocop/pull/2629): Change the offense range for metrics cops to default to `expression` instead of `keyword` (the offense now spans the entire method, class, or module). ([@rrosenblum][])
* [#2891](https://github.com/rubocop-hq/rubocop/pull/2891): Change the caching of remote configs to live alongside the parent file. ([@Fryguy][])
* [#2662](https://github.com/rubocop-hq/rubocop/issues/2662): When setting options for Rake task, nested arrays can be used in the `options`, `formatters`, and `requires` arrays. ([@alexdowad][])
* [#2925](https://github.com/rubocop-hq/rubocop/pull/2925): Bump unicode-display_width dependency to >= 1.0.1. ([@jspanjers][])
* [#2875](https://github.com/rubocop-hq/rubocop/issues/2875): `Style/SignalException` does not flag calls to `fail` if a custom method named `fail` is defined in the same file. ([@alexdowad][])
* [#2923](https://github.com/rubocop-hq/rubocop/issues/2923): `Style/FileName` considers file names which contain a ? or ! character to still be "snake case". ([@alexdowad][])
* [#2879](https://github.com/rubocop-hq/rubocop/issues/2879): When autocorrecting, `Lint/UnusedMethodArgument` removes unused block arguments rather than simply prefixing them with an underscore. ([@alexdowad][])

## 0.37.2 (2016-02-11)

### Bug fixes

* Fix auto-correction of array and hash literals in `Lint/LiteralInInterpolation`. ([@lumeet][])
* [#2815](https://github.com/rubocop-hq/rubocop/pull/2815): Fix missing assets for html formatter. ([@prsimp][])
* `Style/RedundantParentheses` catches offenses involving the 2nd argument to a method call without parentheses, if the 2nd argument is a hash. ([@alexdowad][])
* `Style/RedundantParentheses` catches offenses inside an array literal. ([@alexdowad][])
* `Style/RedundantParentheses` doesn't flag `method (:arg) {}`, since removing the parentheses would change the meaning of the expression. ([@alexdowad][])
* `Performance/Detect` doesn't flag code where `first` or `last` takes an argument, as it cannot be transformed to equivalent code using `detect`. ([@alexdowad][])
* `Style/SpaceAroundOperators` ignores aref assignments. ([@alexdowad][])
* `Style/RescueModifier` indents code correctly when auto-correcting. ([@alexdowad][])
* `Style/RedundantMerge` indents code correctly when auto-correcting, even if the corrected hash had multiple keys, and even if the corrected code was indented to start with. ([@alexdowad][])
* [#2831](https://github.com/rubocop-hq/rubocop/issues/2831): `Performance/RedundantMerge` doesn't break code by autocorrecting a `#merge!` call which occurs at tail position in a block. ([@alexdowad][])

### Changes

* Handle auto-correction of nested interpolations in `Lint/LiteralInInterpolation`. ([@lumeet][])
* RuboCop results cache uses different directory names when there are many (or long) CLI options, to avoid a very long path which could cause failures on some filesystems. ([@alexdowad][])

## 0.37.1 (2016-02-09)

### New features

* [#2798](https://github.com/rubocop-hq/rubocop/pull/2798): `Rails/FindEach` cop works with `where.not`. ([@pocke][])
* `Style/MultilineBlockLayout` can correct offenses which involve argument destructuring. ([@alexdowad][])
* `Style/SpaceAroundKeyword` checks `super` nodes with no args. ([@alexdowad][])
* `Style/SpaceAroundKeyword` checks `defined?` nodes. ([@alexdowad][])
* [#2719](https://github.com/rubocop-hq/rubocop/issues/2719): `Style/ConditionalAssignment` handles correcting the alignment of `end`. ([@rrosenblum][])

### Bug fixes

* Fix auto-correction of `not` with parentheses in `Style/Not`. ([@lumeet][])
* [#2784](https://github.com/rubocop-hq/rubocop/issues/2784): RuboCop can inspect `super { ... }` and `super(arg) { ... }`. ([@alexdowad][])
* [#2781](https://github.com/rubocop-hq/rubocop/issues/2781): `Performance/RedundantMerge` doesn't flag calls to `#update`, since many classes have methods by this name (not only `Hash`). ([@alexdowad][])
* [#2780](https://github.com/rubocop-hq/rubocop/issues/2780): `Lint/DuplicateMethods` does not flag method definitions inside dynamic `Class.new` blocks. ([@alexdowad][])
* [#2775](https://github.com/rubocop-hq/rubocop/issues/2775): `Style/SpaceAroundKeyword` doesn't flag `yield.method`. ([@alexdowad][])
* [#2774](https://github.com/rubocop-hq/rubocop/issues/2774): `Style/SpaceAroundOperators` doesn't flag calls to `#[]`. ([@alexdowad][])
* [#2772](https://github.com/rubocop-hq/rubocop/issues/2772): RuboCop doesn't crash when `AllCops` section in configuration file is empty (rather, it displays a warning as intended). ([@alexdowad][])
* [#2737](https://github.com/rubocop-hq/rubocop/issues/2737): `Style/GuardClause` handles `elsif` clauses correctly. ([@alexdowad][])
* [#2735](https://github.com/rubocop-hq/rubocop/issues/2735): `Style/MultilineBlockLayout` doesn't cause an infinite loop by moving `end` onto the same line as the block args. ([@alexdowad][])
* [#2715](https://github.com/rubocop-hq/rubocop/issues/2715): `Performance/RedundantMatch` doesn't flag calls to `#match` which take a block. ([@alexdowad][])
* [#2704](https://github.com/rubocop-hq/rubocop/issues/2704): `Lint/NestedMethodDefinition` doesn't flag singleton defs which define a method on the value of a local variable. ([@alexdowad][])
* [#2660](https://github.com/rubocop-hq/rubocop/issues/2660): `Style/TrailingUnderscoreVariable` shows recommended code in its offense message. ([@alexdowad][])
* [#2671](https://github.com/rubocop-hq/rubocop/issues/2671): `Style/WordArray` doesn't attempt to inspect strings with invalid encoding, to avoid failing with an encoding error. ([@alexdowad][])

### Changes

* [#2739](https://github.com/rubocop-hq/rubocop/issues/2739): Change the configuration option `when_needed` in `Style/FrozenStringLiteralComment` to add a `frozen_string_literal` comment to all files when the `TargetRubyVersion` is set to 2.3+. ([@rrosenblum][])

## 0.37.0 (2016-02-04)

### New features

* [#2620](https://github.com/rubocop-hq/rubocop/pull/2620): New cop `Style/ZeroLengthPredicate` checks for `object.size == 0` and variants, and suggests replacing them with an appropriate `empty?` predicate. ([@drenmi][])
* [#2657](https://github.com/rubocop-hq/rubocop/pull/2657): Floating headers in HTML output. ([@mattparlane][])
* Add new `Style/SpaceAroundKeyword` cop. ([@lumeet][])
* [#2745](https://github.com/rubocop-hq/rubocop/pull/2745): New cop `Style/MultilineHashBraceLayout` checks that the closing brace in a hash literal is symmetrical with respect to the opening brace and the hash elements. ([@panthomakos][])
* [#2761](https://github.com/rubocop-hq/rubocop/pull/2761): New cop `Style/MultilineMethodDefinitionBraceLayout` checks that the closing brace in a method definition is symmetrical with respect to the opening brace and the method parameters. ([@panthomakos][])
* [#2699](https://github.com/rubocop-hq/rubocop/pull/2699): `Performance/Casecmp` can register offenses when `str.downcase` or `str.upcase` are passed to an equality method. ([@rrosenblum][])
* [#2766](https://github.com/rubocop-hq/rubocop/pull/2766): New cop `Style/MultilineMethodCallBraceLayout` checks that the closing brace in a method call is symmetrical with respect to the opening brace and the method arguments. ([@panthomakos][])
* `Style/Semicolon` can autocorrect useless semicolons at the beginning of a line. ([@alexdowad][])

### Bug fixes

* [#2723](https://github.com/rubocop-hq/rubocop/issues/2723): Fix NoMethodError in Style/GuardClause. ([@drenmi][])
* [#2674](https://github.com/rubocop-hq/rubocop/issues/2674): Also check for Hash#update alias in `Performance/RedundantMerge`. ([@drenmi][])
* [#2630](https://github.com/rubocop-hq/rubocop/issues/2630): Take frozen string literals into account in `Style/MutableConstant`. ([@segiddins][])
* [#2642](https://github.com/rubocop-hq/rubocop/issues/2642): Support assignment via `||=` in `Style/MutableConstant`. ([@segiddins][])
* [#2646](https://github.com/rubocop-hq/rubocop/issues/2646): Fix auto-correcting assignment to a constant in `Style/ConditionalAssignment`. ([@segiddins][])
* [#2614](https://github.com/rubocop-hq/rubocop/issues/2614): Check for zero return value from `casecmp` in `Performance/casecmp`. ([@segiddins][])
* [#2647](https://github.com/rubocop-hq/rubocop/issues/2647): Allow `xstr` interpolations in `Lint/LiteralInInterpolation`. ([@segiddins][])
* Report a violation when `freeze` is called on a frozen string literal in `Style/RedundantFreeze`. ([@segiddins][])
* [#2641](https://github.com/rubocop-hq/rubocop/issues/2641): Fix crashing on empty methods with block args in `Performance/RedundantBlockCall`. ([@segiddins][])
* `Lint/DuplicateMethods` doesn't crash when `class_eval` is used with an implicit receiver. ([@lumeet][])
* [#2654](https://github.com/rubocop-hq/rubocop/issues/2654): Fix handling of unary operations in `Style/RedundantParentheses`. ([@lumeet][])
* [#2661](https://github.com/rubocop-hq/rubocop/issues/2661): `Style/Next` doesn't crash when auto-correcting modifier `if/unless`. ([@lumeet][])
* [#2665](https://github.com/rubocop-hq/rubocop/pull/2665): Make specs pass when running on Windows. ([@jonas054][])
* [#2691](https://github.com/rubocop-hq/rubocop/pull/2691): Do not register an offense in `Performance/TimesMap` for calling `map` or `collect` on a variable named `times`. ([@rrosenblum][])
* [#2689](https://github.com/rubocop-hq/rubocop/pull/2689): Change `Performance/RedundantBlockCall` to respect parentheses usage. ([@rrosenblum][])
* [#2694](https://github.com/rubocop-hq/rubocop/issues/2694): Fix caching when using a different JSON gem such as Oj. ([@georgyangelov][])
* [#2707](https://github.com/rubocop-hq/rubocop/pull/2707): Change `Lint/NestedMethodDefinition` to respect `Class.new` and `Module.new`. ([@owst][])
* [#2701](https://github.com/rubocop-hq/rubocop/pull/2701): Do not consider assignments to the same variable as useless if later assignments are within a loop. ([@owst][])
* [#2696](https://github.com/rubocop-hq/rubocop/issues/2696): `Style/NestedModifier` adds parentheses around a condition when needed. ([@lumeet][])
* [#2666](https://github.com/rubocop-hq/rubocop/issues/2666): Fix bug when auto-correcting symbol literals in `Lint/LiteralInInterpolation`. ([@lumeet][])
* [#2664](https://github.com/rubocop-hq/rubocop/issues/2664): `Performance/Casecmp` can auto-correct case comparison to variables and method calls without error. ([@rrosenblum][])
* [#2729](https://github.com/rubocop-hq/rubocop/issues/2729): Fix handling of hash literal as the first argument in `Style/RedundantParentheses`. ([@lumeet][])
* [#2703](https://github.com/rubocop-hq/rubocop/issues/2703): Handle byte order mark in `Style/IndentationWidth`, `Style/ElseAlignment`, `Lint/EndAlignment`, and `Lint/DefEndAlignment`. ([@jonas054][])
* [#2710](https://github.com/rubocop-hq/rubocop/pull/2710): Fix handling of fullwidth characters in some cops. ([@seikichi][])
* [#2690](https://github.com/rubocop-hq/rubocop/issues/2690): Fix alignment of operands that are part of an assignment in `Style/MultilineOperationIndentation`. ([@jonas054][])
* [#2228](https://github.com/rubocop-hq/rubocop/issues/2228): Use the config of a related cop whether it's enabled or not. ([@madwort][])
* [#2721](https://github.com/rubocop-hq/rubocop/issues/2721): Do not register an offense for constants wrapped in parentheses passed to `rescue` in `Style/RedundantParentheses`. ([@rrosenblum][])
* [#2742](https://github.com/rubocop-hq/rubocop/issues/2742): Fix `Style/TrailingCommaInArguments` & `Style/TrailingCommaInLiteral` for inline single element arrays. ([@annih][])
* [#2768](https://github.com/rubocop-hq/rubocop/issues/2768): Allow parentheses after keyword `not` in `Style/MethodCallParentheses`. ([@lumeet][])
* [#2758](https://github.com/rubocop-hq/rubocop/issues/2758): Allow leading underscores in camel case variable names.([@mmcguinn][])

### Changes

* Remove `Style/SpaceAfterControlKeyword` and `Style/SpaceBeforeModifierKeyword` as the more generic `Style/SpaceAroundKeyword` handles the same cases. ([@lumeet][])
* Handle comparisons with `!=` in `Performance/casecmp`. ([@segiddins][])
* [#2684](https://github.com/rubocop-hq/rubocop/pull/2684): Do not base `Style/FrozenStringLiteralComment` on the version of Ruby that is running. ([@rrosenblum][])
* [#2732](https://github.com/rubocop-hq/rubocop/issues/2732): Change the default style of `Style/SignalException` to `only_raise`. ([@bbatsov][])

## 0.36.0 (2016-01-14)

### New features

* [#2598](https://github.com/rubocop-hq/rubocop/pull/2598): New cop `Lint/RandOne` checks for `rand(1)`, `Kernel.rand(1.0)` and similar calls. Such call are most likely a mistake because they always return `0`. ([@DNNX][])
* [#2590](https://github.com/rubocop-hq/rubocop/pull/2590): New cop `Performance/DoubleStartEndWith` checks for two `start_with?` (or `end_with?`) calls joined by `||` with the same receiver, like `str.start_with?('x') || str.start_with?('y')` and suggests using one call instead: `str.start_with?('x', 'y')`. ([@DNNX][])
* [#2583](https://github.com/rubocop-hq/rubocop/pull/2583): New cop `Performance/TimesMap` checks for `x.times.map{}` and suggests replacing them with `Array.new(x){}`. ([@DNNX][])
* [#2581](https://github.com/rubocop-hq/rubocop/pull/2581): New cop `Lint/NextWithoutAccumulator` finds bare `next` in `reduce`/`inject` blocks which assigns `nil` to the accumulator. ([@mvidner][])
* [#2529](https://github.com/rubocop-hq/rubocop/pull/2529): Add EnforcedStyle config parameter to IndentArray. ([@jawshooah][])
* [#2479](https://github.com/rubocop-hq/rubocop/pull/2479): Add option `AllowHeredoc` to `Metrics/LineLength`. ([@fphilipe][])
* [#2416](https://github.com/rubocop-hq/rubocop/pull/2416): New cop `Style/ConditionalAssignment` checks for assignment of the same variable in all branches of conditionals and replaces them with a single assignment to the return of the conditional. ([@rrosenblum][])
* [#2410](https://github.com/rubocop-hq/rubocop/pull/2410): New cop `Style/IndentAssignment` checks the indentation of the first line of the right-hand-side of a multi-line assignment. ([@panthomakos][])
* [#2431](https://github.com/rubocop-hq/rubocop/issues/2431): Add `IgnoreExecutableScripts` option to `Style/FileName`. ([@sometimesfood][])
* [#2460](https://github.com/rubocop-hq/rubocop/pull/2460): New cop `Style/UnneededInterpolation` checks for strings that are just an interpolated expression. ([@cgriego][])
* [#2361](https://github.com/rubocop-hq/rubocop/pull/2361): `Style/MultilineAssignmentLayout` cop checks for a newline after the assignment operator in a multi-line assignment. ([@panthomakos][])
* [#2462](https://github.com/rubocop-hq/rubocop/issues/2462): `Lint/UselessAccessModifier` can catch more types of useless access modifiers. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/Casecmp` cop. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/RangeInclude` cop. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/RedundantSortBy` cop. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/LstripRstrip` cop. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/StartWith` cop. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/EndWith` cop. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/RedundantMerge` cop. ([@alexdowad][])
* `Lint/Debugger` cop can now auto-correct offenses. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/RedundantMatch` cop. ([@alexdowad][])
* [#1677](https://github.com/rubocop-hq/rubocop/issues/1677): Add new `Performance/RedundantBlockCall` cop. ([@alexdowad][])
* [#1954](https://github.com/rubocop-hq/rubocop/issues/1954): `Lint/UnneededDisable` can now autocorrect. ([@alexdowad][])
* [#2501](https://github.com/rubocop-hq/rubocop/issues/2501): Add new `Lint/ImplicitStringConcatenation` cop. ([@alexdowad][])
* Add new `Style/RedundantParentheses` cop. ([@lumeet][])
* [#1346](https://github.com/rubocop-hq/rubocop/issues/1346): `Style/SpecialGlobalVars` can be configured to use either `use_english_names` or `use_perl_names` styles. ([@alexdowad][])
* [#2426](https://github.com/rubocop-hq/rubocop/issues/2426): New `Style/NestedParenthesizedCalls` cop checks for non-parenthesized method calls nested inside a parenthesized call, like `method1(method2 arg)`. ([@alexdowad][])
* [#2502](https://github.com/rubocop-hq/rubocop/issues/2502): The `--stdin` and `--auto-correct` CLI options can be combined, and if you do so, corrected code is printed to stdout. ([@alexdowad][])
* `Style/ConditionalAssignment` works on conditionals with a common aref assignment (like `array[index] = val`) or attribute assignment (like `self.attribute = val`). ([@alexdowad][])
* [#2476](https://github.com/rubocop-hq/rubocop/issues/2476): `Style/GuardClause` catches if..else nodes with one branch which terminates the execution of the current scope. ([@alexdowad][])
* New `Style/IdenticalConditionalBranches` flags `if..else` and `case..when..else` constructs with an identical line at the end of each branch. ([@alexdowad][])
* [#207](https://github.com/rubocop-hq/rubocop/issues/207): Add new `Lint/FloatOutOfRange` cop which catches floating-point literals which are too large or too small for Ruby to represent. ([@alexdowad][])
* `Style/GuardClause` doesn't report offenses in places where correction would make a line too long. ([@alexdowad][])
* `Lint/DuplicateMethods` can find duplicate method definitions in many more circumstances, even across multiple files; however, it ignores definitions inside `if` or something which could be a DSL method. ([@alexdowad][])
* A warning is printed if an invalid `EnforcedStyle` is configured. ([@alexdowad][])
* [#1367](https://github.com/rubocop-hq/rubocop/issues/1367): New `Lint/IneffectiveAccessModifier` checks for access modifiers which are erroneously applied to a singleton method, where they have no effect. ([@alexdowad][])
* [#1614](https://github.com/rubocop-hq/rubocop/issues/1614): `Lint/BlockAlignment` aligns block end with splat operator when applied to a splatted method call. ([@alexdowad][])
* [#2263](https://github.com/rubocop-hq/rubocop/issues/2263): Warn if `task.options = %w(--format ...)` is used when configuring `RuboCop::RakeTask`; this should be `task.formatters = ...` instead. ([@alexdowad][])
* [#2511](https://github.com/rubocop-hq/rubocop/issues/2511): `--no-offense-counts` CLI option suppresses the inclusion of offense count lines in auto-generated config. ([@alexdowad][])
* [#2504](https://github.com/rubocop-hq/rubocop/issues/2504): New `AllowForAlignment` config parameter for `Style/SingleSpaceBeforeFirstArg` allows the insertion of extra spaces before the first argument if it aligns it with something on the preceding or following line. ([@alexdowad][])
* [#2478](https://github.com/rubocop-hq/rubocop/issues/2478): `Style/ExtraSpacing` has new `ForceEqualSignAlignment` config parameter which forces = signs on consecutive lines to be aligned, and it can auto-correct. ([@alexdowad][])
* `Lint/BlockAlignment` aligns block end with unary operators like ~, -, or ! when such operators are applied to the method call taking the block. ([@alexdowad][])
* [#1460](https://github.com/rubocop-hq/rubocop/issues/1460): `Style/Alias` supports both `prefer_alias` and `prefer_alias_method` styles. ([@alexdowad][])
* [#1569](https://github.com/rubocop-hq/rubocop/issues/1569): New `ExpectMatchingDefinition` config parameter for `Style/FileName` makes it check for a class or module definition in each file which corresponds to the file name and path. ([@alexdowad][])
* [#2480](https://github.com/rubocop-hq/rubocop/pull/2480): Add a configuration to `Style/ConditionalAssignment` to check and correct conditionals that contain multiple assignments. ([@rrosenblum][])
* [#2480](https://github.com/rubocop-hq/rubocop/pull/2480): Allow `Style/ConditionalAssignment` to correct assignment in ternary operations. ([@rrosenblum][])
* [#2480](https://github.com/rubocop-hq/rubocop/pull/2480): Allow `Style/ConditionalAssignment` to correct comparable methods. ([@rrosenblum][])
* [#1633](https://github.com/rubocop-hq/rubocop/issues/1633): New cop `Style/MultilineMethodCallIndentation` takes over the responsibility for checking alignment of methods from the `Style/MultilineOperationIndentation` cop. ([@jonas054][])
* [#2472](https://github.com/rubocop-hq/rubocop/pull/2472): New cop `Style/MultilineArrayBraceLayout` checks that the closing brace in an array literal is symmetrical with respect to the opening brace and the array elements. ([@panthomakos][])
* [#1543](https://github.com/rubocop-hq/rubocop/issues/1543): `Style/WordArray` has both `percent` and `brackets` (which enforces the use of bracketed arrays for strings) styles. ([@alexdowad][])
* `Style/SpaceAroundOperators` has `AllowForAlignment` config parameter which allows extra spaces on the left if they serve to align the operator with another. ([@alexdowad][])
* `Style/SymbolArray` has both `percent` and `brackets` (which enforces the user of bracketed arrays for symbols) styles. ([@alexdowad][])
* [#2343](https://github.com/rubocop-hq/rubocop/issues/2343): Entire cop types (or "departments") can be disabled using in .rubocop.yml using config like `Style: Enabled: false`. ([@alexdowad][])
* [#2399](https://github.com/rubocop-hq/rubocop/issues/2399): New `start_of_line` style for `Lint/EndAlignment` aligns a closing `end` keyword with the start of the line where the opening keyword appears. ([@alexdowad][])
* [#1545](https://github.com/rubocop-hq/rubocop/issues/1545): New `Regex` config parameter for `Style/FileName` allows user to provide their own regex for validating file names. ([@alexdowad][])
* [#2253](https://github.com/rubocop-hq/rubocop/issues/2253): New `DefaultFormatter` config parameter can be used to set formatter from within .rubocop.yml. ([@alexdowad][])
* [#2481](https://github.com/rubocop-hq/rubocop/issues/2481): New `WorstOffendersFormatter` prints a list of files with offenses (and offense counts), showing the files with the most offenses first. ([@alexdowad][])
* New `IfInsideElse` cop catches `if..end` nodes which can be converted into an `elsif` instead, reducing the nesting level. ([@alexdowad][])
* [#1725](https://github.com/rubocop-hq/rubocop/issues/1725): --color CLI option forces color output, even when not printing to a TTY. ([@alexdowad][])
* [#2549](https://github.com/rubocop-hq/rubocop/issues/2549): New `ConsistentQuotesInMultiline` config param for `Style/StringLiterals` forces all literals which are concatenated using \ to use the same quote style. ([@alexdowad][])
* [#2560](https://github.com/rubocop-hq/rubocop/issues/2560): `Style/AccessModifierIndentation`, `Style/CaseIndentation`, `Style/FirstParameterIndentation`, `Style/IndentArray`, `Style/IndentAssignment`, `Style/IndentHash`, `Style/MultilineMethodCallIndentation`, and `Style/MultilineOperationIndentation` all have a new `IndentationWidth` parameter which can be used to override the indentation width from `Style/IndentationWidth`. ([@alexdowad][])
* Add new `Performance/HashEachMethods` cop. ([@ojab][])
* New cop `Style/FrozenStringLiteralComment` will check for and add the comment `# frozen_string_literal: true` to the top of files. This will help with upgrading to Ruby 3.0. ([@rrosenblum][])

### Bug Fixes

* [#2594](https://github.com/rubocop-hq/rubocop/issues/2594): `Style/EmptyLiteral` autocorrector respects `Style/StringLiterals:EnforcedStyle` config. ([@DNNX][])
* [#2411](https://github.com/rubocop-hq/rubocop/issues/2411): Make local inherited configuration override configuration loaded from gems. ([@jonas054][])
* [#2413](https://github.com/rubocop-hq/rubocop/issues/2413): Allow `%Q` for dynamic strings with double quotes inside them. ([@jonas054][])
* [#2404](https://github.com/rubocop-hq/rubocop/issues/2404): `Style/Next` does not remove comments when auto-correcting. ([@lumeet][])
* `Style/Next` handles auto-correction of nested offenses. ([@lumeet][])
* `Style/VariableInterpolation` now detects non-numeric regex back references. ([@cgriego][])
* `ProgressFormatter` fully respects the `--no-color` switch. ([@savef][])
* Replace `Time.zone.current` with `Time.current` on `Rails::TimeZone` cop message. ([@volmer][])
* [#2451](https://github.com/rubocop-hq/rubocop/issues/2451): `Style/StabbyLambdaParentheses` does not treat method calls named `lambda` as lambdas. ([@domcleal][])
* [#2463](https://github.com/rubocop-hq/rubocop/issues/2463): Allow comments before an access modifier. ([@codebeige][])
* [#2471](https://github.com/rubocop-hq/rubocop/issues/2471): `Style/MethodName` doesn't choke on methods which are defined inside methods. ([@alexdowad][])
* [#2449](https://github.com/rubocop-hq/rubocop/issues/2449): `Style/StabbyLambdaParentheses` only checks lambdas in the arrow form. ([@lumeet][])
* [#2456](https://github.com/rubocop-hq/rubocop/issues/2456): `Lint/NestedMethodDefinition` doesn't register offenses for method definitions inside an eval block (either `instance_eval`, `class_eval`, or `module_eval`). ([@alexdowad][])
* [#2464](https://github.com/rubocop-hq/rubocop/issues/2464): `Style/ParallelAssignment` understands aref and attribute assignments, and doesn't warn if they can't be correctly rearranged into a series of single assignments. ([@alexdowad][])
* [#2482](https://github.com/rubocop-hq/rubocop/issues/2482): `Style/AndOr` doesn't raise an exception when trying to autocorrect `!variable or ...`. ([@alexdowad][])
* [#2446](https://github.com/rubocop-hq/rubocop/issues/2446): `Style/Tab` doesn't register errors for leading tabs which occur inside a string literal (including heredoc). ([@alexdowad][])
* [#2452](https://github.com/rubocop-hq/rubocop/issues/2452): `Style/TrailingComma` incorrectly categorizes single-line hashes in methods calls. ([@panthomakos][])
* [#2441](https://github.com/rubocop-hq/rubocop/issues/2441): `Style/AlignParameters` doesn't crash if it finds nested offenses. ([@alexdowad][])
* [#2436](https://github.com/rubocop-hq/rubocop/issues/2436): `Style/SpaceInsideHashLiteralBraces` doesn't mangle a hash literal which is not surrounded by curly braces, but has another hash literal which does as its first key. ([@alexdowad][])
* [#2483](https://github.com/rubocop-hq/rubocop/issues/2483): `Style/Attr` differentiate between attr_accessor and attr_reader. ([@weh][])
* `Style/ConditionalAssignment` doesn't crash if it finds a `case` with an empty branch. ([@lumeet][])
* [#2506](https://github.com/rubocop-hq/rubocop/issues/2506): `Lint/FormatParameterMismatch` understands `%{}` and `%<>` interpolations. ([@alexdowad][])
* [#2145](https://github.com/rubocop-hq/rubocop/issues/2145): `Lint/ParenthesesAsGroupedExpression` ignores calls with multiple arguments, since they are not ambiguous. ([@alexdowad][])
* [#2484](https://github.com/rubocop-hq/rubocop/issues/2484): Remove two vulnerabilities in cache handling. ([@jonas054][])
* [#2517](https://github.com/rubocop-hq/rubocop/issues/2517): `Lint/UselessAccessModifier` doesn't think that an access modifier applied to `attr_writer` is useless. ([@alexdowad][])
* [#2518](https://github.com/rubocop-hq/rubocop/issues/2518): `Style/ConditionalAssignment` doesn't think that branches using `<<` and `[]=` should be combined. ([@alexdowad][])
* `CharacterLiteral` auto-corrector now properly corrects `?'`. ([@bfontaine][])
* [#2313](https://github.com/rubocop-hq/rubocop/issues/2313): `Rails/FindEach` doesn't break code which uses `order(...).each`, `limit(...).each`, and so on. ([@alexdowad][])
* [#1938](https://github.com/rubocop-hq/rubocop/issues/1938): `Rails/FindBy` doesn't autocorrect `where(...).first` to `find_by`, since the returned record is often different. ([@alexdowad][])
* [#1801](https://github.com/rubocop-hq/rubocop/issues/1801): `EmacsFormatter` strips newlines out of error messages, if there are any. ([@alexdowad][])
* [#2534](https://github.com/rubocop-hq/rubocop/issues/2534): `Style/RescueEnsureAlignment` works on `rescue` nested inside a `class` or `module` block. ([@alexdowad][])
* `Lint/BlockAlignment` does not refer to a block terminator as `end` when it is actually `}`. ([@alexdowad][])
* [#2540](https://github.com/rubocop-hq/rubocop/issues/2540): `Lint/FormatParameterMismatch` understands format specifiers with multiple flags. ([@alexdowad][])
* [#2538](https://github.com/rubocop-hq/rubocop/issues/2538): `Style/SpaceAroundOperators` doesn't eat newlines. ([@alexdowad][])
* [#2531](https://github.com/rubocop-hq/rubocop/issues/2531): `Style/AndOr` autocorrects in cases where parentheses must be added, even inside a nested begin node. ([@alexdowad][])
* [#2450](https://github.com/rubocop-hq/rubocop/issues/2450): `Style/Next` adjusts indentation when auto-correcting, to avoid introducing new offenses. ([@alexdowad][])
* [#2066](https://github.com/rubocop-hq/rubocop/issues/2066): `Style/TrivialAccessors` doesn't flag what appear to be trivial accessor method definitions, if they are nested inside a call to `instance_eval`. ([@alexdowad][])
* `Style/SymbolArray` doesn't flag arrays of symbols if a symbol contains a space character. ([@alexdowad][])
* `Style/SymbolArray` can auto-correct offenses. ([@alexdowad][])
* [#2546](https://github.com/rubocop-hq/rubocop/issues/2546): Report when two `rubocop:disable` comments (not the single line kind) for a given cop apppear in a file with no `rubocop:enable` in between. ([@jonas054][])
* [#2552](https://github.com/rubocop-hq/rubocop/issues/2552): `Style/Encoding` can auto-correct files with a blank first line. ([@alexdowad][])
* [#2556](https://github.com/rubocop-hq/rubocop/issues/2556): `Style/SpecialGlobalVariables` generates auto-config correctly. ([@alexdowad][])
* [#2565](https://github.com/rubocop-hq/rubocop/issues/2565): Let `Style/SpaceAroundOperators` leave spacing around `=>` to `Style/AlignHash`. ([@jonas054][])
* [#2569](https://github.com/rubocop-hq/rubocop/issues/2569): `Style/MethodCallParentheses` doesn't register warnings for `object.()` syntax, since it is handled by `Style/LambdaCall`. ([@alexdowad][])
* [#2570](https://github.com/rubocop-hq/rubocop/issues/2570): `Performance/RedundantMerge` doesn't break code with a modifier `if` when autocorrecting. ([@alexdowad][])
* `Performance/RedundantMerge` doesn't break code with a modifier `while` or `until` when autocorrecting. ([@alexdowad][])
* [#2574](https://github.com/rubocop-hq/rubocop/issues/2574): `variable` style for `Lint/EndAlignment` is working again. ([@alexdowad][])
* `Lint/EndAlignment` can autocorrect offenses on the RHS of an assignment to an instance variable, class variable, constant, and so on; previously, it only worked if the LHS was a local variable. ([@alexdowad][])
* [#2580](https://github.com/rubocop-hq/rubocop/issues/2580): `Style/StringReplacement` doesn't break code when autocorrection involves a regex with embedded escapes (like /\n/). ([@alexdowad][])
* [#2582](https://github.com/rubocop-hq/rubocop/issues/2582): `Style/AlignHash` doesn't move a key so far left that it goes onto the previous line (in an attempt to align). ([@alexdowad][])
* [#2588](https://github.com/rubocop-hq/rubocop/issues/2588): `Style/SymbolProc` doesn't break code when autocorrecting a method call with a trailing comma in the argument list. ([@alexdowad][])
* [#2448](https://github.com/rubocop-hq/rubocop/issues/2448): `Style/TrailingCommaInArguments` and `Style/TrailingCommaInLiteral` don't special-case single-item lists in a way which contradicts the documentation. ([@alexdowad][])
* Fix for remote config files to only load from on http and https URLs. ([@ptrippett][])
* [#2604](https://github.com/rubocop-hq/rubocop/issues/2604): `Style/FileName` doesn't fail on empty files when `ExpectMatchingDefinition` is true. ([@alexdowad][])
* `Style/RedundantFreeze` registers offences for frozen dynamic symbols. ([@segiddins][])
* [#2609](https://github.com/rubocop-hq/rubocop/issues/2609): All cops which rely on the `AutocorrectUnlessChangingAST` module can now autocorrect files which contain `__FILE__`. ([@alexdowad][])
* [#2608](https://github.com/rubocop-hq/rubocop/issues/2608): `Style/ConditionalAssignment` can autocorrect `=~` within a ternary expression. ([@alexdowad][])

### Changes

* [#2427](https://github.com/rubocop-hq/rubocop/pull/2427): Allow non-snake-case file names (e.g. `some-random-script`) for Ruby scripts that have a shebang. ([@sometimesfood][])
* [#2430](https://github.com/rubocop-hq/rubocop/pull/2430): `Lint/UnneededDisable` now adds "unknown cop" to messages if cop names in `rubocop:disable` comments are unrecognized, or "did you mean ..." if they are misspelled names of existing cops. ([@jonas054][])
* [#947](https://github.com/rubocop-hq/rubocop/issues/947): `Style/Documentation` considers classes and modules which only define constants to be "namespaces", and doesn't flag them for lack of a documentation comment. ([@alexdowad][])
* [#2467](https://github.com/rubocop-hq/rubocop/issues/2467): Explicitly inheriting configuration from the rubocop gem in .rubocop.yml is not allowed. ([@alexdowad][])
* [#2322](https://github.com/rubocop-hq/rubocop/issues/2322): Output of --auto-gen-config shows content of default config parameters which are Arrays; this is especially useful for SupportedStyles. ([@alexdowad][])
* [#1566](https://github.com/rubocop-hq/rubocop/issues/1566): When autocorrecting on Windows, line endings are not converted to "\r\n" in untouched portions of the source files; corrected portions may use "\n" rather than "\r\n". ([@alexdowad][])
* New `rake repl` task can be used for experimentation when working on RuboCop. ([@alexdowad][])
* `Lint/SpaceBeforeFirstArg` cop has been removed, since it just duplicates `Style/SingleSpaceBeforeFirstArg`. ([@alexdowad][])
* `Style/SingleSpaceBeforeFirstArg` cop has been renamed to `Style/SpaceBeforeFirstArg`, which more accurately reflects what it now does. ([@alexdowad][])
* `Style/UnneededPercentQ` reports `%q()` strings with what only appears to be an escape, but is not really (there are no escapes in `%q()` strings). ([@alexdowad][])
* `Performance/StringReplacement`, `Performance\StartWith`, and `Performance\EndWith` more accurately identify code which can be improved. ([@alexdowad][])
* The `MultiSpaceAllowedForOperators` config parameter for `Style/SpaceAroundOperators` has been removed, as it is made redundant by `AllowForAlignment`. If someone attempts to use it, config validation will fail with a helpful message. ([@alexdowad][])
* The `RunRailsCops` config parameter in .rubocop.yml is now obsolete. If someone attempts to use it, config validation will fail with a helpful message. ([@alexdowad][])
* If .rubocop.yml contains configuration for a custom cop, no warning regarding "unknown cop" will be printed. The custom cop must inherit from RuboCop::Cop::Cop, and must be loaded into memory for this to work. ([@alexdowad][])
* [#2102](https://github.com/rubocop-hq/rubocop/issues/2102): If .rubocop.yml exists in the working directory when running --auto-gen-config, any `Exclude` config parameters in .rubocop.yml will be merged into the generated .rubocop_todo.yml. ([@alexdowad][])
* [#1895](https://github.com/rubocop-hq/rubocop/issues/1895): Remove `Rails/DefaultScope` cop. ([@alexdowad][])
* [#2550](https://github.com/rubocop-hq/rubocop/issues/2550): New `TargetRubyVersion` configuration parameter can be used to specify which version of the Ruby interpreter the inspected code is intended to run on. ([@alexdowad][])
* [#2557](https://github.com/rubocop-hq/rubocop/issues/2557): `Style/GuardClause` does not warn about `if` nodes whose condition spans multiple lines. ([@alexdowad][])
* `Style/EmptyLinesAroundClassBody`, `Style/EmptyLinesAroundModuleBody`, and `Style/EmptyLinesAroundBlockBody` accept an empty body with no blank line, even if configured to `empty_lines` style. This is because the empty lines only serve to provide a break between the header, body, and footer, and are redundant if there is no body. ([@alexdowad][])
* [#2554](https://github.com/rubocop-hq/rubocop/issues/2554): `Style/FirstMethodArgumentLineBreak` handles implicit hash arguments without braces; `Style/FirstHashElementLineBreak` still handles those with braces. ([@alexdowad][])
* `Style/TrailingComma` has been split into `Style/TrailingCommaInArguments` and `Style/TrailingCommaInLiteral`. ([@alexdowad][])
* RuboCop returns process exit code 2 if it fails due to bad configuration, bad CLI options, or an internal error. If it runs successfully but finds one or more offenses, it still exits with code 1, as was previously the case. This is helpful when invoking RuboCop programmatically, perhaps from a script. ([@alexdowad][])

## 0.35.1 (2015-11-10)

### Bug Fixes

* [#2407](https://github.com/rubocop-hq/rubocop/issues/2407): Use `Process.uid` rather than `Etc.getlogin` for simplicity and compatibility. ([@jujugrrr][])

## 0.35.0 (2015-11-07)

### New features

* [#2028](https://github.com/rubocop-hq/rubocop/issues/2028): New config `ExtraDetails` supports addition of `Details` param to all cops to allow extra details on offense to be displayed. ([@tansaku][])
* [#2036](https://github.com/rubocop-hq/rubocop/issues/2036): New cop `Style/StabbyLambdaParentheses` will find and correct cases where a stabby lambda's parameters are not wrapped in parentheses. ([@hmadison][])
* [#2246](https://github.com/rubocop-hq/rubocop/pull/2246): `Style/TrailingUnderscoreVariable` will now register an offense for `*_`. ([@rrosenblum][])
* [#2246](https://github.com/rubocop-hq/rubocop/pull/2246): `Style/TrailingUnderscoreVariable` now has a configuration to remove named underscore variables (Defaulted to false). ([@rrosenblum][])
* [#2276](https://github.com/rubocop-hq/rubocop/pull/2276): New cop `Performance/FixedSize` will register an offense when calling `length`, `size`, or `count` on statically sized objected (strings, symbols, arrays, and hashes). ([@rrosenblum][])
* New cop `Style/NestedModifier` checks for nested `if`, `unless`, `while` and `until` modifier statements. ([@lumeet][])
* [#2270](https://github.com/rubocop-hq/rubocop/pull/2270): Add a new `inherit_gem` configuration to inherit a config file from an installed gem [(originally requested in #290)](https://github.com/rubocop-hq/rubocop/issues/290). ([@jhansche][])
* Allow `StyleGuide` parameters in local configuration for all cops, so users can add references to custom style guide documents. ([@cornelius][])
* `UnusedMethodArgument` cop allows configuration to skip keyword arguments. ([@apiology][])
* [#2318](https://github.com/rubocop-hq/rubocop/pull/2318): `Lint/Debugger` cop now checks for `Pry.rescue`. ([@rrosenblum][])
* [#2277](https://github.com/rubocop-hq/rubocop/pull/2277): New cop `Style/FirstArrayElementLineBreak` checks for a line break before the first element in a multi-line array. ([@panthomakos][])
* [#2277](https://github.com/rubocop-hq/rubocop/pull/2277): New cop `Style/FirstHashElementLineBreak` checks for a line break before the first element in a multi-line hash. ([@panthomakos][])
* [#2277](https://github.com/rubocop-hq/rubocop/pull/2277): New cop `Style/FirstMethodArgumentLineBreak` checks for a line break before the first argument in a multi-line method call. ([@panthomakos][])
* [#2277](https://github.com/rubocop-hq/rubocop/pull/2277): New cop `Style/FirstMethodParameterLineBreak` checks for a line break before the first parameter in a multi-line method parameter definition. ([@panthomakos][])
* Add `Rails/PluralizationGrammar` cop, checks for incorrect grammar when using methods like `3.day.ago`, when you should write `3.days.ago`. ([@maxjacobson][])
* [#2347](https://github.com/rubocop-hq/rubocop/pull/2347): `Lint/Eval` cop does not warn about "security risk" when eval argument is a string literal without interpolations. ([@alexdowad][])
* [#2335](https://github.com/rubocop-hq/rubocop/issues/2335): `Style/VariableName` cop checks naming style of method parameters. ([@alexdowad][])
* [#2329](https://github.com/rubocop-hq/rubocop/pull/2329): New style `braces_for_chaining` for `Style/BlockDelimiters` cop enforces braces on a multi-line block if its return value is being chained with another method. ([@panthomakos][])
* `Lint/LiteralInCondition` warns if a symbol or dynamic symbol is used as a condition. ([@alexdowad][])
* [#2369](https://github.com/rubocop-hq/rubocop/issues/2369): `Style/TrailingComma` doesn't add a trailing comma to a multiline method chain which is the only arg to a method call. ([@alexdowad][])
* `CircularArgumentReference` cop updated to lint for ordinal circular argument references on top of optional keyword arguments. ([@maxjacobson][])
* Added ability to download shared rubocop config files from remote urls. ([@ptrippett][])
* [#1601](https://github.com/rubocop-hq/rubocop/issues/1601): Add `IgnoreEmptyMethods` config parameter for `Lint/UnusedMethodArgument` and `IgnoreEmptyBlocks` config parameter for `Lint/UnusedBlockArgument` cops. ([@alexdowad][])
* [#1729](https://github.com/rubocop-hq/rubocop/issues/1729): `Style/MethodDefParentheses` supports new 'require_no_parentheses_except_multiline' style. ([@alexdowad][])
* [#2173](https://github.com/rubocop-hq/rubocop/issues/2173): `Style/AlignParameters` also checks parameter alignment for method definitions. ([@alexdowad][])
* [#1825](https://github.com/rubocop-hq/rubocop/issues/1825): New `NameWhitelist` configuration parameter for `Style/PredicateName` can be used to suppress errors on known-good predicate names. ([@alexdowad][])
* `Style/Documentation` recognizes 'Constant = Class.new' as a class definition. ([@alexdowad][])
* [#1608](https://github.com/rubocop-hq/rubocop/issues/1608): Add new 'align_braces' style for `Style/IndentHash`. ([@alexdowad][])
* `Style/Next` can autocorrect. ([@alexdowad][])

### Bug Fixes

* [#2265](https://github.com/rubocop-hq/rubocop/issues/2265): Handle unary `+` in `ExtraSpacing` cop. ([@jonas054][])
* [#2275](https://github.com/rubocop-hq/rubocop/pull/2275): Copy default `Exclude` into `Exclude` lists in `.rubocop_todo.yml`. ([@jonas054][])
* `Style/IfUnlessModifier` accepts blocks followed by a chained call. ([@lumeet][])
* [#2261](https://github.com/rubocop-hq/rubocop/issues/2261): Make relative `Exclude` paths in `$HOME/.rubocop_todo.yml` be relative to current directory. ([@jonas054][])
* [#2286](https://github.com/rubocop-hq/rubocop/issues/2286): Handle auto-correction of empty method when `AllowIfMethodIsEmpty` is `false` in `Style/SingleLineMethods`. ([@jonas054][])
* [#2246](https://github.com/rubocop-hq/rubocop/pull/2246): Do not register an offense for `Style/TrailingUnderscoreVariable` when the underscore variable is preceded by a splat variable. ([@rrosenblum][])
* [#2292](https://github.com/rubocop-hq/rubocop/pull/2292): Results should not be stored in the cache if affected by errors (crashes). ([@jonas054][])
* [#2280](https://github.com/rubocop-hq/rubocop/issues/2280): Avoid reporting space between hash literal keys and values in `Style/ExtraSpacing`. ([@jonas054][])
* [#2284](https://github.com/rubocop-hq/rubocop/issues/2284): Fix result cache being shared between ruby versions. ([@miquella][])
* [#2285](https://github.com/rubocop-hq/rubocop/issues/2285): Fix `ConfigurableNaming#class_emitter_method?` error when handling singleton class methods. ([@palkan][])
* [#2295](https://github.com/rubocop-hq/rubocop/issues/2295): Fix Performance/Detect autocorrect to handle rogue newlines. ([@palkan][])
* [#2294](https://github.com/rubocop-hq/rubocop/issues/2294): Do not register an offense in `Performance/StringReplacement` for regex with options. ([@rrosenblum][])
* Fix `Style/UnneededPercentQ` condition for single-quoted literal containing interpolation-like string. ([@eagletmt][])
* [#2324](https://github.com/rubocop-hq/rubocop/issues/2324): Handle `--only Lint/Syntax` and `--except Lint/Syntax` correctly. ([@jonas054][])
* [#2317](https://github.com/rubocop-hq/rubocop/issues/2317): Handle `case` as an argument correctly in `Lint/EndAlignment`. ([@lumeet][])
* [#2287](https://github.com/rubocop-hq/rubocop/issues/2287): Fix auto-correct of lines with only whitespace in `Style/IndentationWidth`. ([@lumeet][])
* [#2331](https://github.com/rubocop-hq/rubocop/issues/2331): Do not register an offense in `Performance/Size` for `count` with an argument. ([@rrosenblum][])
* Handle a backslash at the end of a line in `Style/SpaceAroundOperators`. ([@lumeet][])
* Don't warn about lack of "leading space" in a =begin/=end comment. ([@alexdowad][])
* [#2307](https://github.com/rubocop-hq/rubocop/issues/2307): In `Lint/FormatParameterMismatch`, don't register an offense if either argument to % is not a literal. ([@alexdowad][])
* [#2356](https://github.com/rubocop-hq/rubocop/pull/2356): `Style/Encoding` will now place the encoding comment on the second line if the first line is a shebang. ([@rrosenblum][])
* `Style/InitialIndentation` cop doesn't error out when a line begins with an integer literal. ([@alexdowad][])
* [#2296](https://github.com/rubocop-hq/rubocop/issues/2296): In `Style/DotPosition`, don't "correct" (and break) a method call which has a line comment (or blank line) between the dot and the selector. ([@alexdowad][])
* [#2272](https://github.com/rubocop-hq/rubocop/issues/2272): `Lint/NonLocalExitFromIterator` does not warn about `return` in a block which is passed to `Module#define_method`. ([@alexdowad][])
* [#2262](https://github.com/rubocop-hq/rubocop/issues/2262): Replace `Rainbow` reference with `Colorizable#yellow`. ([@minustehbare][])
* [#2068](https://github.com/rubocop-hq/rubocop/issues/2068): Display warning if `Style/Copyright` is misconfigured. ([@alexdowad][])
* [#2321](https://github.com/rubocop-hq/rubocop/issues/2321): In `Style/EachWithObject`, don't replace reduce with each_with_object if the accumulator parameter is assigned to in the block. ([@alexdowad][])
* [#1981](https://github.com/rubocop-hq/rubocop/issues/1981): `Lint/UselessAssignment` doesn't erroneously identify assignments in identical if branches as useless. ([@alexdowad][])
* [#2323](https://github.com/rubocop-hq/rubocop/issues/2323): `Style/IfUnlessModifier` cop parenthesizes autocorrected code when necessary due to operator precedence, to avoid changing its meaning. ([@alexdowad][])
* [#2003](https://github.com/rubocop-hq/rubocop/issues/2003): Make `Lint/UnneededDisable` work with `--auto-correct`. ([@jonas054][])
* Default RuboCop cache dir moved to per-user folders. ([@br3nda][])
* [#2393](https://github.com/rubocop-hq/rubocop/pull/2393): `Style/MethodCallParentheses` doesn't fail on `obj.method ||= func()`. ([@alexdowad][])
* [#2344](https://github.com/rubocop-hq/rubocop/pull/2344): When autocorrecting, `Style/ParallelAssignment` reorders assignment statements, if necessary, to avoid breaking code. ([@alexdowad][])
* `Style/MultilineOperationAlignment` does not try to align the receiver and selector of a method call if both are on the LHS of an assignment. ([@alexdowad][])

### Changes

* [#2194](https://github.com/rubocop-hq/rubocop/issues/2194): Allow any options with `--auto-gen-config`. ([@agrimm][])

## 0.34.2 (2015-09-21)

### Bug Fixes

* [#2232](https://github.com/rubocop-hq/rubocop/issues/2232): Fix false positive in `Lint/FormatParameterMismatch` for argument with splat operator. ([@dreyks][])
* [#2237](https://github.com/rubocop-hq/rubocop/pull/2237): Allow `Lint/FormatParameterMismatch` to be called using `Kernel.format` and `Kernel.sprintf`. ([@rrosenblum][])
* [#2234](https://github.com/rubocop-hq/rubocop/issues/2234): Do not register an offense for `Lint/FormatParameterMismatch` when the format string is a variable. ([@rrosenblum][])
* [#2240](https://github.com/rubocop-hq/rubocop/pull/2240): `Lint/UnneededDisable` should not report non-`Lint` `rubocop:disable` comments when running `rubocop --lint`. ([@jonas054][])
* [#2121](https://github.com/rubocop-hq/rubocop/issues/2121): Allow space before values in hash literals in `Style/ExtraSpacing` to avoid correction conflict. ([@jonas054][])
* [#2241](https://github.com/rubocop-hq/rubocop/issues/2241): Read cache in binary format. ([@jonas054][])
* [#2247](https://github.com/rubocop-hq/rubocop/issues/2247): Fix auto-correct of `Performance/CaseWhenSplat` for percent arrays (`%w`, `%W`, `%i`, and `%I`). ([@rrosenblum][])
* [#2244](https://github.com/rubocop-hq/rubocop/issues/2244): Disregard annotation keywords in `Style/CommentAnnotation` if they don't start a comment. ([@jonas054][])
* [#2257](https://github.com/rubocop-hq/rubocop/pull/2257): Fix bug where `Style/RescueEnsureAlignment` will register an offense for `rescue` and `ensure` on the same line. ([@rrosenblum][])
* [#2255](https://github.com/rubocop-hq/rubocop/issues/2255): Refine the offense highlighting for `Style/SymbolProc`. ([@bbatsov][])
* [#2260](https://github.com/rubocop-hq/rubocop/pull/2260): Make `Exclude` in `.rubocop_todo.yml` work when running from a subdirectory. ([@jonas054][])

### Changes

* [#2248](https://github.com/rubocop-hq/rubocop/issues/2248): Allow block-pass in `Style/AutoResourceCleanup`. ([@lumeet][])
* [#2258](https://github.com/rubocop-hq/rubocop/pull/2258): `Style/Documentation` will exclude test directories by default. ([@rrosenblum][])
* [#2260](https://github.com/rubocop-hq/rubocop/issues/2260): Disable `Style/StringMethods` by default. ([@bbatsov][])

## 0.34.1 (2015-09-09)

### Bug Fixes

* [#2212](https://github.com/rubocop-hq/rubocop/issues/2212): Handle methods without parentheses in auto-correct. ([@karreiro][])
* [#2214](https://github.com/rubocop-hq/rubocop/pull/2214): Fix `File name too long error` when `STDIN` option is provided. ([@mrfoto][])
* [#2217](https://github.com/rubocop-hq/rubocop/issues/2217): Allow block arguments in `Style/SymbolProc`. ([@lumeet][])
* [#2213](https://github.com/rubocop-hq/rubocop/issues/2213): Write to cache with binary encoding to avoid transcoding exceptions in some locales. ([@jonas054][])
* [#2218](https://github.com/rubocop-hq/rubocop/issues/2218): Fix loading config error when safe yaml is only partially loaded. ([@maxjacobson][])
* [#2161](https://github.com/rubocop-hq/rubocop/issues/2161): Allow an explicit receiver (except `Kernel`) in `Style/SignalException`. ([@lumeet][])

## 0.34.0 (2015-09-05)

### New features

* [#2143](https://github.com/rubocop-hq/rubocop/pull/2143): New cop `Performance/CaseWhenSplat` will identify and rearange `case` `when` statements that contain a `when` condition with a splat. ([@rrosenblum][])
* New cop `Lint/DuplicatedKey` checks for duplicated keys in hashes, which Ruby 2.2 warns against. ([@sliuu][])
* [#2106](https://github.com/rubocop-hq/rubocop/issues/2106): Add `SuspiciousParamNames` option to `Style/OptionHash`. ([@wli][])
* [#2193](https://github.com/rubocop-hq/rubocop/pull/2193): `Style/Next` supports more `Enumerable` methods. ([@rrosenblum][])
* [#2179](https://github.com/rubocop-hq/rubocop/issues/2179): Add `--list-target-files` option to CLI, which prints the files which will be inspected. ([@maxjacobson][])
* New cop `Style/MutableConstant` checks for assignment of mutable objects to constants. ([@bbatsov][])
* New cop `Style/RedudantFreeze` checks for usages of `Object#freeze` on immutable objects. ([@bbatsov][])
* [#1924](https://github.com/rubocop-hq/rubocop/issues/1924): New option `--cache` and configuration parameter `AllCops: UseCache` turn result caching on (default) or off. ([@jonas054][])
* [#2204](https://github.com/rubocop-hq/rubocop/pull/2204): New cop `Style/StringMethods` will check for preferred method `to_sym` over `intern`. ([@imtayadeway][])

### Changes

* [#1351](https://github.com/rubocop-hq/rubocop/issues/1351): Allow class emitter methods in `Style/MethodName`. ([@jonas054][])
* [#2126](https://github.com/rubocop-hq/rubocop/pull/2126): `Style/RescueModifier` can now auto-correct. ([@rrosenblum][])
* [#2109](https://github.com/rubocop-hq/rubocop/issues/2109): Allow alignment with a token on the nearest line with same indentation in `Style/ExtraSpacing`. ([@jonas054][])
* `Lint/EndAlignment` handles the `case` keyword. ([@lumeet][])
* [#2146](https://github.com/rubocop-hq/rubocop/pull/2146): Add STDIN support. ([@caseywebdev][])
* [#2175](https://github.com/rubocop-hq/rubocop/pull/2175): Files that are excluded from a cop (e.g. using the `Exclude:` config option) are no longer being processed by that cop. ([@bquorning][])
* `Rails/ActionFilter` now handles complete list of methods found in the Rails 4.2 [release notes](https://github.com/rails/rails/blob/4115a12da1409c753c747fd4bab6e612c0c6e51a/guides/source/4_2_release_notes.md#notable-changes-1). ([@MGerrior][])
* [*2138](https://github.com/rubocop-hq/rubocop/issues/2138): Change the offense in `Style/Next` to highlight the condition instead of the iteration. ([@rrosenblum][])
* `Style/EmptyLineBetweenDefs` now handles class methods as well. ([@unmanbearpig][])
* Improve handling of `super` in `Style/SymbolProc`. ([@lumeet][])
* `Style/SymbolProc` is applied to methods receiving arguments. ([@lumeet][])
* [#1839](https://github.com/rubocop-hq/rubocop/issues/1839): Remove Rainbow monkey patching of String which conflicts with other gems like colorize. ([@daviddavis][])
* `Style/HashSyntax` is now a bit faster when checking Ruby 1.9 syntax hash keys. ([@bquorning][])
* `Lint/DeprecatedClassMethods` is now a whole lot faster. ([@bquorning][])
* `Lint/BlockAlignment`, `Style/IndentationWidth`, and `Style/MultilineOperationIndentation` are now quite a bit faster. ([@bquorning][])

### Bug Fixes

* [#2123](https://github.com/rubocop-hq/rubocop/pull/2123): Fix handing of dynamic widths `Lint/FormatParameterMismatch`. ([@edmz][])
* [#2116](https://github.com/rubocop-hq/rubocop/pull/2116): Fix named params (using hash) `Lint/FormatParameterMismatch`. ([@edmz][])
* [#2135](https://github.com/rubocop-hq/rubocop/issues/2135): Ignore `super` and `zsuper` nodes in `Style/SymbolProc`. ([@bbatsov][])
* [#2165](https://github.com/rubocop-hq/rubocop/issues/2165): Fix a NPE in `Style/Alias`. ([@bbatsov][])
* [#2168](https://github.com/rubocop-hq/rubocop/issues/2168): Fix a NPE in `Rails/TimeZone`. ([@bbatsov][])
* [#2169](https://github.com/rubocop-hq/rubocop/issues/2169): Fix a NPE in `Rails/Date`. ([@bbatsov][])
* [#2105](https://github.com/rubocop-hq/rubocop/pull/2105): Fix a warning that was thrown when enabling `Style/OptionHash`. ([@wli][])
* [#2107](https://github.com/rubocop-hq/rubocop/pull/2107): Fix auto-correct of `Style/ParallelAssignment` for nested expressions. ([@rrosenblum][])
* [#2111](https://github.com/rubocop-hq/rubocop/issues/2111): Deal with byte order mark in `Style/InitialIndentation`. ([@jonas054][])
* [#2113](https://github.com/rubocop-hq/rubocop/issues/2113): Handle non-string tokens in `Style/ExtraSpacing`. ([@jonas054][])
* [#2129](https://github.com/rubocop-hq/rubocop/issues/2129): Handle empty interpolations in `Style/SpaceInsideStringInterpolation`. ([@lumeet][])
* [#2119](https://github.com/rubocop-hq/rubocop/issues/2119): Do not raise an error in `Style/RescueEnsureAlignment` and `Style/RescueModifier` when processing an excluded file. ([@rrosenblum][])
* [#2149](https://github.com/rubocop-hq/rubocop/issues/2149): Do not register an offense in `Rails/Date` when `Date#to_time` is called with a time zone argument. ([@maxjacobson][])
* Do not register a `Rails/TimeZone` offense when using Time.new safely. ([@maxjacobson][])
* [#2124](https://github.com/rubocop-hq/rubocop/issues/2124): Fix bug in `Style/EmptyLineBetweenDefs` when there are only comments between method definitions. ([@lumeet][])
* [#2154](https://github.com/rubocop-hq/rubocop/issues/2154): `Performance/StringReplacement` can auto-correct replacements with backslash in them. ([@rrosenblum][])
* [#2009](https://github.com/rubocop-hq/rubocop/issues/2009): Fix bug in `RuboCop::ConfigLoader.load_file` when `safe_yaml` is required. ([@eitoball][])
* [#2155](https://github.com/rubocop-hq/rubocop/issues/2155): Configuration `EndAlignment: AlignWith: variable` only applies when the operands of `=` are on the same line. ([@jonas054][])
* Fix bug in `Style/IndentationWidth` when `rescue` or `ensure` is preceded by an empty body. ([@lumeet][])
* [#2183](https://github.com/rubocop-hq/rubocop/issues/2183): Fix bug in `Style/BlockDelimiters` when auto-correcting adjacent braces. ([@lumeet][])
* [#2199](https://github.com/rubocop-hq/rubocop/issues/2199): Make `rubocop` exit with error when there are only `Lint/UnneededDisable` offenses. ([@jonas054][])
* Fix handling of empty parentheses when auto-correcting in `Style/SymbolProc`. ([@lumeet][])

## 0.33.0 (2015-08-05)

### New features

* [#2081](https://github.com/rubocop-hq/rubocop/pull/2081): New cop `Style/Send` checks for the use of `send` and instead encourages changing it to `BasicObject#__send__` or `Object#public_send` (disabled by default). ([@syndbg][])
* [#2057](https://github.com/rubocop-hq/rubocop/pull/2057): New cop `Lint/FormatParameterMismatch` checks for a mismatch between the number of fields expected in format/sprintf/% and what was passed to it. ([@edmz][])
* [#2010](https://github.com/rubocop-hq/rubocop/pull/2010): Add `space` style for SpaceInsideStringInterpolation. ([@gotrevor][])
* [#2007](https://github.com/rubocop-hq/rubocop/pull/2007): Allow any modifier before `def`, not only visibility modifiers. ([@fphilipe][])
* [#1980](https://github.com/rubocop-hq/rubocop/pull/1980): `--auto-gen-config` now outputs an excluded files list for failed cops (up to a maxiumum of 15 files). ([@bmorrall][])
* [#2004](https://github.com/rubocop-hq/rubocop/pull/2004): Introduced `--exclude-limit COUNT` to configure how many files `--auto-gen-config` will exclude. ([@awwaiid][], [@jonas054][])
* [#1918](https://github.com/rubocop-hq/rubocop/issues/1918): New configuration parameter `AllCops:DisabledByDefault` when set to `true` makes only cops found in user configuration enabled, which makes cop selection *opt-in*. ([@jonas054][])
* New cop `Performance/StringReplacement` checks for usages of `gsub` that can be replaced with `tr` or `delete`. ([@rrosenblum][])
* [#2001](https://github.com/rubocop-hq/rubocop/issues/2001): New cop `Style/InitialIndentation` checks for indentation of the first non-blank non-comment line in a file. ([@jonas054][])
* [#2060](https://github.com/rubocop-hq/rubocop/issues/2060): New cop `Style/RescueEnsureAlignment` checks for bad alignment of `rescue` and `ensure` keywords. ([@lumeet][])
* New cop `Style/OptionalArguments` checks for optional arguments that do not appear at the end of an argument list. ([@rrosenblum][])
* New cop `Lint/CircularArgumentReference` checks for "circular argument references" in keyword arguments, which Ruby 2.2 warns against. ([@maxjacobson][], [@sliuu][])
* [#2030](https://github.com/rubocop-hq/rubocop/issues/2030): New cop `Style/OptionHash` checks for option hashes and encourages changing them to keyword arguments (disabled by default). ([@maxjacobson][])

### Changes

* [#2052](https://github.com/rubocop-hq/rubocop/pull/2052): `Style/RescueModifier` uses token stream to identify offenses. ([@urbanautomaton][])
* Rename `Rails/Date` and `Rails/TimeZone` style names to "strict" and "flexible" and make "flexible" to be default. ([@palkan][])
* [#2035](https://github.com/rubocop-hq/rubocop/issues/2035): `Style/ExtraSpacing` is now enabled by default and has a configuration parameter `AllowForAlignment` that is `true` by default, making it allow extra spacing if it's used for alignment purposes. ([@jonas054][])

### Bugs fixed

* [#2014](https://github.com/rubocop-hq/rubocop/pull/2014): Fix `Style/TrivialAccessors` to support AllowPredicates: false. ([@gotrevor][])
* [#1988](https://github.com/rubocop-hq/rubocop/issues/1988): Fix bug in `Style/ParallelAssignment` when assigning from `Module::CONSTANT`. ([@rrosenblum][])
* [#1995](https://github.com/rubocop-hq/rubocop/pull/1995): Improve message for `Rails/TimeZone`. ([@palkan][])
* [#1977](https://github.com/rubocop-hq/rubocop/issues/1977): Fix bugs in `Rails/Date` and `Rails/TimeZone` when using namespaced Time/Date. ([@palkan][])
* [#1973](https://github.com/rubocop-hq/rubocop/issues/1973): Do not register an offense in `Performance/Detect` when `select` is called on `Enumerable::Lazy`. ([@palkan][])
* [#2015](https://github.com/rubocop-hq/rubocop/issues/2015): Fix bug occurring for auto-correction of a misaligned `end` in a file with only one method. ([@jonas054][])
* Allow string interpolation segments inside single quoted string literals when double quotes are preferred. ([@segiddins][])
* [#2026](https://github.com/rubocop-hq/rubocop/issues/2026): Allow `Time.current` when style is "acceptable".([@palkan][])
* [#2029](https://github.com/rubocop-hq/rubocop/issues/2029): Fix bug where `Style/RedundantReturn` auto-corrects returning implicit hashes to invalid syntax. ([@rrosenblum][])
* [#2021](https://github.com/rubocop-hq/rubocop/issues/2021): Fix bug in `Style/BlockDelimiters` when a `semantic` expression is used in an array or a range. ([@lumeet][])
* [#1992](https://github.com/rubocop-hq/rubocop/issues/1992): Allow parentheses in assignment to a variable with the same name as the method's in `Style/MethodCallParentheses`. ([@lumeet][])
* [#2045](https://github.com/rubocop-hq/rubocop/issues/2045): Fix crash in `Style/IndentationWidth` when using `private_class_method def self.foo` syntax. ([@unmanbearpig][])
* [#2006](https://github.com/rubocop-hq/rubocop/issues/2006): Fix crash in `Style/FirstParameterIndentation` in case of nested offenses. ([@unmanbearpig][])
* [#2059](https://github.com/rubocop-hq/rubocop/issues/2059): Don't check for trivial accessors in modules. ([@bbatsov][])
* Add proper punctuation to the end of offense messages, where it is missing. ([@lumeet][])
* [#2071](https://github.com/rubocop-hq/rubocop/pull/2071): Keep line breaks in place on WordArray autocorrect.([@unmanbearpig][])
* [#2075](https://github.com/rubocop-hq/rubocop/pull/2075): Properly correct `Style/PercentLiteralDelimiters` with escape characters in them. ([@rrosenblum][])
* [#2023](https://github.com/rubocop-hq/rubocop/issues/2023): Avoid auto-correction corruption in `IndentationWidth`. ([@jonas054][])
* [#2080](https://github.com/rubocop-hq/rubocop/issues/2080): Properly parse code in `Performance/Count` when calling `select..count` in a class that extends an enumerable. ([@rrosenblum][])
* [#2093](https://github.com/rubocop-hq/rubocop/issues/2093): Fix bug in `Style/OneLineConditional` which should not raise an offense with an 'if/then/end' statement. ([@sliuu][])

## 0.32.1 (2015-06-24)

### New features

* `Debugger` cop now checks catches methods called with arguments. ([@crazydog115][])

### Bugs fixed

* Make it possible to disable `Lint/UnneededDisable`. ([@jonas054][])
* [#1958](https://github.com/rubocop-hq/rubocop/issues/1958): Show name of `Lint/UnneededDisable` when `-D/--display-cop-names` is given. ([@jonas054][])
* Do not show `Style/NonNilCheck` offenses as corrected when the source code is not modified. ([@rrosenblum][])
* Fix auto-correct in `Style/RedundantReturn` when `return` has no arguments. ([@lumeet][])
* [#1955](https://github.com/rubocop-hq/rubocop/issues/1955): Fix false positive for `Style/TrailingComma` cop. ([@mattjmcnaughton][])
* [#1928](https://github.com/rubocop-hq/rubocop/issues/1928): Avoid auto-correcting two alignment offenses in the same area at the same time. ([@jonas054][])
* [#1964](https://github.com/rubocop-hq/rubocop/issues/1964): Fix `RedundantBegin` auto-correct issue with comments by doing a smaller correction. ([@jonas054][])
* [#1978](https://github.com/rubocop-hq/rubocop/pull/1978): Don't count disabled offences if fail-level is autocorrect. ([@sch1zo][])
* [#1986](https://github.com/rubocop-hq/rubocop/pull/1986): Fix Date false positives on variables. ([@palkan][])

### Changes

* [#1708](https://github.com/rubocop-hq/rubocop/issues/1708): Improve message for `FirstParameterIndentation`. ([@tejasbubane][])
* [#1959](https://github.com/rubocop-hq/rubocop/issues/1959): Allow `Lint/UnneededDisable` to be inline disabled. ([@rrosenblum][])

## 0.32.0 (2015-06-06)

### New features

* Adjust behavior of `TrailingComma` cop to account for multi-line hashes nested within method calls. ([@panthomakos][])
* [#1719](https://github.com/rubocop-hq/rubocop/pull/1719): Display an error and abort the program if input file can't be found. ([@matugm][])
* New cop `SpaceInsideStringInterpolation` checks for spaces within string interpolations. ([@glasnt][])
* New cop `NestedMethodDefinition` checks for method definitions inside other methods. ([@ojab][])
* `LiteralInInterpolation` cop does auto-correction. ([@tmr08c][])
* [#1865](https://github.com/rubocop-hq/rubocop/issues/1865): New cop `Lint/UnneededDisable` checks for `rubocop:disable` comments that can be removed. ([@jonas054][])
* `EmptyElse` cop does auto-correction. ([@lumeet][])
* Show reference links when displaying style guide links. ([@rrosenblum][])
* `Debugger` cop now checks for the Capybara debug method `save_screenshot`. ([@crazydog115][])
* [#1282](https://github.com/rubocop-hq/rubocop/issues/1282): `CaseIndentation` cop does auto-correction. ([@lumeet][])
* [#1928](https://github.com/rubocop-hq/rubocop/issues/1928): Do auto-correction one offense at a time (rather than one cop at a time) if there are tabs in the code. ([@jonas054][])

### Changes

* Prefer `SpaceInsideBlockBraces` to `SpaceBeforeSemicolon` and `SpaceAfterSemicolon` to avoid an infinite loop when auto-correcting. ([@lumeet][])
* [#1873](https://github.com/rubocop-hq/rubocop/issues/1873): Move `ParallelAssignment` cop from Performance to Style. ([@rrosenblum][])
* Add `getlocal` to acceptable methods of `Rails/TimeZone`. ([@ojab][])
* [#1851](https://github.com/rubocop-hq/rubocop/issues/1851), [#1948](https://github.com/rubocop-hq/rubocop/issues/1948): Change offense message for `ClassLength` and `ModuleLength` to match that of `MethodLength`. ([@bquorning][])

### Bugs fixed

* Don't count required keyword args when specifying `CountKeywordArgs: false` for `ParameterLists`. ([@sumeet][])
* [#1879](https://github.com/rubocop-hq/rubocop/issues/1879): Avoid auto-correcting hash with trailing comma into invalid code in `BracesAroundHashParameters`. ([@jonas054][])
* [#1868](https://github.com/rubocop-hq/rubocop/issues/1868): Do not register an offense in `Performance/Count` when `select` is called with symbols or strings as the parameters. ([@rrosenblum][])
* `Sample` rewritten to properly handle shuffle randomness source, first/last params and non-literal ranges. ([@chastell][])
* [#1873](https://github.com/rubocop-hq/rubocop/issues/1873): Modify `ParallelAssignment` to properly autocorrect when the assignment is protected by a modifier statement. ([@rrosenblum][])
* Configure `ParallelAssignment` to work with non-standard `IndentationWidths`. ([@rrosenblum][])
* [#1899](https://github.com/rubocop-hq/rubocop/issues/1899): Be careful about comments when auto-correcting in `BracesAroundHashParameters`. ([@jonas054][])
* [#1897](https://github.com/rubocop-hq/rubocop/issues/1897): Don't report that semicolon separated statements can be converted to modifier form in `IfUnlessModifier` (and don't auto-correct them). ([@jonas054][])
* [#1644](https://github.com/rubocop-hq/rubocop/issues/1644): Don't search the entire file system when a folder is named `,` (fix for jruby and rbx). ([@rrosenblum][])
* [#1803](https://github.com/rubocop-hq/rubocop/issues/1803): Don't warn for `return` from `lambda` block in `NonLocalExitFromIterator`. ([@ypresto][])
* [#1905](https://github.com/rubocop-hq/rubocop/issues/1905): Ignore sparse and trailing comments in `Style/Documentation`. ([@RGBD][])
* [#1923](https://github.com/rubocop-hq/rubocop/issues/1923): Handle properly `for` without body in `Style/Next`. ([@bbatsov][])
* [#1901](https://github.com/rubocop-hq/rubocop/issues/1901): Do not auto correct comments that are missing a note. ([@rrosenblum][])
* [#1926](https://github.com/rubocop-hq/rubocop/issues/1926): Fix crash in `Style/AlignHash` when correcting a hash with a splat in it. ([@rrosenblum][])
* [#1935](https://github.com/rubocop-hq/rubocop/issues/1935): Allow `Symbol#to_proc` blocks in Performance/Size. ([@m1foley][])

## 0.31.0 (2015-05-05)

### New features

* `Rails/TimeZone` emits acceptable methods on a violation when `EnforcedStyle` is `:acceptable`. ([@l8nite][])
* Recognize rackup file (config.ru) out of the box. ([@carhartl][])
* [#1788](https://github.com/rubocop-hq/rubocop/pull/1788): New cop `ModuleLength` checks for overly long module definitions. ([@sdeframond][])
* New cop `Performance/Count` to convert `Enumerable#select...size`, `Enumerable#reject...size`, `Enumerable#select...count`, `Enumerable#reject...count` `Enumerable#select...length`, and `Enumerable#reject...length` to `Enumerable#count`. ([@rrosenblum][])
* `CommentAnnotation` cop does auto-correction. ([@dylandavidson][])
* New cop `Style/TrailingUnderscoreVariable` to remove trailing underscore variables from mass assignment. ([@rrosenblum][])
* [#1136](https://github.com/rubocop-hq/rubocop/issues/1136): New cop `Performance/ParallelAssignment` to avoid usages of unnessary parallel assignment. ([@rrosenblum][])
* [#1278](https://github.com/rubocop-hq/rubocop/issues/1278): `DefEndAlignment` and `EndAlignment` cops do auto-correction. ([@lumeet][])
* `IndentationWidth` cop follows the `AlignWith` option of the `DefEndAlignment` cop. ([@lumeet][])
* [#1837](https://github.com/rubocop-hq/rubocop/issues/1837): New cop `EachWithObjectArgument` checks that `each_with_object` isn't called with an immutable object as argument. ([@jonas054][])
* `ArrayJoin` cop does auto-correction. ([@tmr08c][])

### Bugs fixed

* [#1816](https://github.com/rubocop-hq/rubocop/issues/1816): Fix bug in `Sample` when calling `#shuffle` with something other than an element selector. ([@rrosenblum][])
* [#1768](https://github.com/rubocop-hq/rubocop/pull/1768): `DefEndAlignment` recognizes preceding `private_class_method` or `public_class_method` before `def`. ([@til][])
* [#1820](https://github.com/rubocop-hq/rubocop/issues/1820): Correct the logic in `AlignHash` for when to ignore a key because it's not on its own line. ([@jonas054][])
* [#1829](https://github.com/rubocop-hq/rubocop/pull/1829): Fix bug in `Sample` and `FlatMap` that would cause them to report having been auto-corrected when they were not. ([@rrosenblum][])
* [#1832](https://github.com/rubocop-hq/rubocop/pull/1832): Fix bug in `UnusedMethodArgument` that would cause them to report having been auto-corrected when they were not. ([@jonas054][])
* [#1834](https://github.com/rubocop-hq/rubocop/issues/1834): Support only boolean values for `AutoCorrect` configuration parameter, and remove warning for unknown parameter. ([@jonas054][])
* [#1843](https://github.com/rubocop-hq/rubocop/issues/1843): Fix crash in `TrailingBlankLines` when a file ends with a block comment without final newline. ([@jonas054][])
* [#1849](https://github.com/rubocop-hq/rubocop/issues/1849): Fix bug where you can not have nested arrays in the Rake task configuration. ([@rrosenblum][])
* Fix bug in `MultilineTernaryOperator` where it will not register an offense when only the false branch is on a separate line. ([@rrosenblum][])
* Fix crash in `MultilineBlockLayout` when using new lambda literal syntax without parentheses. ([@hbd225][])
* [#1859](https://github.com/rubocop-hq/rubocop/pull/1859): Fix bugs in `IfUnlessModifier` concerning comments and empty lines. ([@jonas054][])
* Fix handling of trailing comma in `SpaceAroundBlockParameters` and `SpaceAfterComma`. ([@lumeet][])

## 0.30.1 (2015-04-21)

### Bugs fixed

* [#1691](https://github.com/rubocop-hq/rubocop/issues/1691): For assignments with line break after `=`, use `keyword` alignment in `EndAlignment` regardless of configured style. ([@jonas054][])
* [#1769](https://github.com/rubocop-hq/rubocop/issues/1769): Fix bug where `LiteralInInterpolation` registers an offense for interpolation of `__LINE__`. ([@rrosenblum][])
* [#1773](https://github.com/rubocop-hq/rubocop/pull/1773): Fix typo ('strptime' -> 'strftime') in `Rails/TimeZone`. ([@palkan][])
* [#1777](https://github.com/rubocop-hq/rubocop/pull/1777): Fix offense message from Rails/TimeZone. ([@mzp][])
* [#1784](https://github.com/rubocop-hq/rubocop/pull/1784): Add an explicit error message when config contains an empty section. ([@bankair][])
* [#1791](https://github.com/rubocop-hq/rubocop/pull/1791): Fix autocorrection of `PercentLiteralDelimiters` with no content. ([@cshaffer][])
* Fix handling of `while` and `until` with assignment in `IndentationWidth`. ([@lumeet][])
* [#1793](https://github.com/rubocop-hq/rubocop/pull/1793): Fix bug in `TrailingComma` that caused `,` in comment to count as a trailing comma. ([@jonas054][])
* [#1765](https://github.com/rubocop-hq/rubocop/pull/1765): Update 1.9 hash to stop triggering when the symbol is not valid in the 1.9 hash syntax. ([@crimsonknave][])
* [#1806](https://github.com/rubocop-hq/rubocop/issues/1806): Require a newer version of `parser` and use its corrected solution for comment association in `Style/Documentation`. ([@jonas054][])
* [#1792](https://github.com/rubocop-hq/rubocop/issues/1792): Fix bugs in `Sample` that did not account for array selectors with a range and passing random to shuffle. ([@rrosenblum][])
* [#1770](https://github.com/rubocop-hq/rubocop/pull/1770): Add more acceptable methods to `Rails/TimeZone` (`utc`, `localtime`, `to_i`, `iso8601` etc). ([@palkan][])
* [#1767](https://github.com/rubocop-hq/rubocop/pull/1767): Do not register offenses on non-enumerable select/find_all by `Performance/Detect`. ([@palkan][])
* [#1795](https://github.com/rubocop-hq/rubocop/pull/1795): Fix bug in `TrailingBlankLines` that caused a crash for files containing only newlines. ([@renuo][])

## 0.30.0 (2015-04-06)

### New features

* [#1600](https://github.com/rubocop-hq/rubocop/issues/1600): Add `line_count_based` and `semantic` styles to the `BlockDelimiters` (formerly `Blocks`) cop. ([@clowder][], [@mudge][])
* [#1712](https://github.com/rubocop-hq/rubocop/pull/1712): Set `Offense#corrected?` to `true`, `false`, or `nil` when it was, wasn't, or can't be auto-corrected, respectively. ([@vassilevsky][])
* [#1669](https://github.com/rubocop-hq/rubocop/pull/1669): Add command-line switch `--display-style-guide`. ([@marxarelli][])
* [#1405](https://github.com/rubocop-hq/rubocop/issues/1405): Add Rails TimeZone and Date cops. ([@palkan][])
* [#1641](https://github.com/rubocop-hq/rubocop/pull/1641): Add ruby19_no_mixed_keys style to `HashStyle` cop. ([@iainbeeston][])
* [#1604](https://github.com/rubocop-hq/rubocop/issues/1604): Add `IgnoreClassMethods` option to `TrivialAccessors` cop. ([@bbatsov][])
* [#1651](https://github.com/rubocop-hq/rubocop/issues/1651): The `Style/SpaceAroundOperators` cop now also detects extra spaces around operators. A list of operators that *may* be surrounded by multiple spaces is configurable. ([@bquorning][])
* Add auto-correct to `Encoding` cop. ([@rrosenblum][])
* [#1621](https://github.com/rubocop-hq/rubocop/issues/1621): `TrailingComma` has a new style `consistent_comma`. ([@tamird][])
* [#1611](https://github.com/rubocop-hq/rubocop/issues/1611): Add `empty`, `nil`, and `both` `SupportedStyles` to `EmptyElse` cop. Default is `both`. ([@rrosenblum][])
* [#1611](https://github.com/rubocop-hq/rubocop/issues/1611): Add new `MissingElse` cop. Default is to have this cop be disabled. ([@rrosenblum][])
* [#1602](https://github.com/rubocop-hq/rubocop/issues/1602): Add support for `# :nodoc` in `Documentation`. ([@lumeet][])
* [#1437](https://github.com/rubocop-hq/rubocop/issues/1437): Modify `HashSyntax` cop to allow the use of hash rockets for hashes that have symbol values when using ruby19 syntax. ([@rrosenblum][])
* New cop `Style/SymbolLiteral` makes sure you're not using the string within symbol syntax unless it's needed. ([@bbatsov][])
* [#1657](https://github.com/rubocop-hq/rubocop/issues/1657): Autocorrect can be turned off on a specific cop via the configuration. ([@jdoconnor][])
* New cop `Style/AutoResourceCleanup` suggests the use of block taking versions of methods that do resource cleanup. ([@bbatsov][])
* [#1275](https://github.com/rubocop-hq/rubocop/issues/1275): `WhileUntilModifier` cop does auto-correction. ([@lumeet][])
* New cop `Performance/ReverseEach` to convert `reverse.each` to `reverse_each`. ([@rrosenblum][])
* [#1281](https://github.com/rubocop-hq/rubocop/issues/1281): `IfUnlessModifier` cop does auto-correction. ([@lumeet][])
* New cop `Performance/Detect` to detect usage of `select.first`, `select.last`, `find_all.first`, and `find_all.last` and convert them to use `detect` instead. ([@palkan][], [@rrosenblum][])
* [#1728](https://github.com/rubocop-hq/rubocop/pull/1728): New cop `NonLocalExitFromIterator` checks for misused `return` in block. ([@ypresto][])
* New cop `Performance/Size` to convert calls to `count` on `Array` and `Hash` to `size`. ([@rrosenblum][])
* New cop `Performance/Sample` to convert usages of `shuffle.first`, `shuffle.last`, and `shuffle[Fixnum]` to `sample`. ([@rrosenblum][])
* New cop `Performance/FlatMap` to convert `Enumerable#map...Array#flatten` and `Enumerable#collect...Array#flatten` to `Enumerable#flat_map`. ([@rrosenblum][])
* [#1144](https://github.com/rubocop-hq/rubocop/issues/1144): New cop `ClosingParenthesisIndentation` checks the indentation of hanging closing parentheses. ([@jonas054][])
* New Rails cop `FindBy` identifies usages of `where.first` and `where.take`. ([@bbatsov][])
* New Rails cop `FindEach` identifies usages of `all.each`. ([@bbatsov][])
* [#1342](https://github.com/rubocop-hq/rubocop/issues/1342): `IndentationConsistency` is now configurable with the styles `normal` and `rails`. ([@jonas054][])

### Bugs fixed

* [#1705](https://github.com/rubocop-hq/rubocop/issues/1705): Fix crash when reporting offenses of `MissingElse` cop. ([@gerry3][])
* [#1659](https://github.com/rubocop-hq/rubocop/pull/1659): Fix stack overflow with JRuby and Windows 8, during initial config validation. ([@pimterry][])
* [#1694](https://github.com/rubocop-hq/rubocop/issues/1694): Ignore methods with a `blockarg` in `TrivialAccessors`. ([@bbatsov][])
* [#1617](https://github.com/rubocop-hq/rubocop/issues/1617): Always read the html output template using utf-8. ([@bbatsov][])
* [#1684](https://github.com/rubocop-hq/rubocop/issues/1684): Ignore symbol keys like `:"string"` in `HashSyntax`. ([@bbatsov][])
* Handle explicit `begin` blocks in `Lint/Void`. ([@bbatsov][])
* Handle symbols in `Lint/Void`. ([@bbatsov][])
* [#1695](https://github.com/rubocop-hq/rubocop/pull/1695): Fix bug with `--auto-gen-config` and `SpaceInsideBlockBraces`. ([@meganemura][])
* Correct issues with whitespace around multi-line lambda arguments. ([@zvkemp][])
* [#1579](https://github.com/rubocop-hq/rubocop/issues/1579): Fix handling of similar-looking blocks in `BlockAlignment`. ([@lumeet][])
* [#1676](https://github.com/rubocop-hq/rubocop/pull/1676): Fix auto-correct in `Lambda` when a new multi-line lambda is used as an argument. ([@lumeet][])
* [#1656](https://github.com/rubocop-hq/rubocop/issues/1656): Fix bug that would include hidden directories implicitly. ([@jonas054][])
* [#1728](https://github.com/rubocop-hq/rubocop/pull/1728): Fix bug in `LiteralInInterpolation` and `AssignmentInCondition`. ([@ypresto][])
* [#1735](https://github.com/rubocop-hq/rubocop/issues/1735): Handle trailing space in `LineEndConcatenation` autocorrect. ([@jonas054][])
* [#1750](https://github.com/rubocop-hq/rubocop/issues/1750): Escape offending code lines output by the HTML formatter in case they contain markup. ([@jonas054][])
* [#1541](https://github.com/rubocop-hq/rubocop/issues/1541): No inspection of text that follows `__END__`. ([@jonas054][])
* Fix comment detection in `Style/Documentation`. ([@lumeet][])
* [#1637](https://github.com/rubocop-hq/rubocop/issues/1637): Fix handling of `binding` calls in `UnusedBlockArgument` and `UnusedMethodArgument`. ([@lumeet][])

### Changes

* [#1397](https://github.com/rubocop-hq/rubocop/issues/1397): `UnneededPercentX` renamed to `CommandLiteral`. The cop can be configured to enforce using either `%x` or backticks around command literals, or using `%x` around multi-line commands and backticks around single-line commands. The cop ignores heredoc commands. ([@bquorning][])
* [#1020](https://github.com/rubocop-hq/rubocop/issues/1020): Removed the `MaxSlashes` configuration option for `RegexpLiteral`. Instead, the cop can be configured to enforce using either `%r` or slashes around regular expressions, or using `%r` around multi-line regexes and slashes around single-line regexes. ([@bquorning][])
* [#1734](https://github.com/rubocop-hq/rubocop/issues/1734): The default exclusion of hidden directories has been optimized for speed. ([@jonas054][])
* [#1673](https://github.com/rubocop-hq/rubocop/issues/1673): `Style/TrivialAccessors` now requires matching names by default. ([@bbatsov][])

## 0.29.1 (2015-02-13)

### Bugs fixed

* [#1638](https://github.com/rubocop-hq/rubocop/issues/1638): Use Parser functionality rather than regular expressions for matching comments in `FirstParameterIndentation`. ([@jonas054][])
* [#1642](https://github.com/rubocop-hq/rubocop/issues/1642): Raise the correct exception if the configuration file is malformed. ([@bquorning][])
* [#1647](https://github.com/rubocop-hq/rubocop/issues/1647): Skip `SpaceAroundBlockParameters` when lambda has no argument. ([@eitoball][])
* [#1649](https://github.com/rubocop-hq/rubocop/issues/1649): Handle exception assignments in `UselessSetterCall`. ([@bbatsov][])
* [#1644](https://github.com/rubocop-hq/rubocop/issues/1644): Don't search the entire file system when a folder is named `,`. ([@bquorning][])

## 0.29.0 (2015-02-05)

### New features

* [#1430](https://github.com/rubocop-hq/rubocop/issues/1430): Add `--except` option for disabling cops on the command line. ([@jonas054][])
* [#1506](https://github.com/rubocop-hq/rubocop/pull/1506): Add auto-correct from `EvenOdd` cop. ([@blainesch][])
* [#1507](https://github.com/rubocop-hq/rubocop/issues/1507): `Debugger` cop now checks for the Capybara debug methods `save_and_open_page` and `save_and_open_screenshot`. ([@rrosenblum][])
* [#1539](https://github.com/rubocop-hq/rubocop/pull/1539): Implement autocorrection for Rails/ReadWriteAttribute cop. ([@huerlisi][])
* [#1324](https://github.com/rubocop-hq/rubocop/issues/1324): Add `AllCops/DisplayCopNames` configuration option for showing cop names in reports, like `--display-cop-names`. ([@jonas054][])
* [#1271](https://github.com/rubocop-hq/rubocop/issues/1271): `Lambda` cop does auto-correction. ([@lumeet][])
* [#1284](https://github.com/rubocop-hq/rubocop/issues/1284): Support namespaces, e.g. `Lint`, in the arguments to `--only` and `--except`. ([@jonas054][])
* [#1276](https://github.com/rubocop-hq/rubocop/issues/1276): `SelfAssignment` cop does auto-correction. ([@lumeet][])
* Add autocorrect to `RedundantException`. ([@mattjmcnaughton][])
* [#1571](https://github.com/rubocop-hq/rubocop/pull/1571): New cop `StructInheritance` checks for inheritance from Struct.new. ([@mmozuras][])
* [#1575](https://github.com/rubocop-hq/rubocop/issues/1575): New cop `DuplicateMethods` points out duplicate method name in class and module. ([@d4rk5eed][])
* [#1144](https://github.com/rubocop-hq/rubocop/issues/1144): New cop `FirstParameterIndentation` checks the indentation of the first parameter in a method call. ([@jonas054][])
* [#1627](https://github.com/rubocop-hq/rubocop/issues/1627): New cop `SpaceAroundBlockParameters` checks the spacing inside and after block parameters pipes. ([@jonas054][])

### Changes

* [#1492](https://github.com/rubocop-hq/rubocop/pull/1492): Abort when auto-correct causes an infinite loop. ([@dblock][])
* Options `-e`/`--emacs` and `-s`/`--silent` are no longer recognized. Using them will now raise an error. ([@bquorning][])
* [#1565](https://github.com/rubocop-hq/rubocop/issues/1565): Let `--fail-level A` cause exit with error if all offenses are auto-corrected. ([@jonas054][])
* [#1309](https://github.com/rubocop-hq/rubocop/issues/1309): Add argument handling to `MultilineBlockLayout`. ([@lumeet][])

### Bugs fixed

* [#1634](https://github.com/rubocop-hq/rubocop/pull/1634): Fix `PerlBackrefs` Cop Autocorrections to Not Raise. ([@cshaffer][])
* [#1553](https://github.com/rubocop-hq/rubocop/pull/1553): Fix bug where `Style/EmptyLinesAroundAccessModifier` interfered with `Style/EmptyLinesAroundBlockBody` when there is and access modifier at the beginning of a block. ([@volkert][])
* Handle element assignment in `Lint/AssignmentInCondition`. ([@jonas054][])
* [#1484](https://github.com/rubocop-hq/rubocop/issues/1484): Fix `EmptyLinesAroundAccessModifier` incorrectly finding a violation inside method calls with names identical to an access modifier. ([@dblock][])
* Fix bug concerning `Exclude` properties inherited from a higher directory level. ([@jonas054][])
* [#1500](https://github.com/rubocop-hq/rubocop/issues/1500): Fix crashing `--auto-correct --only IndentationWidth`. ([@jonas054][])
* [#1512](https://github.com/rubocop-hq/rubocop/issues/1512): Fix false negative for typical string formatting examples. ([@kakutani][], [@jonas054][])
* [#1504](https://github.com/rubocop-hq/rubocop/issues/1504): Fail with a meaningful error if the configuration file is malformed. ([@bquorning][])
* Fix bug where `auto_correct` Rake tasks does not take in the options specified in its parent task. ([@rrosenblum][])
* [#1054](https://github.com/rubocop-hq/rubocop/issues/1054): Handle comments within concatenated strings in `LineEndConcatenation`. ([@yujinakayama][], [@jonas054][])
* [#1527](https://github.com/rubocop-hq/rubocop/issues/1527): Make autocorrect `BracesAroundHashParameter` leave the correct number of spaces. ([@mattjmcnaughton][])
* [#1547](https://github.com/rubocop-hq/rubocop/issues/1547): Don't print `[Corrected]` when auto-correction was avoided in `Style/Semicolon`. ([@jonas054][])
* [#1573](https://github.com/rubocop-hq/rubocop/issues/1573): Fix assignment-related auto-correction for `BlockAlignment`. ([@lumeet][])
* [#1587](https://github.com/rubocop-hq/rubocop/pull/1587): Exit with exit code 1 if there were errors ("crashing" cops). ([@jonas054][])
* [#1574](https://github.com/rubocop-hq/rubocop/issues/1574): Avoid auto-correcting `Hash.new` to `{}` when braces would be interpreted as a block. ([@jonas054][])
* [#1591](https://github.com/rubocop-hq/rubocop/issues/1591): Don't check parameters inside `[]` in `MultilineOperationIndentation`. ([@jonas054][])
* [#1509](https://github.com/rubocop-hq/rubocop/issues/1509): Ignore class methods in `Rails/Delegate`. ([@bbatsov][])
* [#1594](https://github.com/rubocop-hq/rubocop/issues/1594): Fix `@example` warnings in Yard Doc documentation generation. ([@mattjmcnaughton][])
* [#1598](https://github.com/rubocop-hq/rubocop/issues/1598): Fix bug in file inclusion when running from another directory. ([@jonas054][])
* [#1580](https://github.com/rubocop-hq/rubocop/issues/1580): Don't print `[Corrected]` when auto-correction was avoided in `TrivialAccessors`. ([@lumeet][])
* [#1612](https://github.com/rubocop-hq/rubocop/issues/1612): Allow `expand_path` on `inherit_from` in `.rubocop.yml`. ([@mattjmcnaughton][])
* [#1610](https://github.com/rubocop-hq/rubocop/issues/1610): Check that class method names actually match the name of the containing class/module in `Style/ClassMethods`. ([@bbatsov][])

## 0.28.0 (2014-12-10)

### New features

* [#1450](https://github.com/rubocop-hq/rubocop/issues/1450): New cop `ExtraSpacing` points out unnecessary spacing in files. ([@blainesch][])
* New cop `EmptyLinesAroundBlockBody` provides same functionality as the EmptyLinesAround(Class|Method|Module)Body but for blocks. ([@jcarbo][])
* New cop `Style/EmptyElse` checks for empty `else`-clauses. ([@Koronen][])
* [#1454](https://github.com/rubocop-hq/rubocop/issues/1454): New `--only-guide-cops` and `AllCops/StyleGuideCopsOnly` options that will only enforce cops that link to a style guide. ([@marxarelli][])

### Changes

* [#801](https://github.com/rubocop-hq/rubocop/issues/801): New style `context_dependent` for `Style/BracesAroundHashParameters` looks at preceding parameter to determine if braces should be used for final parameter. ([@jonas054][])
* [#1427](https://github.com/rubocop-hq/rubocop/issues/1427): Excluding directories on the top level is now done earlier, so that these file trees are not searched, thus saving time when inspecting projects with many excluded files. ([@jonas054][])
* [#1325](https://github.com/rubocop-hq/rubocop/issues/1325): When running with `--auto-correct`, only offenses *that can not be corrected* will result in a non-zero exit code. ([@jonas054][])
* [#1445](https://github.com/rubocop-hq/rubocop/issues/1445): Allow sprockets directive comments (starting with `#=`) in `Style/LeadingCommentSpace`. ([@bbatsov][])

### Bugs fixed

* Fix `%W[]` auto corrected to `%w(]`. ([@toy][])
* Fix Style/ElseAlignment Cop to find the right parent on def/rescue/else/ensure/end. ([@oneamtu][])
* [#1181](https://github.com/rubocop-hq/rubocop/issues/1181): *(fix again)* `Style/StringLiterals` cop stays away from strings inside interpolated expressions. ([@jonas054][])
* [#1441](https://github.com/rubocop-hq/rubocop/issues/1441): Correct the logic used by `Style/Blocks` and other cops to determine if an auto-correction would alter the meaning of the code. ([@jonas054][])
* [#1449](https://github.com/rubocop-hq/rubocop/issues/1449): Handle the case in `MultilineOperationIndentation` where instances of both correct style and unrecognized (plain wrong) style are detected during an `--auto-gen-config` run. ([@jonas054][])
* [#1456](https://github.com/rubocop-hq/rubocop/pull/1456): Fix autocorrect in `SymbolProc` when there are multiple offenses on the same line. ([@jcarbo][])
* [#1459](https://github.com/rubocop-hq/rubocop/issues/1459): Handle parenthesis around the condition in `--auto-correct` for `NegatedWhile`. ([@jonas054][])
* [#1465](https://github.com/rubocop-hq/rubocop/issues/1465): Fix autocorrect of code like `#$1` in `PerlBackrefs`. ([@bbatsov][])
* Fix autocorrect of code like `#$:` in `SpecialGlobalVars`. ([@bbatsov][])
* [#1466](https://github.com/rubocop-hq/rubocop/issues/1466): Allow leading underscore for unused parameters in `SingleLineBlockParams`. ([@jonas054][])
* [#1470](https://github.com/rubocop-hq/rubocop/issues/1470): Handle `elsif` + `else` in `ElseAlignment`. ([@jonas054][])
* [#1474](https://github.com/rubocop-hq/rubocop/issues/1474): Multiline string with both `<<` and `\` caught by `Style/LineEndConcatenation` cop. ([@katieschilling][])
* [#1485](https://github.com/rubocop-hq/rubocop/issues/1485): Ignore procs in `SymbolProc`. ([@bbatsov][])
* [#1473](https://github.com/rubocop-hq/rubocop/issues/1473): `Style/MultilineOperationIndentation` doesn't recognize assignment to array/hash element. ([@jonas054][])

## 0.27.1 (2014-11-08)

### Changes

* [#1343](https://github.com/rubocop-hq/rubocop/issues/1343): Remove auto-correct from `RescueException` cop. ([@bbatsov][])
* [#1425](https://github.com/rubocop-hq/rubocop/issues/1425): `AllCops/Include` configuration parameters are only taken from the project `.rubocop.yml` and files it inherits from, not from `.rubocop.yml` files in subdirectories. ([@jonas054][])

### Bugs fixed

* [#1411](https://github.com/rubocop-hq/rubocop/issues/1411): Handle lambda calls without a selector in `MultilineOperationIndentation`. ([@bbatsov][])
* [#1401](https://github.com/rubocop-hq/rubocop/issues/1401): Files in hidden directories, i.e. ones beginning with dot, can now be selected through configuration, but are still not included by default. ([@jonas054][])
* [#1415](https://github.com/rubocop-hq/rubocop/issues/1415): String literals concatenated with backslashes are now handled correctly by `StringLiteralsInInterpolation`. ([@jonas054][])
* [#1416](https://github.com/rubocop-hq/rubocop/issues/1416): Fix handling of `begin/rescue/else/end` in `ElseAlignment`. ([@jonas054][])
* [#1413](https://github.com/rubocop-hq/rubocop/issues/1413): Support empty elsif branches in `MultilineIfThen`. ([@janraasch][], [@jonas054][])
* [#1406](https://github.com/rubocop-hq/rubocop/issues/1406): Allow a newline in `SpaceInsideRangeLiteral`. ([@bbatsov][])

## 0.27.0 (2014-10-30)

### New features

* [#1348](https://github.com/rubocop-hq/rubocop/issues/1348): New cop `ElseAlignment` checks alignment of `else` and `elsif` keywords. ([@jonas054][])
* [#1321](https://github.com/rubocop-hq/rubocop/issues/1321): New cop `MultilineOperationIndentation` checks indentation/alignment of binary operations if they span more than one line. ([@jonas054][])
* [#1077](https://github.com/rubocop-hq/rubocop/issues/1077): New cop `Metrics/AbcSize` checks the ABC metric, based on assignments, branches, and conditions. ([@jonas054][], [@jfelchner][])
* [#1352](https://github.com/rubocop-hq/rubocop/issues/1352): `WordArray` is now configurable with the `WordRegex` option. ([@bquorning][])
* [#1181](https://github.com/rubocop-hq/rubocop/issues/1181): New cop `Style/StringLiteralsInInterpolation` checks quotes inside interpolated expressions in strings. ([@jonas054][])
* [#872](https://github.com/rubocop-hq/rubocop/issues/872): `Style/IndentationWidth` is now configurable with the `Width` option. ([@jonas054][])
* [#1396](https://github.com/rubocop-hq/rubocop/issues/1396): Include `.opal` files by default. ([@bbatsov][])
* [#771](https://github.com/rubocop-hq/rubocop/issues/771): Three new `Style` cops, `EmptyLinesAroundMethodBody` , `EmptyLinesAroundClassBody` , and `EmptyLinesAroundModuleBody` replace the `EmptyLinesAroundBody` cop. ([@jonas054][])

### Changes

* [#1084](https://github.com/rubocop-hq/rubocop/issues/1084): Disabled `Style/CollectionMethods` by default. ([@bbatsov][])

### Bugs fixed

* `AlignHash` no longer skips multiline hashes that contain some elements on the same line. ([@mvz][])
* [#1349](https://github.com/rubocop-hq/rubocop/issues/1349): `BracesAroundHashParameters` no longer cleans up whitespace in autocorrect, as these extra corrections are likely to interfere with other cops' corrections. ([@jonas054][])
* [#1350](https://github.com/rubocop-hq/rubocop/issues/1350): Guard against `Blocks` cop introducing syntax errors in auto-correct. ([@jonas054][])
* [#1374](https://github.com/rubocop-hq/rubocop/issues/1374): To eliminate interference, auto-correction is now done by one cop at a time, with saving and re-parsing in between. ([@jonas054][])
* [#1388](https://github.com/rubocop-hq/rubocop/issues/1388): Fix a false positive in `FormatString`. ([@bbatsov][])
* [#1389](https://github.com/rubocop-hq/rubocop/issues/1389): Make `--out` to create parent directories. ([@yous][])
* Refine HTML formatter. ([@yujinakayama][])
* [#1410](https://github.com/rubocop-hq/rubocop/issues/1410): Handle specially Java primitive type references in `ColonMethodCall`. ([@bbatsov][])

## 0.26.1 (2014-09-18)

### Bugs fixed

* [#1326](https://github.com/rubocop-hq/rubocop/issues/1326): Fix problem in `SpaceInsideParens` with detecting space inside parentheses used for grouping expressions. ([@jonas054][])
* [#1335](https://github.com/rubocop-hq/rubocop/issues/1335): Restrict URI schemes permitted by `LineLength` when `AllowURI` is enabled. ([@smangelsdorf][])
* [#1339](https://github.com/rubocop-hq/rubocop/issues/1339): Handle `eql?` and `equal?` in `OpMethod`. ([@bbatsov][])
* [#1340](https://github.com/rubocop-hq/rubocop/issues/1340): Fix crash in `Style/SymbolProc` cop when the block calls a method with no explicit receiver. ([@smangelsdorf][])

## 0.26.0 (2014-09-03)

### New features

* New formatter `HTMLFormatter` generates a html file with a list of files with offences in them. ([@SkuliOskarsson][])
* New cop `SpaceInsideRangeLiteral` checks for spaces around `..` and `...` in range literals. ([@bbatsov][])
* New cop `InfiniteLoop` checks for places where `Kernel#loop` should have been used. ([@bbatsov][])
* New cop `SymbolProc` checks for places where a symbol can be used as proc instead of a block. ([@bbatsov][])
* `UselessAssignment` cop now suggests a variable name for possible typos if there's a variable-ish identifier similar to the unused variable name in the same scope. ([@yujinakayama][])
* `PredicateName` cop now has separate configurations for prefices that denote predicate method names and predicate prefices that should be removed. ([@bbatsov][])
* [#1272](https://github.com/rubocop-hq/rubocop/issues/1272): `Tab` cop does auto-correction. ([@yous][])
* [#1274](https://github.com/rubocop-hq/rubocop/issues/1274): `MultilineIfThen` cop does auto-correction. ([@bbatsov][])
* [#1279](https://github.com/rubocop-hq/rubocop/issues/1279): `DotPosition` cop does auto-correction. ([@yous][])
* [#1277](https://github.com/rubocop-hq/rubocop/issues/1277): `SpaceBeforeFirstArg` cop does auto-correction. ([@yous][])
* [#1310](https://github.com/rubocop-hq/rubocop/issues/1310): Handle `module_function` in `Style/AccessModifierIndentation` and `Style/EmptyLinesAroundAccessModifier`. ([@bbatsov][])

### Changes

* [#1289](https://github.com/rubocop-hq/rubocop/issues/1289): Use utf-8 as default encoding for inspected files. ([@jonas054][])
* [#1304](https://github.com/rubocop-hq/rubocop/issues/1304): `Style/Encoding` is no longer a no-op on Ruby 2.x. It's also disabled by default, as projects not supporting 1.9 don't need to run it. ([@bbatsov][])

### Bugs fixed

* [#1263](https://github.com/rubocop-hq/rubocop/issues/1263): Do not report `%W` literals with special escaped characters in `UnneededCapitalW`. ([@jonas054][])
* [#1286](https://github.com/rubocop-hq/rubocop/issues/1286): Fix a false positive in `VariableName`. ([@bbatsov][])
* [#1211](https://github.com/rubocop-hq/rubocop/issues/1211): Fix false negative in `UselessAssignment` when there's a reference for the variable in an exclusive branch. ([@yujinakayama][])
* [#1307](https://github.com/rubocop-hq/rubocop/issues/1307): Fix auto-correction of `RedundantBegin` cop deletes new line. ([@yous][])
* [#1283](https://github.com/rubocop-hq/rubocop/issues/1283): Fix auto-correction of indented expressions in `PercentLiteralDelimiters`. ([@jonas054][])
* [#1315](https://github.com/rubocop-hq/rubocop/pull/1315): `BracesAroundHashParameters` auto-correction removes whitespace around content inside braces. ([@jspanjers][])
* [#1313](https://github.com/rubocop-hq/rubocop/issues/1313): Fix a false positive in `AndOr` when enforced style is `conditionals`. ([@bbatsov][])
* Handle post-conditional `while` and `until` in `AndOr` when enforced style is `conditionals`. ([@yujinakayama][])
* [#1319](https://github.com/rubocop-hq/rubocop/issues/1319): Fix a false positive in `FormatString`. ([@bbatsov][])
* [#1287](https://github.com/rubocop-hq/rubocop/issues/1287): Allow missing blank line for EmptyLinesAroundAccessModifier if next line closes a block. ([@sch1zo][])

## 0.25.0 (2014-08-15)

### New features

* [#1259](https://github.com/rubocop-hq/rubocop/issues/1259): Allow AndOr cop to autocorrect by adding method call parenthesis. ([@vrthra][])
* [#1232](https://github.com/rubocop-hq/rubocop/issues/1232): Add EnforcedStyle option to cop `AndOr` to restrict it to conditionals. ([@vrthra][])
* [#835](https://github.com/rubocop-hq/rubocop/issues/835): New cop `PercentQLiterals` checks if use of `%Q` and `%q` matches configuration. ([@jonas054][])
* [#835](https://github.com/rubocop-hq/rubocop/issues/835): New cop `BarePercentLiterals` checks if usage of `%()` or `%Q()` matches configuration. ([@jonas054][])
* [#1079](https://github.com/rubocop-hq/rubocop/pull/1079): New cop `MultilineBlockLayout` checks if a multiline block has an expression on the same line as the start of the block. ([@barunio][])
* [#1217](https://github.com/rubocop-hq/rubocop/pull/1217): `Style::EmptyLinesAroundAccessModifier` cop does auto-correction. ([@tamird][])
* [#1220](https://github.com/rubocop-hq/rubocop/issues/1220): New cop `PerceivedComplexity` is similar to `CyclomaticComplexity`, but reports when methods have a high complexity for a human reader. ([@jonas054][])
* `Debugger` cop now checks for `binding.pry_remote`. ([@yous][])
* [#1238](https://github.com/rubocop-hq/rubocop/issues/1238): Add `MinBodyLength` option to `Next` cop. ([@bbatsov][])
* [#1241](https://github.com/rubocop-hq/rubocop/issues/1241): `TrailingComma` cop does auto-correction. ([@yous][])
* [#1078](https://github.com/rubocop-hq/rubocop/pull/1078): New cop `BlockEndNewline` checks if the end statement of a multiline block is on its own line. ([@barunio][])
* [#1078](https://github.com/rubocop-hq/rubocop/pull/1078): `BlockAlignment` cop does auto-correction. ([@barunio][])

### Changes

* [#1220](https://github.com/rubocop-hq/rubocop/issues/1220): New namespace `Metrics` created and some `Style` cops moved there. ([@jonas054][])
* Drop support for Ruby 1.9.2 in accordance with [the end of the security maintenance extension](https://www.ruby-lang.org/en/news/01-07-2014/eol-for-1-8-7-and-1-9-2/). ([@yujinakayama][])

### Bugs fixed

* [#1251](https://github.com/rubocop-hq/rubocop/issues/1251): Fix `PercentLiteralDelimiters` auto-correct indentation error. ([@hannestyden][])
* [#1197](https://github.com/rubocop-hq/rubocop/issues/1197): Fix false positive for new lambda syntax in `SpaceInsideBlockBraces`. ([@jonas054][])
* [#1201](https://github.com/rubocop-hq/rubocop/issues/1201): Fix error at anonymous keyword splat arguments in some variable cops. ([@yujinakayama][])
* Fix false positive in `UnneededPercentQ` for `/%Q(something)/`. ([@jonas054][])
* Fix `SpacesInsideBrackets` for `Hash#[]` calls with spaces after left bracket. ([@mcls][])
* [#1210](https://github.com/rubocop-hq/rubocop/issues/1210): Fix false positive in `UnneededPercentQ` for `%Q(\t")`. ([@jonas054][])
* Fix false positive in `UnneededPercentQ` for heredoc strings with `%q`/`%Q`. ([@jonas054][])
* [#1214](https://github.com/rubocop-hq/rubocop/issues/1214): Don't destroy code in `AlignHash` autocorrect. ([@jonas054][])
* [#1219](https://github.com/rubocop-hq/rubocop/issues/1219): Don't report bad alignment for `end` or `}` in `BlockAlignment` if it doesn't begin its line. ([@jonas054][])
* [#1227](https://github.com/rubocop-hq/rubocop/issues/1227): Don't permanently change yamler as it can affect other apps. ([@jonas054][])
* [#1184](https://github.com/rubocop-hq/rubocop/issues/1184): Fix a false positive in `Output` cop. ([@bbatsov][])
* [#1256](https://github.com/rubocop-hq/rubocop/issues/1256): Ignore block-pass in `TrailingComma`. ([@tamird][])
* [#1255](https://github.com/rubocop-hq/rubocop/issues/1255): Compare without context in `AutocorrectUnlessChangingAST`. ([@jonas054][])
* [#1262](https://github.com/rubocop-hq/rubocop/issues/1262): Handle regexp and backtick literals in `VariableInterpolation`. ([@bbatsov][])

## 0.24.1 (2014-07-03)

### Bugs fixed

* [#1174](https://github.com/rubocop-hq/rubocop/issues/1174): Fix `--auto-correct` crash in `AlignParameters`. ([@jonas054][])
* [#1176](https://github.com/rubocop-hq/rubocop/issues/1176): Fix `--auto-correct` crash in `IndentationWidth`. ([@jonas054][])
* [#1177](https://github.com/rubocop-hq/rubocop/issues/1177): Avoid suggesting underscore-prefixed name for unused keyword arguments and auto-correcting in that way. ([@yujinakayama][])
* [#1157](https://github.com/rubocop-hq/rubocop/issues/1157): Validate `--only` arguments later when all cop names are known. ([@jonas054][])
* [#1188](https://github.com/rubocop-hq/rubocop/issues/1188), [#1190](https://github.com/rubocop-hq/rubocop/issues/1190): Fix crash in `LineLength` cop when `AllowURI` option is enabled. ([@yujinakayama][])
* [#1191](https://github.com/rubocop-hq/rubocop/issues/1191): Fix crash on empty body branches in a loop in `Next` cop. ([@yujinakayama][])

## 0.24.0 (2014-06-25)

### New features

* [#639](https://github.com/rubocop-hq/rubocop/issues/639): Support square bracket setters in `UselessSetterCall`. ([@yujinakayama][])
* [#835](https://github.com/rubocop-hq/rubocop/issues/835): `UnneededCapitalW` cop does auto-correction. ([@sfeldon][])
* [#1092](https://github.com/rubocop-hq/rubocop/issues/1092): New cop `DefEndAlignment` takes over responsibility for checking alignment of method definition `end`s from `EndAlignment`, and is configurable. ([@jonas054][])
* [#1145](https://github.com/rubocop-hq/rubocop/issues/1145): New cop `ClassCheck` enforces consistent use of `is_a?` or `kind_of?`. ([@bbatsov][])
* [#1161](https://github.com/rubocop-hq/rubocop/pull/1161): New cop `SpaceBeforeComma` detects spaces before a comma. ([@agrimm][])
* [#1161](https://github.com/rubocop-hq/rubocop/pull/1161): New cop `SpaceBeforeSemicolon` detects spaces before a semicolon. ([@agrimm][])
* [#835](https://github.com/rubocop-hq/rubocop/issues/835): New cop `UnneededPercentQ` checks for usage of the `%q`/`%Q` syntax when `''` or `""` would do. ([@jonas054][])
* [#977](https://github.com/rubocop-hq/rubocop/issues/977): Add `AllowURI` option (enabled by default) to `LineLength` cop. ([@yujinakayama][])

### Changes

* Unused block local variables (`obj.each { |arg; this| }`) are now handled by `UnusedBlockArgument` cop instead of `UselessAssignment` cop. ([@yujinakayama][])
* [#1141](https://github.com/rubocop-hq/rubocop/issues/1141): Clarify in the message from `TrailingComma` that a trailing comma is never allowed for lists where some items share a line. ([@jonas054][])

### Bugs fixed

* [#1133](https://github.com/rubocop-hq/rubocop/issues/1133): Handle `reduce/inject` with no arguments in `EachWithObject`. ([@bbatsov][])
* [#1152](https://github.com/rubocop-hq/rubocop/issues/1152): Handle `while/until` with no body in `Next`. ([@tamird][])
* Fix a false positive in `UselessSetterCall` for setter call on a local variable that contains a non-local object. ([@yujinakayama][])
* [#1158](https://github.com/rubocop-hq/rubocop/issues/1158): Fix auto-correction of floating-point numbers. ([@bbatsov][])
* [#1159](https://github.com/rubocop-hq/rubocop/issues/1159): Fix checking of `begin`..`end` structures, blocks, and parenthesized expressions in `IndentationWidth`. ([@jonas054][])
* [#1159](https://github.com/rubocop-hq/rubocop/issues/1159): More rigid conditions for when `attr` is considered an offense. ([@jonas054][])
* [#1167](https://github.com/rubocop-hq/rubocop/issues/1167): Fix handling of parameters spanning multiple lines in `TrailingComma`. ([@jonas054][])
* [#1169](https://github.com/rubocop-hq/rubocop/issues/1169): Fix handling of ternary op conditions in `ParenthesesAroundCondition`. ([@bbatsov][])
* [#1147](https://github.com/rubocop-hq/rubocop/issues/1147): WordArray checks arrays with special characters. ([@camilleldn][])
* Fix a false positive against `return` in a loop in `Next` cop. ([@yujinakayama][])
* [#1165](https://github.com/rubocop-hq/rubocop/issues/1165): Support `rescue`/`else`/`ensure` bodies in `IndentationWidth`. ([@jonas054][])
* Fix false positive for aligned list of values after `when` in `IndentationWidth`. ([@jonas054][])

## 0.23.0 (2014-06-02)

### New features

* [#1117](https://github.com/rubocop-hq/rubocop/issues/1117): `BlockComments` cop does auto-correction. ([@jonas054][])
* [#1124](https://github.com/rubocop-hq/rubocop/pull/1124): `TrivialAccessors` cop auto-corrects class-level accessors. ([@ggilder][])
* [#1062](https://github.com/rubocop-hq/rubocop/pull/1062): New cop `InlineComment` checks for inline comments. ([@salbertson][])
* [#1118](https://github.com/rubocop-hq/rubocop/issues/1118): Add checking and auto-correction of right brackets in `IndentArray` and `IndentHash`. ([@jonas054][])

### Changes

* [#1097](https://github.com/rubocop-hq/rubocop/issues/1097): Add optional namespace prefix to cop names: `Style/LineLength` instead of `LineLength` in config files, `--only` argument, `--show-cops` output, and `# rubocop:disable`. ([@jonas054][])
* [#1075](https://github.com/rubocop-hq/rubocop/issues/1075): More strict limits on when to require trailing comma. ([@jonas054][])
* Renamed `Rubocop` module to `RuboCop`. ([@bbatsov][])

### Bugs fixed

* [#1126](https://github.com/rubocop-hq/rubocop/pull/1126): Fix `--auto-gen-config` bug with `RegexpLiteral` where only the last file's results would be used. ([@ggilder][])
* [#1104](https://github.com/rubocop-hq/rubocop/issues/1104): Fix `EachWithObject` with modifier if as body. ([@geniou][])
* [#1106](https://github.com/rubocop-hq/rubocop/issues/1106): Fix `EachWithObject` with single method call as body. ([@geniou][])
* Avoid the warning about ignoring syck YAML engine from JRuby. ([@jonas054][])
* [#1111](https://github.com/rubocop-hq/rubocop/issues/1111): Fix problem in `EndOfLine` with reading non-UTF-8 encoded files. ([@jonas054][])
* [#1115](https://github.com/rubocop-hq/rubocop/issues/1115): Fix `Next` to ignore super nodes. ([@geniou][])
* [#1117](https://github.com/rubocop-hq/rubocop/issues/1117): Don't auto-correct indentation in scopes that contain block comments (`=begin`..`=end`). ([@jonas054][])
* [#1123](https://github.com/rubocop-hq/rubocop/pull/1123): Support setter calls in safe assignment in `ParenthesesAroundCondition`. ([@jonas054][])
* [#1090](https://github.com/rubocop-hq/rubocop/issues/1090): Correct handling of documentation vs annotation comment. ([@jonas054][])
* [#1118](https://github.com/rubocop-hq/rubocop/issues/1118): Never write invalid ruby to a file in auto-correct. ([@jonas054][])
* [#1120](https://github.com/rubocop-hq/rubocop/issues/1120): Don't change indentation of heredoc strings in auto-correct. ([@jonas054][])
* [#1109](https://github.com/rubocop-hq/rubocop/issues/1109): Handle conditions with modifier ops in them in `ParenthesesAroundCondition`. ([@bbatsov][])

## 0.22.0 (2014-05-20)

### New features

* [#974](https://github.com/rubocop-hq/rubocop/pull/974): New cop `CommentIndentation` checks indentation of comments. ([@jonas054][])
* Add new cop `EachWithObject` to prefer `each_with_object` over `inject` or `reduce`. ([@geniou][])
* [#1010](https://github.com/rubocop-hq/rubocop/issues/1010): New Cop `Next` check for conditions at the end of an iteration and propose to use `next` instead. ([@geniou][])
* The `GuardClause` cop now also looks for unless and it is configurable how many lines the body of an if / unless needs to have to not be ignored. ([@geniou][])
* [#835](https://github.com/rubocop-hq/rubocop/issues/835): New cop `UnneededPercentX` checks for `%x` when backquotes would do. ([@jonas054][])
* Add auto-correct to `UnusedBlockArgument` and `UnusedMethodArgument` cops. ([@hannestyden][])
* [#1074](https://github.com/rubocop-hq/rubocop/issues/1074): New cop `SpaceBeforeComment` checks for missing space between code and a comment on the same line. ([@jonas054][])
* [#1089](https://github.com/rubocop-hq/rubocop/pull/1089): New option `-F`/`--fail-fast` inspects files in modification time order and stop after the first file with offenses. ([@jonas054][])
* Add optional `require` directive to `.rubocop.yml` to load custom ruby files. ([@geniou][])

### Changes

* `NonNilCheck` offense reporting and autocorrect are configurable to include semantic changes. ([@hannestyden][])
* The parameters `AllCops/Excludes` and `AllCops/Includes` with final `s` only give a warning and don't halt `rubocop` execution. ([@jonas054][])
* The `GuardClause` cop is no longer ignoring a one-line body by default - see configuration. ([@geniou][])
* [#1050](https://github.com/rubocop-hq/rubocop/issues/1050): Rename `rubocop-todo.yml` file to `.rubocop_todo.yml`. ([@geniou][])
* [#1064](https://github.com/rubocop-hq/rubocop/issues/1064): Adjust default max line length to 80. ([@bbatsov][])

### Bugs fixed

* Allow assignment in `AlignParameters` cop. ([@tommeier][])
* Fix `Void` and `SpaceAroundOperators` for short call syntax `lambda.()`. ([@biinari][])
* Fix `Delegate` for delegation with assignment or constant. ([@geniou][])
* [#1032](https://github.com/rubocop-hq/rubocop/issues/1032): Avoid duplicate reporting when code moves around due to `--auto-correct`. ([@jonas054][])
* [#1036](https://github.com/rubocop-hq/rubocop/issues/1036): Handle strings like `__FILE__` in `LineEndConcatenation`. ([@bbatsov][])
* [#1006](https://github.com/rubocop-hq/rubocop/issues/1006): Fix LineEndConcatenation to handle chained concatenations. ([@barunio][])
* [#1066](https://github.com/rubocop-hq/rubocop/issues/1066): Fix auto-correct for `NegatedIf` when the condition has parentheses around it. ([@jonas054][])
* Fix `AlignParameters` `with_fixed_indentation` for multi-line method calls. ([@molawson][])
* Fix problem that appears in some installations when reading empty YAML files. ([@jonas054][])
* [#1022](https://github.com/rubocop-hq/rubocop/issues/1022): A Cop will no longer auto-correct a file that's excluded through an `Exclude` setting in the cop's configuration. ([@jonas054][])
* Fix paths in `Exclude` config section not being recognized on Windows. ([@wndhydrnt][])
* [#1094](https://github.com/rubocop-hq/rubocop/issues/1094): Fix ClassAndModuleChildren for classes with a single method. ([@geniou][])

## 0.21.0 (2014-04-24)

### New features

* [#835](https://github.com/rubocop-hq/rubocop/issues/835): New cop `UnneededCapitalW` checks for `%W` when interpolation not necessary and `%w` would do. ([@sfeldon][])
* [#934](https://github.com/rubocop-hq/rubocop/issues/934): New cop `UnderscorePrefixedVariableName` checks for `_`-prefixed variables that are actually used. ([@yujinakayama][])
* [#934](https://github.com/rubocop-hq/rubocop/issues/934): New cop `UnusedMethodArgument` checks for unused method arguments. ([@yujinakayama][])
* [#934](https://github.com/rubocop-hq/rubocop/issues/934): New cop `UnusedBlockArgument` checks for unused block arguments. ([@yujinakayama][])
* [#964](https://github.com/rubocop-hq/rubocop/issues/964): `RedundantBegin` cop does auto-correction. ([@tamird][])
* [#966](https://github.com/rubocop-hq/rubocop/issues/966): `RescueException` cop does auto-correction. ([@tamird][])
* [#967](https://github.com/rubocop-hq/rubocop/issues/967): `TrivialAccessors` cop does auto-correction. ([@tamird][])
* [#963](https://github.com/rubocop-hq/rubocop/issues/963): Add `AllowDSLWriters` options to `TrivialAccessors`. ([@tamird][])
* [#969](https://github.com/rubocop-hq/rubocop/issues/969): Let the `Debugger` cop check for forgotten calls to byebug. ([@bquorning][])
* [#971](https://github.com/rubocop-hq/rubocop/issues/971): Configuration format deprecation warnings include the path to the problematic config file. ([@bcobb][])
* [#490](https://github.com/rubocop-hq/rubocop/issues/490): Add EnforcedStyle config option to TrailingBlankLines. ([@jonas054][])
* Add `auto_correct` task to Rake integration. ([@irrationalfab][])
* [#986](https://github.com/rubocop-hq/rubocop/issues/986): The `--only` option can take a comma-separated list of cops. ([@jonas054][])
* New Rails cop `Delegate` that checks for delegations that could be replaced by the `delegate` method. ([@geniou][])
* Add configuration to `Encoding` cop to only enforce encoding comment if there are non ASCII characters. ([@geniou][])

### Changes

* Removed `FinalNewline` cop as its check is now performed by `TrailingBlankLines`. ([@jonas054][])
* [#1011](https://github.com/rubocop-hq/rubocop/issues/1011): Pattern matching with `Dir#[]` for config parameters added. ([@jonas054][])

### Bugs fixed

* Update description on `LineEndConcatenation` cop. ([@mockdeep][])
* [#978](https://github.com/rubocop-hq/rubocop/issues/978): Fix regression in `IndentationWidth` handling method calls. ([@tamird][])
* [#976](https://github.com/rubocop-hq/rubocop/issues/976): Fix `EndAlignment` not handling element assignment correctly. ([@tamird][])
* [#976](https://github.com/rubocop-hq/rubocop/issues/976): Fix `IndentationWidth` not handling element assignment correctly. ([@tamird][])
* [#800](https://github.com/rubocop-hq/rubocop/issues/800): Do not report `[Corrected]` in `--auto-correct` mode if correction wasn't done. ([@jonas054][])
* [#968](https://github.com/rubocop-hq/rubocop/issues/968): Fix bug when running RuboCop with `-c .rubocop.yml`. ([@bquorning][])
* [#975](https://github.com/rubocop-hq/rubocop/pull/975): Fix infinite correction in `IndentationWidth`. ([@jonas054][])
* [#986](https://github.com/rubocop-hq/rubocop/issues/986): When `--lint` is used together with `--only`, all lint cops are run in addition to the given cops. ([@jonas054][])
* [#997](https://github.com/rubocop-hq/rubocop/issues/997): Fix handling of file paths for matching against `Exclude` property when `rubocop .` is called. ([@jonas054][])
* [#1000](https://github.com/rubocop-hq/rubocop/issues/1000): Support modifier (e.g., `private`) and `def` on the same line (Ruby >= 2.1) in `IndentationWidth`. ([@jonas054][])
* [#1001](https://github.com/rubocop-hq/rubocop/issues/1001): Fix `--auto-gen-config` logic for `RegexpLiteral`. ([@jonas054][])
* [#993](https://github.com/rubocop-hq/rubocop/issues/993): Do not report any offenses for the contents of an empty file. ([@jonas054][])
* [#1016](https://github.com/rubocop-hq/rubocop/issues/1016): Fix a false positive in `ConditionPosition` regarding statement modifiers. ([@bbatsov][])
* [#1014](https://github.com/rubocop-hq/rubocop/issues/1014): Fix handling of strings nested in `dstr` nodes. ([@bbatsov][])

## 0.20.1 (2014-04-05)

### Bugs fixed

* [#940](https://github.com/rubocop-hq/rubocop/issues/940): Fixed `UselessAccessModifier` not handling `attr_*` correctly. ([@fshowalter][])
* `NegatedIf` properly handles negated `unless` condition. ([@bbatsov][])
* `NegatedWhile` properly handles negated `until` condition. ([@bbatsov][])
* [#925](https://github.com/rubocop-hq/rubocop/issues/925): Do not disable the `Syntax` cop in output from `--auto-gen-config`. ([@jonas054][])
* [#943](https://github.com/rubocop-hq/rubocop/issues/943): Fix auto-correction interference problem between `SpaceAfterComma` and other cops. ([@jonas054][])
* [#954](https://github.com/rubocop-hq/rubocop/pull/954): Fix auto-correction bug in `NilComparison`. ([@bbatsov][])
* [#953](https://github.com/rubocop-hq/rubocop/pull/953): Fix auto-correction bug in `NonNilCheck`. ([@bbatsov][])
* [#952](https://github.com/rubocop-hq/rubocop/pull/952): Handle implicit receiver in `StringConversionInInterpolation`. ([@bbatsov][])
* [#956](https://github.com/rubocop-hq/rubocop/pull/956): Apply `ClassMethods` check only on `class`/`module` bodies. ([@bbatsov][])
* [#945](https://github.com/rubocop-hq/rubocop/issues/945): Fix SpaceBeforeFirstArg cop for multiline argument and exclude assignments. ([@cschramm][])
* [#948](https://github.com/rubocop-hq/rubocop/issues/948): `Blocks` cop avoids auto-correction if it would introduce a semantic change. ([@jonas054][])
* [#946](https://github.com/rubocop-hq/rubocop/issues/946): Allow non-nil checks that are the final expressions of predicate method definitions in `NonNilCheck`. ([@bbatsov][])
* [#957](https://github.com/rubocop-hq/rubocop/issues/957): Allow space + comment inside parentheses, braces, and square brackets. ([@jonas054][])

## 0.20.0 (2014-04-02)

### New features

* New cop `GuardClause` checks for conditionals that can be replaced by guard clauses. ([@bbatsov][])
* New cop `EmptyInterpolation` checks for empty interpolation in double-quoted strings. ([@bbatsov][])
* [#899](https://github.com/rubocop-hq/rubocop/issues/899): Make `LineEndConcatenation` cop `<<` aware. ([@mockdeep][])
* [#896](https://github.com/rubocop-hq/rubocop/issues/896): New option `--fail-level` changes minimum severity for exit with error code. ([@hiroponz][])
* [#893](https://github.com/rubocop-hq/rubocop/issues/893): New option `--force-exclusion` forces excluding files specified in the configuration `Exclude` even if they are explicitly passed as arguments. ([@yujinakayama][])
* `VariableInterpolation` cop does auto-correction. ([@bbatsov][])
* `Not` cop does auto-correction. ([@bbatsov][])
* `ClassMethods` cop does auto-correction. ([@bbatsov][])
* `StringConversionInInterpolation` cop does auto-correction. ([@bbatsov][])
* `NilComparison` cop does auto-correction. ([@bbatsov][])
* `NonNilComparison` cop does auto-correction. ([@bbatsov][])
* `NegatedIf` cop does auto-correction. ([@bbatsov][])
* `NegatedWhile` cop does auto-correction. ([@bbatsov][])
* New lint cop `SpaceBeforeFirstArg` checks for space between the method name and the first argument in method calls without parentheses. ([@jonas054][])
* New style cop `SingleSpaceBeforeFirstArg` checks that no more than one space is used between the method name and the first argument in method calls without parentheses. ([@jonas054][])
* New formatter `disabled_lines` displays cops and line ranges disabled by inline comments. ([@fshowalter][])
* New cop `UselessAccessModifiers` checks for access modifiers that have no effect. ([@fshowalter][])

### Changes

* [#913](https://github.com/rubocop-hq/rubocop/issues/913): `FileName` accepts multiple extensions. ([@tamird][])
* `AllCops/Excludes` and `AllCops/Includes` were renamed to `AllCops/Exclude` and `AllCops/Include` for consistency with standard cop params. ([@bbatsov][])
* Extract `NonNilCheck` cop from `NilComparison`. ([@bbatsov][])
* Renamed `FavorJoin` to `ArrayJoin`. ([@bbatsov][])
* Renamed `FavorUnlessOverNegatedIf` to `NegatedIf`. ([@bbatsov][])
* Renamed `FavorUntilOverNegatedWhile`to `NegatedWhile`. ([@bbatsov][])
* Renamed `HashMethods` to `DeprecatedHashMethods`. ([@bbatsov][])
* Renamed `ReadAttribute` to `ReadWriteAttribute` and extended it to check for uses of `write_attribute`. ([@bbatsov][])
* Add experimental support for Ruby 2.2 (development version) by falling back to Ruby 2.1 parser. ([@yujinakayama][])

### Bugs fixed

* [#926](https://github.com/rubocop-hq/rubocop/issues/926): Fixed `BlockNesting` not auto-generating correctly. ([@tmorris-fiksu][])
* [#904](https://github.com/rubocop-hq/rubocop/issues/904): Fixed a NPE in `LiteralInInterpolation`. ([@bbatsov][])
* [#904](https://github.com/rubocop-hq/rubocop/issues/904): Fixed a NPE in `StringConversionInInterpolation`. ([@bbatsov][])
* [#892](https://github.com/rubocop-hq/rubocop/issues/892): Make sure `Include` and `Exclude` paths in a `.rubocop.yml` are interpreted as relative to the directory of that file. ([@jonas054][])
* [#906](https://github.com/rubocop-hq/rubocop/issues/906): Fixed a false positive in `LiteralInInterpolation`. ([@bbatsov][])
* [#909](https://github.com/rubocop-hq/rubocop/issues/909): Handle properly multiple `rescue` clauses in `SignalException`. ([@bbatsov][])
* [#876](https://github.com/rubocop-hq/rubocop/issues/876): Do a deep merge of hashes when overriding default configuration in a `.rubocop.yml` file. ([@jonas054][])
* [#912](https://github.com/rubocop-hq/rubocop/issues/912): Fix a false positive in `LineEndConcatenation` for `%` string literals. ([@bbatsov][])
* [#912](https://github.com/rubocop-hq/rubocop/issues/912): Handle top-level constant resolution in `DeprecatedClassMethods` (e.g. `::File.exists?`). ([@bbatsov][])
* [#914](https://github.com/rubocop-hq/rubocop/issues/914): Fixed rdoc error during gem installation. ([@bbatsov][])
* The `--only` option now enables the given cop in case it is disabled in configuration. ([@jonas054][])
* Fix path resolution so that the default exclusion of `vendor` directories works. ([@jonas054][])
* [#908](https://github.com/rubocop-hq/rubocop/issues/908): Fixed hanging while auto correct for `SpaceAfterComma` and `SpaceInsideBrackets`. ([@hiroponz][])
* [#919](https://github.com/rubocop-hq/rubocop/issues/919): Don't avoid auto-correction in `HashSyntax` when there is missing space around operator. ([@jonas054][])
* Fixed handling of floats in `NumericLiterals`. ([@bbatsov][])
* [#927](https://github.com/rubocop-hq/rubocop/issues/927): Let `--auto-gen-config` overwrite an existing `rubocop-todo.yml` file instead of asking the user to remove it. ([@jonas054][])
* [#936](https://github.com/rubocop-hq/rubocop/issues/936): Allow `_other` as well as `other` in `OpMethod`. ([@bbatsov][])

## 0.19.1 (2014-03-17)

### Bugs fixed

* [#884](https://github.com/rubocop-hq/rubocop/issues/884): Fix --auto-gen-config for `NumericLiterals` so MinDigits is correct. ([@tmorris-fiksu][])
* [#879](https://github.com/rubocop-hq/rubocop/issues/879): Fix --auto-gen-config for `RegexpLiteral` so we don't generate illegal values for `MaxSlashes`. ([@jonas054][])
* Fix the name of the `Include` param in the default config of the Rails cops. ([@bbatsov][])
* [#878](https://github.com/rubocop-hq/rubocop/pull/878): Blacklist `Rakefile`, `Gemfile` and `Capfile` by default in the `FileName` cop. ([@bbatsov][])
* [#875](https://github.com/rubocop-hq/rubocop/issues/875): Handle `separator` style hashes in `IndentHash`. ([@jonas054][])
* Fix a bug where multiple cli options that result in exit can be specified at once (e.g. `-vV`, `-v --show-cops`). ([@jkogara][])
* [#889](https://github.com/rubocop-hq/rubocop/issues/889): Fix a false positive for `LiteralInCondition` when the condition is non-primitive array. ([@bbatsov][])

## 0.19.0 (2014-03-13)

### New features

* New cop `FileName` makes sure that source files have snake_case names. ([@bbatsov][])
* New cop `DeprecatedClassMethods` checks for deprecated class methods. ([@bbatsov][])
* New cop `StringConversionInInterpolation` checks for redundant `Object#to_s` in string interpolation. ([@bbatsov][])
* New cop `LiteralInInterpolation` checks for interpolated string literals. ([@bbatsov][])
* New cop `SelfAssignment` checks for places where the self-assignment shorthand should have been used. ([@bbatsov][])
* New cop `DoubleNegation` checks for uses of `!!`. ([@bbatsov][])
* New cop `PercentLiteralDelimiters` enforces consistent usage of `%`-literal delimiters. ([@hannestyden][])
* New Rails cop `ActionFilter` enforces the use of `_filter` or `_action` action filter methods. ([@bbatsov][])
* New Rails cop `ScopeArgs` makes sure you invoke the `scope` method properly. ([@bbatsov][])
* Add `with_fixed_indentation` style to `AlignParameters` cop. ([@hannestyden][])
* Add `IgnoreLastArgumentHash` option to `AlignHash` cop. ([@hannestyden][])
* [#743](https://github.com/rubocop-hq/rubocop/issues/743): `SingleLineMethods` cop does auto-correction. ([@jonas054][])
* [#743](https://github.com/rubocop-hq/rubocop/issues/743): `Semicolon` cop does auto-correction. ([@jonas054][])
* [#743](https://github.com/rubocop-hq/rubocop/issues/743): `EmptyLineBetweenDefs` cop does auto-correction. ([@jonas054][])
* [#743](https://github.com/rubocop-hq/rubocop/issues/743): `IndentationWidth` cop does auto-correction. ([@jonas054][])
* [#743](https://github.com/rubocop-hq/rubocop/issues/743): `IndentationConsistency` cop does auto-correction. ([@jonas054][])
* [#809](https://github.com/rubocop-hq/rubocop/issues/809): New formatter `fuubar` displays a progress bar and shows details of offenses as soon as they are detected. ([@yujinakayama][])
* [#797](https://github.com/rubocop-hq/rubocop/issues/797): New cop `IndentHash` checks the indentation of the first key in multi-line hash literals. ([@jonas054][])
* [#797](https://github.com/rubocop-hq/rubocop/issues/797): New cop `IndentArray` checks the indentation of the first element in multi-line array literals. ([@jonas054][])
* [#806](https://github.com/rubocop-hq/rubocop/issues/806): Now excludes files in `vendor/**` by default. ([@jeremyolliver][])
* [#795](https://github.com/rubocop-hq/rubocop/issues/795): `IfUnlessModifier` and `WhileUntilModifier` supports `MaxLineLength`, which is independent of `LineLength` parameter `Max`. ([@agrimm][])
* [#868](https://github.com/rubocop-hq/rubocop/issues/868): New cop `ClassAndModuleChildren` checks the style of children definitions at classes and modules: nested / compact. ([@geniou][])

### Changes

* [#793](https://github.com/rubocop-hq/rubocop/issues/793): Add printing total count when `rubocop --format offences`. ([@ma2gedev][])
* Remove `Ignore` param from the Rails `Output` cop. The standard `Exclude/Include` should be used instead. ([@bbatsov][])
* Renamed `FavorSprintf` to `FormatString` and made it configurable. ([@bbatsov][])
* Renamed `Offence` to `Offense`. ([@bbatsov][])
* Use `offense` in all messages instead of `offence`. ([@bbatsov][])
* For indentation of `if`/`unless`/`while`/`until` bodies when the result is assigned to a variable, instead of supporting two styles simultaneously, `IndentationWidth` now supports one style of indentation at a time, specified by `EndAlignment`/`AlignWith`. ([@jonas054][])
* Renamed `Style` param of `DotPosition` cop to `EnforcedStyle`. ([@bbatsov][])
* Add `length` value to locations of offense in JSON formatter. ([@yujinakayama][])
* `SpaceAroundBlockBraces` cop replaced by `SpaceBeforeBlockBraces` and `SpaceInsideBlockBraces`. ([@jonas054][])
* `SpaceAroundEqualsInParameterDefault` cop is now configurable with the `EnforcedStyle` option. ([@jonas054][])

### Bugs fixed

* [#790](https://github.com/rubocop-hq/rubocop/issues/790): Fix auto-correction interference problem between `MethodDefParentheses` and other cops. ([@jonas054][])
* [#794](https://github.com/rubocop-hq/rubocop/issues/794): Fix handling of modifier keywords with required parentheses in `ParenthesesAroundCondition`. ([@bbatsov][])
* [#804](https://github.com/rubocop-hq/rubocop/issues/804): Fix a false positive with operator assignments in a loop (including `begin..rescue..end` with `retry`) in `UselessAssignment`. ([@yujinakayama][])
* [#815](https://github.com/rubocop-hq/rubocop/issues/815): Fix a false positive for heredocs with blank lines in them in `EmptyLines`. ([@bbatsov][])
* Auto-correction is now more robust and less likely to die because of `RangeError` or "clobbering". ([@jonas054][])
* Offenses always reported in order of position in file, also during `--auto-correct` runs. ([@jonas054][])
* Fix problem with `[Corrected]` tag sometimes missing in output from `--auto-correct` runs. ([@jonas054][])
* Fix message from `EndAlignment` cop when `AlignWith` is `keyword`. ([@jonas054][])
* Handle `case` conditions in `LiteralInCondition`. ([@bbatsov][])
* [#822](https://github.com/rubocop-hq/rubocop/issues/822): Fix a false positive in `DotPosition` when enforced style is set to `trailing`. ([@bbatsov][])
* Handle properly dynamic strings in `LineEndConcatenation`. ([@bbatsov][])
* [#832](https://github.com/rubocop-hq/rubocop/issues/832): Fix auto-correction interference problem between `BracesAroundHashParameters` and `SpaceInsideHashLiteralBraces`. ([@jonas054][])
* Fix bug in auto-correction of alignment so that only space can be removed. ([@jonas054][])
* Fix bug in `IndentationWidth` auto-correction so it doesn't correct things that `IndentationConsistency` should correct. ([@jonas054][])
* [#847](https://github.com/rubocop-hq/rubocop/issues/847): Fix bug in `RegexpLiteral` concerning `--auto-gen-config`. ([@jonas054][])
* [#848](https://github.com/rubocop-hq/rubocop/issues/848): Fix bug in `--show-cops` that made it print the default configuration rather than the current configuration. ([@jonas054][])
* [#862](https://github.com/rubocop-hq/rubocop/issues/862): Fix a bug where single line `rubocop:disable` comments with indentations were treated as multiline cop disabling comments. ([@yujinakayama][])
* Fix a bug where `rubocop:disable` comments with a cop name including `all` (e.g. `MethodCallParentheses`) were disabling all cops. ([@yujinakayama][])
* Fix a bug where string and regexp literals including `# rubocop:disable` were confused with real comments. ([@yujinakayama][])
* [#877](https://github.com/rubocop-hq/rubocop/issues/877): Fix bug in `PercentLiteralDelimiters` concerning auto-correct of regular expressions with interpolation. ([@hannestyden][])

## 0.18.1 (2014-02-02)

### Bugs fixed

* Remove double reporting in `EmptyLinesAroundBody` of empty line inside otherwise empty class/module/method that caused crash in autocorrect. ([@jonas054][])
* [#779](https://github.com/rubocop-hq/rubocop/issues/779): Fix a false positive in `LineEndConcatenation`. ([@bbatsov][])
* [#751](https://github.com/rubocop-hq/rubocop/issues/751): Fix `Documentation` cop so that a comment followed by an empty line and then a class definition is not considered to be class documentation. ([@jonas054][])
* [#783](https://github.com/rubocop-hq/rubocop/issues/783): Fix a false positive in `ParenthesesAroundCondition` when the parentheses are actually required. ([@bbatsov][])
* [#781](https://github.com/rubocop-hq/rubocop/issues/781): Fix problem with back-and-forth auto-correction in `AccessModifierIndentation`. ([@jonas054][])
* [#785](https://github.com/rubocop-hq/rubocop/issues/785): Fix false positive on `%w` arrays in `TrailingComma`. ([@jonas054][])
* [#782](https://github.com/rubocop-hq/rubocop/issues/782): Fix false positive in `AlignHash` for single line hashes. ([@jonas054][])

## 0.18.0 (2014-01-30)

### New features

* [#714](https://github.com/rubocop-hq/rubocop/issues/714): New cop `RequireParentheses` checks for method calls without parentheses together with a boolean operator indicating that a mistake about precedence may have been made. ([@jonas054][])
* [#743](https://github.com/rubocop-hq/rubocop/issues/743): `WordArray` cop does auto-correction. ([@jonas054][])
* [#743](https://github.com/rubocop-hq/rubocop/issues/743): `Proc` cop does auto-correction. ([@bbatsov][])
* [#743](https://github.com/rubocop-hq/rubocop/issues/743): `AccessModifierIndentation` cop does auto-correction. ([@jonas054][])
* [#768](https://github.com/rubocop-hq/rubocop/issues/768): Rake task now supports `requires` and `options`. ([@nevir][])
* [#759](https://github.com/rubocop-hq/rubocop/issues/759): New cop `EndLineConcatenation` checks for string literal concatenation with `+` at line end. ([@bbatsov][])

### Changes

* [#762](https://github.com/rubocop-hq/rubocop/issues/762): Support Rainbow gem both 1.99.x and 2.x. ([@yujinakayama][])
* [#761](https://github.com/rubocop-hq/rubocop/issues/761): Relax `json` requirement to `>= 1.7.7`. ([@bbatsov][])
* [#757](https://github.com/rubocop-hq/rubocop/issues/757): `Include/Exclude` supports relative globbing to some extent. ([@nevir][])

### Bugs fixed

* [#764](https://github.com/rubocop-hq/rubocop/issues/764): Handle heredocs in `TrailingComma`. ([@jonas054][])
* Guide for contributors now points to correct issues page. ([@scottmatthewman][])

## 0.17.0 (2014-01-25)

### New features

* New cop `ConditionPosition` checks for misplaced conditions in expressions like `if/unless/when/until`. ([@bbatsov][])
* New cop `ElseLayout` checks for odd arrangement of code in the `else` branch of a conditional expression. ([@bbatsov][])
* [#694](https://github.com/rubocop-hq/rubocop/issues/694): Support Ruby 1.9.2 until June 2014. ([@yujinakayama][])
* [#702](https://github.com/rubocop-hq/rubocop/issues/702): Improve `rubocop-todo.yml` with comments about offence count, configuration parameters, and auto-correction support. ([@jonas054][])
* Add new command-line flag `-D/--display-cop-names` to trigger the display of cop names in offence messages. ([@bbatsov][])
* [#733](https://github.com/rubocop-hq/rubocop/pull/733): `NumericLiterals` cop does auto-correction. ([@dblock][])
* [#713](https://github.com/rubocop-hq/rubocop/issues/713): New cop `TrailingComma` checks for comma after the last item in a hash, array, or method call parameter list. ([@jonas054][])

### Changes

* [#581](https://github.com/rubocop-hq/rubocop/pull/581): Extracted a new cop `AmbiguousOperator` from `Syntax` cop. It checks for ambiguous operators in the first argument of a method invocation without parentheses. ([@yujinakayama][])
* Extracted a new cop `AmbiguousRegexpLiteral` from `Syntax` cop. It checks for ambiguous regexp literals in the first argument of a method invocation without parentheses. ([@yujinakayama][])
* Extracted a new cop `UselessElseWithoutRescue` from `Syntax` cop. It checks for useless `else` in `begin..end` without `rescue`. ([@yujinakayama][])
* Extracted a new cop `InvalidCharacterLiteral` from `Syntax` cop. It checks for invalid character literals with a non-escaped whitespace character (e.g. `? `). ([@yujinakayama][])
* Removed `Syntax` cop from the configuration. It no longer can be disabled and it reports only invalid syntax offences. ([@yujinakayama][])
* [#688](https://github.com/rubocop-hq/rubocop/issues/688): Output from `rubocop --show-cops` now looks like a YAML configuration file. The `--show-cops` option takes a comma separated list of cops as optional argument. ([@jonas054][])
* New cop `IndentationConsistency` extracted from `IndentationWidth`, which has checked two kinds of offences until now. ([@jonas054][])

### Bugs fixed

* [#698](https://github.com/rubocop-hq/rubocop/pull/698): Support Windows paths on command-line. ([@rifraf][])
* [#498](https://github.com/rubocop-hq/rubocop/issues/498): Disable terminal ANSI escape sequences when a formatter's output is not a TTY. ([@yujinakayama][])
* [#703](https://github.com/rubocop-hq/rubocop/issues/703): BracesAroundHashParameters auto-correction broken with trailing comma. ([@jonas054][])
* [#709](https://github.com/rubocop-hq/rubocop/issues/709): When `EndAlignment` has configuration `AlignWith: variable`, it now handles `@@a = if ...` and `a, b = if ...`. ([@jonas054][])
* `SpaceAroundOperators` now reports an offence for `@@a=0`. ([@jonas054][])
* [#707](https://github.com/rubocop-hq/rubocop/issues/707): Fix error on operator assignments in top level scope in `UselessAssignment`. ([@yujinakayama][])
* Fix a bug where some offences were discarded when any cop that has specific target file path (by `Include` or `Exclude` under each cop configuration) had run. ([@yujinakayama][])
* [#724](https://github.com/rubocop-hq/rubocop/issues/724): Accept colons denoting required keyword argument (a new feature in Ruby 2.1) without trailing space in `SpaceAfterColon`. ([@jonas054][])
* The `--no-color` option works again. ([@jonas054][])
* [#716](https://github.com/rubocop-hq/rubocop/issues/716): Fixed a regression in the auto-correction logic of `MethodDefParentheses`. ([@bbatsov][])
* Inspected projects that lack a `.rubocop.yml` file, and therefore get their configuration from RuboCop's `config/default.yml`, no longer get configuration from RuboCop's `.rubocop.yml` and `rubocop-todo.yml`. ([@jonas054][])
* [#730](https://github.com/rubocop-hq/rubocop/issues/730): `EndAlignment` now handles for example `private def some_method`, which is allowed in Ruby 2.1. It requires `end` to be aligned with `private`, not `def`, in such cases. ([@jonas054][])
* [#744](https://github.com/rubocop-hq/rubocop/issues/744): Any new offences created by `--auto-correct` are now handled immediately and corrected when possible, so running `--auto-correct` once is enough. ([@jonas054][])
* [#748](https://github.com/rubocop-hq/rubocop/pull/748): Auto-correction conflict between `EmptyLinesAroundBody` and `TrailingWhitespace` resolved. ([@jonas054][])
* `ParenthesesAroundCondition` no longer crashes on parentheses around the condition in a ternary if. ([@jonas054][])
* [#738](https://github.com/rubocop-hq/rubocop/issues/738): Fix a false positive in `StringLiterals`. ([@bbatsov][])

## 0.16.0 (2013-12-25)

### New features

* [#612](https://github.com/rubocop-hq/rubocop/pull/612): `BracesAroundHashParameters` cop does auto-correction. ([@dblock][])
* [#614](https://github.com/rubocop-hq/rubocop/pull/614): `ParenthesesAroundCondition` cop does auto-correction. ([@dblock][])
* [#624](https://github.com/rubocop-hq/rubocop/pull/624): `EmptyLines` cop does auto-correction. ([@dblock][])
* New Rails cop `DefaultScope` ensures `default_scope` is called properly with a block argument. ([@bbatsov][])
* All cops now support the `Include` param, which specifies the files on which they should operate. ([@bbatsov][])
* All cops now support the `Exclude` param, which specifies the files on which they should not operate. ([@bbatsov][])
* [#631](https://github.com/rubocop-hq/rubocop/issues/631): `IndentationWidth` cop now detects inconsistent indentation between lines that should have the same indentation. ([@jonas054][])
* [#649](https://github.com/rubocop-hq/rubocop/pull/649): `EmptyLinesAroundBody` cop does auto-correction. ([@dblock][])
* [#657](https://github.com/rubocop-hq/rubocop/pull/657): `Alias` cop does auto-correction. ([@dblock][])
* Rake task now support setting formatters. ([@pmenglund][])
* [#653](https://github.com/rubocop-hq/rubocop/issues/653): `CaseIndentation` cop is now configurable with parameters `IndentWhenRelativeTo` and `IndentOneStep`. ([@jonas054][])
* [#654](https://github.com/rubocop-hq/rubocop/pull/654): `For` cop is now configurable to enforce either `each` (default) or `for`. ([@jonas054][])
* [#661](https://github.com/rubocop-hq/rubocop/issues/661): `EndAlignment` cop is now configurable for alignment with `keyword` (default) or `variable`. ([@jonas054][])
* Allow to overwrite the severity of a cop with the new `Severity` param. ([@codez][])
* New cop `FlipFlop` checks for flip flops. ([@agrimm][])
* [#577](https://github.com/rubocop-hq/rubocop/issues/577): Introduced `MethodDefParentheses` to allow for for requiring either parentheses or no parentheses in method definitions. Replaces `DefWithoutParentheses`. ([@skanev][])
* [#693](https://github.com/rubocop-hq/rubocop/pull/693): Generation of parameter values (i.e., not only `Enabled: false`) in `rubocop-todo.yml` by the `--auto-gen-config` option is now supported for some cops. ([@jonas054][])
* New cop `AccessorMethodName` checks accessor method names for non-idiomatic names like `get_attribute` and `set_attribute`. ([@bbatsov][])
* New cop `PredicateName` checks the names of predicate methods for non-idiomatic names like `is_something`, `has_something`, etc. ([@bbatsov][])
* Support Ruby 2.1 with Parser 2.1. ([@yujinakayama][])

### Changes

* Removed `SymbolNames` as it was generating way too many false positives. ([@bbatsov][])
* Renamed `ReduceArguments` to `SingleLineBlockParams` and made it configurable. ([@bbatsov][])

### Bugs fixed

* Handle properly heredocs in `StringLiterals` cop. ([@bbatsov][])
* Fix `SpaceAroundOperators` to not report missing space around operator for `def self.method *args`. ([@jonas054][])
* Properly handle `['AllCops']['Includes']` and `['AllCops']['Excludes']` when passing config via `-c`. ([@fancyremarker][], [@codez][])
* [#611](https://github.com/rubocop-hq/rubocop/pull/611): Fix crash when loading an empty config file. ([@sinisterchipmunk][])
* Fix `DotPosition` cop with `trailing` style for method calls on same line. ([@vonTronje][])
* [#627](https://github.com/rubocop-hq/rubocop/pull/627): Fix counting of slashes in complicated regexps in `RegexpLiteral` cop. ([@jonas054][])
* [#638](https://github.com/rubocop-hq/rubocop/issues/638): Fix bug in auto-correct that changes `each{ |x|` to `each d o |x|`. ([@jonas054][])
* [#418](https://github.com/rubocop-hq/rubocop/issues/418): Stop searching for configuration files above the work directory of the isolated environment when running specs. ([@jonas054][])
* Fix error on implicit match conditionals (e.g. `if /pattern/; end`) in `MultilineIfThen`. ([@agrimm][])
* [#651](https://github.com/rubocop-hq/rubocop/issues/651): Handle properly method arguments in `RedundantSelf`. ([@bbatsov][])
* [#628](https://github.com/rubocop-hq/rubocop/issues/628): Allow `self.Foo` in `RedundantSelf` cop. ([@chulkilee][])
* [#668](https://github.com/rubocop-hq/rubocop/issues/668): Fix crash in `EndOfLine` that occurs when default encoding is `US_ASCII` and an inspected file has non-ascii characters. ([@jonas054][])
* [#664](https://github.com/rubocop-hq/rubocop/issues/664): Accept oneline while when condition has local variable assignment. ([@emou][])
* Fix auto-correct for `MethodDefParentheses` when parentheses are required. ([@skanev][])

## 0.15.0 (2013-11-06)

### New features

* New cop `Output` checks for calls to print, puts, etc. in Rails. ([@daviddavis][])
* New cop `EmptyLinesAroundBody` checks for empty lines around the bodies of class, method and module definitions. ([@bbatsov][])
* `LeadingCommentSpace` cop does auto-correction. ([@jonas054][])
* `SpaceAfterControlKeyword` cop does auto-correction. ([@jonas054][])
* `SpaceAfterColon` cop does auto-correction. ([@jonas054][])
* `SpaceAfterComma` cop does auto-correction. ([@jonas054][])
* `SpaceAfterSemicolon` cop does auto-correction. ([@jonas054][])
* `SpaceAfterMethodName` cop does auto-correction. ([@jonas054][])
* `SpaceAroundBlockBraces` cop does auto-correction. ([@jonas054][])
* `SpaceAroundEqualsInParameterDefault` cop does auto-correction. ([@jonas054][])
* `SpaceAroundOperators` cop does auto-correction. ([@jonas054][])
* `SpaceBeforeModifierKeyword` cop does auto-correction. ([@jonas054][])
* `SpaceInsideHashLiteralBraces` cop does auto-correction. ([@jonas054][])
* `SpaceInsideBrackets` cop does auto-correction. ([@jonas054][])
* `SpaceInsideParens` cop does auto-correction. ([@jonas054][])
* `TrailingWhitespace` cop does auto-correction. ([@jonas054][])
* `TrailingBlankLines` cop does auto-correction. ([@jonas054][])
* `FinalNewline` cop does auto-correction. ([@jonas054][])
* New cop `CyclomaticComplexity` checks the cyclomatic complexity of methods against a configurable max value. ([@jonas054][])
* [#594](https://github.com/rubocop-hq/rubocop/pull/594): New parameter `EnforcedStyleForEmptyBraces` with values `space` and `no_space` (default) added to `SpaceAroundBlockBraces`. ([@jonas054][])
* [#603](https://github.com/rubocop-hq/rubocop/pull/603): New parameter `MinSize` added to `WordArray` to allow small string arrays, retaining the default (0). ([@claco][])

### Changes

* [#557](https://github.com/rubocop-hq/rubocop/pull/557): Configuration files for excluded files are no longer loaded. ([@jonas054][])
* [#571](https://github.com/rubocop-hq/rubocop/pull/571): The default rake task now runs RuboCop over itself! ([@nevir][])
* Encoding errors are reported as fatal offences rather than printed with red text. ([@jonas054][])
* `AccessControl` cop is now configurable with the `EnforcedStyle` option. ([@sds][])
* Split `AccessControl` cop to `AccessModifierIndentation` and `EmptyLinesAroundAccessModifier`. ([@bbatsov][])
* [#594](https://github.com/rubocop-hq/rubocop/pull/594): Add configuration parameter `EnforcedStyleForEmptyBraces` to `SpaceInsideHashLiteralBraces` cop, and change `EnforcedStyleIsWithSpaces` (values `true`, `false`) to `EnforcedStyle` (values `space`, `no_space`). ([@jonas054][])
* Coverage builds linked from the README page are enabled again. ([@jonas054][])

### Bugs fixed

* [#561](https://github.com/rubocop-hq/rubocop/pull/561): Handle properly negative literals in `NumericLiterals` cop. ([@bbatsov][])
* [#567](https://github.com/rubocop-hq/rubocop/pull/567): Register an offence when the last hash parameter has braces in `BracesAroundHashParameters` cop. ([@dblock][])
* `StringLiterals` cop no longer reports errors for character literals such as ?/. That should be done only by the `CharacterLiterals` cop. ([@jonas054][])
* Made auto-correct much less likely to crash due to conflicting corrections ("clobbering"). ([@jonas054][])
* [#565](https://github.com/rubocop-hq/rubocop/pull/565): `$GLOBAL_VAR from English library` should no longer be inserted when autocorrecting short-form global variables like `$!`. ([@nevir][])
* [#566](https://github.com/rubocop-hq/rubocop/pull/566): Methods that just assign a splat to an ivar are no longer considered trivial writers. ([@nevir][])
* [#585](https://github.com/rubocop-hq/rubocop/pull/585): `MethodCallParentheses` should allow methods starting with uppercase letter. ([@bbatsov][])
* [#574](https://github.com/rubocop-hq/rubocop/issues/574): Fix error on multiple-assignment with non-array right hand side in `UselessSetterCall`. ([@yujinakayama][])
* [#576](https://github.com/rubocop-hq/rubocop/issues/576): Output config validation warning to STDERR so that it won't be mixed up with formatter's output. ([@yujinakayama][])
* [#599](https://github.com/rubocop-hq/rubocop/pull/599): `EndOfLine` cop is operational again. ([@jonas054][])
* [#604](https://github.com/rubocop-hq/rubocop/issues/604): Fix error on implicit match conditionals (e.g. `if /pattern/; end`) in `FavorModifier`. ([@yujinakayama][])
* [#600](https://github.com/rubocop-hq/rubocop/pull/600): Don't require an empty line for access modifiers at the beginning of class/module body. ([@bbatsov][])
* [#608](https://github.com/rubocop-hq/rubocop/pull/608): `RescueException` no longer crashes when the namespace of a rescued class is in a local variable. ([@jonas054][])
* [#173](https://github.com/rubocop-hq/rubocop/issues/173): Allow the use of `alias` in the body of an `instance_exec`. ([@bbatsov][])
* [#554](https://github.com/rubocop-hq/rubocop/issues/554): Handle properly multi-line arrays with comments in them in `WordArray`. ([@bbatsov][])

## 0.14.1 (2013-10-10)

### New features

* [#551](https://github.com/rubocop-hq/rubocop/pull/551): New cop `BracesAroundHashParameters` checks for braces in function calls with hash parameters. ([@dblock][])
* New cop `SpaceAfterNot` tracks redundant space after the `!` operator. ([@bbatsov][])

### Bugs fixed

* Fix bug concerning table and separator alignment of multi-line hash with multiple keys on the same line. ([@jonas054][])
* [#550](https://github.com/rubocop-hq/rubocop/pull/550): Fix a bug where `ClassLength` counted lines of inner classes/modules. ([@yujinakayama][])
* [#550](https://github.com/rubocop-hq/rubocop/pull/550): Fix a false positive for namespace class in `Documentation`. ([@yujinakayama][])
* [#556](https://github.com/rubocop-hq/rubocop/pull/556): Fix "Parser::Source::Range spans more than one line" bug in clang formatter. ([@yujinakayama][])
* [#552](https://github.com/rubocop-hq/rubocop/pull/552): `RaiseArgs` allows exception constructor calls with more than one 1 argument. ([@bbatsov][])

## 0.14.0 (2013-10-07)

### New features

* [#491](https://github.com/rubocop-hq/rubocop/issues/491): New cop `MethodCalledOnDoEndBlock` keeps track of methods called on `do`...`end` blocks.
* [#456](https://github.com/rubocop-hq/rubocop/issues/456): New configuration parameter `AllCops`/`RunRailsCops` can be set to `true` for a project, removing the need to give the `-R`/`--rails` option with every invocation of `rubocop`.
* [#501](https://github.com/rubocop-hq/rubocop/issues/501): `simple`/`clang`/`progress`/`emacs` formatters now print `[Corrected]` along with offence message when the offence is automatically corrected.
* [#501](https://github.com/rubocop-hq/rubocop/issues/501): `simple`/`clang`/`progress` formatters now print count of auto-corrected offences in the final summary.
* [#501](https://github.com/rubocop-hq/rubocop/issues/501): `json` formatter now outputs `corrected` key with boolean value in offence objects whether the offence is automatically corrected.
* New cop `ClassLength` checks for overly long class definitions.
* New cop `Debugger` checks for forgotten calls to debugger or pry.
* New cop `RedundantException` checks for code like `raise RuntimeError, message`.
* [#526](https://github.com/rubocop-hq/rubocop/issues/526): New cop `RaiseArgs` checks the args passed to `raise/fail`.

### Changes

* Cop `MethodAndVariableSnakeCase` replaced by `MethodName` and `VariableName`, both having the configuration parameter `EnforcedStyle` with values `snake_case` (default) and `camelCase`.
* [#519](https://github.com/rubocop-hq/rubocop/issues/519): `HashSyntax` cop is now configurable and can enforce the use of the classic hash rockets syntax.
* [#520](https://github.com/rubocop-hq/rubocop/issues/520): `StringLiterals` cop is now configurable and can enforce either single-quoted or double-quoted strings.
* [#528](https://github.com/rubocop-hq/rubocop/issues/528): Added a config option to `RedundantReturn` to allow a `return` with multiple values.
* [#524](https://github.com/rubocop-hq/rubocop/issues/524): Added a config option to `Semicolon` to allow the use of `;` as an expression separator.
* [#525](https://github.com/rubocop-hq/rubocop/issues/525): `SignalException` cop is now configurable and can enforce the semantic rule or an exclusive use of `raise` or `fail`.
* `LambdaCall` is now configurable and enforce either `Proc#call` or `Proc#()`.
* [#529](https://github.com/rubocop-hq/rubocop/issues/529): Added config option `EnforcedStyle` to `SpaceAroundBraces`.
* [#529](https://github.com/rubocop-hq/rubocop/issues/529): Changed config option `NoSpaceBeforeBlockParameters` to `SpaceBeforeBlockParameters`.
* Support Parser 2.0.0 (non-beta).

### Bugs fixed

* [#514](https://github.com/rubocop-hq/rubocop/issues/514): Fix alignment of the hash containing different key lengths in one line.
* [#496](https://github.com/rubocop-hq/rubocop/issues/496): Fix corner case crash in `AlignHash` cop: single key/value pair when configuration is `table` for '=>' and `separator` for `:`.
* [#502](https://github.com/rubocop-hq/rubocop/issues/502): Don't check non-decimal literals with `NumericLiterals`.
* [#448](https://github.com/rubocop-hq/rubocop/issues/448): Fix auto-correction of parameters spanning more than one line in `AlignParameters` cop.
* [#493](https://github.com/rubocop-hq/rubocop/issues/493): Support disabling `Syntax` offences with `warning` severity.
* Fix bug appearing when there were different values for the `AllCops`/`RunRailsCops` configuration parameter in different directories.
* [#512](https://github.com/rubocop-hq/rubocop/issues/512): Fix bug causing crash in `AndOr` auto-correction.
* [#515](https://github.com/rubocop-hq/rubocop/issues/515): Fix bug causing `AlignParameters` and `AlignArray` auto-correction to destroy code.
* [#516](https://github.com/rubocop-hq/rubocop/issues/516): Fix bug causing `RedundantReturn` auto-correction to produce invalid code.
* [#527](https://github.com/rubocop-hq/rubocop/issues/527): Handle `!=` expressions in `EvenOdd` cop.
* `SignalException` cop now finds `raise` calls anywhere, not only in `begin` sections.
* [#538](https://github.com/rubocop-hq/rubocop/issues/538): Fix bug causing `Blocks` auto-correction to produce invalid code.

## 0.13.1 (2013-09-19)

### New features

* `HashSyntax` cop does auto-correction.
* [#484](https://github.com/rubocop-hq/rubocop/pull/484): Allow calls to self to fix name clash with argument.
* Renamed `SpaceAroundBraces` to `SpaceAroundBlockBraces`.
* `SpaceAroundBlockBraces` now has a `NoSpaceBeforeBlockParameters` config option to enforce a style for blocks with parameters like `{|foo| puts }`.
* New cop `LambdaCall` tracks uses of the obscure `lambda.(...)` syntax.

### Bugs fixed

* Fix crash on empty input file in `FinalNewline`.
* [#485](https://github.com/rubocop-hq/rubocop/issues/485): Fix crash on multiple-assignment and op-assignment in `UselessSetterCall`.
* [#497](https://github.com/rubocop-hq/rubocop/issues/497): Fix crash in `UselessComparison` and `NilComparison`.

## 0.13.0 (2013-09-13)

### New features

* New configuration parameter `AllowAdjacentOneLineDefs` for `EmptyLineBetweenDefs`.
* New cop `MultilineBlockChain` keeps track of chained blocks spanning multiple lines.
* `RedundantSelf` cop does auto-correction.
* `AvoidPerlBackrefs` cop does auto-correction.
* `AvoidPerlisms` cop does auto-correction.
* `RedundantReturn` cop does auto-correction.
* `Blocks` cop does auto-correction.
* New cop `TrailingBlankLines` keeps track of extra blanks lines at the end of source file.
* New cop `AlignHash` keeps track of bad alignment in multi-line hash literals.
* New cop `AlignArray` keeps track of bad alignment in multi-line array literals.
* New cop `SpaceBeforeModifierKeyword` keeps track of missing space before a modifier keyword (`if`, `unless`, `while`, `until`).
* New cop `FinalNewline` keeps tracks of the required final newline in a source file.
* Highlightling corrected in `SpaceInsideHashLiteralBraces` and `SpaceAroundBraces` cops.

### Changes

* [#447](https://github.com/rubocop-hq/rubocop/issues/447): `BlockAlignment` cop now allows `end` to be aligned with the start of the line containing `do`.
* `SymbolName` now has an `AllowDots` config option to allow symbols like `:'whatever.submit_button'`.
* [#469](https://github.com/rubocop-hq/rubocop/issues/469): Extracted useless setter call tracking part of `UselessAssignment` cop to `UselessSetterCall`.
* [#469](https://github.com/rubocop-hq/rubocop/issues/469): Merged `UnusedLocalVariable` cop into `UselessAssignment`.
* [#458](https://github.com/rubocop-hq/rubocop/issues/458): The merged `UselessAssignment` cop now has advanced logic that tracks not only assignment at the end of the method but also every assignment in every scope.
* [#466](https://github.com/rubocop-hq/rubocop/issues/466): Allow built-in JRuby global vars in `AvoidGlobalVars`.
* Added a config option `AllowedVariables` to `AvoidGlobalVars` to allow users to whitelist certain global variables.
* Renamed `AvoidGlobalVars` to `GlobalVars`.
* Renamed `AvoidPerlisms` to `SpecialGlobalVars`.
* Renamed `AvoidFor` to `For`.
* Renamed `AvoidClassVars` to `ClassVars`.
* Renamed `AvoidPerlBackrefs` to `PerlBackrefs`.
* `NumericLiterals` now accepts a config param `MinDigits` - the minimal number of digits in the integer portion of number for the cop to check it.

### Bugs fixed

* [#449](https://github.com/rubocop-hq/rubocop/issues/449): Remove whitespaces between condition and `do` with `WhileUntilDo` auto-correction.
* Continue with file inspection after parser warnings. Give up only on syntax errors.
* Don't trigger the HashSyntax cop on digit-starting keys.
* Fix crashes while inspecting class definition subclassing another class stored in a local variable in `UselessAssignment` (formerly of `UnusedLocalVariable`) and `ShadowingOuterLocalVariable` (like `clazz = Array; class SomeClass < clazz; end`).
* [#463](https://github.com/rubocop-hq/rubocop/issues/463): Do not warn if using destructuring in second `reduce` argument (`ReduceArguments`).

## 0.12.0 (2013-08-23)

### New features

* [#439](https://github.com/rubocop-hq/rubocop/issues/439): Added formatter 'OffenceCount' which outputs a summary list of cops and their offence count.
* [#395](https://github.com/rubocop-hq/rubocop/issues/395): Added `--show-cops` option to show available cops.
* New cop `NilComparison` keeps track of comparisons like `== nil`.
* New cop `EvenOdd` keeps track of occasions where `Fixnum#even?` or `Fixnum#odd?` should have been used (like `x % 2 == 0`).
* New cop `IndentationWidth` checks for files using indentation that is not two spaces.
* New cop `SpaceAfterMethodName` keeps track of method definitions with a space between the method name and the opening parenthesis.
* New cop `ParenthesesAsGroupedExpression` keeps track of method calls with a space before the opening parenthesis.
* New cop `HashMethods` keeps track of uses of deprecated `Hash` methods.
* New Rails cop `HasAndBelongsToMany` checks for uses of `has_and_belongs_to_many`.
* New Rails cop `ReadAttribute` tracks uses of `read_attribute`.
* `Attr` cop does auto-correction.
* `CollectionMethods` cop does auto-correction.
* `SignalException` cop does auto-correction.
* `EmptyLiteral` cop does auto-correction.
* `MethodCallParentheses` cop does auto-correction.
* `DefWithParentheses` cop does auto-correction.
* `DefWithoutParentheses` cop does auto-correction.

### Changes

* Dropped `-s`/`--silent` option. Now `progress`/`simple`/`clang` formatters always report summary and `emacs`/`files` formatters no longer report.
* Dropped the `LineContinuation` cop.

### Bugs fixed

* [#432](https://github.com/rubocop-hq/rubocop/issues/432): Fix false positive for constant assignments when rhs is a method call with block in `ConstantName`.
* [#434](https://github.com/rubocop-hq/rubocop/issues/434): Support classes and modules defined with `Class.new`/`Module.new` in `AccessControl`.
* Fix which ranges are highlighted in reports from IfUnlessModifier, WhileUntilModifier, and MethodAndVariableSnakeCase cop.
* [#438](https://github.com/rubocop-hq/rubocop/issues/438): Accept setting attribute on method argument in `UselessAssignment`.

## 0.11.1 (2013-08-12)

### Changes

* [#425](https://github.com/rubocop-hq/rubocop/issues/425): `ColonMethodCalls` now allows constructor methods (like `Nokogiri::HTML()` to be called with double colon.

### Bugs fixed

* [#427](https://github.com/rubocop-hq/rubocop/issues/427): FavorUnlessOverNegatedIf triggered when using elsifs.
* [#429](https://github.com/rubocop-hq/rubocop/issues/429): Fix `LeadingCommentSpace` offence reporting.
* Fixed `AsciiComments` offence reporting.
* Fixed `BlockComments` offence reporting.

## 0.11.0 (2013-08-09)

### New features

* [#421](https://github.com/rubocop-hq/rubocop/issues/421): `TrivialAccessors` now ignores methods on user-configurable whitelist (such as `to_s` and `to_hash`).
* [#369](https://github.com/rubocop-hq/rubocop/issues/369): New option `--auto-gen-config` outputs RuboCop configuration that disables all cops that detect any offences.
* The list of annotation keywords recognized by the `CommentAnnotation` cop is now configurable.
* Configuration file names are printed as they are loaded in `--debug` mode.
* Auto-correct support added in `AlignParameters` cop.
* New cop `UselessComparison` checks for comparisons of the same arguments.
* New cop `UselessAssignment` checks for useless assignments to local variables.
* New cop `SignalException` checks for proper usage of `fail` and `raise`.
* New cop `ModuleFunction` checks for usage of `extend self` in modules.

### Bugs fixed

* [#374](https://github.com/rubocop-hq/rubocop/issues/374): Fixed error at post condition loop (`begin-end-while`, `begin-end-until`) in `UnusedLocalVariable` and `ShadowingOuterLocalVariable`.
* [#373](https://github.com/rubocop-hq/rubocop/issues/373) and [#376](https://github.com/rubocop-hq/rubocop/issues/376): Allow braces around multi-line blocks if `do`-`end` would change the meaning of the code.
* `RedundantSelf` now allows `self.` followed by any ruby keyword.
* [#391](https://github.com/rubocop-hq/rubocop/issues/391): Fix bug in counting slashes in a regexp.
* [#394](https://github.com/rubocop-hq/rubocop/issues/394): `DotPosition` cop handles correctly code like `l.(1)`.
* [#390](https://github.com/rubocop-hq/rubocop/issues/390): `CommentAnnotation` cop allows keywords (e.g. Review, Optimize) if they just begin a sentence.
* [#400](https://github.com/rubocop-hq/rubocop/issues/400): Fix bug concerning nested defs in `EmptyLineBetweenDefs` cop.
* [#399](https://github.com/rubocop-hq/rubocop/issues/399): Allow assignment inside blocks in `AssignmentInCondition` cop.
* Fix bug in favor_modifier.rb regarding missed offences after else etc.
* [#393](https://github.com/rubocop-hq/rubocop/issues/393): Retract support for multiline chaining of blocks (which fixed [#346](https://github.com/rubocop-hq/rubocop/issues/346)), thus rejecting issue 346.
* [#389](https://github.com/rubocop-hq/rubocop/issues/389): Ignore symbols that are arguments to Module#private_constant in `SymbolName` cop.
* [#387](https://github.com/rubocop-hq/rubocop/issues/387): Do autocorrect in `AndOr` cop only if it does not change the meaning of the code.
* [#398](https://github.com/rubocop-hq/rubocop/issues/398): Don't display blank lines in the output of the clang formatter.
* [#283](https://github.com/rubocop-hq/rubocop/issues/283): Refine `StringLiterals` string content check.

## 0.10.0 (2013-07-17)

### New features

* New cop `RedundantReturn` tracks redundant `return`s in method bodies.
* New cop `RedundantBegin` tracks redundant `begin` blocks in method definitions.
* New cop `RedundantSelf` tracks redundant uses of `self`.
* New cop `EmptyEnsure` tracks empty `ensure` blocks.
* New cop `CommentAnnotation` tracks formatting of annotation comments such as TODO.
* Added custom rake task.
* New formatter `FileListFormatter` outputs just a list of files with offences in them (related to [#357](https://github.com/rubocop-hq/rubocop/issues/357)).

### Changes

* `TrivialAccessors` now has an `ExactNameMatch` config option (related to [#308](https://github.com/rubocop-hq/rubocop/issues/308)).
* `TrivialAccessors` now has an `ExcludePredicates` config option (related to [#326](https://github.com/rubocop-hq/rubocop/issues/326)).
* Cops don't inherit from `Parser::AST::Rewriter` anymore. All 3rd party Cops should remove the call to `super` in their callbacks. If you implement your own processing you need to define the `#investigate` method instead of `#inspect`. Refer to the documentation of `Cop::Commissioner` and `Cop::Cop` classes for more information.
* `EndAlignment` cop split into `EndAlignment` and `BlockAlignment` cops.

### Bugs fixed

* [#288](https://github.com/rubocop-hq/rubocop/issues/288): Work with absolute Excludes paths internally (2nd fix for this issue).
* `TrivialAccessors` now detects class attributes as well as instance attributes.
* [#338](https://github.com/rubocop-hq/rubocop/issues/338): Fix end alignment of blocks in chained assignments.
* [#345](https://github.com/rubocop-hq/rubocop/issues/345): Add `$SAFE` to the list of built-in global variables.
* [#340](https://github.com/rubocop-hq/rubocop/issues/340): Override config parameters rather than merging them.
* [#349](https://github.com/rubocop-hq/rubocop/issues/349): Fix false positive for `CharacterLiteral` (`%w(?)`).
* [#346](https://github.com/rubocop-hq/rubocop/issues/346): Support method chains for block end alignment checks.
* [#350](https://github.com/rubocop-hq/rubocop/issues/350): Support line breaks between variables on left hand side for block end alignment checks.
* [#356](https://github.com/rubocop-hq/rubocop/issues/356): Allow safe assignment in `ParenthesesAroundCondition`.

### Misc

* Improved performance on Ruby 1.9 by about 20%.
* Improved overall performance by about 35%.

## 0.9.1 (2013-07-05)

### New features

* Added `-l/--lint` option to allow doing only linting with no style checks (similar to running `ruby -wc`).

### Changes

* Removed the `BlockAlignSchema` configuration option from `EndAlignment`. We now support only the default alignment schema - `StartOfAssignment`.
* Made the preferred collection methods in `CollectionMethods` configurable.
* Made the `DotPosition` cop configurable - now both `leading` and `trailing` styles are supported.

### Bugs fixed

* [#318](https://github.com/rubocop-hq/rubocop/issues/318): Correct some special cases of block end alignment.
* [#317](https://github.com/rubocop-hq/rubocop/issues/317): Fix a false positive in `LiteralInCondition`.
* [#321](https://github.com/rubocop-hq/rubocop/issues/321): Ignore variables whose name start with `_` in `ShadowingOuterLocalVariable`.
* [#322](https://github.com/rubocop-hq/rubocop/issues/322): Fix exception of `UnusedLocalVariable` and `ShadowingOuterLocalVariable` when inspecting keyword splat argument.
* [#316](https://github.com/rubocop-hq/rubocop/issues/316): Correct nested postfix unless in `MultilineIfThen`.
* [#327](https://github.com/rubocop-hq/rubocop/issues/327): Fix false offences for block expression that span on two lines in `EndAlignment`.
* [#332](https://github.com/rubocop-hq/rubocop/issues/332): Fix exception of `UnusedLocalVariable` and `ShadowingOuterLocalVariable` when inspecting named captures.
* [#333](https://github.com/rubocop-hq/rubocop/issues/333): Fix a case that `EnsureReturn` throws an exception when ensure has no body.

## 0.9.0 (2013-07-01)

### New features

* Introduced formatter feature, enables custom formatted output and multiple outputs.
* Added progress formatter and now it's the default. (`--format progress`).
* Added JSON formatter. (`--format json`).
* Added clang style formatter showing the offending source. code. (`--format clang`). The `clang` formatter marks a whole range rather than just the starting position, to indicate more clearly where the problem is.
* Added `-f`/`--format` option to specify formatter.
* Added `-o`/`--out` option to specify output file for each formatter.
* Added `-r/--require` option to inject external Ruby code into RuboCop.
* Added `-V/--verbose-version` option that displays Parser version and Ruby version as well.
* Added `-R/--rails` option that enables extra Rails-specific cops.
* Added support for auto-correction of some offences with `-a`/`--auto-correct`.
* New cop `CaseEquality` checks for explicit use of `===`.
* New cop `AssignmentInCondition` checks for assignment in conditions.
* New cop `EndAlignment` tracks misaligned `end` keywords.
* New cop `Void` tracks uses of literals/variables/operators in possibly void context.
* New cop `Documentation` checks for top level class/module doc comments.
* New cop `UnreachableCode` tracks unreachable code segments.
* New cop `MethodCallParentheses` tracks unwanted braces in method calls.
* New cop `UnusedLocalVariable` tracks unused local variables for each scope.
* New cop `ShadowingOuterLocalVariable` tracks use of the same name as outer local variables for block arguments or block local variables.
* New cop `WhileUntilDo` tracks uses of `do` with multi-line `while/until`.
* New cop `CharacterLiteral` tracks uses of character literals (`?x`).
* New cop `EndInMethod` tracks uses of `END` in method definitions.
* New cop `LiteralInCondition` tracks uses of literals in the conditions of `if/while/until`.
* New cop `BeginBlock` tracks uses of `BEGIN` blocks.
* New cop `EndBlock` tracks uses of `END` blocks.
* New cop `DotPosition` tracks the dot position in multi-line method calls.
* New cop `Attr` tracks uses of `Module#attr`.
* Add support for auto-correction of some offences with `-a`/`--auto-correct`.

### Changes

* Deprecated `-e`/`--emacs` option. (Use `--format emacs` instead).
* Made `progress` formatter the default.
* Most formatters (`progress`, `simple` and `clang`) now print relative file paths if the paths are under the current working directory.
* Migrate all cops to new namespaces. `Rubocop::Cop::Lint` is for cops that emit warnings. `Rubocop::Cop::Style` is for cops that do not belong in other namespaces.
* Merge `FavorPercentR` and `PercentR` into one cop called `RegexpLiteral`, and add configuration parameter `MaxSlashes`.
* Add `CountKeywordArgs` configuration option to `ParameterLists` cop.

### Bugs fixed

* [#239](https://github.com/rubocop-hq/rubocop/issues/239): Fixed double quotes false positives.
* [#233](https://github.com/rubocop-hq/rubocop/issues/233): Report syntax cop offences.
* Fix off-by-one error in favor_modifier.
* [#229](https://github.com/rubocop-hq/rubocop/issues/229): Recognize a line with CR+LF as a blank line in AccessControl cop.
* [#235](https://github.com/rubocop-hq/rubocop/issues/235): Handle multiple constant assignment in ConstantName cop.
* [#246](https://github.com/rubocop-hq/rubocop/issues/246): Correct handling of unicode escapes within double quotes.
* Fix crashes in Blocks, CaseEquality, CaseIndentation, ClassAndModuleCamelCase, ClassMethods, CollectionMethods, and ColonMethodCall.
* [#263](https://github.com/rubocop-hq/rubocop/issues/263): Do not check for space around operators called with method syntax.
* [#271](https://github.com/rubocop-hq/rubocop/issues/271): Always allow line breaks inside hash literal braces.
* [#270](https://github.com/rubocop-hq/rubocop/issues/270): Fixed a false positive in ParenthesesAroundCondition.
* [#288](https://github.com/rubocop-hq/rubocop/issues/288): Get config parameter AllCops/Excludes from highest config file in path.
* [#276](https://github.com/rubocop-hq/rubocop/issues/276): Let columns start at 1 instead of 0 in all output of column numbers.
* [#292](https://github.com/rubocop-hq/rubocop/issues/292): Don't check non-regular files (like sockets, etc).
* Fix crashes in WordArray on arrays of character literals such as `[?\r, ?\n]`.
* Fix crashes in Documentation on empty modules.

## 0.8.3 (2013-06-18)

### Bug fixes

* Lock Parser dependency to version 2.0.0.beta5.

## 0.8.2 (2013-06-05)

### New features

* New cop `BlockNesting` checks for excessive block nesting.

### Bug fixes

* Correct calculation of whether a modifier version of a conditional statement will fit.
* Fix an error in `MultilineIfThen` cop that occurred in some special cases.
* [#231](https://github.com/rubocop-hq/rubocop/issues/231): Fix a false positive for modifier if.

## 0.8.1 (2013-05-30)

### New features

* New cop `Proc` tracks uses of `Proc.new`.

### Changes

* Renamed `NewLambdaLiteral` to `Lambda`.
* Aligned the `Lambda` cop more closely to the style guide - it now allows the use of `lambda` for multi-line blocks.

### Bugs fixed

* [#210](https://github.com/rubocop-hq/rubocop/issues/210): Fix a false positive for double quotes in regexp literals.
* [#211](https://github.com/rubocop-hq/rubocop/issues/211): Fix a false positive for `initialize` method looking like a trivial writer.
* [#215](https://github.com/rubocop-hq/rubocop/issues/215): Fixed a lot of modifier `if/unless/while/until` issues.
* [#213](https://github.com/rubocop-hq/rubocop/issues/213): Make sure even disabled cops get their configuration set.
* [#214](https://github.com/rubocop-hq/rubocop/issues/214): Fix SpaceInsideHashLiteralBraces to handle string interpolation right.

## 0.8.0 (2013-05-28)

### Changes

* Folded `ArrayLiteral` and `HashLiteral` into `EmptyLiteral` cop.
* The maximum number of params `ParameterLists` accepts in now configurable.
* Reworked `SymbolSnakeCase` into `SymbolName`, which has an option `AllowCamelCase` enabled by default.
* Migrated from `Ripper` to the portable [Parser](https://github.com/whitequark/parser).

### New features

* New cop `ConstantName` checks for constant which are not using `SCREAMING_SNAKE_CASE`.
* New cop `AccessControl` checks private/protected indentation and surrounding blank lines.
* New cop `Loop` checks for `begin/end/while(until)` and suggests the use of `Kernel#loop`.

## 0.7.2 (2013-05-13)

### Bugs fixed

* [#155](https://github.com/rubocop-hq/rubocop/issues/155): 'Do not use semicolons to terminate expressions.' is not implemented correctly.
* `OpMethod` now handles definition of unary operators without crashing.
* `SymbolSnakeCase` now handles aliasing of operators without crashing.
* `RescueException` now handles the splat operator `*` in a `rescue` clause without crashing.
* [#159](https://github.com/rubocop-hq/rubocop/issues/159): AvoidFor cop misses many violations.

## 0.7.1 (2013-05-11)

### Bugs fixed

* Added missing files to the gemspec.

## 0.7.0 (2013-05-11)

### New features

* Added ability to include or exclude files/directories through `.rubocop.yml`.
* Added option --only for running a single cop.
* Relax semicolon rule for one line methods, classes and modules.
* Configuration files, such as `.rubocop.yml`, can now include configuration from other files through the `inherit_from` directive. All configuration files implicitly inherit from `config/default.yml`.
* New cop `ClassMethods` checks for uses for class/module names in definitions of class/module methods.
* New cop `SingleLineMethods` checks for methods implemented on a single line.
* New cop `FavorJoin` checks for usages of `Array#*` with a string argument.
* New cop `BlockComments` tracks uses of block comments(`=begin/=end` comments).
* New cop `EmptyLines` tracks consecutive blank lines.
* New cop `WordArray` tracks arrays of words.
* [#108](https://github.com/rubocop-hq/rubocop/issues/108): New cop `SpaceInsideHashLiteralBraces` checks for spaces inside hash literal braces - style is configurable.
* New cop `LineContinuation` tracks uses of the line continuation character (`\`).
* New cop `SymbolArray` tracks arrays of symbols.
* Print warnings for unrecognized names in configuration files.
* New cop `TrivialAccessors` tracks method definitions that could be automatically generated with `attr_*` methods.
* New cop `LeadingCommentSpace` checks for missing space after `#` in comments.
* New cop `ColonMethodCall` tracks uses of `::` for method calls.
* New cop `AvoidGlobalVars` tracks uses of non built-in global variables.
* New cop `SpaceAfterControlKeyword` tracks missing spaces after `if/elsif/case/when/until/unless/while`.
* New cop `Not` tracks uses of the `not` keyword.
* New cop `Eval` tracks uses of the `eval` function.

### Bugs fixed

* [#101](https://github.com/rubocop-hq/rubocop/issues/101): `SpaceAroundEqualsInParameterDefault` doesn't work properly with empty string.
* Fix `BraceAfterPercent` for `%W`, `%i` and `%I` and added more tests.
* Fix a false positive in the `Alias` cop. `:alias` is no longer treated as keyword.
* `ArrayLiteral` now properly detects `Array.new`.
* `HashLiteral` now properly detects `Hash.new`.
* `VariableInterpolation` now detects regexp back references and doesn't crash.
* Don't generate pathnames like some/project//some.rb.
* [#151](https://github.com/rubocop-hq/rubocop/issues/151): Don't print the unrecognized cop warning several times for the same `.rubocop.yml`.

### Misc

* Renamed `Indentation` cop to `CaseIndentation` to avoid confusion.
* Renamed `EmptyLines` cop to `EmptyLineBetweenDefs` to avoid confusion.

## 0.6.1 (2013-04-28)

### New features

* Split `AsciiIdentifiersAndComments` cop in two separate cops.

### Bugs fixed

* [#90](https://github.com/rubocop-hq/rubocop/issues/90): Two cops crash when scanning code using `super`.
* [#93](https://github.com/rubocop-hq/rubocop/issues/93): Issue with `whitespace?': undefined method`.
* [#97](https://github.com/rubocop-hq/rubocop/issues/97): Build fails.
* [#100](https://github.com/rubocop-hq/rubocop/issues/100): `OpMethod` cop doesn't work if method arg is not in braces.
* `SymbolSnakeCase` now tracks Ruby 1.9 hash labels as well as regular symbols.

### Misc

* [#88](https://github.com/rubocop-hq/rubocop/issues/88): Abort gracefully when interrupted with Ctrl-C.
* No longer crashes on bugs within cops. Now problematic checks are skipped and a message is displayed.
* Replaced `Term::ANSIColor` with `Rainbow`.
* Add an option to disable colors in the output.
* Cop names are now displayed alongside messages when `-d/--debug` is passed.

## 0.6.0 (2013-04-23)

### New features

* New cop `ReduceArguments` tracks argument names in reduce calls.
* New cop `MethodLength` tracks number of LOC (lines of code) in methods.
* New cop `RescueModifier` tracks uses of `rescue` in modifier form.
* New cop `PercentLiterals` tracks uses of `%q`, `%Q`, `%s` and `%x`.
* New cop `BraceAfterPercent` tracks uses of % literals with delimiters other than ().
* Support for disabling cops locally in a file with rubocop:disable comments.
* New cop `EnsureReturn` tracks usages of `return` in `ensure` blocks.
* New cop `HandleExceptions` tracks suppressed exceptions.
* New cop `AsciiIdentifiersAndComments` tracks uses of non-ascii characters in identifiers and comments.
* New cop `RescueException` tracks uses of rescuing the `Exception` class.
* New cop `ArrayLiteral` tracks uses of Array.new.
* New cop `HashLiteral` tracks uses of Hash.new.
* New cop `OpMethod` tracks the argument name in operator methods.
* New cop `PercentR` tracks uses of %r literals with zero or one slash in the regexp.
* New cop `FavorPercentR` tracks uses of // literals with more than one slash in the regexp.

### Bugs fixed

* [#62](https://github.com/rubocop-hq/rubocop/issues/62): Config files in ancestor directories are ignored if another exists in home directory.
* [#65](https://github.com/rubocop-hq/rubocop/issues/65): Suggests to convert symbols `:==`, `:<=>` and the like to snake_case.
* [#66](https://github.com/rubocop-hq/rubocop/issues/66): Does not crash on unreadable or unparseable files.
* [#70](https://github.com/rubocop-hq/rubocop/issues/70): Support `alias` with bareword arguments.
* [#64](https://github.com/rubocop-hq/rubocop/issues/64): Performance issue with Bundler.
* [#75](https://github.com/rubocop-hq/rubocop/issues/75): Make it clear that some global variables require the use of the English library.
* [#79](https://github.com/rubocop-hq/rubocop/issues/79): Ternary operator missing whitespace detection.

### Misc

* Dropped Jeweler for gem release management since it's no longer actively maintained.
* Handle pluralization properly in the final summary.

## 0.5.0 (2013-04-17)

### New features

* New cop `FavorSprintf` that checks for usages of `String#%`.
* New cop `Semicolon` that checks for usages of `;` as expression separator.
* New cop `VariableInterpolation` that checks for variable interpolation in double quoted strings.
* New cop `Alias` that checks for uses of the keyword `alias`.
* Automatically detect extensionless Ruby files with shebangs when search for Ruby source files in a directory.

### Bugs fixed

* [#59](https://github.com/rubocop-hq/rubocop/issues/59): Interpolated variables not enclosed in braces are not noticed.
* [#42](https://github.com/rubocop-hq/rubocop/issues/42): Received malformed format string ArgumentError from rubocop.

[@bbatsov]: https://github.com/bbatsov
[@jonas054]: https://github.com/jonas054
[@yujinakayama]: https://github.com/yujinakayama
[@dblock]: https://github.com/dblock
[@nevir]: https://github.com/nevir
[@daviddavis]: https://github.com/daviddavis
[@sds]: https://github.com/sds
[@fancyremarker]: https://github.com/fancyremarker
[@sinisterchipmunk]: https://github.com/sinisterchipmunk
[@vonTronje]: https://github.com/vonTronje
[@agrimm]: https://github.com/agrimm
[@pmenglund]: https://github.com/pmenglund
[@chulkilee]: https://github.com/chulkilee
[@codez]: https://github.com/codez
[@cyberdelia]: https://github.com/cyberdelia
[@emou]: https://github.com/emou
[@skanev]: https://github.com/skanev
[@claco]: https://github.com/claco
[@rifraf]: https://github.com/rifraf
[@scottmatthewman]: https://github.com/scottmatthewman
[@ma2gedev]: https://github.com/ma2gedev
[@jeremyolliver]: https://github.com/jeremyolliver
[@hannestyden]: https://github.com/hannestyden
[@geniou]: https://github.com/geniou
[@jkogara]: https://github.com/jkogara
[@tmorris-fiksu]: https://github.com/tmorris-fiksu
[@mockdeep]: https://github.com/mockdeep
[@hiroponz]: https://github.com/hiroponz
[@tamird]: https://github.com/tamird
[@fshowalter]: https://github.com/fshowalter
[@cschramm]: https://github.com/cschramm
[@bquorning]: https://github.com/bquorning
[@bcobb]: https://github.com/bcobb
[@irrationalfab]: https://github.com/irrationalfab
[@tommeier]: https://github.com/tommeier
[@sfeldon]: https://github.com/sfeldon
[@biinari]: https://github.com/biinari
[@barunio]: https://github.com/barunio
[@molawson]: https://github.com/molawson
[@wndhydrnt]: https://github.com/wndhydrnt
[@ggilder]: https://github.com/ggilder
[@salbertson]: https://github.com/salbertson
[@camilleldn]: https://github.com/camilleldn
[@mcls]: https://github.com/mcls
[@yous]: https://github.com/yous
[@vrthra]: https://github.com/vrthra
[@SkuliOskarsson]: https://github.com/SkuliOskarsson
[@jspanjers]: https://github.com/jspanjers
[@sch1zo]: https://github.com/sch1zo
[@smangelsdorf]: https://github.com/smangelsdorf
[@mvz]: https://github.com/mvz
[@jfelchner]: https://github.com/jfelchner
[@janraasch]: https://github.com/janraasch
[@jcarbo]: https://github.com/jcarbo
[@oneamtu]: https://github.com/oneamtu
[@toy]: https://github.com/toy
[@Koronen]: https://github.com/Koronen
[@blainesch]: https://github.com/blainesch
[@marxarelli]: https://github.com/marxarelli
[@katieschilling]: https://github.com/katieschilling
[@kakutani]: https://github.com/kakutani
[@rrosenblum]: https://github.com/rrosenblum
[@mattjmcnaughton]: https://github.com/mattjmcnaughton
[@huerlisi]: https://github.com/huerlisi
[@volkert]: https://github.com/volkert
[@lumeet]: https://github.com/lumeet
[@mmozuras]: https://github.com/mmozuras
[@d4rk5eed]: https://github.com/d4rk5eed
[@cshaffer]: https://github.com/cshaffer
[@eitoball]: https://github.com/eitoball
[@iainbeeston]: https://github.com/iainbeeston
[@pimterry]: https://github.com/pimterry
[@palkan]: https://github.com/palkan
[@jdoconnor]: https://github.com/jdoconnor
[@meganemura]: https://github.com/meganemura
[@zvkemp]: https://github.com/zvkemp
[@vassilevsky]: https://github.com/vassilevsky
[@gerry3]: https://github.com/gerry3
[@ypresto]: https://github.com/ypresto
[@clowder]: https://github.com/clowder
[@mudge]: https://github.com/mudge
[@mzp]: https://github.com/mzp
[@bankair]: https://github.com/bankair
[@crimsonknave]: https://github.com/crimsonknave
[@renuo]: https://github.com/renuo
[@sdeframond]: https://github.com/sdeframond
[@til]: https://github.com/til
[@carhartl]: https://github.com/carhartl
[@dylandavidson]: https://github.com/dylandavidson
[@tmr08c]: https://github.com/tmr08c
[@hbd225]: https://github.com/hbd225
[@l8nite]: https://github.com/l8nite
[@sumeet]: https://github.com/sumeet
[@ojab]: https://github.com/ojab
[@chastell]: https://github.com/chastell
[@glasnt]: https://github.com/glasnt
[@crazydog115]: https://github.com/crazydog115
[@RGBD]: https://github.com/RGBD
[@panthomakos]: https://github.com/panthomakos
[@matugm]: https://github.com/matugm
[@m1foley]: https://github.com/m1foley
[@tejasbubane]: https://github.com/tejasbubane
[@bmorrall]: https://github.com/bmorrall
[@fphilipe]: https://github.com/fphilipe
[@gotrevor]: https://github.com/gotrevor
[@awwaiid]: https://github.com/awwaiid
[@segiddins]: https://github.com/segiddins
[@urbanautomaton]: https://github.com/urbanautomaton.com
[@unmanbearpig]: https://github.com/unmanbearpig
[@maxjacobson]: https://github.com/maxjacobson
[@sliuu]: https://github.com/sliuu
[@edmz]: https://github.com/edmz
[@syndbg]: https://github.com/syndbg
[@wli]: https://github.com/wli
[@caseywebdev]: https://github.com/caseywebdev
[@MGerrior]: https://github.com/MGerrior
[@imtayadeway]: https://github.com/imtayadeway
[@mrfoto]: https://github.com/mrfoto
[@karreiro]: https://github.com/karreiro
[@dreyks]: https://github.com/dreyks
[@hmadison]: https://github.com/hmadison
[@miquella]: https://github.com/miquella
[@jhansche]: https://github.com/jhansche
[@cornelius]: https://github.com/cornelius
[@eagletmt]: https://github.com/eagletmt
[@apiology]: https://github.com/apiology
[@alexdowad]: https://github.com/alexdowad
[@minustehbare]: https://github.com/minustehbare
[@tansaku]: https://github.com/tansaku
[@ptrippett]: https://github.com/ptrippett
[@br3nda]: https://github.com/br3nda
[@jujugrrr]: https://github.com/jujugrrr
[@sometimesfood]: https://github.com/sometimesfood
[@cgriego]: https://github.com/cgriego
[@savef]: https://github.com/savef
[@volmer]: https://github.com/volmer
[@domcleal]: https://github.com/domcleal
[@codebeige]: https://github.com/codebeige
[@weh]: https://github.com/weh
[@bfontaine]: https://github.com/bfontaine
[@jawshooah]: https://github.com/jawshooah
[@DNNX]: https://github.com/DNNX
[@mvidner]: https://github.com/mvidner
[@mattparlane]: https://github.com/mattparlane
[@drenmi]: https://github.com/drenmi
[@georgyangelov]: https://github.com/georgyangelov
[@owst]: https://github.com/owst
[@seikichi]: https://github.com/seikichi
[@madwort]: https://github.com/madwort
[@annih]: https://github.com/annih
[@mmcguinn]: https://github.com/mmcguinn
[@pocke]: https://github.com/pocke
[@prsimp]: https://github.com/prsimp
[@ptarjan]: https://github.com/ptarjan
[@jweir]: https://github.com/jweir
[@Fryguy]: https://github.com/Fryguy
[@mikegee]: https://github.com/mikegee
[@tbrisker]: https://github.com/tbrisker
[@necojackarc]: https://github.com/necojackarc
[@laurelfan]: https://github.com/laurelfan
[@amuino]: https://github.com/amuino
[@dylanahsmith]: https://github.com/dylanahsmith
[@gerrywastaken]: https://github.com/gerrywastaken
[@bolshakov]: https://github.com/bolshakov
[@jastkand]: https://github.com/jastkand
[@graemeboy]: https://github.com/graemeboy
[@akihiro17]: https://github.com/akihiro17
[@magni-]: https://github.com/magni-
[@NobodysNightmare]: https://github.com/NobodysNightmare
[@gylaz]: https://github.com/gylaz
[@tjwp]: https://github.com/tjwp
[@neodelf]: https://github.com/neodelf
[@josh]: https://github.com/josh
[@natalzia-paperless]: https://github.com/natalzia-paperless
[@jules2689]: https://github.com/jules2689
[@giannileggio]: https://github.com/giannileggio
[@deivid-rodriguez]: https://github.com/deivid-rodriguez
[@pclalv]: https://github.com/pclalv
[@flexoid]: https://github.com/flexoid
[@sgringwe]: https://github.com/sgringwe
[@Tei]: https://github.com/Tei
[@haziqhafizuddin]: https://github.com/haziqhafizuddin
[@dvandersluis]: https://github.com/dvandersluis
[@QuinnHarris]: https://github.com/QuinnHarris
[@sooyang]: https://github.com/sooyang
[@metcalf]: https://github.com/metcalf
[@annaswims]: https://github.com/annaswims
[@soutaro]: https://github.com/soutaro
[@nicklamuro]: https://github.com/nicklamuro
[@mikezter]: https://github.com/mikezter
[@joejuzl]: https://github.com/joejuzl
[@hedgesky]: https://github.com/hedgesky
[@tjwallace]: https://github.com/tjwallace
[@scottohara]: https://github.com/scottohara
[@koic]: https://github.com/koic
[@groddeck]: https://github.com/groddeck
[@b-t-g]: https://github.com/b-t-g
[@coorasse]: https://github.com/coorasse
[@tcdowney]: https://github.com/tcdowney
[@logicminds]: https://github.com/logicminds
[@abrom]: https://github.com/abrom
[@thegedge]: https://github.com/thegedge
[@jmks]: https://github.com/jmks/
[@connorjacobsen]: https://github.com/connorjacobsen
[@legendetm]: https://github.com/legendetm
[@bronson]: https://github.com/bronson
[@albus522]: https://github.com/albus522
[@sihu]: https://github.com/sihu
[@kamaradclimber]: https://github.com/kamaradclimber
[@swcraig]: https://github.com/swcraig
[@jessieay]: https://github.com/jessieay
[@tiagocasanovapt]: https://github.com/tiagocasanovapt
[@iGEL]: https://github.com/iGEL
[@tessi]: https://github.com/tessi
[@ivanovaleksey]: https://github.com/ivanovaleksey
[@Ana06]: https://github.com/Ana06
[@aroben]: https://github.com/aroben
[@olliebennett]: https://github.com/olliebennett
[@aesthetikx]: https://github.com/aesthetikx
[@tdeo]: https://github.com/tdeo
[@AlexWayfer]: https://github.com/AlexWayfer
[@amogil]: https://github.com/amogil
[@kevindew]: https://github.com/kevindew
[@lucasuyezu]: https://github.com/lucasuyezu
[@breckenedge]: https://github.com/breckenedge
[@enriikke]: https://github.com/enriikke
[@iguchi1124]: https://github.com/iguchi1124
[@vergenzt]: https://github.com/vergenzt
[@rahulcs]: https://github.com/rahulcs
[@dominh]: https://github.com/dominh
[@sue445]: https://github.com/sue445
[@zverok]: https://github.com/zverok
[@backus]: https://github.com/backus
[@AdrienSldy]: https://github.com/adriensldy
[@pat]: https://github.com/pat
[@sinsoku]: https://github.com/sinsoku
[@nodo]: https://github.com/nodo
[@onk]: https://github.com/onk
[@dabroz]: https://github.com/dabroz
[@buenaventure]: https://github.com/buenaventure
[@dorian]: https://github.com/dorian
[@attilahorvath]: https://github.com/attilahorvath
[@droptheplot]: https://github.com/droptheplot
[@wkurniawan07]: https://github.com/wkurniawan07
[@kddeisz]: https://github.com/kddeisz
[@ota42y]: https://github.com/ota42y
[@smakagon]: https://github.com/smakagon
[@musialik]: https://github.com/musialik
[@twe4ked]: https://github.com/twe4ked
[@maxbeizer]: https://github.com/maxbeizer
[@andriymosin]: https://github.com/andriymosin
[@brandonweiss]: https://github.com/brandonweiss
[@betesh]: https://github.com/betesh
[@dpostorivo]: https://github.com/dpostorivo
[@konto-andrzeja]: https://github.com/konto-andrzeja
[@sadovnik]: https://github.com/sadovnik
[@cjlarose]: https://github.com/cjlarose
[@alpaca-tc]: https://github.com/alpaca-tc
[@ilansh]: https://github.com/ilansh
[@mclark]: https://github.com/mclark
[@klesse413]: https://github.com/klesse413
[@gprado]: https://github.com/gprado
[@yhirano55]: https://github.com/yhirano55
[@hoshinotsuyoshi]: https://github.com/hoshinotsuyoshi
[@timrogers]: https://github.com/timrogers
[@harold-s]: https://github.com/harold-s
[@daniloisr]: https://github.com/daniloisr
[@promisedlandt]: https://github.com/promisedlandt
[@oboxodo]: https://github.com/oboxodo
[@gohdaniel15]: https://github.com/gohdaniel15
[@barthez]: https://github.com/barthez
[@Envek]: https://github.com/Envek
[@petehamilton]: https://github.com/petehamilton
[@donjar]: https://github.com/donjar
[@highb]: https://github.com/highb
[@JoeCohen]: https://github.com/JoeCohen
[@theRealNG]: https://github.com/theRealNG
[@akhramov]: https://github.com/akhramov
[@jekuta]: https://github.com/jekuta
[@fujimura]: https://github.com/fujimura
[@kristjan]: https://github.com/kristjan
[@frodsan]: https://github.com/frodsan
[@erikdstock]: https://github.com/erikdstock
[@GauthamGoli]: https://github.com/GauthamGoli
[@nelsonjr]: https://github.com/nelsonjr
[@jonatas]: https://github.com/jonatas
[@jaredbeck]: https://www.jaredbeck.com
[@michniewicz]: https://github.com/michniewicz
[@bgeuken]: https://github.com/bgeuken
[@mtsmfm]: https://github.com/mtsmfm
[@bdewater]: https://github.com/bdewater
[@garettarrowood]: https://github.com/garettarrowood
[@sambostock]: https://github.com/sambostock
[@asherkach]: https://github.com/asherkach
[@tiagotex]: https://github.com/tiagotex
[@wata727]: https://github.com/wata727
[@marcandre]: https://github.com/marcandre
[@walf443]: https://github.com/walf443
[@reitermarkus]: https://github.com/reitermarkus
[@chrishulton]: https://github.com/chrishulton
[@siegfault]: https://github.com/siegfault
[@melch]: https://github.com/melch
[@nattfodd]: https://github.com/nattfodd
[@flyerhzm]: https://github.com/flyerhzm
[@ybiquitous]: https://github.com/ybiquitous
[@mame]: https://github.com/mame
[@dominicsayers]: https://github.com/dominicsayers
[@albertpaulp]: https://github.com/albertpaulp
[@orgads]: https://github.com/orgads
[@leklund]: https://github.com/leklund
[@untitaker]: https://github.com/untitaker
[@walinga]: https://github.com/walinga
[@georf]: https://github.com/georf
[@Edouard-chin]: https://github.com/Edouard-chin
[@eostrom]: https://github.com/eostrom
[@roberts1000]: https://github.com/roberts1000
[@satyap]: https://github.com/satyap
[@unkmas]: https://github.com/unkmas
[@elebow]: https://github.com/elebow
[@colorbox]: https://github.com/colorbox
[@mmyoji]: https://github.com/mmyoji
[@unused]: https://github.com/unused
[@htwroclau]: https://github.com/htwroclau
[@hamada14]: https://github.com/hamada14
[@anthony-robin]: https://github.com/anthony-robin
[@YukiJikumaru]: https://github.com/YukiJikumaru
[@jlfaber]: https://github.com/jlfaber
[@drewpterry]: https://github.com/drewpterry
[@mcfisch]: https://github.com/mcfisch
[@istateside]: https://github.com/istateside
[@parkerfinch]: https://github.com/parkerfinch
[@joshuapinter]: https://github.com/joshuapinter
[@Darhazer]: https://github.com/Darhazer
[@Wei-LiangChew]: https://github.com/Wei-LiangChew
[@svendittmer]: https://github.com/svendittmer
[@composerinteralia]: https://github.com/composerinteralia
[@PointlessOne]: https://github.com/PointlessOne
[@JacobEvelyn]: https://github.com/JacobEvelyn
[@shanecav84]: https://github.com/shanecav84
[@thomasbrus]: https://github.com/thomasbrus
[@balbesina]: https://github.com/balbesina
[@cupakromer]: https://github.com/cupakromer
[@TikiTDO]: https://github.com/TikiTDO
[@EiNSTeiN-]: https://github.com/EiNSTeiN-
[@nroman-stripe]: https://github.com/nroman-stripe
[@sunny]: https://github.com/sunny
[@tatsuyafw]: https://github.com/tatsuyafw
[@alexander-lazarov]: https://github.com/alexander-lazarov
[@r7kamura]: https://github.com/r7kamura
[@Vasfed]: https://github.com/Vasfed
[@drn]: https://github.com/drn
[@maxh]: https://github.com/maxh
[@kenman345]: https://github.com/kenman345
[@nijikon]: https://github.com/nijikon
[@mikeyhew]: https://github.com/mikeyhew
[@mkenyon]: https://github.com/mkenyon
[@repinel]: https://github.com/repinel
[@gmalette]: https://github.com/gmalette
[@MagedMilad]: https://github.com/MagedMilad
[@robotdana]: https://github.com/robotdana
[@bacchir]: https://github.com/bacchir
[@khiav223577]: https://github.com/khiav223577
[@schneems]: https://github.com/schneems
[@ShockwaveNN]: https://github.com/ShockwaveNN
[@Knack]: https://github.com/Knack
[@akanoi]: https://github.com/akanoi
[@yensaki]: https://github.com/yensaki
[@ryanhageman]: https://github.com/ryanhageman
[@autopp]: https://github.com/autopp
[@lukasz-wojcik]: https://github.com/lukasz-wojcik
[@albaer]: https://github.com/albaer
[@Kevinrob]: https://github.com/Kevinrob
[@andrew-aladev]: https://github.com/andrew-aladev
[@y-yagi]: https://github.com/y-yagi
[@DiscoStarslayer]: https://github.com/DiscoStarslayer
[@davearonson]: https://github.com/davearonson
[@timon]: https://github.com/timon
[@gsamokovarov]: https://github.com/gsamokovarov
[@itsWill]: https://github.com/itsWill
[@xlts]: https://github.com/xlts
[@takaram]: https://github.com/takaram
[@gmcgibbon]: https://github.com/gmcgibbon
[@dduugg]: https://github.com/dduugg
[@mmedal]: https://github.com/mmedal
[@timmcanty]: https://github.com/timmcanty
[@tom-lord]: https://github.com/tom-lord
[@bayandin]: https://github.com/bayandin
[@rspeicher]: https://github.com/rspeicher
[@nadiyaka]: https://github.com/nadiyaka
[@allcentury]: https://github.com/allcentury
[@antonzaytsev]: https://github.com/antonzaytsev
[@amatsuda]: https://github.com/amatsuda
[@Intrepidd]: https://github.com/Intrepidd
[@Ruffeng]: https://github.com/Ruffeng
[@roooodcastro]: https://github.com/roooodcastro
[@rmm5t]: https://github.com/rmm5t
[@marcotc]: https://github.com/marcotc
[@dazuma]: https://github.com/dazuma
[@dischorde]: https://github.com/dischorde
[@mhelmetag]: https://github.com/mhelmetag
[@Bhacaz]: https://github.com/bhacaz
[@enkessler]: https://github.com/enkessler
[@dcluna]: https://github.com/dcluna
[@tagliala]: https://github.com/tagliala
[@unasuke]: https://github.com/unasuke
[@elmasantos]: https://github.com/elmasantos
[@luciamo]: https://github.com/luciamo
[@dirtyharrycallahan]: https://github.com/dirtyharrycallahan
[@ericsullivan]: https://github.com/ericsullivan
[@aeroastro]: https://github.com/aeroastro
[@anuja-joshi]: https://github.com/anuja-joshi
[@XrXr]: https://github.com/XrXr
[@thomthom]: https://github.com/thomthom
[@Blue-Pix]: https://github.com/Blue-Pix
[@diachini]: https://github.com/diachini
[@Mange]: https://github.com/Mange
[@jmanian]: https://github.com/jmanian
[@vfonic]: https://github.com/vfonic
[@andreaseger]: https://github.com/andreaseger
[@yakout]: https://github.com/yakout
[@RicardoTrindade]: https://github.com/RicardoTrindade
[@att14]: https://github.com/att14
[@houli]: https://github.com/houli
[@lavoiesl]: https://github.com/lavoiesl
[@fwininger]: https://github.com/fwininger
[@stoivo]: https://github.com/stoivo
[@eugeneius]: https://github.com/eugeneius
[@malyshkosergey]: https://github.com/malyshkosergey
[@fwitzke]: https://github.com/fwitzke
[@okuramasafumi]: https://github.com/okuramasafumi
[@buehmann]: https://github.com/buehmann
[@halfwhole]: https://github.com/halfwhole
