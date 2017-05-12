From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Unlock zone in case of error in sd_setup_write_same_cmnd()
Date: Thu, 11 May 2017 23:12:15 -0400
Message-ID: <yq1k25mix9s.fsf@oracle.com>
References: <20170508055903.28695-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170508055903.28695-1-damien.lemoal@wdc.com> (damien lemoal's
        message of "Mon, 8 May 2017 14:59:02 +0900")
Sender: stable-owner@vger.kernel.org
To: damien.lemoal@wdc.com
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Damien,

> scsi_io_init() may fail, leaving a zone of a zoned block device locked.
> Fix this by properly unlocking the write same request target zone if
> scsi_io_init() fails.

Applied to 4.12/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
