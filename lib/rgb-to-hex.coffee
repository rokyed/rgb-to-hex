RgbToHexView = require './rgb-to-hex-view'
{CompositeDisposable} = require 'atom'

module.exports = RgbToHex =
    subscriptions: null

    activate: ->
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.commands.add 'atom-workspace',
            'rgb-to-hex:toggle': => @convert()

    deactivate: ->
        @subscriptions.dispose()

    convert: ->
        if editor = atom.workspace.getActiveTextEditor()
             if selectedText = editor.getSelectedText()
                 patternString = ///(rgba*\s*\()*\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{0,3})\s*((\d{0,3})\s*)*\)*(\;*)///i
                 if rgb = selectedText.match patternString
                        editor.delete()
                        editor.insertText(this.rgb2hex(selectedText))

    rgb2hex: (rgb) ->
         semis = '';

         if rgb.indexOf(';') != -1
             semis = ';'
         rgb = rgb.replace('rgb', '')
         rgb = rgb.replace('a', '')
         rgb = rgb.replace('(', '')
         rgb = rgb.replace(')', '')
         rgb = rgb.replace(///\s*///g, '')
         rgb = rgb.replace(';', '')

         rgbarr = rgb.split(',')

         return "#" + this.componentToHex(rgbarr[0]) + this.componentToHex(rgbarr[1]) + this.componentToHex(rgbarr[2]) + semis

    componentToHex: (c) ->
        c = new Number(c)
        hex = c.toString(16)

        if hex.length > 1
            return hex
        else
            return "0" + hex
