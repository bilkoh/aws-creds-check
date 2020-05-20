#!/bin/bash
norestore=false
infile=""
awscredfile=~/.aws/credentials

usage () {
  cat <<USAGE_END
$0 will test aws credentials listed in a file
  this will edit ~/.aws/credentials, but will backup/restore original
  use -n flag [no-restore] to keep credentials added by script in $awscredfile file
Usage:
  $0 [file]
  $0 -n [file]
USAGE_END
}

backup () {
  tmpfile=$(mktemp aws.creds.XXXX)
  printf "Backing up %s file to %s\n" "$awscredfile" "$tmpfile"
  cat $awscredfile > $tmpfile
}

restore () {
  printf "Restoring %s file with %s\n" "$awscredfile" "$tmpfile"
  cp $tmpfile $awscredfile && rm -f $tmpfile
  # cp $tmpfile $awscredfile && rm -f $tmpfile
}


OPTIND=1
# Resetting OPTIND is necessary if getopts was used previously in the script.
# It is a good idea to make OPTIND local if you process options in a function.

while getopts hn opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    n)
      norestore=true
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --
printf '<norestore %s>\n' "$norestore"
printf '<%s>\n' "$1"

if [ -z "$1" ]; then
    usage >&2
    exit 1
fi

backup

while IFS=":" read line val
do 
  echo $line : $val; 
  aws configure --profile $line set aws_access_key_id $line
  aws configure --profile $line set aws_secret_access_key $val
  aws sts get-caller-identity --profile $line
done < $1


if [ "$norestore" = false ] ; then
  restore
fi
