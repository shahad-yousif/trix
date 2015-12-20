Trix.config.blockAttributes = attributes =
  default:
    tagName: "div"
    parse: false
  figure:
    tagName: "figure"
    parse: false
  quote:
    tagName: "blockquote"
    nestable: true
  code:
    tagName: "pre"
    indentWithTab: true
    text:
      plaintext: true
  bulletList:
    tagName: "ul"
    parse: false
  bullet:
    tagName: "li"
    listAttribute: "bulletList"
    test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
  numberList:
    tagName: "ol"
    parse: false
  number:
    tagName: "li"
    listAttribute: "numberList"
    test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
