{makeElement} = Trix
{classNames} = Trix.config.css

class Trix.AttachmentView extends Trix.ObjectView
  @attachmentSelector: "[data-trix-attachment]"

  constructor: ->
    super
    @attachment = @object
    @attachment.uploadProgressDelegate = this
    @attachmentPiece = @options.piece

  createContentNodes: ->
    []

  createNodes: ->
    figure = makeElement({tagName: "figure", className: @getClassName()})

    if @attachment.hasContent()
      figure.innerHTML = @attachment.getContent()
    else
      figure.appendChild(node) for node in @createContentNodes()

    # figure.appendChild(@createCaptionElement())

    data =
      trixAttachment: JSON.stringify(@attachment)
      trixContentType: @attachment.getContentType()
      trixId: @attachment.id

    attributes = @attachmentPiece.getAttributesForAttachment()
    unless attributes.isEmpty()
      data.trixAttributes = JSON.stringify(attributes)

    if @attachment.isPending()
      @progressElement = makeElement
        tagName: "div"
        attributes:
          class: classNames.attachment.progressBar
        data:
          trixMutable: true
          trixStoreKey: @attachment.getCacheKey("progressElement")
      progressBar = makeElement 
        tagName: "div"
        attributes:
          class: "bar"
            
      @progressElement.appendChild(progressBar)

      figure.appendChild(@progressElement)
      data.trixSerialize = false

    if href = @getHref()
      element = makeElement("a", {href})
      element.appendChild(figure)
    else
      element = figure

    element.dataset[key] = value for key, value of data
    element.setAttribute("contenteditable", false)

    [@createCursorTarget(), element, @createCursorTarget()]

  createCaptionElement: ->
    figcaption = makeElement(tagName: "figcaption", className: classNames.attachment.caption)

    if caption = @attachmentPiece.getCaption()
      figcaption.classList.add(classNames.attachment.captionEdited)
      figcaption.textContent = caption
    else
      if filename = @attachment.getFilename()
        figcaption.textContent = filename

        if filesize = @attachment.getFormattedFilesize()
          figcaption.appendChild(document.createTextNode(" "))
          span = makeElement(tagName: "span", className: classNames.attachment.size, textContent: filesize)
          figcaption.appendChild(span)

    figcaption

  getClassName: ->
    names = [classNames.attachment.container, "#{classNames.attachment.typePrefix}#{@attachment.getType()}"]
    if extension = @attachment.getExtension()
      names.push(extension)
    names.join(" ")

  getHref: ->
    unless htmlContainsTagName(@attachment.getContent(), "a")
      @attachment.getHref()

  createCursorTarget: ->
    makeElement
      tagName: "span"
      textContent: Trix.ZERO_WIDTH_SPACE
      data:
        trixCursorTarget: true
        trixSerialize: false

  findProgressBarElement: ->
    @findElement()?.querySelector(".progress .bar")

  # Attachment delegate

  attachmentDidChangeUploadProgress: ->
    value = @attachment.getUploadProgress()
    @findProgressBarElement()?.innerHTML = "#{value}%"

htmlContainsTagName = (html, tagName) ->
  div = makeElement("div")
  div.innerHTML = html ? ""
  div.querySelector(tagName)
