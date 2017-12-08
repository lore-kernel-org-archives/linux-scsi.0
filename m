From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and queue is idle
Date: Thu, 07 Dec 2017 19:54:52 -0500
Message-ID: <yq1shcmvy1v.fsf@oracle.com>
References: <20171205075256.10319-1-ming.lei@redhat.com>
        <0352a2f1-d49b-aaa1-f8e9-10486bb5fa9d@applied-asynchrony.com>
        <20171207014002.GB10214@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171207014002.GB10214@ming.t460p> (Ming Lei's message of "Thu,
        7 Dec 2017 09:40:04 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


Ming,

> Jens, Martin, would any of you mind making this patch in V4.15? Since
> it fixes real use cases and this way is exact what we do before
> 0df21c86bdbf("scsi: implement .get_budget and .put_budget for blk-mq").

Applied to 4.15/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
