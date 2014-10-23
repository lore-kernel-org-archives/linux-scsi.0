From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fix blk-mq for SPI hosts
Date: Thu, 23 Oct 2014 10:14:54 -0700
Message-ID: <20141023171454.GA16990@infradead.org>
References: <1413731638-28305-1-git-send-email-hch@lst.de>
 <20141023084530.GB20233@infradead.org>
 <alpine.LRH.2.11.1410231151160.2821@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1410231151160.2821@adalberg.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 23, 2014 at 01:49:07PM +0300, Meelis Roos wrote:
> > ping?
> 
> Sorry, forgot to reply. Yes, it worked fine, on the initial Ultra 1 and 
> additionally on Ultra 2 too.

Thanks!

Can I get a review from Jens and some SCSI developers, too?

Jens, are you fine taking the blkdev.h revert through the SCSI tree?
