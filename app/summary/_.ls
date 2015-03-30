require! {
    util
    crel
}

Summary = ->
    clear = -> $('.summary').hide()

    validationErrorsSummary = $('.summary.errors')
    validationErrors = validationErrorsSummary.find 'ul'
    appendValidationErrorInfo = (value, template, cssClass) ->
        if value > 0
            validationErrors.append crel(
                'li', class:cssClass,
                    util.format(template, value),
                    crel 'span', class:'separator', ' / '
            )

    showValid: ->
        clear()
        $('.summary.valid').show()

    showError: (message) ->
        clear()
        $error = $('.summary.error')
        $error.show()
        $error.find('.message').text message

    showInvalid: ({wrong, missing, additional}) ->
        clear()
        validationErrors.children().remove()

        appendValidationErrorInfo wrong, '%s wrong', 'validation-wrong-type'
        appendValidationErrorInfo missing, '%s missing', 'validation-missing'
        appendValidationErrorInfo additional, '%s additional', 'validation-additional'

        validationErrors.find('.separator').last().remove()
        validationErrorsSummary.show()

module.exports =
    Summary
