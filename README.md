# Kore Seeder

Kore-seeder is a crawler for the Kore network, which exposes a list
of reliable nodes via a built-in DNS server.

Features:
* regularly revisits known nodes to check their availability
* bans nodes after enough failures, or bad behaviour
* accepts nodes down to v0.12.5 to request new IP addresses from,
  but only reports good post-v0.12.5 nodes.
* keeps statistics over (exponential) windows of 2 hours, 8 hours,
  1 day and 1 week, to base decisions on.
* very low memory (a few tens of megabytes) and cpu requirements.
* crawlers run in parallel (by default 24 threads simultaneously).

## Installing

Kore network runs under Tor, so you'll need to install it first in order to connect to the node's onion addresses.

We prepared a cool script for you to avoid too much work (the easy way), but there is some prerequisites:

### Prerequisites

* A 64bits VPS running Ubuntu (16 recommended)
* Open the ports 53 (TCP and UDP) and 10743 (TCP and UDP)
* A domain with a an "A" record ponting to your VPS
* Another domain with only a "NS" record pointing to the previous domain mentioned before

### Easy way

Run this:

```sh
wget "https://raw.githubusercontent.com/Plorark/kore-seeder/master/auto-install.sh" && chmod 777 ./auto-install.sh && sudo ./auto-install.sh
```

**IMPORTANT**

While it's an easy way to set everything up, it lacks some features yet:
* If you restart the VPS you must run the dnsseeder again with  
`run-kore-seeder`
* It won't restart if it crashes (it shouldn't happen tho)

Those features will be added soon.

### Hard way

This repo is based on the original [sipa's Bitcoin Seeder](https://github.com/sipa/bitcoin-seeder), so you can always check the [original README](https://github.com/Plorark/kore-seeder/blob/master/README.old.md) and learn how everything works.

## Extra information

#### Why two domains? (extra info about the domains stuff)

The seeder itself is almost a DNS server. What we want is that whe we run a `nslookup ourdnsseedaddress.coin.com`, the nodes are shown. For this to happen, we need an address with a **NS** record that points to a DNS server (or our DnsSeed).

However, **NS** records can only point to a domain (not an IP), that's why we need the other domain pointing with an **A** record to your VPS

So this is what we have something like this:

|-------**DNS Address**------::|  
|-----dnsaddr.coin.com----:|  
|-------**NS** Record to:-------|  
|-------------▼--------------|  
|-------------▼--------------|  
|--------**NS Address**--------|  
|------nsaddr.coin.com-----|  
|---------**A** Record to:------:|  
|-------------▼--------------|  
|-------------▼--------------|  
|------------**VPS**------------:|  
|-------10.254.12.145-------|  
|--------(example IP)-------:|  
