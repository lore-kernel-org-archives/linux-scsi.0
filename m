From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 05/13] block: Export I/O topology for block devices and
	partitions
Date: Fri, 22 May 2009 09:30:51 +0200
Message-ID: <20090522073050.GH11363@kernel.dk>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-6-git-send-email-martin.petersen@oracle.com> <20090518175741.GM4140@kernel.dk> <20090518181204.GC32085@redhat.com> <yq1fxf1gi3y.fsf@sermon.lab.mkp.net> <20090519181530.GH4140@kernel.dk> <yq1ws8bealr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52539 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZEVHau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2009 03:30:50 -0400
Content-Disposition: inline
In-Reply-To: <yq1ws8bealr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, May 20 2009, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> If you repost an updated 5/13 patch and I'll add it to the mix.
> 
> block: Export I/O topology for block devices and partitions
> 
> To support devices with physical block sizes bigger than 512 bytes we
> need to ensure proper alignment.  This patch adds support for exposing
> I/O topology characteristics as devices are stacked.
> 
>   logical_block_size is the smallest unit the device can address.
> 
>   physical_block_size indicates the smallest I/O the device can write
>   without incurring a read-modify-write penalty.
> 
>   The alignment_offset parameter indicates the number of bytes the start
>   of the device/partition is offset from the device's natural alignment.
>   Partition tools and MD/DM utilities can use this to pad their offsets
>   so filesystems start on proper boundaries.
> 
>   The io_min parameter is the smallest preferred I/O size reported by
>   the device.  In many cases this is the same as the physical block
>   size.  However, the io_min parameter can be scaled up when stacking
>   (RAID5 chunk size > physical block size).
> 
>   The io_opt characteristic indicates the optimal I/O size reported by
>   the device.  This is usually the stripe width for arrays.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

I replaced the original patch and went to apply this, but it fails even
at the first patch. What is this against? If you want it queued for
2.6.31, please post it against the for-2.6.31 branch of the block repo.

-- 
Jens Axboe

