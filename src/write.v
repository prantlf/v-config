module config

import os { write_file }
import prantlf.json
import prantlf.path { extname }

pub fn write_config[T](file string, cfg &T) ! {
	d.log('write configuration to "%s"', file)
	ext := extname(file).to_lower()
	match ext {
		'.json' {
			d.log_str('marshal json')
			contents := json.marshal[T](cfg, json.MarshalOpts{
				enums_as_names: true
				pretty: true
			})!
			d.log_str('write file')
			write_file(file, contents)!
		}
		else {
			return error('unsupported config file extension: "${ext}"')
		}
	}
}
