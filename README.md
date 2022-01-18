# OWASP ModSecurity Core Rule Set - Fake Bot Plugin

## Description

This is a plugin that brings blocking of bots faking User-Agent to CRS.

The plugin is able to detect and block bots pretending to be:

 * Googlebot
 * Bingbot
 * Facebookbot

Detection is done using DNS PTR.

## Prerequisities

 * CRS version 3.4 or newer (or see "Preparation for older installations" below)
 * ModSecurity compiled with Lua support
 * LuaSocket library
 * Fully working DNS resolving

## Installation

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

After configuration, antivirus protection should be tested, for example, using:  
curl http://localhost --header "User-Agent: Googlebot"

## License

Copyright (c) 2022 OWASP ModSecurity Core Rule Set project. All rights reserved.

The OWASP ModSecurity Core Rule Set and its official plugins are distributed
under Apache Software License (ASL) version 2. Please see the enclosed LICENSE
file for full details.
