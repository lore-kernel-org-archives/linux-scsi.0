From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: add timer on blkdev_dequeue_request() not	elv_next_request()
Date: Thu, 30 Oct 2008 18:51:25 +0900
Message-ID: <4909839D.1020508@kernel.org>
References: <490927CD.2010205@kernel.org> <20081030072956.GL31673@kernel.dk> <49096865.2050006@kernel.org> <20081030075855.GO31673@kernel.dk> <20081030092741.GA9478@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081030092741.GA9478@linux.vnet.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> From: Mike Anderson <andmike@linux.vnet.ibm.com>
> Date: Thu, 30 Oct 2008 02:16:20 -0700
> Subject: [PATCH 1/1] blk: move blk_delete_timer call in end_that_request_last
> 
> Move the calling  blk_delete_timer to later in end_that_request_last to
> address an issue where blkdev_dequeue_request may have add a timer for the
> request.
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch definitely is necessary.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
