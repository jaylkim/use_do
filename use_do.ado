*! version 0.0.0.9000 Jay Kim 27jan2021

/***

_version 0.0.0.9000_

use_do
======

Description
-----------

This command is designed to create a do-file with a specific template.

Syntax
------

> __use_do__ _filename_ [, options]

__filename__ is a name of a do-file you want to create. If it is specified
without a file extension, __.do__ is assumed.

Options
-------

**proj**ect(_str_) : Project title

**aut**hor(_str_) : Author name

**d**epends(_namelist_) : Any packages other than the base Stata

**stata**ver(_integer_) : Which version of Stata will be used? (default: 13)

Author
------

Jay (Jongyeon) Kim

Johns Hopkins University

jay.luke.kim@gmail.com

[https://github.com/jaylkim](https://github.com/jaylkim)

[https://jaylkim.rbind.io](https://jaylkim.rbind.io)

License
-------

MIT License

Copyright (c) 2021 Jongyeon Kim

***/


program define use_do

  syntax anything(name=filename id="A do-file name is") ///
  [,                ///
  PROJect(str)      /// Project name
  AUThor(str)       /// Author name
  Depends(namelist) /// Dependencies other than the base commands
  STATAver(integer 13) /// Stata version your script will run on
  ]

  // Append .do if not provided
  if lower(substr("`filename'", -3, .)) != ".do" {
    local filename = "`filename'" + ".do"
  }

  // If an option is not given, leave it empty
  if missing("`project'") {
    local project = ""
  }
  if missing("`author'") {
    local author = ""
  }
  if missing("`depends'") {
    local depends = ""
  }

  // Check if the file exists
  capture confirm file "`filename'"
  if _rc == 0 {
    local ans = ""
    while "`ans'" != "y" & "`ans'" != "n" {
      disp "`filename' already exists. Replace it? (y/n)?" _request(_ans)
      if "`ans'" == "y" {
        file open mydo using `filename', write replace
        continue, break
      }
      else if "`ans'" == "n" {
        disp as error "Aborted"
        exit 
      }
    }
  }
  else {
    file open mydo using `filename', write
  }

  // Write a template header
  file write mydo ("*" + "=" * 79) _n
  file write mydo ("* Project       : " + "`project'") _n
  file write mydo ("* Author        : " + "`author'")  _n
  file write mydo ("* Version       : ") _n
  file write mydo ("* Date added    : " + c(current_date)) _n
  file write mydo ("* Date modified : ") _n
  file write mydo ("* Depends on    : " + "`depends'") _n
  file write mydo ("*" + "-" * 79) _n
  file write mydo _n
  file write mydo _n

  // Write template code lines
  file write mydo ("clear all") _n
  file write mydo _n

  local logname = regexr("`filename'", ".do$", "")
  file write mydo _n
  file write mydo ("log using " + "`logname'" + ".log, replace text") _n
  file write mydo _n
  file write mydo ("version " + "`stataver'") _n
  file write mydo _n

  file write mydo ("// Import data") _n
  file write mydo ("use , clear") _n
  file write mydo _n
  file write mydo _n
  file write mydo _n

  file write mydo ("log close") _n

  file close mydo

end
