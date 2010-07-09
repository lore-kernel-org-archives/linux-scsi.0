From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Fri, 9 Jul 2010 05:55:31 +0200
Message-ID: <20100709035531.GA5233@lst.de>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp> <20100707163902.GB11837@lst.de> <20100708093945R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41151 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab0GIDzw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 23:55:52 -0400
Content-Disposition: inline
In-Reply-To: <20100708093945R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk

On Thu, Jul 08, 2010 at 09:40:12AM +0900, FUJITA Tomonori wrote:
> Thanks for testing!
> 
> This is purely scsi stuff but depends on block's for-2.6.36. Jens, can
> you add this to your for-2.6.36?
> 
> James, you are going to create a post-merge tree?

Can we get this in through the block tree for now?  It's pretty simple
and keeps all the things to be tested in one place.
