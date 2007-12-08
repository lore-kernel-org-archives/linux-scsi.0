From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Recent sym53c8xx patches
Date: Fri, 07 Dec 2007 20:45:37 -0600
Message-ID: <1197081937.4911.2.camel@localhost.localdomain>
References: <474C2F0C.6030303@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:56683
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbXLHCxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 21:53:22 -0500
In-Reply-To: <474C2F0C.6030303@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, jejb@kernel.org, hch@infradead.org


On Tue, 2007-11-27 at 09:51 -0500, Tony Battersby wrote:
> Hello,
> 
> I am sending this message to check up on the merge status of my recent
> sym53c8xx patches to make sure they aren't forgotten.  Matthew Wilcox,
> could you give an ack/nak for these merge requests?  Also, please let me
> know if I need to do anything else (such as resending later) to make
> sure these patches get merged.
> 
> [PATCH] [SCSI] sym53c8xx: fix free_irq() regression in 2.6.24
> http://marc.info/?t=119438263300007&r=1&w=4
> Regression fix.  Should be merged in 2.6.24.  OK'ed by Christoph Hellwig.
> 
> [PATCH] [SCSI] sym53c8xx: fix resid calculation
> http://marc.info/?l=linux-scsi&m=119438360705773&w=4
> Bug fix.  I would like it to be merged in 2.6.24.  No replies to initial
> message.

These two I have flagged for inclusion.

> [PATCH] [SCSI] sym53c8xx: don't flood syslog with negotiation messages
> http://marc.info/?l=linux-scsi&m=119446914818689&w=4
> More an annoyance fix than a bug fix.  Probably safe to merge for
> 2.6.24, but could wait for 2.6.25 if someone objects.  No replies to
> initial message.

This one I'd like to wait on maintainer feedback

> [PATCH] [SCSI] sym53c8xx: fix setflag user command to control disconnects
> http://marc.info/?l=linux-scsi&m=119446790116497&w=4
> Fix for long-broken not-widely-used feature.  Can be dropped if the
> disconnect attribute will be added to the SPI transport class in the
> near future.  Is anyone working on this BTW?

This one, I was sort of expecting, since you want the feature that you'd
add it to the transport class ...

> [PATCH] [SCSI] sym53c8xx: increase sg_tablesize for larger data transfers
> http://marc.info/?l=linux-scsi&m=119513922112712&w=4
> Enhancement.  On hold for the moment due to speculation that it may
> break some 875 chips.

I'd like more feedback, but sometimes the best way of testing things
like this is to stick it in the field and see if it breaks something.

James


