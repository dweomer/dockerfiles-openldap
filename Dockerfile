FROM alpine:3.2

COPY ldap.conf.template slapd.conf.template /srv/openldap/
COPY openldap.sh /srv/

RUN set -x \
 && chmod -v +x /srv/openldap.sh \
 && apk add --update \
        gettext \
        openldap \
        openldap-back-hdb \
        openldap-clients \
 && mv -vf /etc/openldap/ldap.conf /etc/openldap/ldap.conf.original \
 && mv -vf /etc/openldap/slapd.conf /etc/openldap/slapd.conf.original \
 && rm -vfr /tmp/* /var/tmp/* /var/cache/apk/*

VOLUME ["/etc/openldap/slapd.d", "/var/lib/openldap"]

EXPOSE 389

ENTRYPOINT ["/srv/openldap.sh"]
CMD ["slapd", "-h", "ldapi:/// ldap:///", "-d", "none", "-u", "ldap", "-g", "ldap"]
