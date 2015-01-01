function check_directory() {
	local dir_name=$1
	local user=$2
	local permission=$3
	local dir_is_valid=1

	if [[ -d ${dir_name} ]]; then
		if [[ $(stat --printf=%G ${dir_name}) == "${user}" ]] && [[ $(stat --printf=%U ${dir_name}) == "${user}" ]] && [[ $(stat --printf=%a ${dir_name}) == "${permission}" ]]; then
			dir_is_valid=0
		fi
	fi

	return ${dir_is_valid}
}

function check_file() {
	local filename=$1
	local user=$2
	local permission=$3
	local file_is_valid=1

	if [[ -f ${filename} ]]; then
		if [[ $(stat --printf=%G ${filename}) == "${user}" ]] && [[ $(stat --printf=%U ${filename}) == "${user}" ]] && [[ $(stat --printf=%a ${filename}) == "${permission}" ]]; then
			file_is_valid=0
		fi
	fi

	return ${file_is_valid}
}