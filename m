From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of
 REQ_TYPE_BLOCK_PC
Date: Thu, 8 Jul 2010 09:40:12 +0900
Message-ID: <20100708093945R.fujita.tomonori@lab.ntt.co.jp>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
	<20100707163902.GB11837@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49864 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab0GHAko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 20:40:44 -0400
In-Reply-To: <20100707163902.GB11837@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk

On Wed, 7 Jul 2010 18:39:02 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Works for me with the OCZ SSD,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for testing!

This is purely scsi stuff but depends on block's for-2.6.36. Jens, can
you add this to your for-2.6.36?

James, you are going to create a post-merge tree?
