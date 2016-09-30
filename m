From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 5/7] block: Implement support for zoned block devices
Date: Thu, 29 Sep 2016 22:05:37 -0400
Message-ID: <yq160peuopa.fsf@sermon.lab.mkp.net>
References: <1475052339-10202-1-git-send-email-damien.lemoal@hgst.com>
        <1475052339-10202-6-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26576 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935362AbcI3CFt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2016 22:05:49 -0400
In-Reply-To: <1475052339-10202-6-git-send-email-damien.lemoal@hgst.com>
        (Damien Le Moal's message of "Wed, 28 Sep 2016 17:45:37 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@hgst.com> writes:

Damien> Implement zoned block device zone information reporting and
Damien> reset.  Zone information are reported as struct blk_zone. This
Damien> implementation does not differentiate between host-aware and
Damien> host-managed device models and is valid for both. Two functions
Damien> are provided: blkdev_report_zones for discovering the zone
Damien> configuration of a zoned block device, and blkdev_reset_zones
Damien> for resetting the write pointer of sequential zones. The helper
Damien> function blk_queue_zone_size and bdev_zone_size are also
Damien> provided for, as the name suggest, obtaining the zone size (in
Damien> 512B sectors) of the zones of the device.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
