From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: return correct blkprep status code in case scsi_init_io() fails.
Date: Thu, 13 Apr 2017 22:13:02 -0400
Message-ID: <yq1r30vwxch.fsf@oracle.com>
References: <20170412072119.7529-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170412072119.7529-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Wed, 12 Apr 2017 09:21:19 +0200")
Sender: stable-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Johannes Thumshirn <jthumshirn@suse.de> writes:

> When instrumenting the SCSI layer to run into the
> !blk_rq_nr_phys_segments(rq) case the following warning emitted from
> the block layer:

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
