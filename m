From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of
 REQ_TYPE_BLOCK_PC
Date: Thu, 08 Jul 2010 09:35:55 -0500
Message-ID: <1278599755.4622.28.camel@mulgrave.site>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
	 <20100707163902.GB11837@lst.de>
	 <20100708093945R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51540 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0GHOgF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 10:36:05 -0400
In-Reply-To: <20100708093945R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, linux-scsi@vger.kernel.org, snitzer@redhat.com, axboe@kernel.dk

On Thu, 2010-07-08 at 09:40 +0900, FUJITA Tomonori wrote:
> On Wed, 7 Jul 2010 18:39:02 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Works for me with the OCZ SSD,
> > 
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks for testing!
> 
> This is purely scsi stuff but depends on block's for-2.6.36. Jens, can
> you add this to your for-2.6.36?
> 
> James, you are going to create a post-merge tree?

Well, I'm open to the idea, since it seems we need to clean up some of
the error handling a bit more ... and we could certainly do with
cleaning up the patch history, since it's rather confusing.

However, I don't quite see how to do it cleanly given the intertwining
of block and SCSI on this ... if you can suggest a good separation
point, I'd be game.

James


