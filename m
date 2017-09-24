From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V4 06/16] block: Add zoned block device information to
        request queue
Date: Sun, 24 Sep 2017 16:59:23 +0200
Message-ID: <20170924145923.GD14806@lst.de>
References: <20170924070247.25560-1-damien.lemoal@wdc.com> <20170924070247.25560-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43504 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752629AbdIXO7Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Sep 2017 10:59:24 -0400
Content-Disposition: inline
In-Reply-To: <20170924070247.25560-7-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

> +	 * Zoned block device information for mq I/O schedulers.
> +	 * Set by low level device driver (stacking driver may not set this).
> +	 */
> +	unsigned int	nr_zones;
> +	unsigned long	*seq_zones;

Might be worth explaining the seq_zones is a bit bitmap to check
if a given zone number is sequential.

And maybe give it a name that hints at that, like seq_zone_bitmap?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
