FROM alpine:3.2

MAINTAINER Jacob Blain Christen <mailto:dweomer5@gmail.com, https://github.com/dweomer, https://twitter.com/dweomer>

COPY *.template /srv/openldap/
COPY openldap.sh /srv/

RUN set -x \
 && mkdir -p /srv/openldap.d /etc/openldap/sasl2 \
 && chmod -v +x /srv/openldap.sh \
 && apk add --update \
        gettext \
        libintl \
        openldap \
        openldap-back-hdb \
        openldap-clients \
 && cp -v /usr/bin/envsubst /usr/local/bin/ \
 && apk del --purge gettext \
 && mv -vf /etc/openldap/ldap.conf /etc/openldap/ldap.conf.original \
 && mv -vf /etc/openldap/slapd.conf /etc/openldap/slapd.conf.original \
 && echo "mech_list: plain external" > /etc/openldap/sasl2/slapd.conf \
 && rm -vfr /tmp/* /var/tmp/* /var/cache/apk/*

VOLUME ["/etc/openldap/slapd.d", "/var/lib/openldap"]

EXPOSE 389

ENTRYPOINT ["/srv/openldap.sh"]
CMD ["slapd", "-h", "ldapi:/// ldap:///", "-u", "ldap", "-g", "ldap", "-d", "none"]
