modules = {
	scaffolding {
		dependsOn 'bootstrap'
		resource url: 'css/scaffolding.css'
	}
        popover {
		dependsOn 'bootstrap'
                resource url: 'js/bootstrap-popover.js', disposition:'head'
        }
}
