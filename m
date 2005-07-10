From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Sun, 10 Jul 2005 21:55:53 +0200
Message-ID: <42D17D49.1000007@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>	<42D07E94.8070409@drzeus.cx>	<20050709210824.29a90c5b.rdunlap@xenotime.net>	<42D12A39.80207@drzeus.cx>	<20050710093907.3f3c36e4.rdunlap@xenotime.net>	<42D15968.1080101@drzeus.cx> <20050710105635.6d1606e3.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:3456 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S262091AbVGJTzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 15:55:55 -0400
In-Reply-To: <20050710105635.6d1606e3.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy_dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

randy_dunlap wrote:

>Are you using netcat on the receive side?
>
>  
>

I've been using tcpdump and not a single packet eminates from the
machine when printk:s show up.

>Matt Mackall says that a common problem is running kernels with
>a log low level:
>
>Kernel command line: ro root=LABEL=/ rhgb quiet acpi=ht
>
>so remove the "quiet" option there, or change it to "debug".
>  
>

Tried with 'debug' and nothing at all. No effect. I also messed around
with the 'printk' setting in /proc/sys/kernel. Netconsole simply doesn't
like me. :(

Perhaps I'm misunderstanding the scope of netconsole. Is it supposed to
send out everything I can see with 'dmesg' or just panics?

Rgds
Pierre

