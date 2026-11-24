
# ------------------------------------------------------------------------
# Custom function to see user password status in colorized tabular format
# Usage: passtab [username]  (defaults to all regular users if omitted)
# ------------------------------------------------------------------------
passtab() {
  local target_user="$1"

  # Define ANSI color codes
  local BOLD='\033[1m'
  local DIM='\033[2m'
  local GREEN='\033[0;32m'
  local RED='\033[0;31m'
  local YELLOW='\033[0;33m'
  local CYAN='\033[0;36m'
  local RESET='\033[0m'

  # Determine which users to check
  local users=()
  if [[ -n "$target_user" ]]; then
    users=("$target_user")
  else
    # Fetch regular users (UID >= 1000, excluding 'nobody')
    while IFS=: read -r uname _ uid _; do
      if [[ "$uid" -ge 1000 && "$uname" != "nobody" ]]; then
        users+=("$uname")
      fi
    done < /etc/passwd
  fi

  # Build and format the table
  {
    printf "${BOLD}${CYAN}USERNAME STATUS LAST_CHANGED MIN_DAYS MAX_DAYS WARN_DAYS INACTIVE_DAYS${RESET}\n"
    for u in "${users[@]}"; do
      passwd --status "$u" 2>/dev/null
    done | awk -v g="$GREEN" -v r="$RED" -v y="$YELLOW" -v rst="$RESET" '{
      if ($2 == "P")       $2 = g "Active_Password" rst;
      else if ($2 == "L")  $2 = r "Locked" rst;
      else if ($2 == "NP") $2 = y "No_Password" rst;
      print $1, $2, $3, $4, $5, $6, $7
    }'
  } | column -t

  # Print legend
  printf "\n${DIM}--------------------------------------------------------------------------------${RESET}\n"
  printf "${BOLD}Legend:${RESET}\n"
  printf "  ${CYAN}MIN_DAYS${RESET}      : Minimum days required between password changes\n"
  printf "  ${CYAN}MAX_DAYS${RESET}      : Maximum days a password is valid before expiring\n"
  printf "  ${CYAN}WARN_DAYS${RESET}     : Days before expiration to start warning the user\n"
  printf "  ${CYAN}INACTIVE_DAYS${RESET} : Grace period (days) after expiration before locking (-1 = disabled)\n"
}
