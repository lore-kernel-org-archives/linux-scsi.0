From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: add timer on blkdev_dequeue_request() not elv_next_request()
Date: Thu, 30 Oct 2008 16:55:17 +0900
Message-ID: <49096865.2050006@kernel.org>
References: <490927CD.2010205@kernel.org> <20081030072956.GL31673@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081030072956.GL31673@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> That's actually a pretty dumb error, I'm surprised it hasn't reared its
> ugly face in more ways. Presumably because the timeout is usually so
> long, that we'll get to actually issuing and completing it within the
> normal timeout anyway.

Heh... it showed its ugly face in many different ways while I was
playing with PMP connected via a very long eSATA cable.

Thanks.  :-)

-- 
tejun
