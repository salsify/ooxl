# Contributing to OOXL

Thank you for your interest in contributing to OOXL! This document provides guidelines and instructions for contributing.

## Development Setup

1. Fork and clone the repository:

   ```bash
   git clone https://github.com/<your-username>/ooxl.git
   cd ooxl
   ```

2. Install dependencies:

   ```bash
   bin/setup
   ```

3. Verify everything works:

   ```bash
   bundle exec rake spec
   ```

4. Open an interactive console to experiment:

   ```bash
   bin/console
   ```

## Running Tests

```bash
bundle exec rake spec
```

All tests must pass before a pull request can be merged. CI runs the test suite against Ruby 3.0, 3.1, 3.2, and 3.3.

## Branch and PR Conventions

1. Create a feature branch from `master`:

   ```bash
   git checkout -b my-feature master
   ```

2. Make your changes in small, focused commits.

3. Push your branch and open a pull request against `master`.

4. Fill out the pull request template, including a description of the change, whether tests were added, and whether the changelog was updated.

## Code Style

- Follow standard Ruby conventions and the patterns already established in the codebase.
- Keep methods short and focused.
- Add tests for any new functionality or bug fixes.
- Update `CHANGELOG.md` under the `[Unreleased]` section when making user-facing changes.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.
