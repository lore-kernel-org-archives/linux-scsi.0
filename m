From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Avoid that a kernel warning appears during system resume
Date: Tue, 19 Mar 2019 14:27:44 -0400
Message-ID: <yq1bm26en33.fsf@oracle.com>
References: <20190315232758.221199-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190315232758.221199-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 15 Mar 2019 16:27:58 -0700")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Oleksandr Natalenko <oleksandr@natalenko.name>, Martin Steigerwald <martin@lichtvoll.de>, stable@vger.kernel.org, Jisheng Zhang <Jisheng.Zhang@synaptics.com>
List-Id: linux-scsi@vger.kernel.org


Bart,

> Since scsi_device_quiesce() skips SCSI devices that have another state
> than RUNNING, OFFLINE or TRANSPORT_OFFLINE, scsi_device_resume()
> should not complain about SCSI devices that have been skipped. Hence
> this patch.  This patch avoids that the following warning appears
> during resume:

Applied to 5.1/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
