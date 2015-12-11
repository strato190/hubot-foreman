# Description
#   A hubot script for interaction with foreman api
#
# Dependencies:
#   None
#
# Configuration:
# FOREMAN_AUTH (e.g. user:password for Basic Auth)
# FOREMAN_URL (e.g. https://foreman.example.com)
#
# Commands:
#
#   foreman s|search <pattern> - search and list of hosts and their last reports
#   foreman c|classes <fqdn>  - show puppet classes assigned to host
#
# Authors:
#   strato190
#
foreman_url = process.env.FOREMAN_URL
foreman_auth = process.env.FOREMAN_AUTH

module.exports = (robot) ->

  robot.hear /foreman (s|search) (\w+)/i, (msg) ->
    foremansearch msg

  robot.hear /foreman (c|classes) (\w+)/i, (msg) ->
    foremanpuppetclasses msg

foremansearch = (msg, query, cb) ->
  data = []
  port = ":443"
  response = ""
  uri = "/api/hosts?search=#{msg.match[2]}"
  auth = 'Basic ' + new Buffer(foreman_auth).toString('base64') if foreman_auth
  headers = { Accept: "application/json", 'Content-type': 'application/json' }
  headers['Authorization'] = auth if auth
  msg
    .http(foreman_url + port + uri)
    .headers(headers)
    .get() (err, res, data) ->
      unless res.statusCode is 200
        console.log(res, uri, port, foreman_url, 'err', res.statusCode)
       i = 0
       body = JSON.parse(data)
       while i < body.length
         object = body[i]
         for property of object
           response += "#{i + 1}. #{object[property]['name']}  id: #{object[property]['id']}\n"
           response += "#{process.env.FOREMAN_URL}/hosts/#{object[property]['name']}\n"
           response += "#{process.env.FOREMAN_URL}/hosts/#{object[property]['name']}/reports/last\n"
         i++
       msg.send response

foremanpuppetclasses = (msg) ->
  data = []
  port = ":443"
  response = ""
  serverregex = /(\bforeman\b)\ (\S+)\ (\S+)$/
  host = msg.match.input.match(serverregex)[3]
  uri = "/api/hosts/#{msg.match.input.match(serverregex)[3]}/puppetclasses"
  auth = 'Basic ' + new Buffer(foreman_auth).toString('base64') if foreman_auth
  headers = { Accept: "application/json", 'Content-type': 'application/json' }
  headers['Authorization'] = auth if auth
  msg
    .http(foreman_url + port + uri)
    .headers(headers)
    .get() (err, res, data) ->
      unless res.statusCode is 200
        console.log(res, uri, port, foreman_url, 'err', res.statusCode)
       body = JSON.parse(data)
       response += "host: #{host}\n"
       for property of body
         object = body[property]
         for item of object
           response += "#{object[item].puppetclass['name']}\n"
       msg.send response

