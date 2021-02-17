# ----------- Build -----------------
TARGET=_index.md
TARGET_NAME=_index.md
TARGET_PATH=content/client-libraries/react/ui-components

echo Building $TARGET_PATH/$TARGET_NAME...

cat $TARGET_PATH/$TARGET_NAME.header > $TARGET_PATH/$TARGET_NAME
curl https://raw.githubusercontent.com/speechly/react-ui/main/docs/react-ui.md >> $TARGET_PATH/$TARGET_NAME
