editorModule "Code", template: "editor_empty"

editorTest "one-line indent", (expectDocument) ->
  typeCharacters "abc\ndef", ->
    clickToolbarButton attribute: "code", ->
      pressKey "tab", ->
        expectBlockAttributes([4, 9], ["code"])
        assertLocationRange({index: 1, offset: 0}, {index: 1, offset: 5}) 
        expectDocument("abc\n  def\n")

editorTest "one-line dedent", (expectDocument) ->
  typeCharacters "abc\n  def", ->
    clickToolbarButton attribute: "code", ->
      pressKeyWithModifier "tab", "shift", ->
        expectBlockAttributes([4, 7], ["code"])
        assertLocationRange({index: 1, offset: 0}, {index: 1, offset: 3})
        expectDocument("abc\ndef\n")

editorTest "multi-line indent", (expectDocument) ->
  typeCharacters "abc\ndef\nghi\njkl\nmno\npqr", ->
    getSelectionManager().setLocationRange([{index: 1, offset: 0}, {index: 4, offset: 3}])
    clickToolbarButton attribute: "code", ->
      getSelectionManager().setLocationRange([{index: 1, offset: 4}, {index: 1, offset: 11}])
      pressKey "tab", ->
        expectBlockAttributes([4, 23], ["code"])
        assertLocationRange({index: 1, offset: 4}, {index: 1, offset: 15}) 
        expectDocument("abc\ndef\n  ghi\n  jkl\nmno\npqr\n")

editorTest "multi-line dedent", (expectDocument) ->
  typeCharacters "abc\ndef\n  ghi\n  jkl\nmno\npqr", ->
    getSelectionManager().setLocationRange([{index: 1, offset: 0}, {index: 4, offset: 3}])
    clickToolbarButton attribute: "code", ->
      getSelectionManager().setLocationRange([{index: 1, offset: 4}, {index: 1, offset: 15}])
      pressKeyWithModifier "tab", "shift", ->
        expectBlockAttributes([4, 19], ["code"])
        assertLocationRange({index: 1, offset: 4}, {index: 1, offset: 11}) 
        expectDocument("abc\ndef\nghi\njkl\nmno\npqr\n")

editorTest "multi-line indent with overhighlight", (expectDocument) ->
  typeCharacters "abc\ndef\nghi\njkl\nmno\npqr", ->
    getSelectionManager().setLocationRange([{index: 1, offset: 0}, {index: 4, offset: 3}])
    clickToolbarButton attribute: "code", ->
      getSelectionManager().setLocationRange([{index: 0, offset: 0}, {index: 2, offset: 3}])
      pressKey "tab", ->
        expectBlockAttributes([4, 27], ["code"])
        assertLocationRange({index: 1, offset: 0}, {index: 1, offset: 23}) 
        expectDocument("abc\n  def\n  ghi\n  jkl\n  mno\npqr\n")

editorTest "multi-line dedent with overhighlight", (expectDocument) ->
  typeCharacters "abc\n  def\n  ghi\n  jkl\n  mno\npqr", ->
    getSelectionManager().setLocationRange([{index: 1, offset: 0}, {index: 4, offset: 5}])
    clickToolbarButton attribute: "code", ->
      getSelectionManager().setLocationRange([{index: 0, offset: 0}, {index: 2, offset: 3}])
      pressKeyWithModifier "tab", "shift", ->
        expectBlockAttributes([4, 19], ["code"])
        assertLocationRange({index: 1, offset: 0}, {index: 1, offset: 15}) 
        expectDocument("abc\ndef\nghi\njkl\nmno\npqr\n")

