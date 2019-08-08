From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: core: fix missing .cleanup_rq for
	SCSI hosts without request batching
Date: Wed, 07 Aug 2019 22:18:59 -0400
Message-ID: <yq136iccsbw.fsf@oracle.com>
References: <20190807144948.28265-1-maier@linux.ibm.com>
	<20190807144948.28265-2-maier@linux.ibm.com>
	<CACVXFVM0tFj8CmcHON04_KjxR=QErCbUx0abJgG2W9OBb7akZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACVXFVM0tFj8CmcHON04_KjxR=QErCbUx0abJgG2W9OBb7akZA@mail.gmail.com>
	(Ming Lei's message of "Thu, 8 Aug 2019 07:32:29 +0800")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <tom.leiming@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>, linux-s390 <linux-s390@vger.kernel.org>, Benjamin Block <bblock@linux.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, Ming Lei <ming.lei@redhat.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Steffen Maier <maier@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org


Ming,

>> +       .cleanup_rq     = scsi_cleanup_rq,
>>         .busy           = scsi_mq_lld_busy,
>>         .map_queues     = scsi_map_queues,
>>  };
>
> This one is a cross-tree thing, either scsi/5.4/scsi-queue needs to
> pull for-5.4/block, or do it after both land linus tree.

I'll set up an amalgamated for-next branch tomorrow.

-- 
Martin K. Petersen	Oracle Linux Engineering
