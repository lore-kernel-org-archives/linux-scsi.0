From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 07 Dec 2007 22:19:43 +0100
Message-ID: <1197062383.5483.46.camel@lov.site>
References: <20071207145526.B561CDBA2@gherkin.frus.com>
	 <4759B06F.60108@orcon.net.nz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:59861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbXLGVUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 16:20:14 -0500
In-Reply-To: <4759B06F.60108@orcon.net.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Cree <mcree@orcon.net.nz>
Cc: Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com

On Sat, 2007-12-08 at 09:43 +1300, Michael Cree wrote:
> Bob Tracy wrote:
> > That was quick :-).  Backing out the sysctl_check.c diff gives me a
> > working kernel.  Beats the #$%@! out of me how/why, though.
> > 
> > Michael Cree: could you try backing out the diff below from your
> > 2.6.24-rc3 tree and see if things are now working for you?
> 
> Yes (conference is now over).  I backed out the sysctl_check patch from 
> 2.6.24-rc3 and, indeed, got a working kernel.
> 
> The working kernel (was probably 2.6.24-rc3 less sysctl_check patch, but 
> might have been a 2.6.23 variant) has the following in /sys/block

> alpha:~# grep . /sys/block/sda/*/dev
> /sys/block/sda/sda1/dev:8:1
> /sys/block/sda/sda2/dev:8:2
> /sys/block/sda/sda3/dev:8:3
> /sys/block/sda/sda4/dev:8:4
> /sys/block/sda/sda5/dev:8:5
> 
> I failed to spot any difference (other than the formatting of the dates) 
> between the two!

Yeah, that looks all fine.

What distro is that, and what's the udev version?

You are booting your kernel with an initramfs?

Is the udev daemon (still) running while it fails?

If you run /sbin/udevtrigger, do the nodes appear?

Kay

