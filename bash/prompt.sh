VIRTUAL_ENV_DISABLE_PROMPT=y

PROMPT_COMMAND=__prompt_command
__prompt_command() {
	local EXIT=$?
	PS1=""

	if [[ $EXIT != 0 ]]; then
		PS1+="$EXIT "
	fi

	PS1+="; "
}

#PS1="; "
