From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH v3 5/7] block: Implement support for zoned block devices
Date: Wed, 28 Sep 2016 13:21:36 +0900
Message-ID: <6d9a2682-33f8-be5a-1f7d-d118663b0986@hgst.com>
References: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
 <1475025757-6340-6-git-send-email-damien.lemoal@hgst.com>
 <yq1d1joznjh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9896 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbcI1EVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 00:21:47 -0400
In-Reply-To: <yq1d1joznjh.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>


Martin,

On 9/28/16 12:54, Martin K. Petersen wrote:
>>>>>> "Damien" == Damien Le Moal <damien.lemoal@hgst.com> writes:
> 
> Purely cosmetic: Looks like whitespace is a bit funky (spaces instead of
> tabs several places). Also a few typos.
> 
> + * blkdev_report_zones - Get zones information
> + * @bdev:	Target block device
> + * @sector:	Sector from which to report zones
> + * @zones:      Array of zone structures where to return the zones information
> + * @nr_zones:   Number of zone structures in the zone array
> + * @gfp_mask:	Memory allocation flags (for bio_alloc)
> 
> Tabs and spaces: Together at last! ^^^^^
> 
> +	/*
> +	 * Process the report resukt: skip the header and go through the
> 
> result
> 
> +	/* Check alignement (handle eventual smaller last zone) */
> 
> alignment

Thanks for all the comments. Should I send a fixed-up series or just
send correction patches later ?

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa, 
Kanagawa, 252-0888 Japan
www.hgst.com
