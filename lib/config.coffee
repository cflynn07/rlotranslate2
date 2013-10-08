format = 'Format: rlotranslate [generate/reverse] [options]' + "\n"

config =
  availableCommands: [
    'generate'
    'reverse'
  ]
  optionDefaults:
    d:             'i18n_masters'
    h:             false
    v:             false
    input:         false
    output:        false
    inputLangName: false
  messages:
    badUsageFormat: format
    help: format + "\n
      [options]\n
      -h    help\n
      -v    version\n
      -d    directory of i18n_master files\n"

module.exports = config