module main

import os
import cli
import toml
import markdown

const default_config = 'config.toml'

const default_index = 'index.md'

const default_dist = 'dist'

fn main() {
	mut app := cli.Command{
		name: 'vss'
		version: '0.0.2'
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

fn get_config_map() map[string]string {
	mut confg_map := map[string]string{}

	// https://modules.vlang.io/toml.html
	config := toml.parse_file(default_config)?
}

fn generate_index_page() ? {
	index_md := os.read_file(default_index)?

	// for $tmpl value
	title := config.value('title').string()
	contents := markdown.to_html(index_md)

	// tmpl に変数を割り当てるのは今の所無理
	// https://github.com/vlang/v/discussions/15068
	index_html := $tmpl('layouts/_index.html')
	dist := default_dist

	if !os.exists(dist) {
		os.mkdir_all(dist)? // build/_dist/ のようなPATHが渡されても作成できるようにmkdir_allを使う
	}
	path := os.join_path(dist, 'index.html')
	os.write_file(path, index_html)?
	return
}
