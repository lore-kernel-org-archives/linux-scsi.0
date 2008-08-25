From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCHSET 3/3 blk-for-2.6.28] block: unify disk/part handling and improve ext devt, take #2
Date: Mon, 25 Aug 2008 20:34:03 +0200
Message-ID: <20080825183403.GN20055@kernel.dk>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [93.163.65.50] ([93.163.65.50]:1341 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbYHYSeG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 14:34:06 -0400
Content-Disposition: inline
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org

On Mon, Aug 25 2008, Tejun Heo wrote:
> Hello, again.
> 
> This is the second take of unify-disk-part-handling patchset.
> 
> Changes from the last take[L] are...
> 
> * adapted to blk-for-2.6.28.
> * devt alloc path simplification in 0013.

Applied all four, thanks Tejun.

-- 
Jens Axboe

