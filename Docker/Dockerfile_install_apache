FROM ubuntu:latest
RUN apt-get update && apt-get install -y apache2 git
COPY . /var/www/html
# Ensure Apache runs in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
