#!/bin/bash

clean_up () {
    # Cleanup temp file
    echo "Cleaning up $TMP_FILEPATH."
    if [ -f $TMP_FILEPATH ]; then
        rm $TMP_FILEPATH
        echo "Cleanup done."
    fi
}

USAGE="\n
Backup file / directory to local directory and / or S3 bucket with file rotation support.\n\n
USAGE:\n
\n
\t backup-and-upload file_or_dir_path --s3 aws_s3_bucket_name --local local_backup_dir_name --rotate 14\n
\n
where:\n
\t --s3 - s3 bucket name you want backup to be uploaded to\n
\t --local - path to local directory where you want to store backups\n
\t --rotate - number of days to save a local backup for\n
"

if [ "$1" == '--help' ]; then
    HELP=1
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    HELP=1
    shift # past argument
    #shift # past value
    ;;
    -l|--local)
    LOCAL="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--s3)
    S3="$2"
    shift # past argument
    shift # past value
    ;;
    --rotate)
    ROTATE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -n "$HELP" ]; then
    echo $USAGE
    exit
fi

FILEPATH=$1
FILENAME=$(basename $FILEPATH)
FILE_EXTENSION="${FILENAME##*.}"
FILENAME_WITHOUT_EXTENSION="${FILENAME%.*}"
TMP_FILEPATH=/tmp/backup__${FILENAME_WITHOUT_EXTENSION}__$(date +'%Y_%m_%dT%H_%M_%S').tar.gz

# Compress or copy file
if [ "$FILE_EXTENSION" == 'gz' ]; then
    echo "Copying $FILENAME to $TMP_FILEPATH."
    TMP_FILEPATH=/tmp/$FILENAME
    cp $FILEPATH $TMP_FILEPATH
else
    echo "Compressing $FILENAME as $TMP_FILEPATH."
    tar fcz $TMP_FILEPATH $FILEPATH
fi

# Copy file to local and rotate backups.
if [ -n "$LOCAL" ]; then
    echo "Copying $TMP_FILEPATH to local $LOCAL backup dir."
    cp $TMP_FILEPATH $LOCAL/
    if [ -n "$ROTATE" ]; then
        echo "Deleting files in $LOCAL older than $ROTATE days."
        find $LOCAL -type f -mtime $ROTATE -print | while read line; do
          FILENAMETODELETE="$(basename ${line})"
          rm -f "${LOCAL}${FILENAMETODELETE}"
        done
    fi
fi

# Upload file to s3.
if [ -n "$S3" ]; then
    # S3 CMD UPLOAD
    echo "Uploading $TMP_FILEPATH to S3 with bucket name $S3"
    s3cmd --access_key=$AWS_ACCESS_KEY --secret_key=$AWS_SECRET_KEY put $TMP_FILEPATH s3://$S3
fi

# Cleanup on error.
trap clean_up EXIT