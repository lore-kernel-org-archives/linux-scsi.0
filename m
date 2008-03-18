From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Tue, 18 Mar 2008 08:26:25 +0100
Message-ID: <20080318072624.GT17940@kernel.dk>
References: <20080314134814.GS17940@kernel.dk> <20080314135945.GO2522@one.firstfloor.org> <20080317082711.GB17940@kernel.dk> <20080317083603.GJ27015@one.firstfloor.org> <20080317083832.GE17940@kernel.dk> <20080317085341.GK27015@one.firstfloor.org> <20080317202931.GO17940@kernel.dk> <20080317204548.GB10846@one.firstfloor.org> <20080317204634.GQ17940@kernel.dk> <20080317213422.GA11966@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:22729 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbYCRH01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 03:26:27 -0400
Content-Disposition: inline
In-Reply-To: <20080317213422.GA11966@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Mon, Mar 17 2008, Andi Kleen wrote:
> > Look further down in the email, queue_bounce_to_mask() or whatever you
> > would want to call it. As also written there, the PRINCIPLE is the same.
> > And that is that exporting a to_allocator_mask() helper is a lot saner
> > than exporting an allocator api tied to the queue.
> > 
> > Can we get over this, please?
> 
> Ok it would have helped if you had explained why it is saner, but I 
> bow to your superior experience on block layer issues.

Do I detect just a touch of sarcasm there? Andi, I have in (approx) 4
emails explained why I think it is saner. It's even right there, above
your own text here. I'm not sure how much more I can say...

> The only open issue is right now if it isn't better to go back
> for automatic bouncing for SCSI scan and the other users. Do you
> have an opinion on that too? If you have one can you please convince
> James of it too.

Sure, I also wrote that in several emails - I'm fine with bouncing for
the scanning, it's not a big deal imho. I can see why James may not like
it so much since we can fairly easily avoid the bounce, but as I wrote
in the previous email, I think that doing a bit of bounce there may not
be such a bad idea after all.

-- 
Jens Axboe

