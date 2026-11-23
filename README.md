# Bash Functions
> A set of custom functions for your bashrc.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Home](https://img.shields.io/badge/Home-Link-blue.svg)](https://github.com/dwmadden70/helpful-customer-bash-functions)   

# Functions

[![passtab](https://img.shields.io/badge/passtab--green.svg)](https://github.com/dwmadden70/helpful-customer-bash-functions#passtab)

- Flexible Arguments:
    - Run passtab with no arguments to list all regular human accounts (UID >= 1000, excluding nobody).
	- Run passtab jdoe to inspect just one specific user.
    - Privilege Note: Running passwd --status on accounts other than your own requires sudo (e.g., sudo passtab or running as root). If run as a standard user without sudo, non-owned accounts are silently skipped (2>/dev/null) rather than cluttering the table with permission errors.
    - Legend Footer: Displays a clean, dimmed divider and definitions for the four day-based columns directly underneath the aligned table.

- Installation
    - Add to your <code style="color: salmon;">~/.bashrc</code> via <code style="color: lightgreen;">nano</code> or your editor of choice. Look near the the Custom Functions section or add one near the end.

[![passtab](https://img.shields.io/badge/rgd--green.svg)](https://github.com/dwmadden70/helpful-customer-bash-functions#passtab)

- Custom funtion to find occurences of word(s) untilizing ripgrep

- Installation
    - Add to your <code style="color: salmon;">~/.bashrc</code> via <code style="color: lightgreen;">nano</code> or your editor of choice. Look near the the Custom Functions section or add one near the end.
    - Place <code style="color: salmon;">.rgd-usuage.md</code> into your home directory. It is the help file for <code style="color: lightgreen;">rgd --help</code>.