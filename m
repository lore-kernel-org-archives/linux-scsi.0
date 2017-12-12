From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi: Fix a scsi_show_rq() NULL pointer dereference
Date: Mon, 11 Dec 2017 21:57:46 -0500
Message-ID: <yq1zi6ops9h.fsf@oracle.com>
References: <20171206005753.28734-1-bart.vanassche@wdc.com>
        <20171206005753.28734-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171206005753.28734-2-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Tue, 5 Dec 2017 16:57:51 -0800")
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> Avoid that scsi_show_rq() triggers a NULL pointer dereference if
> called after sd_uninit_command(). Swap the NULL pointer assignment
> and the mempool_free() call in sd_uninit_command() to make it less
> likely that scsi_show_rq() triggers a use-after-free. Note: even
> with these changes scsi_show_rq() can trigger a use-after-free but
> that's a lesser evil than e.g. suppressing debug information for
> T10-PI commands completely. This patch fixes the following oops:

Applied to 4.15/scsi-fixes. Thanks, Bart.

-- 
Martin K. Petersen	Oracle Linux Engineering
