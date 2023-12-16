module config

import os { read_file }
// import toml
import prantlf.debug { new_debug }
import prantlf.ini
import prantlf.jany
import prantlf.json
import prantlf.path { extname }
import prantlf.yaml

const d = new_debug('config')

pub fn read_config[T](file string) !&T {
	mut cfg := &T{}
	read_config_to[T](file, mut cfg)!
	return cfg
}

pub fn read_config_to[T](file string, mut cfg T) ! {
	config.d.log('read configuration from "%s"', file)
	ext := extname(file).to_lower()
	match ext {
		'.ini', '.properties' {
			config.d.log_str('read file')
			contents := read_file(file)!
			config.d.log_str('unmarshal ini')
			ini.unmarshal_to[T](contents, mut cfg)!
		}
		'.json' {
			config.d.log_str('read file')
			contents := read_file(file)!
			config.d.log_str('unmarshal json')
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
			config.d.log_str('unmarshal yaml file')
			yaml.unmarshal_file_to[T](file, mut cfg, jany.UnmarshalOpts{})!
		}
		else {
			return error('unsupported config file extension: "${ext}"')
		}
	}
}
