# Changelog

## Unreleased

## 0.1.1 - 2026-04-20
- Upgrade `rubyzip` dependency from `~> 2.0` to `~> 3.0`.

## 0.1.0 - 2026-03-23
- Parse Excel spreadsheets (`.xlsx`, `.xlsm`) from file paths, strings, and IO objects.
- Sheet access by name with hidden sheet filtering.
- Row and cell access by index and cell reference (e.g. `A1`).
- Cell values, formulas, types (string, number, boolean, date, formula, inline_str).
- Cell ranges and named ranges with 1D and 2D array returns.
- Column definitions with hidden and width properties.
- Merged cell detection.
- Style access (fonts and fills) per cell.
- Data validations per sheet and per cell.
- Comment extraction.
- Padded rows and padded cells options for gap filling.
- Lazy row loading via row cache for large files.
- CircleCI for Ruby 3.3, 3.4.
