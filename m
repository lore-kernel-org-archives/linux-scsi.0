From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi: Fix a scsi_show_rq() NULL pointer dereference
Date: Mon, 11 Dec 2017 22:11:29 -0500
Message-ID: <yq1vahcprmm.fsf@oracle.com>
References: <20171206005753.28734-1-bart.vanassche@wdc.com>
        <20171206005753.28734-2-bart.vanassche@wdc.com>
        <20171208014528.GD21488@ming.t460p> <yq1374muebm.fsf@oracle.com>
        <20171208084455.GF21488@ming.t460p>
        <20171208104410.GA10667@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171208104410.GA10667@ming.t460p> (Ming Lei's message of "Fri,
        8 Dec 2017 18:44:17 +0800")
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Ming,

> This patch allocates one array for T10_PI_TYPE2_PROTECTION command,
> size of each element is SD_EXT_CDB_SIZE, and the length is
> host->can_queue, then we can retrieve one command buffer runtime
> via rq->tag.
>
> So we can avoid to allocate the command buffer runtime, also the
> recent use-after-free report[1] in scsi_show_rq() can be fixed too.

I'm still mulling over the pros and cons of this one for 4.16+...

-- 
Martin K. Petersen	Oracle Linux Engineering
