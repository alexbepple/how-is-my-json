var setCssClass = function ($el, cssClass, value) {
	if (value) {
		$el.removeClass(cssClass);
		return;
	}
	$el.addClass(cssClass);
};
module.exports = {
	setCssClass: setCssClass
};
