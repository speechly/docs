CURL_OPTS="--fail --silent --show-error"

# ----------- Build -----------------
TARGET=_index.md
TARGET_NAME=_index.md
TARGET_PATH=content/client-libraries/react/ui-components
SOURCE=https://raw.githubusercontent.com/speechly/react-ui/main/index.md

echo Building \"$TARGET_PATH/$TARGET_NAME\" from \"$SOURCE\"...

cat $TARGET_PATH/$TARGET_NAME.header > $TARGET_PATH/$TARGET_NAME
curl $CURL_OPTS $SOURCE >> $TARGET_PATH/$TARGET_NAME

# ----------- Build -----------------
echo OK
