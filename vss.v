module main

import os
import cli
import markdown

fn main() {
	mut app := cli.Command{
		name: 'vss'
		version: '0.0.0'
		description: 'static site generator'
		execute: fn (cmd cli.Command) ? {
			paths := get_paths("docs")
			for path in paths {
				println(path)
			}
			return
		}
	}

	text := '# Markdown Rocks!'
	output := markdown.to_html(text)
	println(output) // <h1>Markdown Rocks!</h1>

	app.setup()
	app.parse(os.args)
}

fn get_paths(path string) []string {
	mds := os.walk_ext(path, '.md')
	return mds
}
