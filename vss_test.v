module main

import os

fn normalise_paths(paths []string) []string {
	mut res := paths.map(it.replace(os.path_separator, '/'))
	res.sort()
	return res
}

fn test_get_html_filename() {
	test_path := 'index.md'
	html_name := get_html_filename(test_path)
	assert html_name == 'index.html'
}
