From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libsrp: fix compile failure
Date: Mon, 4 Jan 2010 13:35:55 -0800
Message-ID: <20100104133555.d5231884.akpm@linux-foundation.org>
References: <1262200866.2749.226.camel@mulgrave.site>
	<alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
	<alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz>
	<1262625721.2724.158.camel@mulgrave.site>
	<alpine.LNX.2.00.1001042206340.2277@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab0ADVgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 16:36:21 -0500
In-Reply-To: <alpine.LNX.2.00.1001042206340.2277@pobox.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: James Bottomley <James.Bottomley@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, Stefani Seibold <stefani@seibold.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>

On Mon, 4 Jan 2010 22:12:26 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> 
> [ added Stephen to CC ]
> 
> On Mon, 4 Jan 2010, James Bottomley wrote:
> 
> > Well, the fact that the compile failure wasn't detected before it went 
> > upstream should answer that ...
> > 
> > But to be more specific: linux-next is our integration tree (and also
> > the obscure architecture compile tree).  To ensure the best possible
> > integration, every tree should be built and tested in linux-next at
> > least once before it goes to Linus.  There were originally technical
> > reasons why -mm wasn't in ... I just thought they'd been fixed by now.
> 
> /me checks ...
> 
> Yes, it indeed is that way -- Andew pulls whole linux-next as one of the 
> patches into -mm series.
> 
> To make linux-next really working the way it is intended to work we need 
> to have -mm part of it, as it is used as a last point for a non-trivial 
> amount of patches before they enter Linus' tree.
> 
> Andrew, why do we have the current setup, and not the other way around?
> 

Because I suck.  I haven't yet got around to feeding -mm into
linux-next.  It's a bit tricky, because -mm is based on linux-next. 
Probably we'll address this by adding a "linux-next before the mm bits"
marker to linux-next.

