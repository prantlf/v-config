module config

import os
// import toml
import prantlf.jany { UnmarshalOpts }
import prantlf.json { unmarshal }
import prantlf.path { extname }
import prantlf.yaml { unmarshal_file }

pub fn read_config[T](file string) !&T {
	d.log('read configuration from "%s"', file)
	ext := extname(file).to_lower()
	match ext {
		'.json' {
			d.log('reading file "%s"', file)
			contents := os.read_file(file)!
			d.log('unmarshal json file "%s"', file)
			cfg := unmarshal[T](contents, json.UnmarshalOpts{
				ignore_comments: true
				ignore_trailing_commas: true
				allow_single_quotes: true
			})!
			return &cfg
		}
		// '.toml' {
		// 	d.log('reading file "%s"', file)
		// 	contents := os.read_file(file)!
		// 	d.log('unmarshal toml file "%s"', file)
		// 	return toml.decode[T](contents)!
		// }
		'.yml', '.yaml' {
			d.log('unmarshal yaml file "%s"', file)
			cfg := unmarshal_file[T](file, UnmarshalOpts{})!
			return &cfg
		}
		else {
			return error('unsupported config file extension: "${ext}"')
		}
	}
}
