From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Block: fix unbalanced bypass-disable in
 blk_register_queue
Date: Wed, 10 Sep 2014 01:43:16 +0900
Message-ID: <20140909164316.GA11748@mtj.dyndns.org>
References: <20140909151726.GA8890@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1409091149360.968-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409091149360.968-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Shirish Pargaonkar <shirishpargaonkar@gmail.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 09, 2014 at 11:50:58AM -0400, Alan Stern wrote:
> When a queue is registered, the block layer turns off the bypass
> setting (because bypass is enabled when the queue is created).  This
> doesn't work well for queues that are unregistered and then registered
> again; we get a WARNING because of the unbalanced calls to
> blk_queue_bypass_end().
> 
> This patch fixes the problem by making blk_register_queue() call
> blk_queue_bypass_end() only the first time the queue is registered.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Tejun Heo <tj@kernel.org>
> CC: James Bottomley <James.Bottomley@HansenPartnership.com>
> CC: Jens Axboe <axboe@kernel.dk>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
