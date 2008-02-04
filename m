From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Date: Mon, 4 Feb 2008 05:12:30 -0800
Message-ID: <20080204051230.70d5b735.akpm@linux-foundation.org>
References: <20080201231147.GA18174@suse.de>
	<20080202111322.GA30767@elte.hu>
	<47A49171.2000003@garzik.org>
	<20080202170828.GA12748@elte.hu>
	<47A4A96D.2040709@garzik.org>
	<20080202175738.GA26560@elte.hu>
	<47A4BB3C.6050709@garzik.org>
	<20080202193524.GC27927@elte.hu>
	<47A4D71F.3060009@garzik.org>
	<20080204125736.GA32056@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYBDNMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 08:12:51 -0500
In-Reply-To: <20080204125736.GA32056@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, pcihpd-discuss@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Mon, 4 Feb 2008 13:57:36 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
> > Ingo Molnar wrote:
> >> so please tell me Jeff. If Greg, who is the super-maintainer of your 
> >> code area, and who deals with your code every day and changes it 
> >> every minute and hour, simply did not Cc: the SCSI list - how am i, a 
> >> largely outside party in this matter, supposed to notice that 3 
> >> maintainers and 3 mailing lists in the Cc: were somehow not enough 
> >> and that i was supposed to grow the already sizable Cc: list even 
> >> more?
> >
> > Because, regardless of the situation, it's both common courtesy and 
> > wise practice to CC relevant driver maintainers, when you touch a 
> > driver.
> >
> > And it's just common sense: Greg simply does not know the intimate 
> > details of every PCI driver.  Nor do I.  Nor you.
> >
> > In the case of lpfc here, we have an active driver maintainer, and an 
> > up-to-date MAINTAINERS entry.  Even if you are too slack to read 
> > MAINTAINERS, 'git log' would have given you the same info.
> >
> > Don't pretend there is some benefit here to ignoring the people that 
> > best know the driver.  I don't buy that; it simply makes no 
> > engineering sense whatsoever.
> 
> what you _STILL_ do not realize is the following: you still attribute 
> the lack of Cc:s to some intention of mine. No, it was not my intention. 
> At first glance the Cc: looked large and complete enough in an 
> _existing_ discussion and that's was the end of my (brief) attention 
> regarding the Cc: line. Yes, it would have been a bit better had i 
> noticed the lack of Cc:s in an existing discussion, but i didnt.

Actually I (and probably others) generally avoid cc'ing mailing lists on
patch traffic.  I spew out enough script-generated traffic as it is.

> ...
>   mailing list aliases to get the 'guaranteed attention' of maintainers 
>

whoa.  You must know better mailing lists than I do ;)

