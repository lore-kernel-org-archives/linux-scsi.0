From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] scsi/sata write barrier support #2
Date: Thu, 27 Jan 2005 18:02:29 -0500
Message-ID: <41F97305.6050404@pobox.com>
References: <20050127120244.GO2751@suse.de> <20050127150845.GY2751@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:57062 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261265AbVA0XCo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2005 18:02:44 -0500
In-Reply-To: <20050127150845.GY2751@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> A few changes:
> 
> - Cleanup up the driver additions even more, blk_complete_barrier_rq()
>   does all the work now.
> 
> - Fixed up the exports
> 
> - Comment functions
> 
> - Fixed a bug with SCSI and write back caching disabled
> 
> - Rename blk_queue_flush() to blk_queue_flushing() to indicate it's a
>   state


Tiny nit for SATA drivers:

Define a ATA_ORDERED_IO constant in libata.h, rather than hardcoding the 
1 in each driver.

