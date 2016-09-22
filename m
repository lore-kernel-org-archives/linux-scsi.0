From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Avoid that toggling use_blk_mq triggers a memory leak
Date: Fri, 23 Sep 2016 01:42:35 +0200
Message-ID: <20160922234235.GA27834@lst.de>
References: <e76485aa-8e04-c6a7-8bcb-67b2ae569a60@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35558 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933539AbcIVXmi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Sep 2016 19:42:38 -0400
Content-Disposition: inline
In-Reply-To: <e76485aa-8e04-c6a7-8bcb-67b2ae569a60@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Yes, that's indeed an issue that popped up when removing the per-host
flag.

Reviewed-by: Christoph Hellwig <hch@lst.de>
