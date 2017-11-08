From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V7 1/8] block: introduce zoned block devices zone write locking
Date: Wed, 08 Nov 2017 18:33:19 -0500
Message-ID: <yq1r2t8xs5c.fsf@oracle.com>
References: <20171108081118.7632-1-damien.lemoal@wdc.com>
        <20171108081118.7632-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108081118.7632-2-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 8 Nov 2017 17:11:11 +0900")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Damien,

> +	 * Zoned block device information for request dispatch control.
> +	 * nr_zones is the total number of zones of the device. This is always
> +	 * 0 for regular block devices. seq_zones_bitmap is a bitmap of nr_zones
> +	 * bits which indicates if a zone is conventional (bit clear) or
> +	 * sequential (bit set). seq_zones_wlock is a bitmap of nr_zones
> +	 * bits which indicates if a zone is write locked, thatt is, if a write
                                                           ^^^^^

> +	 * request targeting the zone was dispatched. All three fields are
> +	 * initialized by the low level device driver. Stacking drivers
> +	 * (device mappers) may or may not initialize these fields.
> +	 */
> +	unsigned int		nr_zones;
> +	unsigned long		*seq_zones_bitmap;
> +	unsigned long		*seq_zones_wlock;
> +
> +	/*

Otherwise OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
