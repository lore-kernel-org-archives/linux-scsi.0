From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Mon, 17 Mar 2008 21:46:34 +0100
Message-ID: <20080317204634.GQ17940@kernel.dk>
References: <20080307175408.E290E1B41AE@basil.firstfloor.org> <1205445980.2893.85.camel@localhost.localdomain> <20080314134814.GS17940@kernel.dk> <20080314135945.GO2522@one.firstfloor.org> <20080317082711.GB17940@kernel.dk> <20080317083603.GJ27015@one.firstfloor.org> <20080317083832.GE17940@kernel.dk> <20080317085341.GK27015@one.firstfloor.org> <20080317202931.GO17940@kernel.dk> <20080317204548.GB10846@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:4013 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYCQUqj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 16:46:39 -0400
Content-Disposition: inline
In-Reply-To: <20080317204548.GB10846@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Mon, Mar 17 2008, Andi Kleen wrote:
> > The queue_to_gfp_mask() would make that conversion equally simple.
> 
> Except that there is no gfp for this in the mask allocator world.
> If I wanted to stay with GFPs i would have never attempted any
> of this in the first place.

Look further down in the email, queue_bounce_to_mask() or whatever you
would want to call it. As also written there, the PRINCIPLE is the same.
And that is that exporting a to_allocator_mask() helper is a lot saner
than exporting an allocator api tied to the queue.

Can we get over this, please?

-- 
Jens Axboe

