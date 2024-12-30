# OWASP CRS - Fake Bot Plugin

## Description

This is a plugin that brings blocking of bots and impersonators faking well known
User-Agents in their HTTP requests.

The plugin is able to detect bots pretending to be:

 * Amazonbot
 * Applebot
 * Bingbot
 * Facebookbot
 * Googlebot
 * LinkedInBot
 * Twitterbot

Detection is done using DNS PTR records.

Upon successful detection, the requests will then be blocked by CRS depending on the CRS configuration.

## Prerequisities

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

For full and up to date instructions for the different available plugin
installation methods, refer to [How to Install a Plugin](https://coreruleset.org/docs/concepts/plugins/#how-to-install-a-plugin)
in the official CRS documentation.

## Plugin configuration

The settings for this plugin reside in `plugins/fake-bot-config.conf`.

### tx.fake-bot-plugin_whitelist_broken_apple_devices

Some software used by Apple devices (for example iMessage) are doing requests
to web pages while pretending to be a Facebookbot and Twitterbot. If you want to
allow this behavior and not block such requests, set this setting to `1`.

Note: This setting, when enabled, is opening a hole in the fake bot detection
which can be used by fake bots to bypass a protection provided by this plugin.

Default value: 0

## Testing

After installation, plugin should be tested, for example, using:  
`curl http://localhost --header "User-Agent: Googlebot"`

Using default CRS configuration, this request should end with status 403 with
the following message in the log:

`ModSecurity: Warning. Fake Bot Plugin: Detected fake Googlebot. [file "/path/plugins/fake-bot-after.conf"] [line "27"] [id "9504110"] [msg "Fake bot detected: Googlebot"] [data "Matched Data: googlebot found within REQUEST_HEADERS:User-Agent: Googlebot"] [severity "CRITICAL"] [ver "fake-bot-plugin/1.0.0"] [tag "application-multi"] [tag "language-multi"] [tag "platform-multi"] [tag "attack-bot"] [tag "capec/1000/225/22/77/13"] [tag "PCI/6.5.10"] [tag "paranoia-level/1"] [hostname "localhost"] [uri "/"] [unique_id "YebRag1XU2Ir-Zmt0Zlo2wAAAAA"]`

If you are running with a higher [Anomaly Threshold](https://coreruleset.org/docs/concepts/paranoia_levels/#how-paranoia-levels-relate-to-anomaly-scoring), you probably won't be blocked, but the alert message will still be there.

## Reporting

Please find a script named `fake-bot-report.sh` in the util folder.

## License

Copyright (c) 2022-2024 OWASP CRS project. All rights reserved.

The OWASP CRS and its official plugins are distributed
under Apache Software License (ASL) version 2. Please see the enclosed LICENSE
file for full details.
