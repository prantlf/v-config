module config

// import toml

struct Test {
mut:
	test int
}

const datadir = 'src/testdata'

fn test_read_ini() {
	test := read_config[Test]('${config.datadir}/config.ini')!
	assert test.test == 42
}

// pub fn (mut t Test) from_toml(any toml.Any) {
// 	mp := any.as_map()
// 	t.test = (mp['test'] or { '0' }).int()
// }

fn test_read_json() {
	test := read_config[Test]('${config.datadir}/config.json')!
	assert test.test == 42
}

// fn test_read_toml() {
// 	test := read_config[Test]('${datadir}/config.toml')!
// 	assert test.test == 42
// }

fn test_read_yml() {
	test := read_config[Test]('${config.datadir}/config.yml')!
	assert test.test == 42
}

fn test_read_yaml() {
	test := read_config[Test]('${config.datadir}/config.yaml')!
	assert test.test == 42
}
