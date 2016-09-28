From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 5/7] block: Implement support for zoned block devices
Date: Tue, 27 Sep 2016 23:54:58 -0400
Message-ID: <yq1d1joznjh.fsf@sermon.lab.mkp.net>
References: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
        <1475025757-6340-6-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1475025757-6340-6-git-send-email-damien.lemoal@hgst.com> (Damien
        Le Moal's message of "Wed, 28 Sep 2016 10:22:35 +0900")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Damien" == Damien Le Moal <damien.lemoal@hgst.com> writes:

Purely cosmetic: Looks like whitespace is a bit funky (spaces instead of
tabs several places). Also a few typos.

+ * blkdev_report_zones - Get zones information
+ * @bdev:	Target block device
+ * @sector:	Sector from which to report zones
+ * @zones:      Array of zone structures where to return the zones information
+ * @nr_zones:   Number of zone structures in the zone array
+ * @gfp_mask:	Memory allocation flags (for bio_alloc)

Tabs and spaces: Together at last! ^^^^^

+	/*
+	 * Process the report resukt: skip the header and go through the

result

+	/* Check alignement (handle eventual smaller last zone) */

alignment

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
