From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Date: Sun, 26 Dec 2010 18:45:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1012261837450.20458@axis700.grange>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl>
 <201012241455.30430.jkrzyszt@tis.icnet.pl> <20101224154120.GH20587@n2100.arm.linux.org.uk>
 <201012250024.38576.jkrzyszt@tis.icnet.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab0LZRpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Dec 2010 12:45:05 -0500
In-Reply-To: <201012250024.38576.jkrzyszt@tis.icnet.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, linux-arch@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>, Sascha Hauer <kernel@pengutronix.de>, linux-usb@vger.kernel.org, David Brownell <dbrownell@users.sourceforge.net>, linux-media@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Catalin Marinas <catalin.marinas@arm.com>

On Sat, 25 Dec 2010, Janusz Krzysztofik wrote:

[snip]

> > Passing the virtual address allows the API to become much more
> > flexible. Not only that, it allows it to be used on ARM, rather than
> > becoming (as it currently stands) prohibited on ARM.
> >
> > I believe that putting ioremap() inside this API was the wrong thing
> > to do, and moving it outside makes the API much more flexible and
> > usable. It's something I still fully support.
> 
> Thanks, this is what I was missing, having my point of view rather my 
> machine centric, with not much wider experience. I'll quote your 
> argumentation in next iteration of this patch if required.

AFAIU, this patch is similar to the previous two attempts:

http://www.spinics.net/lists/linux-sh/msg05482.html
and
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/22271

but is even more intrusive, because those two previous attempts added new 
functions, whereas this one is modifying an existing one. Both those two 
attempts have been NACKed by FUJITA Tomonori, btw, he is not on the 
otherwise extensive CC list for this patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
