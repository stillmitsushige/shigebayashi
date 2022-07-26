module main

import os
import cli
import markdown

const markdown_text = '
# Open Sea

A static site generator

- [GitHub](https://github.com/zztkm)
'

const default_dist = 'dist'

fn main() {
	mut app := cli.Command{
		name: 'vss'
		version: '0.0.0'
		description: 'static site generator'
		execute: fn (cmd cli.Command) ? {
			generate_index_page()?
		}
	}

	app.setup()
	app.parse(os.args)
}

fn get_paths(path string) []string {
	mds := os.walk_ext(path, '.md')
	return mds
}

fn generate_index_page() ? {
	paths := get_paths('testfiles')
	if paths.len == 0 {
		println('Cloud not retrieve path')
		return
	}
	for path in paths {
		println(path)
	}

	// index_html := $embed_file("layouts/_index.html")
	title := 'tsurutatakumi.info'
	contents := markdown.to_html(markdown_text)

	index_html := $tmpl('layouts/_index.html')
	dist := default_dist

	if !os.exists(dist) {
		os.mkdir_all(dist, ) // build/_dist/ のようなPATHが渡されても作成できるようにmkdir_allを使う
	}
	path := os.join_path(dist, 'index.html')
	os.write_file(path, index_html)?
	return
}
