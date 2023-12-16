module config

import os { home_dir, join_path_single }
import prantlf.osutil { exist_in, find_files_opt }

const exts = [
	'.ini',
	'.properties',
	'.json',
	'.yml',
	'.yaml',
]!

pub fn find_config_file_any(start_dir string, name string, depth int, user bool) ?string {
	names := get_all_names(name)
	return find_config_file(start_dir, names, depth, user)
}

pub fn find_config_file(start_dir string, names []string, depth int, user bool) ?string {
	return if dir, name := find_files_opt(names, start_dir, depth) {
		join_path_single(dir, name)
	} else {
		if user {
			home := home_dir()
			if name := exist_in(names, home) {
				join_path_single(home, name)
			} else {
				none
			}
		} else {
			none
		}
	}
}

pub fn find_user_config_file_any(name string) ?string {
	names := get_all_names(name)
	return find_user_config_file(names)
}

pub fn find_user_config_file(names []string) ?string {
	home := home_dir()
	return if name := exist_in(names, home) {
		join_path_single(home, name)
	} else {
		none
	}
}

fn get_all_names(name string) []string {
	mut names := []string{len: config.exts.len}
	for i in 0 .. config.exts.len {
		names[i] = '${name}${config.exts[i]}'
	}
	return names
}
