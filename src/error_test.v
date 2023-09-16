module config

struct Test {
mut:
	test int
}

fn test_read_ini() {
	if _ := read_config[Test]('src/testdata/invalid.ini') {
		assert false
	} else {
		assert err.msg() == 'unexpected end encountered when parsing a property name on line 1, column 5'
		assert error_msg_full(err) == 'unexpected end encountered when parsing a property name:
 1 | test
   |     ^'
	}
}
