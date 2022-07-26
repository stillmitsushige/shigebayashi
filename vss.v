module main

import os
import cli
import markdown

const markdown_text = "
# Open Sea

A static site generator

- [GitHub](https://github.com/zztkm)
"

fn main() {
	mut app := cli.Command{
		name: 'vss'
		version: '0.0.0'
		description: 'static site generator'
		execute: fn (cmd cli.Command) ? {
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
			os.write_file('index.html', index_html) ?
			return
		}
	}

	app.setup()
	app.parse(os.args)
}

fn get_paths(path string) []string {
	mds := os.walk_ext(path, '.md')
	return mds
}
