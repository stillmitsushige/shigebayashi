module commands

import os
import cli
import log
import time
import regex
import markdown
import internal.template
import internal.config

const default_config = 'config.toml'

const default_template = 'layouts/index.html'

const defautl_static = 'static'

const default_index = 'index.md'

const default_dist = 'dist'

fn new_build_cmd() cli.Command {
	return cli.Command{
		name: 'build'
		description: 'build your site'
		usage: 'vss build'
		execute: fn (cmd cli.Command) ? {
			mut logger := log.Log{}
			logger.set_level(log.Level.info)
			build(mut logger) or {
				logger.error(err.msg())
				println('Build failed')
			}
		}
	}
}

fn read_file(filename string) ?string {
	contents := os.read_file(filename.trim_space())?
	return contents
}

fn get_html_path(md_path string) string {
	mut file_name := os.file_name(md_path)
	file_name = file_name.replace('.md', '.html')
	dir := os.dir(md_path)
	if dir == '.' {
		return file_name
	}

	return os.join_path(dir, file_name)
}

fn normalise_paths(paths []string) []string {
	cwd := os.getwd() + os.path_separator
	mut res := paths.map(os.abs_path(it).replace(cwd, '').replace(os.path_separator, '/'))
	res.sort()
	return res
}

// pre_proc_md_to_html convert markdown relative links to html relative links
fn pre_proc_md_to_html(contents string) ?string {
	lines := contents.split_into_lines()
	mut parsed_lines := []string{len: lines.len}
	mut re := regex.regex_opt(r'\[.+\]\(.+\.md\)')?

	for i, line in contents.split_into_lines() {
		start, end := re.find(line)
		if start >= 0 && end > start {
			parsed_lines[i] = line.replace('.md', '.html')
		} else {
			parsed_lines[i] = line
		}
	}
	return parsed_lines.join('\n')
}

fn build(mut logger log.Log) ? {
	println('Start building')
	mut sw := time.new_stopwatch()

	dist := commands.default_dist
	if os.exists(dist) {
		logger.info('re-create dist dir')
		os.rmdir_all(dist)?
		os.mkdir_all(dist)?
	} else {
		logger.info('create dist dir')
		os.mkdir_all(dist)?
	}

	// copy static files
	if os.exists(commands.defautl_static) {
		logger.info('copy static files')
		os.cp_all(commands.defautl_static, dist, false)?
	}

	template_content := os.read_file(commands.default_template)?

	toml_text := read_file(commands.default_config)?
	config := config.load(toml_text)?
	mut config_map := config.as_map()

	md_paths := normalise_paths(os.walk_ext('.', '.md'))
	logger.info('start md to html')
	for path in md_paths {
		file_name := os.file_name(path)
		if file_name in config.build.ignore_files {
			logger.info('$file_name is included in ignore_files, skip build')
			continue
		}
		mut md := os.read_file(path)?
		md = pre_proc_md_to_html(md)?
		contents := markdown.to_html(md)
		config_map['contents'] = contents
		html := template.parse(template_content, config_map)
		html_path := get_html_path(path)
		dist_path := os.join_path(dist, html_path)
		if !os.exists(os.dir(dist_path)) {
			os.mkdir_all(os.dir(dist_path))?
		}
		os.write_file(dist_path, html)?
	}
	logger.info('end md to html')

	sw.stop()
	println('Total in ' + sw.elapsed().milliseconds().str() + ' ms')
	return
}
