
FROM node:latest AS build

#install alpine
FROM nginx:alpine

#install ionic
RUN npm install -g ionic
RUN npm install

# Create a non-root user to own the files and run our server
RUN adduser -D static 

# Gettin the web dev CA
RUN wget https://github.com/marcelomegale/cbwa_ca2/archive/master.tar.gz && tar xf master.tar.gz && rm master.tar.gz && mv /site_cbwa-master /home/static

#app folder
WORKDIR /app/cbwa_ca2-main/

EXPOSE 8080

# Copy over the user
COPY --from=builder /etc/passwd /etc/passwd

#copy the CA file
COPY --from=builder /home/static /home/static

# Use our non-root user
USER static
WORKDIR /home/static

## Changing working directory to /home/static/web_ca1-main
WORKDIR /home/static/site_cbwa-master

RUN rm -rf /usr/share/nginx/html/*
COPY --from=build app/site_cbwa-main//www/ /usr/share/nginx/html/