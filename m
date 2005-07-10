From: randy_dunlap <rdunlap@xenotime.net>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Sun, 10 Jul 2005 09:39:07 -0700
Message-ID: <20050710093907.3f3c36e4.rdunlap@xenotime.net>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
	<42D07E94.8070409@drzeus.cx>
	<20050709210824.29a90c5b.rdunlap@xenotime.net>
	<42D12A39.80207@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chretien.genwebhost.com ([209.59.175.22]:56255 "EHLO
	chretien.genwebhost.com") by vger.kernel.org with ESMTP
	id S261970AbVGJQjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 12:39:14 -0400
In-Reply-To: <42D12A39.80207@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, 10 Jul 2005 16:01:29 +0200 Pierre Ossman wrote:

| randy_dunlap wrote:
| 
| >3c59x ??
| >3c59x.c has CONFIG_NET_POLL_CONTROLLER code in it.
| >I would expect it to work since it's a fairly common NIC, but I
| >can't vouch for it.
| >Did you enable CONFIG_NETPOLL in your kernel .config?
| >
| >  
| >
| 
| Yup. It's enabled. NETPOLL_RX is not enabled though. Is that needed?

Shouldn't be needed.  It's for trapping incoming packets, not
outbound.

| Netconsole is also built as a module so that I can easily fiddle around
| with the parameters. Any known problems there?

Not that I know of.


---
~Randy
