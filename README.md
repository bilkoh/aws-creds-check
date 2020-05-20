# AWS Credential Check

If only the aws cli would let you call `get-caller-identity` with apikey and secret as arguments, I wouldn't have to write this.

## Usage
~~~
./aws-creds-check.sh will test aws credentials listed in a file
  this will edit ~/.aws/credentials, but will backup/restore original
  use -n flag [no-restore] to keep credentials added by script in /home/bilk0h/.aws/credentials file
Usage:
  ./aws-creds-check.sh [file]
  ./aws-creds-check.sh -n [file]
  ~~~
