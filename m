From: scameron@beardog.cce.hp.com
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 11:00:42 -0600
Message-ID: <20100225170042.GA30797@beardog.cce.hp.com>
References: <20100225165901.GZ30797@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:18885 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab0BYQ5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 11:57:33 -0500
Content-Disposition: inline
In-Reply-To: <20100225165901.GZ30797@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, axboe@kernel.dk

On Thu, Feb 25, 2010 at 10:59:01AM -0600, scameron@beardog.cce.hp.com wrote:
> void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_sectors)
> {
>         if (BLK_DEF_MAX_SECTORS > max_sectors)
>                 q->limits.max_hw_sectors = BLK_DEF_MAX_SECTORS;
>         else
>                 q->limits.max_hw_sectors = max_sectors;
> }
> EXPORT_SYMBOL(blk_queue_max_hw_sectors);
>
> So if you try to set max_hw_sectors to allow more than 512k via

No, I'm an idiot, nevermind.  BLK_DEF_MAX_SECTORS is the minimum.

-- steve


