FROM ubuntu:trusty
MAINTAINER MaLu <malu@malu.me> 

RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install wget vim nginx-full apache2-utils supervisor

WORKDIR /opt
RUN wget --no-check-certificate -O- https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz | tar xvfz - && \
# This is where the htpasswd file is placed by the run script
    mkdir /etc/kibana

ADD kibana /etc/nginx/sites-available/kibana
ADD kibana-secure /etc/nginx/sites-available/kibana-secure
RUN rm /etc/nginx/sites-enabled/* && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

ENV KIBANA_SECURE false
ENV KIBANA_USER kibana
ENV KIBANA_PASSWORD kibana
ENV ES **None**
ENV ES_USER **None**
ENV ES_PASS **None**

EXPOSE 80

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD run ./run.sh
RUN chmod +x ./run.sh
CMD ./run.sh
