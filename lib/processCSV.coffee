csv = require 'csv'
fs  = require 'fs'
_   = require 'underscore'

module.exports = (path, file) ->

  #filename + path where output will be stored
  fileName               = ''
  resultPath             = ''
  languageObjects        = {}

  # {en: 0,
  #  fr: 1,
  #  de: 2 ...}
  languageObjectsIndexes = {}

  mode                   = ''

  csv()
  .from.path(path + '/' + file, {delimiter: ',', escape: '"'})
  .transform (row) ->
    return row
  .on 'record', (row, index) ->

    if row[0] == ''
      return

    if row[0].indexOf('(1) ') is 0
      fileName = row[1]

    if row[0].indexOf('(2) ') is 0
      resultPath = row[1]

    if row[0].indexOf('(3) ') is 0
      mode = 'language'
      for valLanguageCode, i in row
        if i is 0 or valLanguageCode is ''
          continue

        languageObjects[valLanguageCode] =
          language: {}
          lexicon:
            language: 'default'
            country:  null
            entries:  []
        languageObjectsIndexes[valLanguageCode] = i - 1
      return

    if row[0].indexOf('(4) ') is 0
      mode = 'keys'
      return

    if row[0].indexOf('(5) ') is 0
      mode = 'specialkeys'
      return

    switch mode
      when 'language'
        for propLanguageCode, i of languageObjectsIndexes
          languageObjects[propLanguageCode]['language'][row[0]] = row[i+1]

      when 'keys'
        for propLanguageCode, i of languageObjectsIndexes
          tmp                         = {}
          tmp['key']                  = row[0]
          tmp['lexicalClass']         = row[1]
          tmp['description']          = row[2]
          tmp['additionalProperties'] = row[3]
          tmp['translation']          = row[4 + i]
          languageObjects[propLanguageCode]['lexicon']['entries'].push tmp

      when 'specialkeys'

        specialKeyRowParts = row[0].split '_'

        for propLanguageCode, langCodeIndex of languageObjectsIndexes
          if _.isUndefined languageObjects[propLanguageCode][specialKeyRowParts[0]]
            languageObjects[propLanguageCode][specialKeyRowParts[0]] = {}
            languageObjects[propLanguageCode][specialKeyRowParts[0]][specialKeyRowParts[1]] = row[langCodeIndex + 1]

          else
            if _.isUndefined languageObjects[propLanguageCode][specialKeyRowParts[0]][specialKeyRowParts[1]]
              languageObjects[propLanguageCode][specialKeyRowParts[0]][specialKeyRowParts[1]] = row[langCodeIndex + 1]
            else if _.isString languageObjects[propLanguageCode][specialKeyRowParts[0]][specialKeyRowParts[1]]
              languageObjects[propLanguageCode][specialKeyRowParts[0]][specialKeyRowParts[1]] = [
                languageObjects[propLanguageCode][specialKeyRowParts[0]][specialKeyRowParts[1]]
                row[langCodeIndex + 1]
              ]
            else if _.isArray languageObjects[propLanguageCode][specialKeyRowParts[0]][specialKeyRowParts[1]]
              languageObjects[propLanguageCode][specialKeyRowParts[0]][specialKeyRowParts[1]].push row[langCodeIndex + 1]


  .on 'end', (count) ->
    for property, value of languageObjects
      newFile = resultPath + '/' + fileName.replace('$', property)
      console.log file + ' --> ' + newFile + "\n"
      fs.writeFileSync newFile, JSON.stringify(value, null, 2)


  .on 'error', (error) ->
    console.log 'error'
    console.log error