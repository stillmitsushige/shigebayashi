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
			generate_pages()?
		}
	}

	app.setup()
	app.parse(os.args)
}

// get_paths
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

fn get_html_filename(md_path string) string {
	mut file_name := os.file_name(md_path)
	file_name = file_name.replace('.md', '')
	return file_name + '.html'
}

// parse_link convert markdown relative links to html relative links
fn parse_link(contents string) string {
	lines := contents.split_into_lines()
	for line in lines {
		println(line)
	}
}

fn generate_pages() ? {
	dist := default_dist
	if !os.exists(dist) {
		os.mkdir_all(dist)? // build/_dist/ のようなPATHが渡されても作成できるようにmkdir_allを使う
	}

	template_content := os.read_file(default_template)?
	mut config_map := get_config_map()

	md_paths := get_paths('.')
	for path in md_paths {
		md := os.read_file(path)?
		contents := markdown.to_html(md)
		config_map['contents'] = contents
		html := template.parse(template_content, config_map)
		filename := get_html_filename(path)
		html_path := os.join_path(dist, filename)
		os.write_file(html_path, html)?
	}
	return
}
