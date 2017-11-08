From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V7 8/8] scsi: sd_zbc: Fix zone information initialization
Date: Wed, 08 Nov 2017 18:46:04 -0500
Message-ID: <yq1wp30wczn.fsf@oracle.com>
References: <20171108081118.7632-1-damien.lemoal@wdc.com>
        <20171108081118.7632-9-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108081118.7632-9-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 8 Nov 2017 17:11:18 +0900")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Damien,

> Make sure that the device request queue zone information (number of
> zones and zone bitmaps) are reinitialized if the number of zones
> changes (e.g. on a drive capacity change on revalidate).

This should probably be part of patch 6.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
