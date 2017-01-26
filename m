From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 12/18] scsi: respect unchecked_isa_dma for blk-mq
Date: Wed, 25 Jan 2017 22:23:34 -0500
Message-ID: <yq1k29i8pxl.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-13-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-13-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:20 +0100")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Currently blk-mq always allocates the sense buffer using
Christoph> normal GFP_KERNEL allocation.  Refactor the cmd pool code to
Christoph> split the cmd and sense allocation and share the code to
Christoph> allocate the sense buffers as well as the sense buffer slab
Christoph> caches between the legacy and blk-mq path.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
