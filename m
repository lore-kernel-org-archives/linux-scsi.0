From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] blk-mq: tags: define several fields of tags as
 pointer
Date: Mon, 5 Feb 2018 07:57:57 +0100
Message-ID: <6959d8aa-9388-74c9-c3ae-189fe7885d1a@suse.de>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <20180203042112.15239-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752292AbeBEG57 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 01:57:59 -0500
In-Reply-To: <20180203042112.15239-2-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On 02/03/2018 05:21 AM, Ming Lei wrote:
> This patch changes tags->breserved_tags, tags->bitmap_tags and
> tags->active_queues as pointer, and prepares for supporting global tags.
> 
> No functional change.
> 
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/bfq-iosched.c    |  4 ++--
>  block/blk-mq-debugfs.c | 10 +++++-----
>  block/blk-mq-tag.c     | 48 ++++++++++++++++++++++++++----------------------
>  block/blk-mq-tag.h     | 10 +++++++---
>  block/blk-mq.c         |  2 +-
>  block/kyber-iosched.c  |  2 +-
>  6 files changed, 42 insertions(+), 34 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
