module config

import os
import prantlf.debug { new_debug }

const d = new_debug('config')

pub fn find_config_file(start_dir string, names []string, depth int, user bool) ?string {
	if config.d.is_enabled() {
		names_str := names.join('"", "')
		dstart_dir := config.d.rwd(start_dir)
		config.d.log_str('look for names "${names_str}" in "${dstart_dir}"')
	}

	mut dir := os.real_path(start_dir)
	for _ in -1 .. depth {
		file := find_file(dir, names)
		if file.len > 0 {
			return normalise_file(file)
		}
		dir = os.join_path_single(dir, '..')
	}

	if user {
		if home_dir := get_home_dir() {
			file := find_file(home_dir, names)
			if file.len > 0 {
				return normalise_file(file)
			}
		}
	}

	config.d.log_str('none of the names found')
	return none
}

pub fn find_user_config_file(names []string) ?string {
	if home_dir := get_home_dir() {
		if config.d.is_enabled() {
			names_str := names.join('"", "')
			dhome_dir := config.d.rwd(home_dir)
			config.d.log_str('look for names "${names_str}" in "${dhome_dir}"')
		}

		file := find_file(home_dir, names)
		if file.len > 0 {
			return normalise_file(file)
		}

		config.d.log_str('none of the names found')
	}

	return none
}

fn normalise_file(path string) string {
	file := os.real_path(path)
	dfile := config.d.rwd(file)
	config.d.log('found "%s"', dfile)
	return file
}

fn find_file(dir string, names []string) string {
	for name in names {
		mut file := os.join_path_single(dir, name)
		mut ddir := config.d.rwd(dir)
		config.d.log('checking if "%s" exists in "%s"', name, ddir)
		if os.exists(file) {
			return file
		}
	}
	return ''
}

fn get_home_dir() ?string {
	var_name := $if windows {
		'USERPROFILE'
	} $else {
		'HOME'
	}
	return if home_dir := os.getenv_opt(var_name) {
		dhome_dir := config.d.rwd(home_dir)
		config.d.log('environment variable "%s" poins to "%s"', var_name, dhome_dir)
		home_dir
	} else {
		config.d.log('environment variable "%s" is empty', var_name)
		none
	}
}
