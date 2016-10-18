From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v8 2/7] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Tue, 18 Oct 2016 12:43:01 -0400
Message-ID: <x49funtvca2.fsf@segfault.boston.devel.redhat.com>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
        <1476772835-18541-3-git-send-email-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754743AbcJRQnG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 12:43:06 -0400
In-Reply-To: <1476772835-18541-3-git-send-email-damien.lemoal@wdc.com> (Damien
        Le Moal's message of "Tue, 18 Oct 2016 15:40:30 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>

Damien Le Moal <damien.lemoal@wdc.com> writes:

> diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
> index 75a5055..ee2d5cd 100644
> --- a/Documentation/ABI/testing/sysfs-block
> +++ b/Documentation/ABI/testing/sysfs-block
> @@ -251,3 +251,16 @@ Description:
>  		since drive-managed zoned block devices do not support
>  		zone commands, they will be treated as regular block
>  		devices and zoned will report "none".
> +
> +What:		/sys/block/<disk>/queue/chunk_sectors
> +Date:		September 2016
> +Contact:	Hannes Reinecke <hare@suse.com>
> +Description:
> +		chunk_sectors has different meaning depending on the type
> +		of the disk. For a RAID device (dm-raid), chunk_sectors
> +		indicates the size in 512B sectors of the RAID volume
> +		stripe segment. For a zoned block device, either
> +		host-aware or host-managed, chunk_sectors indicates the
> +		size of 512B sectors of the zones of the device, with
                     ^^
                     in
