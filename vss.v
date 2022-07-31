module main

import os
import cli
import toml
import markdown
import template

const default_config = 'config.toml'

const config_params = ['title']

const default_template = 'layouts/_index.html'

const default_index = 'index.md'

const default_dist = 'dist'

fn main() {
	mut app := cli.Command{
		name: 'vss'
		version: '0.0.3'
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
	mut config_map := map[string]string{}

	// https://modules.vlang.io/toml.html
	config := toml.parse_file(default_config) or { return config_map }

	for param in config_params {
		config_map[param] = config.value(param).string()
	}
	return config_map
}

fn generate_index_page() ? {
	index_md := os.read_file(default_index)?
	contents := markdown.to_html(index_md)
	mut config_map := get_config_map()
	config_map['contents'] = contents

	template_content := os.read_file(default_template)?

	index_html := template.parse(template_content, config_map)

	dist := default_dist

	if !os.exists(dist) {
		os.mkdir_all(dist)? // build/_dist/ のようなPATHが渡されても作成できるようにmkdir_allを使う
	}
	path := os.join_path(dist, 'index.html')
	os.write_file(path, index_html)?
	return
}
