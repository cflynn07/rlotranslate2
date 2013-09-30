csv = require 'csv'
fs  = require 'fs'

module.exports = (path, file) ->

  #filename + path where output will be stored
  fileName               = ''
  resultPath             = ''
  languageObjects        = {}
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
      for value, key in row
        if key is 0 or value is ''
          continue
        languageObjects[value] =
          language: {}
          lexicon:  []
        languageObjectsIndexes[value] = key - 1
      return

    if row[0].indexOf('(4) ') is 0
      mode = 'keys'
      return

    switch mode
      when 'language'

        for prop, value of languageObjectsIndexes
          languageObjects[prop]['language'][row[0]] = row[value+1]

      when 'keys'

        for prop, value of languageObjectsIndexes
          tmp                         = {}
          tmp['key']                  = row[0]
          tmp['lexicalClass']         = row[1]
          tmp['description']          = row[2]
          tmp['additionalProperties'] = row[3]
          tmp['translation']          = row[4 + value]
          languageObjects[prop]['lexicon'].push tmp

  .on 'end', (count) ->
    for property, value of languageObjects
      newFile = resultPath + '/' + fileName.replace('$', property)
      console.log file + ' --> ' + newFile + "\n"
      fs.writeFileSync newFile, JSON.stringify(value, null, 2)


  .on 'error', (error) ->
    console.log 'error'
    console.log error