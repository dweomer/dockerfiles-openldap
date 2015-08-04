#!/bin/sh -e

ulimit -n 2048

mkdir -p /etc/openldap/slapd.d

export LDAP_DOMAIN="${LDAP_DOMAIN:-example.com}"
export LDAP_ORGANIZATION="${LDAP_ORGANIZATION:-${LDAP_DOMAIN}}"
export LDAP_SUFFIX=$(echo "dc=$(echo $LDAP_DOMAIN | sed 's/^\.//; s/\./,dc=/g')")
export LDAP_PASSWORD="${LDAP_PASSWORD:-lderp}"

export LDAP_BINDDN="cn=admin,${LDAP_SUFFIX}"
export LDAP_BINDPW="$LDAP_PASSWORD"

if [[ ! -d '/etc/openldap/slapd.d/cn=config' ]]; then


#    if [[ "$LDAP_PASSWORD" != "$(echo $LDAP_PASSWORD | grep '{.*}.*')" ]]; then
        export LDAP_PASSWORD=$(slappasswd -u -h '{SSHA}' -s $LDAP_PASSWORD)
#    fi

    if [[ ! -s /etc/openldap/slapd.conf ]]; then
        cat /srv/openldap/slapd.conf.template | envsubst > /etc/openldap/slapd.conf
    fi

    slaptest -n0 -F /etc/openldap/slapd.d -f /etc/openldap/slapd.conf
    slapcat -n0 -F /etc/openldap/slapd.d > /etc/openldap/slapd.ldif

    if [[ ! -s /etc/openldap/ldap.conf ]]; then
        cat /srv/openldap/ldap.conf.template | envsubst > /etc/openldap/ldap.conf
    fi

    chown -R ldap:ldap /etc/openldap/slapd.d/ /var/lib/openldap/
fi

exec "$@"
