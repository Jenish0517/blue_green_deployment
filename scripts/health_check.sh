#!/bin/bash

echo "Checking Green environment health..."

# Try 5 times
for i in {1..5}
do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://green-app)

    if [ "$STATUS" -eq 200 ]; then
        echo "Green is healthy ✅"
        exit 0
    fi

    echo "Attempt $i failed... retrying"
    sleep 2
done

echo "Green is NOT healthy ❌"
exit 1