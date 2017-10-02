From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V7 4/6] block: prepare for passing RQF_PREEMPT to request
 allocation
Date: Mon, 2 Oct 2017 06:45:04 -0700
Message-ID: <20171002134504.GD19119@infradead.org>
References: <20170930061214.10622-1-ming.lei@redhat.com>
 <20170930061214.10622-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930061214.10622-5-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

As mentioned in the reply to Bart, I'd much rather use BLK_MQ_REQ_*
for the sane blk_get_request version (which should have the same
prototype as blk_mq_alloc_request) instead of having another flags
namespace.
