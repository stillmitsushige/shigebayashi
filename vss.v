module main

import os
import cli

import markdown

fn main() {
	mut app := cli.Command {
		name: "vss"
		version: "0.0.0"
		description: "static site generator"
		execute: fn (cmd cli.Command) ? {
			return
		}
	}

    text := '# Markdown Rocks!'
    output := markdown.to_html(text)
    println(output) // <h1>Markdown Rocks!</h1>
}

// work の検証をやる
https://modules.vlang.io/os.html#walk