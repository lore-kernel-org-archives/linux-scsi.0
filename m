From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libsrp: fix compile failure
Date: Mon, 4 Jan 2010 22:36:20 +0000
Message-ID: <20100104223620.4659a241@lxorguk.ukuu.org.uk>
References: <1262200866.2749.226.camel@mulgrave.site>
	<alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
	<alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz>
	<1262625721.2724.158.camel@mulgrave.site>
	<20100104173530.48690e39@lxorguk.ukuu.org.uk>
	<1262633054.4814.21.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53850 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753668Ab0ADWdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 17:33:04 -0500
In-Reply-To: <1262633054.4814.21.camel@wall-e>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefani Seibold <stefani@seibold.net>
Cc: James Bottomley <James.Bottomley@suse.de>, Jiri Kosina <jkosina@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 04 Jan 2010 20:24:14 +0100
Stefani Seibold <stefani@seibold.net> wrote:

> Am Montag, den 04.01.2010, 17:35 +0000 schrieb Alan Cox:
> > > least once before it goes to Linus.  There were originally technical
> > > reasons why -mm wasn't in ... I just thought they'd been fixed by now.
> > 
> > No - mm also caused problems with the kfifo merge of a core API change
> > that didn't go via -next.
> > 
> > Alan
> 
> I tried my best to port everything to the new kfifo API. But it was not
> possible to check it against every architecture. x86 and x86_64 was
> compile clean. I think the missing #include was not a big thing.

Not your fault - -next is there so stuff is visible for merging and to
avoid collisions. Andrew not going via -next broke various pending
patches.

Conversion is easy enough, it just wasn't visible at the right time. 

