#!/bin/sh -l
set -uo pipefail

LINKCHECKER_OUTPUT_DIR=${LINKCHECKER_OUTPUT_DIR:="link-checker"}
LINKCHECKER_OUTPUT_FILENAME=${LINKCHECKER_OUTPUT_FILENAME:="out.md"}

# Make the temp directory
mkdir -p /tmp/link-checker

# Execute Liche
liche $* >/tmp/link-checker/out 2>&1

# If link errors were found output them to the action and to a report to the designated directory
if [ $? -eq 1 ]; then
    result=$(cat /tmp/link-checker/out)
    echo "::set-env name=result::$result"

    mkdir -p $LINKCHECKER_OUTPUT_DIR
    echo -e '### Link Checker\nErrors were reported while checking the connectivity of links.\n```' \
        >$LINKCHECKER_OUTPUT_DIR/$LINKCHECKER_OUTPUT_FILENAME
    result >>$LINKCHECKER_OUTPUT_DIR/$LINKCHECKER_OUTPUT_FILENAME
    echo '```' >>$LINKCHECKER_OUTPUT_DIR/$LINKCHECKER_OUTPUT_FILENAME
    echo "Link checker output file: $LINKCHECKER_OUTPUT_DIR/$LINKCHECKER_OUTPUT_FILENAME"
fi

# Output to console
cat /tmp/link-checker/out
