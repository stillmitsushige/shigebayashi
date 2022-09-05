module commands

import os

fn test_get_html_filename() {
	test_path := 'index.md'
	mut html_name := get_html_path(test_path)
	assert html_name == 'index.html'

	test_path_2 := './post/example-post.md'
	html_name = get_html_path(test_path_2)
	$if windows {
		assert html_name == '.\\post\\example-post.html'
	} $else {
		assert html_name == './post/example-post.html'
	}
}
