# hubot-foreman

A hubot script for interaction with foreman api

See [`src/foreman.coffee`](src/foreman.coffee) for full documentation.


## Sample Interaction

```
user1>> hubot foreman search host
hubot>>
1. host0.domain.lan  id: 111
https://foreman.domain.com/hosts/host0.domain.lan
https://foreman.domain.com/hosts/host0.domain.lan/reports/last
2. host1.net.lan  id: 175
https://foreman.domain.com/hosts/host.net.lan
https://foreman.domain.com/hosts/host.net.lan/reports/last
3. host2.net.lan  id: 179
https://foreman.domain.com/hosts/host.net.lan
https://foreman.domain.com/hosts/host.net.lan/reports/last

```
