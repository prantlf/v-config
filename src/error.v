module config

import prantlf.ini { ParseError }
import prantlf.json { JsonError }

pub fn error_msg_full(err IError) string {
	return match err {
		ParseError {
			err.msg_full()
		}
		JsonError {
			err.msg_full()
		}
		else {
			err.msg()
		}
	}
}
