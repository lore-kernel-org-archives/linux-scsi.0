From: randy_dunlap <rdunlap@xenotime.net>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Sun, 10 Jul 2005 10:56:35 -0700
Message-ID: <20050710105635.6d1606e3.rdunlap@xenotime.net>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
	<42D07E94.8070409@drzeus.cx>
	<20050709210824.29a90c5b.rdunlap@xenotime.net>
	<42D12A39.80207@drzeus.cx>
	<20050710093907.3f3c36e4.rdunlap@xenotime.net>
	<42D15968.1080101@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chretien.genwebhost.com ([209.59.175.22]:63208 "EHLO
	chretien.genwebhost.com") by vger.kernel.org with ESMTP
	id S261994AbVGJR4m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:56:42 -0400
In-Reply-To: <42D15968.1080101@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, 10 Jul 2005 19:22:48 +0200 Pierre Ossman wrote:

| I've tried to get it running on three separate machines now with no
| success (each running a different kernel version), so I'm starting to
| suspect I'm doing something wrong here. I've used the following line to
| load the module:
| 
| modprobe netconsole netconsole=@/,@10.8.0.168/
| 
| I've tried changing the ip-address to both broadcast and specific hosts
| with the same result. I also tried giving all parameters using:
| 
| modprobe netconsole
| netconsole=2000@10.8.0.24/eth0,3000@10.8.0.168/00:0e:35:15:32:d6
| 
| but the result was the same.
| 
| Anything else I might be doing wrong?

netconsole seems to be working:
| netconsole: network logging started

Are you using netcat on the receive side?

Matt Mackall says that a common problem is running kernels with
a log low level:

Kernel command line: ro root=LABEL=/ rhgb quiet acpi=ht

so remove the "quiet" option there, or change it to "debug".

---
~Randy
