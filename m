From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/2] older SG interface fixes (for the block layer conversion)
Date: Tue, 2 Sep 2008 09:31:26 +0200
Message-ID: <20080902073125.GY20055@kernel.dk>
References: <1220340020-4855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:51429 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbYIBHba (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 03:31:30 -0400
Content-Disposition: inline
In-Reply-To: <1220340020-4855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jpy

On Tue, Sep 02 2008, FUJITA Tomonori wrote:
> I messed up the older SG interface's READ commands.
> 
> With READ commands via the older SG interface, we don't know a
> user-space address to transfer the result data when executing a SCSI
> command. So we can't pass a user-space address to blk_rq_map_user.
> 
> This changes blk_rq_map_user to takes a NULL user-space address. That
> is, sg uses blk_rq_map_user to just set up a request and bios with
> page frames without data transfer (similar to what scsi_req_map_sg
> does for sg now).
> 
> blk_rq_map_user doesn't map a user space address so the name,
> blk_rq_map_user, might be odd but I leave it alone.

Applied

-- 
Jens Axboe

