require! {
    util
    crel
}

Summary = ->
    clearSummary = -> $('.summary').hide()

    errorsSummary = $('.summary.errors')
    errors = errorsSummary.children 'ul'

    appendErrorInfo = (value, template, cssClass) ->
        if value > 0
            errors.append crel(
                'li', class:cssClass,
                    util.format(template, value),
                    crel 'span', class:'separator', ' / '
            )

    showValid: ->
        clearSummary()
        $('.summary.valid').show()

    showError: (message) ->
        clearSummary()
        $('.summary.error').show()
        $('.summary.error .message').text message

    showInvalid: ({wrong, missing, additional}) ->
        clearSummary()
        errors.children().remove()

        appendErrorInfo wrong, '%s wrong', 'validation-wrong-type'
        appendErrorInfo missing, '%s missing', 'validation-missing'
        appendErrorInfo additional, '%s additional', 'validation-additional'

        errors.find('.separator').last().remove()
        errorsSummary.show()

module.exports =
    Summary
