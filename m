From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fix blk-mq for SPI hosts
Date: Thu, 23 Oct 2014 11:16:11 -0600
Message-ID: <544937DB.7060803@kernel.dk>
References: <1413731638-28305-1-git-send-email-hch@lst.de> <20141023084530.GB20233@infradead.org> <alpine.LRH.2.11.1410231151160.2821@adalberg.ut.ee> <20141023171454.GA16990@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56608 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaJWRQL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 13:16:11 -0400
Received: by mail-pd0-f179.google.com with SMTP id g10so686982pdj.24
        for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2014 10:16:10 -0700 (PDT)
In-Reply-To: <20141023171454.GA16990@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Meelis Roos <mroos@linux.ee>
Cc: Christoph Hellwig <hch@lst.de>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>

On 10/23/2014 11:14 AM, Christoph Hellwig wrote:
> On Thu, Oct 23, 2014 at 01:49:07PM +0300, Meelis Roos wrote:
>>> ping?
>>
>> Sorry, forgot to reply. Yes, it worked fine, on the initial Ultra 1 and 
>> additionally on Ultra 2 too.
> 
> Thanks!
> 
> Can I get a review from Jens and some SCSI developers, too?

Yes, I did read them, you can add my reviewed/acked.

> Jens, are you fine taking the blkdev.h revert through the SCSI tree?

Sure, that seems to be the easiest way to do it.

-- 
Jens Axboe

