From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Wed, 13 Jul 2005 23:16:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0507132312050.8774@poirot.grange>
References: <20050709175725.75f291bf.rdunlap@xenotime.net> <42D07E94.8070409@drzeus.cx>
 <20050709210824.29a90c5b.rdunlap@xenotime.net> <42D12A39.80207@drzeus.cx>
 <20050710093907.3f3c36e4.rdunlap@xenotime.net> <42D15968.1080101@drzeus.cx>
 <20050710105635.6d1606e3.rdunlap@xenotime.net> <42D17D49.1000007@drzeus.cx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:4020 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261330AbVGMVWt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 17:22:49 -0400
In-Reply-To: <42D17D49.1000007@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: randy_dunlap <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org

Hi

On Sun, 10 Jul 2005, Pierre Ossman wrote:

> randy_dunlap wrote:
> 
> >Are you using netcat on the receive side?
> 
> I've been using tcpdump and not a single packet eminates from the
> machine when printk:s show up.

Have you managed to get netconsole running? Do you have no chance at all 
to use a serial console? You are, perhaps, the only / last user of dc395x 
on a high-mem machine, the driver is known to have a problem there, 
although from your dump I cannot see yet if that is indeed the problem. As 
someone also already suggested, you could also just try to reduce your 
terminal font size to fit the entire Oops on the monitor. I've tried to 
make a patche for the high-mem problem of dc395x, but we didn't have any 
testers. So, would be nice if you could help.

Thanks
Guennadi

> 
> >Matt Mackall says that a common problem is running kernels with
> >a log low level:
> >
> >Kernel command line: ro root=LABEL=/ rhgb quiet acpi=ht
> >
> >so remove the "quiet" option there, or change it to "debug".
> >  
> >
> 
> Tried with 'debug' and nothing at all. No effect. I also messed around
> with the 'printk' setting in /proc/sys/kernel. Netconsole simply doesn't
> like me. :(
> 
> Perhaps I'm misunderstanding the scope of netconsole. Is it supposed to
> send out everything I can see with 'dmesg' or just panics?
> 
> Rgds
> Pierre
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski
