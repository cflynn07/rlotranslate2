config =
  availableCommands: [
    'generate'
    'reverse'
  ]
  optionDefaults:
    d: 'i18n_csv'
    h: false
  messages:
    badUsageFormat: 'Format: ' + process.title + ' [generate/reverse] -d [options]' + "\n"

module.exports = config