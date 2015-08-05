FROM alpine:3.2

COPY *.template /srv/openldap/
COPY openldap.sh /srv/

RUN set -x \
 && mkdir -p /srv/openldap.d /etc/openldap/sasl2 \
 && chmod -v +x /srv/openldap.sh \
 && apk add --update \
        gettext \
        openldap \
        openldap-back-hdb \
        openldap-clients \
 && mv -vf /etc/openldap/ldap.conf /etc/openldap/ldap.conf.original \
 && mv -vf /etc/openldap/slapd.conf /etc/openldap/slapd.conf.original \
 && echo "mech_list: plain external" > /etc/openldap/sasl2/slapd.conf \
 && rm -vfr /tmp/* /var/tmp/* /var/cache/apk/*

VOLUME ["/etc/openldap/slapd.d", "/var/lib/openldap"]

EXPOSE 389

ENTRYPOINT ["/srv/openldap.sh"]
CMD ["slapd", "-h", "ldapi:/// ldap:///", "-u", "ldap", "-g", "ldap", "-d", "none"]
