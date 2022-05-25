# FROM alpine:3.15
# RUN apk add apache2
# COPY index.html /var/www/localhost/htdocs/
# RUN echo "<center><h1>Hello from ECS</h1><br><h2>Demo3 Terraform<h2><br>$HOSTNAME" > /var/www/localhost/htdocs/index.html
# EXPOSE 80
# CMD ["/usr/sbin/httpd", "-DFOREGROUND"]

FROM ubuntu:22.04
RUN apt -y update && apt -y install supervisor apache2 stress
COPY index.html test.sh /var/www/html/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80
CMD ["/usr/bin/supervisord"]