#!/usr/bin/env bash

##########################################
# SCRIPT: postgres_backup.bash [!CURRENTLY DRAFTING - WIP]
#
# AUTHOR: MunKeat
#
# DATE: 10-JUN-2016
#
# PURPOSE: Backup PostgreSQL database
##########################################

##########################################
# FILES AND VARIABLE DEFINITION(S)
##########################################
# Parameters for database backup
database_name=""
database_user=""
database_host=""

# Frequency of backup. Array will store (frequency, time of backup)
# 	frequency: [daily, weekly, bi-weekly] - refer to 'frequency_option'
# 	time of backup: in 24hr format
#	e.g. backup_frequency=(weekly, 13:20)
declare -a backup_frequency

dump_file_prefix=""
dump_file_root_dir=""
log_file=""
# Email(s) to send dump file. Use ; to separate email addresses
user_email=""

# PID of current script (set as immutable constant)
declare -r backup_pid="${$}"
# Result of processing user_email
declare -a user_email_array
# Frequency list
frequency_option=("daily" "weekly" "bi-weekly")

# Formatting
date_format="%Y-%m-%dT%H:%M"
line_break="--------------------------------------------------"

# Prompts and warnings
msg_local_backup="No email was entered. Backup will be stored locally."
prompt_database_name="Enter name of database to be backed up: "
prompt_dump_file_naming="Enter dump file prefix: "
prompt_send_to_background="Setup is complete. Use the command to send this process to background: \n\t1. Ctrl-Z \n\t2. bg \n\t3. disown -h [job-spec] \n\n\t** Hint: Use 'jobs' to find this script's [job-spec]\n${line_break}\n"
prompt_user_email="Enter email(s) to send the dump file to: "
warning_invalid_email="WARNING: Email appears to be invalid."
warning_not_bash_shell="This script has detected that bash is not used, which may lead to improper backup. Continue? (y/n) "

##########################################
# FUNCTION DEFINITION(S)
##########################################

# Check if bash is used currently
function check_shell() {
	echo "${SHELL}" | grep -q "*/?bash/?*"
	if	[ "$?" -ne 1 ]; then
		while : ; do
			read -p "${warning_not_bash_shell}" continue_without_bash		
			case "${continue_without_bash}" in
				[yY][eE][sS]|[yY])
					# Break out of current loop
					break
					;;
				[nN][oO]|[nN])
					# Exit with a non-zero status
					exit 1
					;;
				*)	
					;;
			esac
		done
	fi
}

function database_backup() {
	local current_time_pretty="$(date +%c)"
	local current_time="$(date +$date_format)"
	local current_db_dump="${dump_file_prefix}_${current_time}.sql"
	local rotate_pid
	local pg_dump_status

	pg_dump -d "${database_name}" >> "${current_db_dump}" 2>&1
	# Get exit status of pg_dump
	pg_dump_status=$?

	if [[ "${pg_dump_status}" -ne 0 ]]; then
		echo Hi
		## TODO Send email to users stating the error
	fi
}

function database_backup_job() {
	# Aim for the nearest time specified
	local current_date=""
	local current_epoch=$(date +%s)
	local tentative_target_epoch=$(date -d "${current_date}" "${backup_frequency[1]}" +%s)
	local fallback_target_epoch

	local sleep_seconds=$(( $target_epoch - $current_epoch ))

	sleep "${sleep_seconds}"

	database_backup

	# Start sleep cycle
	while : ;do
		sleep 1
		database_backup
	done
}

function initialize() {
	check_shell
	
	# Examine flags and arguments passed
	while getopts "b:d:e:f:hu:" opts; do
		case "${opts}" in
			b) # Set prefix for the dump file
				dump_file_prefix="${OPTSARG}"
				;;
			d) # Set database name
				database_name="${OPTSARG}"
				;;
			e) # Set email(s) to send dump file to
				user_email=${OPTSARG}
				
				if ! [[ "${user_email}" =~ .*@.* ]];then
					echo "${warning_invalid_email}"
					user_email=""
				fi
				;;
			f) # Set frequency of backup
				;;
			h) # Print help string				
				exit 0
				;;
			u) # Set database user
				database_user=${OPTSARG}
				;;
		esac
	done

	echo

	# Set up variables if any is missing
	if [[ "${database_name}" == "" ]]; then
		read -p "${prompt_database_name}" database_name
		echo "${line_break}"
		database_name="${database_name:="all"}"
	fi

	if [[ "${dump_file_prefix}" == "" ]]; then
		read -p "${prompt_dump_file_naming}" dump_file_prefix
		echo "${line_break}"
		dump_file_prefix="${dump_file_prefix:=${database_name}}"
	fi

	if [[ "${user_email}" == "" ]]; then
		echo "Emails can be separated using the ; character. Example: "
		echo "	abbey@gmail.com;grace@hotmail.com"

		while : ; do
			echo
			read -p "${prompt_user_email}" user_email
	
			# If no email is set, assume user only wants local backup
			if [[ "${user_email}" == "" ]]; then
				echo "${msg_local_backup}"
				break
			# If email validates Regex, begin processing email(s) into array
			elif [[ "${user_email}" =~ .*@.* ]];then
				IFS=';' read -ra user_email_array <<< "${user_email}"
				break
			# If email is set improperly, assume user wants backup to be mailed and prompt again
			elif ! [[ "${user_email}" =~ .*@.* ]];then
				echo "${warning_invalid_email}"
			fi
		done

		echo "${line_break}"
	fi

	# Select backup frequency
	if [[ "${backup_frequency[0]}" -eq "" || "${backup_frequency[1]}" -eq "" ]]; then
		select frequency_selected in "${frequency_option[@]}"; do
			case "${frequency_selected}" in
				"${frequency_option[0]}" | "${frequency_option[1]}" | "${frequency_option[2]}")
					backup_frequency[0]="${frequency_selected}"
					break
					;;
			esac
		done

		echo

		while ! [[ "${backup_frequency[1]}" =~ ^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$ ]]; do
			read -p "Enter the time (in 24 hour format, e.g. 2:30) for backup to commence: " backup_frequency[1]
		done

		echo "${line_break}"
	fi

	printf "${prompt_send_to_background}"
}

function rotate_line() {
	local interval=1
	local line_index=0
	local line=(/ - \\ \| / - \\ \| )

	while : ;do
		line_index=$(( (line_index + 1) % ${#line[@]} ))
		printf "\r${line[${line_index}]}"
		
		sleep "${interval}"
	done
}

##########################################
# MAIN BODY
##########################################
function main() {
	initialize "$@"
	# database_backup
}

main "$@"
