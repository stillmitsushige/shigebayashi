module main

import os

fn normalise_paths(paths []string) []string {
	mut res := paths.map(it.replace(os.path_separator, '/'))
	res.sort()
	return res
}
