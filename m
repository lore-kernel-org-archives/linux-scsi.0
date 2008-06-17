From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 3] Block Layer Data Integrity
Date: Tue, 17 Jun 2008 18:57:02 +0200
Message-ID: <20080617165701.GN20851@kernel.dk>
References: <patchbomb.1213718275@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:28220 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYFQQ5G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 12:57:06 -0400
Content-Disposition: inline
In-Reply-To: <patchbomb.1213718275@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 17 2008, Martin K. Petersen wrote:
> 
> These patches allow data integrity information (checksum and more) to
> be attached to I/Os at the block/filesystem layers and transferred
> through the entire I/O stack all the way to the physical storage
> device.
> 
> The integrity metadata can be generated in close proximity to the
> original data.  Capable host adapters, RAID arrays and physical disks
> can verify the data integrity and abort I/Os in case of a mismatch.
> 
> Changes:
> 
>  - Add "if in doubt" to Kconfig
> 
>  - Make blk_rq_count_integrity_sg() more readable
> 
>  - Queue integrity sysfs fixes
> 
>  - Fix two struct bi leaks
> 
>  - Rename struct bip to bio_integrity_payload
> 
>  - Introduce bio_integrity_hw_sectors() that converts from block layer
>    (512b) sectors to hardware sectors
> 
>  - Fix kunmap_atomic() abuse
> 
>  - Replace ?: constructs with if()
> 
>  - Add __GFP_NOFAIL to bio_integrity_prep() allocation

Thanks Martin, looks good to me now. Applied to pending 2.6.27 queue.

-- 
Jens Axboe

