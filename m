From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 7/7] blk-zoned: implement ioctls
Date: Wed, 28 Sep 2016 01:03:27 -0400
Message-ID: <yq14m50zkdc.fsf@sermon.lab.mkp.net>
References: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
        <1475025757-6340-8-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18930 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbcI1FDn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 01:03:43 -0400
In-Reply-To: <1475025757-6340-8-git-send-email-damien.lemoal@hgst.com> (Damien
        Le Moal's message of "Wed, 28 Sep 2016 10:22:37 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@hgst.com> writes:

Damien> Adds the new BLKREPORTZONE and BLKRESETZONE ioctls for
Damien> respectively obtaining the zone configuration of a zoned block
Damien> device and resetting the write pointer of sequential zones of a
Damien> zoned block device.

Damien> The BLKREPORTZONE ioctl maps directly to a single call of the
Damien> function blkdev_report_zones. The zone information result is
Damien> passed as an array of struct blk_zone identical to the structure
Damien> used internally for processing the REQ_OP_ZONE_REPORT operation.
Damien> The BLKRESETZONE ioctl maps to a single call of the
Damien> blkdev_reset_zones function.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
