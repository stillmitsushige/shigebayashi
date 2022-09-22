module config

import toml

// Build settings for build
struct Build {
pub mut:
	ignore_files []string
}

struct Config {
pub mut:
	build       Build
	title       string
	description string
	base_url    string
}

// load 
pub fn load(toml_text string) ?Config {
	doc := toml.parse_text(toml_text)?

	mut config := doc.reflect<Config>()
	config.build = doc.value('build').reflect<Build>()

	return config
}

// as_map for template.parse
pub fn (c Config) as_map() ?map[string]string {

}