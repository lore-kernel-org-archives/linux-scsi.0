From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [14/20] Don't disable direct_io for unchecked_isa_dma  in st.c
Date: Mon, 17 Mar 2008 09:27:30 +0100
Message-ID: <20080317082730.GC17940@kernel.dk>
References: <20080307653.720459648@firstfloor.org> <20080307175414.08C981B41AE@basil.firstfloor.org> <20080314135135.GT17940@kernel.dk> <20080314142412.GA30325@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:15712 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbYCQI1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 04:27:33 -0400
Content-Disposition: inline
In-Reply-To: <20080314142412.GA30325@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Mar 14 2008, Christoph Hellwig wrote:
> On Fri, Mar 14, 2008 at 02:51:35PM +0100, Jens Axboe wrote:
> > Are you sure? Seems to me that st builds its own list with
> > get_user_pages() for direct io, where will that get bounced? The block
> > layer will only bounce things that are mapped directly, so if st used
> > blk_rq_map_kern() and inserted that request in the queue, we could
> > proceed with killing that check in st.
> 
> Which shouldn't be all too difficult and would be the right thing to
> do.  We really need someone to sit down and convert st/osst/sg to use
> the proper block layer helpers.

Right, I'm just saying that it currently will not work!

-- 
Jens Axboe

