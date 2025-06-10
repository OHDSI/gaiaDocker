#!/bin/sh

export PATH="/bin:/usr/bin/:/usr/local/bin:$PATH"
unset CDPATH IFS TMPDIR
umask 0077
GAIA_X_API_KEY=$(cat $GAIA_X_API_KEY_FILE)

# check for the correct request method, fail if not POST
read -r request_line
request_method=$(printf "%s" "$request_line" | sed 's/ .*//')
if printf "%s" "$request_method" | grep -qi '^post'
then
    request_body=$(mktemp)
    trap 'rm -f $request_body' EXIT INT TERM
else
    cat <<eof
HTTP/1.1 405 Method Not Allowed
Content-type: application/json

{"method": "$request_method", "msg": "Not allowed"}
eof
    exit 0
fi

content_length=0
in_body=0

# read the request
while IFS='' read -r line
do
    if test $in_body -eq 1
    then
        # Collect payload
        printf "%s\n" "$line" >> $request_body
        received_length=$(wc -c < $request_body)
        if test $received_length -ge $content_length
        then
            break
        fi
    elif printf "%s" "$line" | grep -qv ':'
    then
        if test $content_length -eq 0
        then
            break  # There is no body
        else
            in_body=1  # Body starts on the next line
        fi
    elif printf "%s" "$line" | grep -qi '^content-length:'
    then
        content_length=$(printf "%s" "$line" | sed 's/.*:\s*//')
    elif printf "%s" "$line" | grep -qi '^x-api-key:'
    then
        x_api_key=$(printf "%s" "$line" | sed 's/.*:\s*//' | tr -d '\r')
    else
        :  # Placeholder - collect other headers as needed
    fi
done

# fail if GAIA_X_API_KEY not correct
if test $x_api_key != $GAIA_X_API_KEY
then
    cat <<eof
HTTP/1.1 403 Forbidden
eof
    exit 0
fi


# run the command on the correct shell
if [ -z "$(which bash)" ]; then
  res=$(sh "$request_body" 2>&1)
else
  res=$(bash "$request_body" 2>&1)
fi
res=$(echo $res | tr -d \")

# create response
content="{\
\"method\": \"$request_method\", \
\"res\": \"$res\"\
}"

# send response
cat <<eof
HTTP/1.1 200 OK
Content-type: application/json

$content
eof