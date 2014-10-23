From: Meelis Roos <mroos@linux.ee>
Subject: Re: fix blk-mq for SPI hosts
Date: Thu, 23 Oct 2014 13:49:07 +0300 (EEST)
Message-ID: <alpine.LRH.2.11.1410231151160.2821@adalberg.ut.ee>
References: <1413731638-28305-1-git-send-email-hch@lst.de> <20141023084530.GB20233@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:39402 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbaJWKtL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2014 06:49:11 -0400
In-Reply-To: <20141023084530.GB20233@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>

> ping?

Sorry, forgot to reply. Yes, it worked fine, on the initial Ultra 1 and 
additionally on Ultra 2 too.

> On Sun, Oct 19, 2014 at 05:13:56PM +0200, Christoph Hellwig wrote:
> > Fix the assumption that we can treat all blk-mq requests as tagged.  For
> > traditional SCSI that's wrong, as being tagged has a very explicit meaning
> > on the wire.
> > 
> > This is a little bit different from the version Meelis tested earlier, but
> > the concept is the same.  I didn't want to add a Tested-by tag as it's
> > different enough, though.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> 

-- 
Meelis Roos (mroos@linux.ee)
