module main

import os
import cli
import toml
import regex
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
		version: '0.0.4'
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

// pre_proc_md_to_html convert markdown relative links to html relative links
fn pre_proc_md_to_html(contents string) string {
	lines := contents.split_into_lines()
	mut parsed_lines := []string{len: lines.len}
	for i, line in contents.split_into_lines() {
		mut re := regex.regex_opt(r'\[.+\]\(.+\.md\)') or {
			eprintln('error: $err')
			continue
		}

		start, end := re.find(line)
		if start >= 0 && end > start {
			parsed_lines[i] = line.replace('.md', '.html')
		} else {
			parsed_lines[i] = line
		}
	}
	return parsed_lines.join('\n')
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
		mut md := os.read_file(path)?
		md = pre_proc_md_to_html(md)
		contents := markdown.to_html(md)
		config_map['contents'] = contents
		html := template.parse(template_content, config_map)
		filename := get_html_filename(path)
		html_path := os.join_path(dist, filename)
		os.write_file(html_path, html)?
	}
	return
}
