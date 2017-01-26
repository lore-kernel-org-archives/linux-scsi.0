From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05/18] block: allow specifying size for extra command data
Date: Wed, 25 Jan 2017 22:15:55 -0500
Message-ID: <yq160l2a4us.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-6-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:13 +0100")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph,

Christoph> This mirrors the blk-mq capabilities to allocate extra
Christoph> drivers-specific data behind struct request by setting a
Christoph> cmd_size field, as well as having a constructor / destructor
Christoph> for it.

Nice!

A couple of minor nits:

+static void *alloc_request_size(gfp_t gfp_mask, void *data)

I like alloc_request_simple() but alloc_request_size() seems a bit
contrived. _reserve? _extra? _special? Don't have any good suggestions,
I'm afraid.

Also a bit heavy on the else brackets a couple of places. But no biggie.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
