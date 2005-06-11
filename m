From: Pavel Machek <pavel@suse.cz>
Subject: Re: DMA mapping (was Re: [PATCH] cciss 2.6; replaces DMA masks with kernel defines)
Date: Sat, 11 Jun 2005 17:39:07 +0200
Message-ID: <20050611153907.GA2002@elf.ucw.cz>
References: <20050610143453.GA26476@beardog.cca.cpqcorp.net> <42A9C60E.3080604@pobox.com> <1118436000.6423.42.camel@mindpipe> <1118436306.5272.37.camel@laptopd505.fenrus.org> <1118438253.6423.72.camel@mindpipe> <20050610213003.GI24611@parcelfarce.linux.theplanet.co.uk> <1118445434.6423.133.camel@mindpipe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1764 "EHLO amd.ucw.cz")
	by vger.kernel.org with ESMTP id S261393AbVFKPjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 11:39:44 -0400
Content-Disposition: inline
In-Reply-To: <1118445434.6423.133.camel@mindpipe>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Revell <rlrevell@joe-job.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, mike.miller@hp.com, akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi!

> > I know of two others ...
> > 
> > sym2 has:
> > #define DMA_DAC_MASK    0x000000ffffffffffULL /* 40-bit */
> > 
> > and aic7xxx has:
> >         const uint64_t   mask_39bit = 0x7FFFFFFFFFULL;
> > 
> > Would you mind respinning your patch to include these?
> > 
> 
> I'm grepping the drivers, and what a mess.  This will be a nice cleanup.
> 
> Why would someone use 0xFFFFffff?

To make it easier to count Fs?
									Pavel
