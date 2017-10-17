From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v9 07/10] ide, scsi: Tell the block layer at request allocation time about preempt requests
Date: Tue, 17 Oct 2017 00:12:20 -0400
Message-ID: <yq160bexviz.fsf@oracle.com>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
        <20171016232905.5047-8-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016232905.5047-8-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Mon, 16 Oct 2017 16:29:02 -0700")
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org


Bart,

> Convert blk_get_request(q, op, __GFP_RECLAIM) into
> blk_get_request_flags(q, op, BLK_MQ_PREEMPT). This patch does not
> change any functionality.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
