From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of
 REQ_TYPE_BLOCK_PC
Date: Fri, 9 Jul 2010 13:42:21 +0900
Message-ID: <20100709134051K.fujita.tomonori@lab.ntt.co.jp>
References: <20100707163902.GB11837@lst.de>
	<20100708093945R.fujita.tomonori@lab.ntt.co.jp>
	<20100709035531.GA5233@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60096 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab0GIEms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2010 00:42:48 -0400
In-Reply-To: <20100709035531.GA5233@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk

On Fri, 9 Jul 2010 05:55:31 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Jul 08, 2010 at 09:40:12AM +0900, FUJITA Tomonori wrote:
> > Thanks for testing!
> > 
> > This is purely scsi stuff but depends on block's for-2.6.36. Jens, can
> > you add this to your for-2.6.36?
> > 
> > James, you are going to create a post-merge tree?
> 
> Can we get this in through the block tree for now?  It's pretty simple
> and keeps all the things to be tested in one place.

I prefer that too, merging the discard changes and REQ_TYPE_FS
conversion via the block. That could be a reasonable separation
point. However, I suspect that merging all the core scsi changes (that
is, except for driver updates) via the block tree in the next merge
window might be easier.


