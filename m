From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of
 q->prepare_flush_fn()
Date: Fri, 2 Jul 2010 16:56:29 +0900
Message-ID: <20100702165617B.fujita.tomonori@lab.ntt.co.jp>
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100702075248.GB21266@infradead.org>
	<4C2D9AFF.7010401@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39633 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0GBH4u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2010 03:56:50 -0400
In-Reply-To: <4C2D9AFF.7010401@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: hch@infradead.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 02 Jul 2010 09:53:35 +0200
Jens Axboe <axboe@kernel.dk> wrote:

> On 2010-07-02 09:52, Christoph Hellwig wrote:
> > On Fri, Jul 02, 2010 at 04:33:23PM +0900, FUJITA Tomonori wrote:
> >> We could kill q->prepare_flush_fn(). Except for ide, all the users
> >> just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
> >> do like SCSI.
> > 
> > Yes, and I think you should go all the way to kill it instead of
> > keeping both APIs around.  Otherwise the patchset looks good to me.
> 
> Fully agree, lets get rid of ->prepare_flush_fn().

Ok, I'll send patches to clean up all the users of prepare_flush_fn()
soon.
