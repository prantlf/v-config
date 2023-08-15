module config

import os

const wd = os.getwd()

fn test_find_empty() {
	file := find_config_file('src', [], 0, false)
	assert file == none
}

fn test_find_missing_local() {
	file := find_config_file('src', ['v.mod'], 0, false)
	assert file == none
}

fn test_find_missing_home_1() {
	file := find_config_file('.', ['dummy'], 0, true)
	assert file == none
}

fn test_find_missing_home_2() {
	file := find_user_config_file(['dummy'])
	assert file == none
}

fn test_find_local() {
	actual := find_config_file('.', ['v.mod'], 0, false)
	expected := os.join_path_single(config.wd, 'v.mod')
	assert actual? == expected
}

fn test_find_second() {
	actual := find_config_file('.', ['dummy', '.git'], 0, false)
	expected := os.join_path_single(config.wd, '.git')
	assert actual? == expected
}

fn test_find_upwards() {
	actual := find_config_file('src', ['v.mod'], 1, false)
	expected := os.join_path_single(config.wd, 'v.mod')
	assert actual? == expected
}

fn test_find_home_1() {
	dir := find_config_file('.', ['.vmodules'], 0, true)
	assert dir?.len > 0
}

fn test_find_home_2() {
	dir := find_user_config_file(['.vmodules'])
	assert dir?.len > 0
}
