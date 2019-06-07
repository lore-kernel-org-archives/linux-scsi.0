From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: properly communicate queue limits to the DMA layer
Date: Fri, 07 Jun 2019 13:30:30 -0400
Message-ID: <yq1o939i9qh.fsf@oracle.com>
References: <20190605190836.32354-1-hch@lst.de>
        <591cfa1e-fecb-7d00-c855-3b9eb8eb8a2a@kernel.dk>
        <20190605192405.GA18243@lst.de>
        <f07d0abf-b3eb-f530-37b9-e66454740b3f@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f07d0abf-b3eb-f530-37b9-e66454740b3f@kernel.dk> (Jens Axboe's
        message of "Thu, 6 Jun 2019 23:52:35 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Sebastian Ott <sebott@linux.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, Ulf Hansson <ulf.hansson@linaro.org>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jens,

>> The SCSI bits will need a bit more review, and possibly tweaking
>> fo megaraid and mpt3sas.  But they are really independent of the
>> other patches, so maybe skip them for now and leave them for Martin
>> to deal with.
>
> I dropped the SCSI bits.

I'll monitor and merge them.

-- 
Martin K. Petersen	Oracle Linux Engineering
