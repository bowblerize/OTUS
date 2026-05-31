FROM alpine:3.14 AS TEST


RUN apk update && \
	apk upgrade && \
	apk add nginx


RUN adduser -D -g 'www' www && \
	chown -R www:www /var/lib/nginx && \
	chown -R www:www /www

CMD ["nginx", "-g", "daemon off;"]
