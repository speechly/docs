CURL="curl --fail --silent --show-error"

# ----------- Build -----------------
TARGET=_index.md
TARGET_NAME=_index.md
TARGET_PATH=content/client-libraries/react/ui-components
SOURCE=https://raw.githubusercontent.com/speechly/react-ui/main/index.md

echo Building \"$TARGET_PATH/$TARGET_NAME\" from \"$SOURCE\"...

cat $TARGET_PATH/$TARGET_NAME.header > $TARGET_PATH/$TARGET_NAME
$CURL $SOURCE >> $TARGET_PATH/$TARGET_NAME

# ----------- Build -----------------
echo OK

APIREF=content/speechly-api/api-reference.md
API_HEADER=content/speechly-api/api-reference.header
echo Building API reference to $APIREF
cp $API_HEADER $APIREF
$CURL https://raw.githubusercontent.com/speechly/api/master/docs/slu.md >> $APIREF
$CURL https://raw.githubusercontent.com/speechly/api/master/docs/identity.md >> $APIREF
