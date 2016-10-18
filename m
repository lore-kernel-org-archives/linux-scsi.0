From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v8 6/7] sd: Implement support for ZBC devices
Date: Tue, 18 Oct 2016 12:58:11 -0400
Message-ID: <x498ttlvbks.fsf@segfault.boston.devel.redhat.com>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
        <1476772835-18541-7-git-send-email-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933242AbcJRQ6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 12:58:13 -0400
In-Reply-To: <1476772835-18541-7-git-send-email-damien.lemoal@wdc.com> (Damien
        Le Moal's message of "Tue, 18 Oct 2016 15:40:34 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>

Damien Le Moal <damien.lemoal@wdc.com> writes:

> +	if (!is_power_of_2(zone_blocks)) {
> +		if (sdkp->first_scan)
> +			sd_printk(KERN_NOTICE, sdkp,
> +				  "Devices with non power of 2 zone "
> +				  "size are not supported\n");
> +		return -ENODEV;
> +	}

Are power of 2 zone sizes required by the standard?  I see why you've
done this, but I wonder if we're artificially limiting the
implementation, and whether there will be valid devices on the market
that simply won't work with Linux because of this.

-Jeff
