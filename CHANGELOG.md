# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## Unreleased

### Changed
- Updated gemspec metadata

## 0.1.0 - 2026-03-23

### Added
- Parse Excel spreadsheets (`.xlsx`, `.xlsm`) from file paths, strings, and IO objects
- Sheet access by name with hidden sheet filtering
- Row and cell access by index and cell reference (e.g. `A1`)
- Cell values, formulas, types (string, number, boolean, date, formula, inline_str)
- Cell ranges and named ranges with 1D and 2D array returns
- Column definitions with hidden and width properties
- Merged cell detection
- Style access (fonts and fills) per cell
- Data validations per sheet and per cell
- Comment extraction
- Padded rows and padded cells options for gap filling
- Lazy row loading via row cache for large files
- GitHub Actions CI for Ruby 3.0, 3.1, 3.2, 3.3
