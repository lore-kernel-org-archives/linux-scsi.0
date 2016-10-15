From: Hannes Reinecke <hare@suse.de>
Subject: Re: expose queue the queue mapping for SCSI drivers
Date: Sat, 15 Oct 2016 13:45:32 +0200
Message-ID: <92ed9a0b-9fde-5062-7cfc-7d8c67e32617@suse.de>
References: <1476521241-32765-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55504 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752691AbcJOLpf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 Oct 2016 07:45:35 -0400
In-Reply-To: <1476521241-32765-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com, don.brace@microsemi.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On 10/15/2016 10:47 AM, Christoph Hellwig wrote:
> In 4.9 I've added support in the interrupt layer to automatically
> assign the interrupt affinity at interrupt allocation time, and
> expose that information to blk-mq.
>
> This series extents that so that SCSI driver can pass on the information
> as well.  The SCSI part is fairly trivial, although we need to also
> export the default queue mapping function in blk-mq to keep things simple.
>
> I've also converted over the smartpqi driver as an example as it's the
> easiest of the multiqueue SCSI drivers to convert.  I don't actually
> have smartpqi hardware, so that part will need additionaly testing.
>
> (I've tested it with virtio_scsi, but that requires a lot of virtio
>  changes not ready to post yet)
>
Very nice.
I've recently looked into exposing the multiqueue settings for 
fcoe/ixgbe, and figured that the SCSI part was indeed missing.
Thanks for doing this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
