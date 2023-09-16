module config

import os { read_file }
// import toml
import prantlf.ini
import prantlf.jany
import prantlf.json
import prantlf.path { extname }
import prantlf.yaml

pub fn read_config[T](file string) !&T {
	mut cfg := &T{}
	read_config_to[T](file, mut cfg)!
	return cfg
}

pub fn read_config_to[T](file string, mut cfg T) ! {
	d.log('read configuration from "%s"', file)
	ext := extname(file).to_lower()
	match ext {
		'.ini', '.properties' {
			d.log('reading file "%s"', file)
			contents := read_file(file)!
			d.log('unmarshal ini file "%s"', file)
			ini.unmarshal_to[T](contents, mut cfg)!
		}
		'.json' {
			d.log('reading file "%s"', file)
			contents := read_file(file)!
			d.log('unmarshal json file "%s"', file)
			json.unmarshal_to[T](contents, mut cfg, json.UnmarshalOpts{
				ignore_comments: true
				ignore_trailing_commas: true
				allow_single_quotes: true
			})!
		}
		// '.toml' {
		// 	d.log('reading file "%s"', file)
		// 	contents := read_file(file)!
		// 	d.log('unmarshal toml file "%s"', file)
		// 	return toml.decode[T](contents)!
		// }
		'.yml', '.yaml' {
			d.log('unmarshal yaml file "%s"', file)
			yaml.unmarshal_file_to[T](file, mut cfg, jany.UnmarshalOpts{})!
		}
		else {
			return error('unsupported config file extension: "${ext}"')
		}
	}
}
