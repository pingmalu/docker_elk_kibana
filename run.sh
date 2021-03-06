#!/bin/bash

if [[ "${ES}" != "**None**" ]]; then
    sed -i "s/localhost:9200/$ES/g" /opt/kibana-4.1.1-linux-x64/config/kibana.yml
fi

if [[ "${ES_USER}" != "**None**" && "${ES_PASS}" != "**None**" ]]; then
    echo "" >> /opt/kibana-4.1.1-linux-x64/config/kibana.yml
    echo "kibana_elasticsearch_username: $ES_USER" >> /opt/kibana-4.1.1-linux-x64/config/kibana.yml
    echo "kibana_elasticsearch_password: $ES_PASS" >> /opt/kibana-4.1.1-linux-x64/config/kibana.yml
fi

if [ "$KIBANA_SECURE" = "true" ] ; then
	ln -s /etc/nginx/sites-available/kibana-secure /etc/nginx/sites-enabled/kibana
	htpasswd -bc /etc/kibana/htpasswd ${KIBANA_USER} ${KIBANA_PASSWORD}
else
	ln -s /etc/nginx/sites-available/kibana /etc/nginx/sites-enabled/kibana
fi

sed -i "s/kibana:5601/$HOSTNAME:5601/g" /etc/nginx/sites-enabled/kibana

exec /usr/bin/supervisord -n
