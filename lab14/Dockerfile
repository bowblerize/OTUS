FROM alpine:latest
 
RUN apk add --no-cache nginx && \
    mkdir -p /run/nginx
 
COPY default.conf /etc/nginx/http.d/default.conf
COPY index.html /var/lib/nginx/html/index.html
 
EXPOSE 80
 
CMD ["nginx", "-g", "daemon off;"]

