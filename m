From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/16] block: allow specifying size for extra command data
Date: Tue, 24 Jan 2017 09:10:53 +0100
Message-ID: <88ce26fc-53fa-04a6-6d88-3534b3c88939@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34127 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752493AbdAXIK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Jan 2017 03:10:56 -0500
In-Reply-To: <1485185361-29786-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> This mirrors the blk-mq capabilities to allocate extra drivers-specific
> data behind struct request by setting a cmd_size field, as well as having
> a constructor / destructor for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c       | 59 ++++++++++++++++++++++++++++++++++++++++----------
>  block/blk-flush.c      |  5 ++---
>  block/blk-sysfs.c      |  7 ++++--
>  include/linux/blkdev.h |  7 ++++++
>  4 files changed, 61 insertions(+), 17 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
