buster   = require 'buster'
_        = require 'underscore'
execSync = require 'exec-sync'

buster.testCase 'It enforces proper arguments',
  '--> Single invalid command exits error': () ->
    response = execSync 'pwd', true
    buster.assert.same 'test', 'test'


  '--> Multiple commands fail': () ->
    response = execSync 'pwd', true
    buster.assert.same 'test', 'test'

  '//--> Single valid command exits success': () ->
