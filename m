From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: reduce CONFIG_SCSI_CONSTANTS impact by 4k
Date: Sun, 4 Oct 2015 01:02:17 -0700
Message-ID: <20151004080217.GA22816@infradead.org>
References: <87h9mbg6h1.fsf@rasmusvillemoes.dk>
 <20151003171437.GA20847@infradead.org>
 <87bncf1u4p.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbJDICV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Oct 2015 04:02:21 -0400
Content-Disposition: inline
In-Reply-To: <87bncf1u4p.fsf@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Oct 04, 2015 at 12:09:58AM +0200, Rasmus Villemoes wrote:
> On Sat, Oct 03 2015, Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Hi Rasmus,
> >
> > I like this idea.  But maybe it's also time to just move the constants
> > to a plain text file and auto-generate C headers from them?  That way
> > the format in which they can be edited is decoupled from the
> > representation in the kernel image.
> 
> Well, I don't really have an opinion on that part.
> 
> In the meantime, I got another idea for doubling the saving to 8k. It
> requires a few more code changes and is perhaps also more hacky. 2/2
> would be something like below. Please let me know which version you'd
> prefer, and I'll send both patches properly.

I don't think the new version is too bad, and the saving is impressive.
So I'd opt for the new one.
