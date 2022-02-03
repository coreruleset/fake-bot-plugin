-- Code inspired by http://lua-users.org/wiki/StringRecipes .
function ends_with(str, ending)
	str = str:lower()
	ending = ending:lower()
	return ending == "" or str:sub(-#ending) == ending
end

function main(user_agent_lowercase)
	pcall(require, "m")
	local ok, socket = pcall(require, "socket")
	if not ok then
		m.log(2, "Fake Bot Plugin ERROR: LuaSocket library not installed, please install it or disable this plugin.")
		return nil
	end
	if string.match(user_agent_lowercase, "googlebot") then
		-- https://developers.google.com/search/docs/advanced/crawling/verifying-googlebot
		bot_domains = {".googlebot.com", ".google.com"}
		bot_name = "Googlebot"
	elseif string.match(user_agent_lowercase, "facebookexternalhit") or string.match(user_agent_lowercase, "facebookcatalog") or string.match(user_agent_lowercase, "facebookbot") then
		-- https://developers.facebook.com/docs/sharing/webmasters/crawler/
		-- https://developers.facebook.com/docs/sharing/bot/
		bot_domains = {".facebook.com", ".fbsv.net"}
		bot_name = "Facebookbot"
	elseif string.match(user_agent_lowercase, "bingbot") then
		-- https://blogs.bing.com/webmaster/2012/08/31/how-to-verify-that-bingbot-is-bingbot
		bot_domains = {".search.msn.com"}
		bot_name = "Bingbot"
	else
		return nil
	end
	local remote_addr = m.getvar("REMOTE_ADDR", "none")
	hosts = socket.dns.getnameinfo(remote_addr)
	for k1, host in pairs(hosts) do
		for k2, domain in pairs(bot_domains) do
			if ends_with(host, domain) then
				addrinfo = socket.dns.getaddrinfo(host)
				for k3, ips in pairs(addrinfo) do
					for k4, ip in pairs(ips) do
						if remote_addr == ip then
							return nil
						end
					end
				end
			end
		end
	end
	m.setvar("tx.fake-bot-plugin_bot_name", bot_name)
	return string.format("Fake Bot Plugin: Detected fake %s.", bot_name)
end
