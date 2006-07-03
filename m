From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Kernel panic when re-inserting Adaptec PCMCIA card
Date: Mon, 3 Jul 2006 15:13:39 -0700 (PDT)
Message-ID: <20060703221339.97025.qmail@web50201.mail.yahoo.com>
References: <20060703144457.0b3b4e8c.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web50201.mail.yahoo.com ([206.190.38.42]:7003 "HELO
	web50201.mail.yahoo.com") by vger.kernel.org with SMTP
	id S1751113AbWGCWNk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jul 2006 18:13:40 -0400
In-Reply-To: <20060703144457.0b3b4e8c.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>, Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-scsi@vger.kernel.org, linux-pcmcia@lists.infradead.org

[snip]
> Hi,
> 
> What does that first question mean?
> I typically remove the card and then unload the driver in my
> testing.
> 
> Anyway, I upgraded to a "new" distro (open SUSE Linux 10.1).
> 
FWIW, I'm running Slackware 10.2. I had to install pcmciautils 0.14 myself.

> Unfortunately, I am still seeing:
> pcmcia: Detected deprecated PCMCIA ioctl usage from process: hald.
> 
> aha152x_cs ->probe() is returning 0.
> 
> I notice that when I remove the card and then rmmod the driver,
> the usage count on module "pcmcia" (in lsmod) is increasing by 2
> for each load/unload of aha152x_cs.  Is this due to the deprecated
> ioctl usage or something else?  Actually the usage count goes up
> by 3 each time that I insert the card and load the driver,
> then it goes down by 1 when I remvoe the card and rmmod the driver.
> 
> Thanks,
> ---
> ~Randy
> 


I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
