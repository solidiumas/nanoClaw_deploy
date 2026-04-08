FROM alpine:latest

# Vi bytter --no-color med --no-cache (som er riktig for Alpine)
RUN apk add --no-cache curl bash

# Her legger du logikken for agenten din senere
CMD ["sh", "-c", "echo 'NanoClaw Agent kjører...' && sleep infinity"]
