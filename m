From: Mike Galbraith <efault@gmx.de>
Subject: Re: regression: CD burning (k3b) went broke
Date: Wed, 27 Feb 2008 03:58:48 +0100
Message-ID: <1204081128.26640.20.camel@homer.simson.net>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
	 <1203752563.5225.4.camel@homer.simson.net>
	 <1203839683.17463.9.camel@homer.simson.net>
	 <1204019283.8731.11.camel@homer.simson.net>
	 <1204033003.11828.22.camel@homer.simson.net>
	 <20080226150845.2196bc1a.akpm@linux-foundation.org>
	 <47C4B2D4.109@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47C4B2D4.109@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 2008-02-26 at 19:46 -0500, Jeff Garzik wrote:

> I would love to get an answer as to what data_len (and of course 
> raw_data_len) should be set to AFTER the command completes, which is 
> what is going on here.

Yeah, blk_complete_sghdr_rq() used to do hdr->resid = irq->data_len,
which is modified down lower.  How/where that hdr->resid percolates back
up, and turns into a retry/nogo, I don't know.

	-Mike

