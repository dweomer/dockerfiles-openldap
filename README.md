# OpenLDAP's SLAPD running on a slimmer-than-Debian Alpine Linux 3.2.
The _memberof_ and _refint_ overlays are also installed.

## Usage
```
docker run -itd -p 389:389 dweomer/openldap
```

## Modifying Default Behavior
### Environment Variables
Variable Name | Default Value | Notes
------------- | ------------- | -----
`LDAP_DOMAIN` | `example.com` |
`LDAP_SUFFIX` | dc=example,dc=com | by default this is generated from `${LDAP_DOMAIN}` but you could as easily pass `o=example.com` or any other legitimate `dn` supported by the `objectClass`
`LDAP_DOMAIN_OBJECTCLASS` | `domain` | any `objectClass` or combination thereof that supports `dc` and `o`, e.g. `export LDAP_DOMAIN_OBJECTCLASS="organization\nobjectClass: dcObject"`
`LDAP_ORGANIZATION` | `${LDAP_DOMAIN}` |
`LDAP_PASSWORD` | lderp!example | if not specified this is the string 'lderp!' concatenated with the first domain component from `${LDAP_DOMAIN}`

### Initializing Your Database
The first time the container starts up it will look for any files under the `/srv/openldap.d/` hierarchy and process them in lexical order.
Right now the only supported file extensions are `.sh` and `.ldif`, everything else is ignored. 
