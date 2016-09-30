From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 2/7] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Thu, 29 Sep 2016 22:02:31 -0400
Message-ID: <yq1inteuoug.fsf@sermon.lab.mkp.net>
References: <1475052339-10202-1-git-send-email-damien.lemoal@hgst.com>
        <1475052339-10202-3-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1475052339-10202-3-git-send-email-damien.lemoal@hgst.com>
        (Damien Le Moal's message of "Wed, 28 Sep 2016 17:45:34 +0900")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Damien" == Damien Le Moal <damien.lemoal@hgst.com> writes:

Damien> From: Hannes Reinecke <hare@suse.de> The queue limits already
Damien> have a 'chunk_sectors' setting, so we should be presenting it
Damien> via sysfs.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
