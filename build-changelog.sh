#!/usr/bin/env bash

prev="$1"
curr="$2"

if [[ -z $prev || -z $curr ]]; then
  echo "Usage: $0 <previous.info> <current.info>"
  exit 1
fi

# read previous packages
declare -A prev_packages
while IFS= read -r entry; do
  prev_packages[${entry%%=*}]=${entry#*=}
done < <(awk '/^ii/ {print $2 "=" $3}' "$prev")

# read current packages
declare -A curr_packages
while IFS= read -r entry; do
  curr_packages[${entry%%=*}]=${entry#*=}
done < <(awk '/^ii/ {print $2 "=" $3}' "$curr")

# compute added and updated packages
added=""
updated=""
while IFS= read -r package; do
  [[ -z $package ]] && continue
  curr_version=${curr_packages[$package]}
  if [[ -z ${prev_packages[$package]+_} ]]; then
    added+="* [added] ${package%%:*} ($curr_version)"$'\n'
  else
    prev_version=${prev_packages[$package]}
    if [[ $curr_version != "$prev_version" ]]; then
      updated+="* [updated] ${package%%:*} ($prev_version -> $curr_version)"$'\n'
    fi
  fi
done < <(tr ' ' '\n' <<< "${!curr_packages[@]}" | sort)

# compute removed packages
removed=""
while IFS= read -r package; do
  [[ -z $package ]] && continue
  prev_version=${prev_packages[$package]}
  if [[ -z ${curr_packages[$package]+_} ]]; then
    removed+="* [removed] ${package%%:*} ($prev_version)"$'\n'
  fi
done < <(tr ' ' '\n' <<< "${!prev_packages[@]}" | sort)

# write changelog
echo "**Changelog**"
echo $'`'$'`'$'`'
[[ -n "$added" ]] && echo -n "$added"
[[ -n "$updated" ]] && echo -n "$updated"
[[ -n "$removed" ]] && echo -n "$removed"
echo $'`'$'`'$'`'
