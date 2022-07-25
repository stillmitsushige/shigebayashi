module main

import os


fn normalise_paths(paths []string) []string {
	mut res := paths.map(it.replace(os.path_separator, '/'))
	res.sort()
	return res
}

fn test_get_paths() {
	testpath := "testfiles"
	mds := normalise_paths(get_paths(testpath))
	assert mds.len == 2
	assert mds == [
		"testfiles/aaa.md",
		"testfiles/bbb.md",
	]	
}