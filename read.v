module config

import os { read_file }
// import toml
import prantlf.debug { new_debug }
import prantlf.ini
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
	d.log('read configuration from "%s"', file)
	ext := extname(file).to_lower()
	match ext {
		'.ini', '.properties' {
			d.log_str('read file')
			contents := read_file(file)!
			d.log_str('unmarshal ini')
			ini.unmarshal_to[T](contents, mut cfg)!
		}
		'.json' {
			d.log_str('read file')
			contents := read_file(file)!
			d.log_str('unmarshal json')
			json.unmarshal_opt_to[T](contents, mut cfg, &json.UnmarshalOpts{
				ignore_comments:        true
				ignore_trailing_commas: true
				allow_single_quotes:    true
			})!
		}
		// '.toml' {
		// 	d.log('reading file "%s"', file)
		// 	contents := read_file(file)!
		// 	d.log('unmarshal toml file "%s"', file)
		// 	return toml.decode[T](contents)!
		// }
		'.yml', '.yaml' {
			d.log_str('unmarshal yaml file')
			yaml.unmarshal_file_to[T](file, mut cfg)!
		}
		else {
			return error('unsupported config file extension: "${ext}"')
		}
	}
}
