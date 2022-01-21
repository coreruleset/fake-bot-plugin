# OWASP ModSecurity Core Rule Set - Fake Bot Plugin

## Description

This is a plugin that brings blocking of bots faking User-Agent to CRS.

The plugin is able to detect and block bots pretending to be:

 * Googlebot
 * Bingbot
 * Facebookbot

Detection is done using DNS PTR records.

## Prerequisities

 * CRS version 3.4 or newer (or see "Preparation for older installations" below)
 * ModSecurity compiled with Lua support
 * Lua
 * LuaSocket library
 * Fully working DNS resolving

## How to determine whether you have Lua support in ModSecurity

Most modern distro packages come with Lua support compiled in. If you are unsure, or if you get odd error messages (e.g. `EOL found`) chances are you are unlucky. To be really sure look for ModSecurity announce Lua support when launching your web server:

```
... ModSecurity for Apache/2.9.5 (http://www.modsecurity.org/) configured.
... ModSecurity: APR compiled version="1.7.0"; loaded version="1.7.0"
... ModSecurity: PCRE compiled version="8.39 "; loaded version="8.39 2016-06-14"
... ModSecurity: LUA compiled version="Lua 5.3"
...
```

If this line is missing, then you are probably stuck without Lua. Check out the documentation at [coreruleset.org](https://coreruleset.org/docs) to learn how to get Lua support for your installation.

## LuaSocket library installation

LuaSocket library should be part of your linux distribution. Here is an example
of installation on Debian / Ubuntu Linux:  

`apt install lua-socket`

## Plugin installation

Copy all files from `plugins` directory into the `plugins` directory of your
OWASP ModSecurity Core Rule Set (CRS) installation.

### Preparation for older installations

 * Create a folder named `plugins` in your existing CRS installation. That
   folder is meant to be on the same level as the `rules` folder. So there is
   your `crs-setup.conf` file and next to it the two folders `rules` and
   `plugins`.
 * Update your CRS rules include to follow this pattern:

```
<IfModule security2_module>

 Include modsecurity.d/owasp-modsecurity-crs/crs-setup.conf

 Include modsecurity.d/owasp-modsecurity-crs/plugins/*-config.conf
 Include modsecurity.d/owasp-modsecurity-crs/plugins/*-before.conf

 Include modsecurity.d/owasp-modsecurity-crs/rules/*.conf

 Include modsecurity.d/owasp-modsecurity-crs/plugins/*-after.conf

</IfModule>
```

_Your exact config may look a bit different, namely the paths. The important
part is to accompany the rules-include with two plugins-includes before and
after like above. Adjust the paths accordingly._

## Testing

After installation, plugin should be tested, for example, using:  
`curl http://localhost --header "User-Agent: Googlebot"`

Using default CRS configuration, this request should end with status 403 with
the following message in the log:

`ModSecurity: Warning. Fake Bot Plugin: Detected fake Googlebot. [file "/path/plugins/fake-bot-after.conf"] [line "27"] [id "9504110"] [msg "Fake bot detected: Googlebot"] [data "Matched Data: googlebot found within REQUEST_HEADERS:User-Agent: googlebot"] [severity "CRITICAL"] [ver "fake-bot-plugin/1.0.0"] [tag "application-multi"] [tag "language-multi"] [tag "platform-multi"] [tag "attack-bot"] [tag "capec/1000/225/22/77/13"] [tag "PCI/6.5.10"] [tag "paranoia-level/1"] [hostname "localhost"] [uri "/"] [unique_id "YebRag1XU2Ir-Zmt0Zlo2wAAAAA"]`

If you are running with a higher Anomaly Threshold, you probably won't be blocked, but the alert message will still be there.

## License

Copyright (c) 2022 OWASP ModSecurity Core Rule Set project. All rights reserved.

The OWASP ModSecurity Core Rule Set and its official plugins are distributed
under Apache Software License (ASL) version 2. Please see the enclosed LICENSE
file for full details.
