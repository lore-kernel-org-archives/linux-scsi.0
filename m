From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 2/8] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Wed, 7 Feb 2018 08:43:13 +0800
Message-ID: <20180207004311.GA13470@ming.t460p>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-3-ming.lei@redhat.com>
 <398c755a-ada6-1e60-9562-51b69476e55d@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932106AbeBGAwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Feb 2018 19:52:40 -0500
Content-Disposition: inline
In-Reply-To: <398c755a-ada6-1e60-9562-51b69476e55d@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On Tue, Feb 06, 2018 at 04:18:20PM -0700, Jens Axboe wrote:
> On 2/5/18 8:20 AM, Ming Lei wrote:
...
> 
> GLOBAL implies that it's, strangely enough, global. That isn't really the
> case. Why not call this BLK_MQ_F_HOST_TAGS or something like that? I'd
> welcome better names, but global doesn't seem to be a great choice.
> 
> BLK_MQ_F_SET_TAGS?

Good point, I am fine with either BLK_MQ_F_HOST_TAGS or BLK_MQ_F_SET_TAGS,
will update in V3.

Thanks,
Ming
