From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] Use blist_flags_t consistently
Date: Tue, 12 Dec 2017 08:52:08 +0100
Message-ID: <20171212075208.GA32670@lst.de>
References: <20171212000803.5989-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57673 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751434AbdLLHwK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 02:52:10 -0500
Content-Disposition: inline
In-Reply-To: <20171212000803.5989-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On Mon, Dec 11, 2017 at 04:08:03PM -0800, Bart Van Assche wrote:
> +		if (!((__force unsigned int)sdev->sdev_bflags & BIT(i)))

I'd case the right side argument to  __force blist_flags_t here for
purely esthetic reasons.

Except for that this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
