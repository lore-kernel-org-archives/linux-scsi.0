From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sd: don't crash the host on invalid commands
Date: Tue, 25 Sep 2018 20:52:58 -0400
Message-ID: <yq1tvmdgjv9.fsf@oracle.com>
References: <20180921070101.9260-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921070101.9260-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Fri, 21 Sep 2018 09:01:01 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> When sd_init_command() get's a with a unknown req_op() it crashes the
> system via BUG().
>
> This makes debugging the actual reason for the broken request
> cmd_flags pretty hard as the system is down before it's able to write
> out debugging data on the serial console or the trace buffer.
>
> Change the BUG() to a WARN_ON() and return BLKPREP_KILL to fail
> gracefully and return an I/O error to the producer of the request.

Looks like a bunch of my merge mails didn't make it out last week.

For the record, I did merge this into 4.19/scsi-fixes and it has made
its way upstream.

-- 
Martin K. Petersen	Oracle Linux Engineering
