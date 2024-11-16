module config

import os { exists, mkdir, read_file, rm }

struct Test {
	test int = 42
}

const outdir = 'src/testout'

fn testsuite_begin() {
	if !exists(outdir) {
		mkdir(outdir)!
	}
}

fn test_write_ini() {
	file := '${outdir}/config.ini'
	if exists(file) {
		rm(file)!
	}
	write_config(file, Test{})!
	contents := read_file(file)!
	assert contents == 'test = 42
'
}

fn test_write_json() {
	file := '${outdir}/config.json'
	if exists(file) {
		rm(file)!
	}
	write_config(file, Test{})!
	contents := read_file(file)!
	assert contents == '{
  "test": 42
}'
}
