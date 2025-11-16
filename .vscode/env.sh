#!/usr/bin/env bash
# Retrieve environment config from 1Password

__usage() {
	echo -e "env <1password subdomain> <secret_name> <vault>" && exit 1
}

__missing_reqs() {
	for i in "$@"; do
		[[ "$0" != "$i" ]] && [[ "$(type $i 2> /dev/null)" == '' ]] && echo "$i is required to perform this function." && return 0;
	done; return 1
}

__populate_1pass() {
	__missing_reqs op jq && return 1
	op item get "$1" --fields type=concealed --vault "$VAULT" --format=json | jq -r '.[] | {(.label) : .value}' | tr -d \{ | tr -d \} | grep -v -e '^$' | sed 's#\ *\"\(.*\)\":\ \"\(.*\)\"$#declare -x \1=\"\2\"#'
}

[ -z "$2" ] && __usage
PROJECT="$2"
export VAULT=${3:-Personal}
OPASS_ACCOUNT_PREFIX="$1"
op account get 2>/dev/null || eval $(op signin --account https://"$OPASS_ACCOUNT_PREFIX".1password.com)
__populate_1pass "$PROJECT" > .env
exit $?
