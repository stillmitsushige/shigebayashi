module config

const toml_text = '# for test
title = "test site"
description = "test page"
base_url = "https://vss.github.io/vss/"

[build]
ignore_files = ["ignore.md", "README.md"]
'

fn test_load() {
	config := load(config.toml_text) or {
		eprintln(err)
		return
	}

	assert config.title == 'test site'
	assert config.description == 'test page'
	assert config.base_url == 'https://vss.github.io/vss/'
	assert config.build.ignore_files == ['ignore.md', 'README.md']
}
