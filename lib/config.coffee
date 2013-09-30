config =
  availableCommands: [
    'generate'
    'reverse'
  ]
  optionDefaults:
    d: 'i18n_masters'
    h: false
    v: false
  messages:
    badUsageFormat: 'Format: ' + process.title + ' [generate/reverse] -d [options]' + "\n"

module.exports = config