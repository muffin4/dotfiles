__PS1='; '
PS1=$__PS1

# Allow parameter expansion, command substitution, arithmetic expansion, and quote removal in prompt strings.
shopt -s promptvars

PROMPT_COMMAND=__prompt_command
__prompt_command() {
	local EXIT=$?
	PS1=""

	if [[ $EXIT != 0 ]]; then
		PS1+="$EXIT "
	fi

	# include default
	PS1+=$__PS1
}
