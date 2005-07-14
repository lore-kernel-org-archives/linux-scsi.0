From: randy_dunlap <rdunlap@xenotime.net>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Wed, 13 Jul 2005 18:57:19 -0700
Message-ID: <20050713185719.700f9ce2.rdunlap@xenotime.net>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
	<42D07E94.8070409@drzeus.cx>
	<20050709210824.29a90c5b.rdunlap@xenotime.net>
	<42D12A39.80207@drzeus.cx>
	<20050710093907.3f3c36e4.rdunlap@xenotime.net>
	<42D15968.1080101@drzeus.cx>
	<20050710105635.6d1606e3.rdunlap@xenotime.net>
	<42D17D49.1000007@drzeus.cx>
	<Pine.LNX.4.60.0507132312050.8774@poirot.grange>
	<42D5AA82.3010304@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chretien.genwebhost.com ([209.59.175.22]:18757 "EHLO
	chretien.genwebhost.com") by vger.kernel.org with ESMTP
	id S262769AbVGNB5Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 21:57:25 -0400
In-Reply-To: <42D5AA82.3010304@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

On Thu, 14 Jul 2005 01:57:54 +0200 Pierre Ossman wrote:

> Guennadi Liakhovetski wrote:
> 
> >
> >Have you managed to get netconsole running? Do you have no chance at all 
> >to use a serial console? You are, perhaps, the only / last user of dc395x 
> >on a high-mem machine, the driver is known to have a problem there, 
> >although from your dump I cannot see yet if that is indeed the problem. As 
> >someone also already suggested, you could also just try to reduce your 
> >terminal font size to fit the entire Oops on the monitor. I've tried to 
> >make a patche for the high-mem problem of dc395x, but we didn't have any 
> >testers. So, would be nice if you could help.
> >
> 
> I never got netconsole running no. And serial setup is a bit pesky. I'll
> try changing the font size when I get access to the machine again (this
> weekend).

Pierre,

I apologize for my slowness, but I finally tested netconsole (with
netcat on the receiving side) and it worked for me.

test system boots with:
netconsole=6665@192.168.1.104/eth0,6666@192.168.1.107/00:0e:35:4c:9a:0c

and the target system runs netcat (nc):
nc -l -u -p 6666


> As far as I know the machine is not a high-mem machine. It is only
> equipped with 1 GB memory. I have no intention of changing the
> SCSI-controller in that machine so I'll be glad to test any patches. Be
> warned that I don't have the machine close by though so it might take a
> day or two before I can test anything you send.


---
~Randy
