# About these certs

## `_.vagrant.test.*`

These are for wildcard subdomains. That means any subdomain will work with SSL.
For example, `example.vagrant.test` or `foobar.vagrant.test`. The `vagrant.test`
domain must be present.

## `_.test.*`

These are also for wildcard domains, but shortened. This means you can use
`example.test` or `foobar.test`.

# Generating new certs

If the above certs are not enough for testing purposes, new certs can always be
generated. Be sure to create the custom vhost configurations as well.

```
cd /vagrant/nginx/ssl
openssl genrsa 2048 > newdomain.test.key
openssl req -new -x509 -nodes -sha256 -days 3650 -key newdomain.test.key > newdomain.test.crt
```

The third command will ask for a "Common Name (e.g. server FQDN or YOUR name)"
domain name to use. If it is `newdomain.test` enter that. If you want wildcards
on `newdomain.test` enter `*.newdomain.test`.

```
openssl x509 -noout -fingerprint -text < newdomain.test.crt > newdomain.test.info
cat newdomain.test.crt newdomain.test.key > newdomain.test.pem
```
