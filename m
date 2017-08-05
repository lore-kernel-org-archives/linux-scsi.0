From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_dh_alua: suppress errors from unsupported devices
Date: Sat, 5 Aug 2017 13:35:23 +0200
Message-ID: <20170805113523.GC16313@lst.de>
References: <1501828660-89497-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34035 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751226AbdHELfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 5 Aug 2017 07:35:24 -0400
Content-Disposition: inline
In-Reply-To: <1501828660-89497-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>  	error = scsi_dh_add_device(sdev);
> -	if (error)
> -		/*
> -		 * device_handler is optional, so any error can be ignored
> -		 */
> -		sdev_printk(KERN_INFO, sdev,
> -				"failed to add device handler: %d\n", error);
> +	/* device_handler is optional, so any error can be ignored */

In that case it should return void.
