From: randy_dunlap <rdunlap@xenotime.net>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Sat, 9 Jul 2005 21:08:24 -0700
Message-ID: <20050709210824.29a90c5b.rdunlap@xenotime.net>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
	<42D07E94.8070409@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chretien.genwebhost.com ([209.59.175.22]:2485 "EHLO
	chretien.genwebhost.com") by vger.kernel.org with ESMTP
	id S261758AbVGJEI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 00:08:27 -0400
In-Reply-To: <42D07E94.8070409@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, 10 Jul 2005 03:49:08 +0200 Pierre Ossman wrote:

| randy_dunlap wrote:
| 
| >Pierre,
| >
| >Can you capture the complete panic message using serial console or
| >netconsole?  or at least use a smaller font on the console so that
| >we can see the entire panic message, as some critical parts of it
| >have scrolled off the top of the screen.
| >
| >  
| >
| 
| Hmm... I made an attempt to get netconsole up and running but nothing is
| emitted to the network. It seems to think everthing is fine though:
| 
| netconsole: local port 6665
| netconsole: interface eth0
| netconsole: remote port 6666
| netconsole: remote IP 10.100.0.4
| netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
| netconsole: local IP 10.100.0.10
| netconsole: network logging started
| 
| Perhaps the 3c95x driver doesn't work with netconsole?

3c59x ??
3c59x.c has CONFIG_NET_POLL_CONTROLLER code in it.
I would expect it to work since it's a fairly common NIC, but I
can't vouch for it.
Did you enable CONFIG_NETPOLL in your kernel .config?


---
~Randy
