From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V7 2/8] blokc: mq-deadline: Introduce dispatch helpers
Date: Wed, 08 Nov 2017 18:34:35 -0500
Message-ID: <yq1mv3wxs38.fsf@oracle.com>
References: <20171108081118.7632-1-damien.lemoal@wdc.com>
        <20171108081118.7632-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108081118.7632-3-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 8 Nov 2017 17:11:12 +0900")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Damien,

> Avoid directly referencing the next_rq and fifo_list arrays using the
> helper functions deadline_next_request() and deadline_fifo_request()
> to facilitate changes in the dispatch request selection in
> __dd_dispatch_request() for zoned block devices.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
