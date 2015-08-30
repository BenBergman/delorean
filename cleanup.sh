#!/bin/bash

today=`date +%s`
one_day=$((24*60*60))
two_days=$(($one_day*2))
one_week=$(($one_day*7))
two_weeks=$(($one_week*2))
one_month=$(($one_day*30))
two_months=$(($one_month*2))
last_preserved=0
delete="no"

delete_all_but_first()
{
	if [ $1 -lt $2 ]; then
		delete="yes"
	else
		last_preserved=$date
	fi
}

for backup in `ls | egrep "^back" | sort -r`; do
	date=`date --date="${backup:5:10}" +%s`
	delete="no"
	threshold=""
	gap=$(($last_preserved-$date))

	diff=$(($today-$date))
    if [ $last_preserved -eq 0 ]; then
        threshold="first preserved"
        last_preserved=$date
	elif [ $diff -lt $two_days ]; then
		threshold="less than two days"
		last_preserved=$date
	elif [ $diff -lt $two_weeks ]; then
		threshold="less than two weeks"
		delete_all_but_first $gap $one_day
	elif [ $diff -lt $two_months ]; then
		threshold="less than two months"
		delete_all_but_first $gap $one_week
	else
		threshold="older than two months"
		delete_all_but_first $gap $one_month
	fi

	echo -e "backup: $backup \tdate: $date \tdeleted: $delete \tthreshold: $threshold \tlast_preserved: $last_preserved \tgap: $gap"
	if [ "$delete" == "yes" ]; then
		rm -rfv $backup | pv -l >/dev/null
	fi
done

# Deletion Rules
# If backup is less than 48 hrs old, keep
# If backup is between 48 hrs and one week old, keep one per day
# If backup is between one week and two months old, keep one per week
# If backup is older than two months, keep one per month
