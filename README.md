# Pronto runner for Prettier using NPM

[![Build Status](https://travis-ci.org/andrewmcodes/pronto-prettier-npm.svg?branch=master)](https://travis-ci.org/andrewmcodes/pronto-prettier-npm)

[Pronto](https://github.com/mmozuras/pronto) runner for [Prettier](https://prettier.io), an opinionated code formatter for JavaScript, JSX, and more.

---

## Prerequisites

You'll need to install [prettier by yourself with yarn/npm][prettier-install]. If `prettier` is in your `PATH`, everything will simply work, otherwise you have to provide pronto-prettier-npm your custom executable path (see [below](#configuration-of-prettier)).

[prettier-install]: https://prettier.io/docs/en/install.html

---

## Configuration of Prettier

Configure Prettier like you [normally would][prettier-configuration].

[prettier-configuration]: https://prettier.io/docs/en/configuration.html

---

## Configuration of Pronto::Prettier::NPM

`pronto-prettier-npm` can be configured by placing a `.pronto_prettier_npm.yml` inside the directory where Pronto is run.

Following options are available:

| Option              | Meaning                                                                                  | Default                                 |
| ------------------- | ---------------------------------------------------------------------------------------- | --------------------------------------- |
| prettier_executable | Prettier executable to call.                                                             | `prettier` (calls `prettier` in `PATH`) |
| files_to_lint       | What files to lint. Absolute path of offending file will be matched against this Regexp. | `(\.js|\.jsx|\.scss)$`                  |
| cmd_line_opts       | Command line options to pass to prettier when running                                    | `--check`                               |

---

## Example configuration

Calls custom prettier executable and only lints files ending with `.my_custom_extension`:

```yaml
# .pronto_prettier_npm.yml
prettier_executable: '/my/custom/node/path/.bin/prettier'
files_to_lint: '\.my_custom_extension$'
cmd_line_opts: '--ext .scss,.js,.jsx'
```

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pronto-prettier-npm'
```

---

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

---

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andrewmcodes/pronto-prettier-npm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

---

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

## Code of Conduct

Everyone interacting in the Pronto::Prettier::Npm project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pronto-prettier-npm/blob/master/CODE_OF_CONDUCT.md).

---

## Recognition

This project was originally forked from [doits/pronto-eslint_npm](https://github.com/doits/pronto-eslint_npm). Many thanks to [Markus Doits](https://github.com/doits) for creating this awesome project.
