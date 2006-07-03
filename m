From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: Kernel panic when re-inserting Adaptec PCMCIA card
Date: Mon, 3 Jul 2006 14:44:57 -0700
Message-ID: <20060703144457.0b3b4e8c.rdunlap@xenotime.net>
References: <20060614022139.21737.qmail@web50208.mail.yahoo.com>
	<20060615162912.744328ad.rdunlap@xenotime.net>
	<20060702184842.GA18192@dominikbrodowski.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:49850 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750834AbWGCVmM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2006 17:42:12 -0400
Received: from midway.site ([71.245.108.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 3 Jul 2006 14:42:10 -0700
In-Reply-To: <20060702184842.GA18192@dominikbrodowski.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: alex14641@yahoo.com, linux-scsi@vger.kernel.org, linux-pcmcia@lists.infradead.org

On Sun, 2 Jul 2006 20:48:42 +0200 Dominik Brodowski wrote:

> Hi,
> 
> On Thu, Jun 15, 2006 at 04:29:12PM -0700, Randy.Dunlap wrote:
> > It gets even worse for me.  Card ejection does not cause
> > aha152x_detach() to be called. but I don't see why not.
> > Dominik, can you give me a clue here, please?
> 
> Is aha152x bound to it in between? Also, does its ->probe() function return
> zero or not?

Hi,

What does that first question mean?
I typically remove the card and then unload the driver in my
testing.

Anyway, I upgraded to a "new" distro (open SUSE Linux 10.1).

Unfortunately, I am still seeing:
pcmcia: Detected deprecated PCMCIA ioctl usage from process: hald.

aha152x_cs ->probe() is returning 0.

I notice that when I remove the card and then rmmod the driver,
the usage count on module "pcmcia" (in lsmod) is increasing by 2
for each load/unload of aha152x_cs.  Is this due to the deprecated
ioctl usage or something else?  Actually the usage count goes up
by 3 each time that I insert the card and load the driver,
then it goes down by 1 when I remvoe the card and rmmod the driver.

Thanks,
---
~Randy
