[![Build Status](https://travis-ci.org/pyromaniac/hotcell.png)](https://travis-ci.org/pyromaniac/hotcell)

# Hotcell

Hotcell is a sanboxed template processor.

Key features:

* Ruby-like adult syntax, every expression returns its value
* Ragel-based lexer + Racc-based parser = fast engine base
* Stateless: once compiled - rendered as many times as nessesary
* Safe and sandboxed. Template variables and functions are evaluated safely
  and have no any access to the environment

## Installation

Add this line to your application's Gemfile:

    gem 'hotcell'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hotcell

## Language reference

Hotcell template consists of template parts and tags. Tags are enclosed in
double curly braces `Hello, {{ name }}!`.
Tags can contain expressions or commands. Expression is a combination of
values and operators. Value can be an object, referenced by variable or
a basic type.

### Basic types

Hotcell has several basic types:

* Numbers: integer `{{ 42 }}` or float `{{ 36.6 }}`
* Strings: single-quoted `{{ 'Hello' }}` or double-quoted `{{ "World" }}`.
  Strings support escaping `{{ 'tlhab \'oS \'Iw HoHwI\' So\' batlh\' }}`.
  Double-quoted strings also support escape sequences {{ "\n\r\s\t" }}
* Regular expressions `{{ /Foo/i }}`. Simple. Expression plus options (imx)
* Arrays `{{ [42, 'hello', /regex/m] }}`
* Hashes `{{ { a: 42, b: 'bar' } }}` has js-like syntax, so only string
  can be a key for a hash
* Constant values `{{ true }}`, `{{ false }}`, `{{ nil }}` and `{{ null }}`.
  Last two have the same meaning, use whatever you like.

All the basic types are objects and support method calls on themselfs.

### Variables

Variable is a value reference (`{{ name }}`). Variable name is better
to describe with regexp 

```ruby
/\[_a-z\]\[_a-z0-9\]*[?!]?/i
```

So `_` or `sum42?` - is a
variable, but `123foo` - is not.

### Operators

Operators between values form an expression: `{{ forty_two = 6 * 7 }}` or
`{{ [1, 2, 3].sum && true == 'wtf?' }}`

1. Arithmetical:
  * `+`, `-`, `*`, `/` are ordinary
  * `%` means modulo
  * `**` is the power
2. Logical:
  * `&&` - and, `||` - or, `!` - not
  * `==` - equal and `!=` - inequal
  * comparation: `>`, `>=`, `<`, `<=`
3. Other:
  * `=` for assigning (`{{ hello_string = 'Hello' }}`)
  * `.` for method calling (`{{ 'hello'.strip }}`)
  * `;` as an expressions delimiter (`{{ a = 'foo'; 3 == 7 }}`)
  * `(` and `)` for operator precedence (`{{ (2 + 2) * 2 }}`) or
    method arguments passing: `{{ hello(who, where) }}`
  * `[]` is used for array or hash elements access (`{{ some_array[2] }}`
    or `{{ [1, 2, 3][2] }}` or `{{ { foo: 'bar' }['foo'] }}`)

Method call args are similar to ruby ones. You can call function like
this: `{{ foo(42, 'string', opt1: 3, opt2: /regexp/) }}`, and the last
argument would be a hash. Also parentheses are not required if function
takes no arguments: `{{ foo.bar.baz }}` is similar to
`{{ foo().bar().baz() }}`. Unlike ruby, in case of arguments presence,
parentheses are required.

### Expressions

Hotcell supports multiline complex expressions. Only the last expression of
an expression sequence will be returned. Expression delimeters are `;` or `\n`.

```
{{
  forty_two = 6 * 7
  sum = [1, 2, 3].sum;
  (forty_two + sum) / 8
}} {{# => 6 #}}
```

Feel free to combine operators, variables and objects - hotcell has
really flexible expressions syntax.

### Tags

There is some tag modificators to set tag mode.

* `!` - silence modificator. Prevents tag value to be concatenated with
  template, so `{{! 42 }}` will return '' - empty string. This modificator
  is useful for pre-calculation: `{{! var = 'foo' * 3 }}`.

### Comments

There is two comments types in Hotcell: in-tag line comment and block comment.

#### In-tag line comments

In-tag line comment works inside tag only. It starts from `#` symbol
and finishes at the end of the line (`\n`):

```
{{
  # here I will calculate number forty two
  # with arithmetic operations help
  6 * 7 # found!
}}
```

#### Block comments

Block comments are useful to enclose even tags:

```
{{# {{ 'string'.truncate(10) }} Template {{ nil || value }} #}}
```

### Commands

Command is a special tag case. It is a logic of your template. It
is more complex then function call and divided into two types:
commands and blocks.

Command syntax looks like this: `{{ [variable =] command_name [arg1, arg2...] }}`
Unlike methods or functions call, command doesn't use parentheses to take
arguments. Blocks are consist of command, closing tag and optional subcommands:

```
{{ [variable =] command_name [arg1, arg2...] }}
  {{ subcommand [arg1, arg2...] }}
{{ end command_name }} {{# or {{ endcommand_name }} #}}
```

Variable and assigment is optional and with it you can assign the
command result to variable. For example, next command will put `Hello`
string into `result` variable and concat nothing to template (because of
the silence tag mode):

```
{{! result = if true }}
  Hello
{{ else }}
  World
{{ end if }}
```

#### Built-in Commands

##### Include

Include command renders and returns rendering result of another template
into current.

```
{{ include 'template/path', name: 'Hulk' }}
```

Also additional local variables could be transferred to the included
template via optional command hash.

`Hotcell::Resolver` ancestors are used for template resolving. Default resolver
stored in `Hotcell.resolver`, also resolver for current rendering could be
set up via `:resolver` shared option:

```ruby
Hotcell::Template.parse('{{ include 'template' }}').render(shared: { resolver: MyResolver.new })
```

##### Cycle

Command used for cycled output values from array. Useful with loops.

```
{{ for i, in: [1, 2, 3], loop: true }}
  {{ i }} {{ cycle ['one', 'two', 'three'] }}{{ unless loop.last? }}, {{ end unless }}
{{ end for }}
```

This will output `1 one, 2 two, 3 three`.

#### Built-in Blocks

##### If

Conditional command. Like in most programming languages

```
{{ if var == 3 }}
  foo
{{ elsif !cool }}
  bar
{{ else }}
  baz
{{ end if }}
```

##### Unless

Reversed conditional command. Sumilar to rubys. Only `else` subcommand is supported

```
{{ unless var == 3 }}
  foo
{{ else }}
  bar
{{ end unless }}
```

##### Case

Case command. Like in most programming languages

```
{{ case 42 }}
{{ when 42, 43 }}
  foo
{{ when value, 'string' }}
  bar
{{ else }}
  baz
{{ end case }}
```

##### For

Loop command, first argument - variable to put next value, `in` option
takes an array.

```
{{ for post, in: posts }}
  {{ post.title }}
{{ end for }}
```

Additional option `loop`. Takes `true` or `'string'`. Uses string as variable
name to store loop options, in case of `true`, the default variable name is `'loop'`.

```
{{ for post, in: [1, 2, 3], loop: true }}
{{# or {{ for post, in: [1, 2, 3], loop: 'forloop' }} #}}
  {{ loop.index }}
  {{# or {{ forloop.index }} #}}
{{ end for }}
```

Full list of loop object methods:

* `prev` - previous element of the array (nil if current is the first)
* `next` - previous element of the array (nil if current is the last)
* `length` or `size` or `count` - number, array length
* `index` - current array value index, counting from 0
* `rindex` - the same, but starting from the array tail
* `first` or `first?` - boolean value, detect whether the current element is the first
* `last` or `last?` - boolean value, detect whether the current element is the last

##### Scope

Block with encapsulated variables. Used for variables environment changing:

```
{{ scope count: 50, foo: some_value }}
  {{ count }}
  {{ foo }}
{{ end scope }}
```

Or for template capturing:

```
{{! title = scope }}<h1>Hello</h1>{{ end scope }}
{{ title }}
```

## Usage

### Basic usage:

```ruby
Hotcell::Template.parse('Hello, {{ name }}!').render name: 'Pyromaniac'
```

### Additional `render` options:

* `:variables` - variables hash
* `:environment` - environment variables hash
* `:scope` - variables and environment variables together

The main difference between environment and ordinary variables is: ordinary variables
are accessible from the template and environment variables are not. Environment variables
are user for official purposes, in tag, for example. At the options level, variables have
string keys and environment variables have symbol keys.

```ruby
Hotcell::Template.parse('Hello, {{ name }}!').render(
  variables: { name: 'Pyromaniac' },
  environments: { some_access_token: '1234567890' },
  scope: { 'foo' => 42, bar: 43 },
  moo: 'Hello'
)
```

So if you will use something like above, all three options will be merged, but `:variables`
hash keys will be stringified, `:environment` hash keys will be symbolized, `:scope`
hash will be lived as is and the rest non-official options will be stringified and used as
variables. The result of this algorithm will be:

```ruby
{
  'name' => 'Pyromaniac', 'foo' => 42, 'moo' => 'Hello',
  some_access_token: '1234567890', bar: 43
}
```

Remaining allowed options are:

* `:rescuer` - a lambda for error rescuing logic. The result of lambda call will be joined to
  the template. The default lambda just returns error message to the template.

  ```ruby
    Hotcell::Template.parse('Hello, {{ name }}!').render(
      name: 'Pyromaniac',
      rescuer: ->(e) { Rollbar.report_exception(e) }
    )
  ```

* `:reraise` - raise exception after occurence or not. Error raises after `:rescuer` execution and
  doesn't affect it. Accepts true or false.
* `:helpers` - array of modules with fuctions accessible from template. `Hotcell.helpers` config
  option is used by default. Works similar to ActionController's helpers.

  ```ruby
    Hotcell::Template.parse('Hello, {{ name }}!').render(
      name: 'Pyromaniac',
      helpers: MyHelper # or array [MyHelper1, MyHelper2]
    )
  ```
* `:shared` - just hash of shared variables, for internal usage

### Configuring Hotcell

Hotcell has several configuration methods, which provide default internals for
template processor proper work.

* `commands` accessor returns a hash of default commands
* `blocks` - same is for blocks
* `helpers` - default helper modules array
* `resolver` - default resolver for `include` command

Also there are methods to setup configuration options:

* `register_command` adds command or block to the list of default commands or blocks
* `register_helpers` used for adding module to the list of helpers
* `resolver=` setups new default resolver


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
