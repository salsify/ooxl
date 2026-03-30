# OOXL

[![Gem Version](https://badge.fury.io/rb/ooxl.svg)](https://badge.fury.io/rb/ooxl)
[![CI](https://circleci.com/gh/salsify/ooxl.svg?style=shield)](https://circleci.com/gh/salsify/ooxl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ruby](https://img.shields.io/badge/Ruby-3.3%2B-red.svg)](https://www.ruby-lang.org)

A lightweight Ruby library for parsing Excel spreadsheets (`.xlsx`, `.xlsm`). Extract sheet data, cell values, formulas, styles, comments, data validations, and named ranges with a simple API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ooxl'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ooxl

## Usage

### Opening a Spreadsheet

```ruby
# From a file path
ooxl = OOXL.new('example.xlsx')
# or
ooxl = OOXL.open('example.xlsx')

# From a string or IO stream (e.g. uploaded file, HTTP response)
ooxl = OOXL.parse(file_contents)
```

### Options

```ruby
ooxl = OOXL.open('example.xlsx',
  skip_hidden_sheets: true,  # exclude hidden sheets from iteration
  padded_rows: true,         # fill gaps in row indices with empty rows
  padded_cells: true         # fill gaps in columns with blank cells
)
```

### Sheets

```ruby
ooxl.sheets                     # => ["Sheet 1", "Sheet 2"]
ooxl.sheets(skip_hidden: true)  # exclude hidden sheets

sheet = ooxl.sheet('Sheet 1')
# or
sheet = ooxl['Sheet 1']
```

### Rows and Cells

```ruby
sheet = ooxl['Sheet 1']

# Access rows by index
sheet.rows        # all rows
sheet.rows[0]     # first row
sheet[0]          # shorthand

# Access cells
sheet[0].cells    # all cells in the first row
sheet[0][0]       # first cell of the first row
sheet[0][0].value # cell value

# Access a cell directly by reference
cell = sheet.cell('C1')
cell.value    # => "some value"
cell.column   # => "C"
cell.row      # => "1"
cell.type     # => :string, :number, :boolean, :date, :formula, :inline_str
cell.formula  # => formula string, or nil
```

### Iteration

```ruby
# Iterate over rows in a sheet
ooxl['Sheet 1'].each do |row|
  row.each do |cell|
    puts cell.value
  end
end

# Iterate over all sheets
ooxl.each do |sheet|
  sheet.each do |row|
    row.each do |cell|
      puts cell.value
    end
  end
end
```

### Cell Ranges and Named Ranges

```ruby
# Named range
ooxl.named_range('my_named_range') # => ["value1", "value2", "value3"]

# Cell range (column)
ooxl['Lists!A1:A6']   # => ["1", "2", "3", "4", "5", "6"]

# Single cell
ooxl['Lists!A1']       # => ["1"]

# Rectangle (returns 2D array)
ooxl['Lists!A1:B2']   # => [["1", "2"], ["3", "4"]]

# Entire column
ooxl['Lists!A:A']     # => ["1", "2", "3", "4", "5", "6"]
```

### Columns

```ruby
sheet = ooxl['Sheet 1']

sheet.columns          # all column definitions
sheet.column('A')      # by letter
sheet.column(1)        # by index
sheet.column('A').hidden?
sheet.column('A').width
```

### Merged Cells

```ruby
sheet.in_merged_cells?('C1') # => true / false
```

### Styles

```ruby
# Font
font = ooxl['Sheet 1'].font('A1')
font.name      # => "Arial"
font.size      # => "8"
font.rgb_color # => "FFE10000"
font.bold?     # => false

# Cell fill
fill = ooxl['Sheet 1'].fill('A1')
fill.pattern_type # => "solid"
fill.fg_color     # => "FFE10000"
fill.bg_color     # => "FFE10000"
```

### Data Validations

```ruby
# All validations on a sheet
validations = ooxl['Sheet 1'].data_validations

# Validation for a specific cell
validation = ooxl['Input Sheet'].data_validation('D4')
validation.type    # => "textLength"
validation.formula # => "20"
validation.prompt  # => "Sample Validation Message"
```

### Comments

```ruby
sheet = ooxl['Sheet 1']
sheet.comment('A1') # => comment text, or nil
```

For full API details, see the [source documentation](https://github.com/salsify/ooxl).

## Development

```bash
# Install dependencies
bin/setup

# Run the test suite
bundle exec rake spec

# Open an interactive console
bin/console
```

CI runs automatically via CircleCI on push and pull requests against `master`, testing Ruby 3.3 and 3.4.

## Status

Tested with Ruby 3.3 and 3.4 on MRI.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/salsify/ooxl. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This gem is available as open source under the terms of the [MIT License](LICENSE.txt).
