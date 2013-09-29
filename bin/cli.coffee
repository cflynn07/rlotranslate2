process.bin = process.title = 'rlotranslate'

fs            = require 'fs'
_             = require 'underscore'
argv          = require('optimist').argv
clearTerminal = require '../lib/clearTerminal'
validateUsage = require '../lib/validateUsage'
config        = require '../lib/config'
execSync      = require 'exec-sync'
pwd           = execSync 'pwd'

clearTerminal()

options = _.extend {}, config.optionDefaults

#Will exit if improper usage, mutates optionDefaults
command = validateUsage options, argv

if options.h
  console.log 'help coming soon...'
  process.exit 0

switch command
  when 'generate'
    path = pwd + '/' + options.d

    if !fs.existsSync path
      console.log 'Error: directory does not exist: ' + path
      process.exit 1

    dirContents = fs.readdirSync path
    console.log 'dirContents'
    console.log dirContents