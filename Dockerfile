FROM httpd:2.4
WORKDIR /
COPY ./public/ /usr/local/apache2/htdocs/
