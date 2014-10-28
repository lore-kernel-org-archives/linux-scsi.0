From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] Revert "block: all blk-mq requests are tagged"
Date: Mon, 27 Oct 2014 20:23:13 -0400
Message-ID: <yq1wq7loxe6.fsf@sermon.lab.mkp.net>
References: <1413731638-28305-1-git-send-email-hch@lst.de>
	<1413731638-28305-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413731638-28305-2-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 19 Oct 2014 17:13:57 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This reverts commit fb3ccb5da71273e7f0d50b50bc879e50cedd60e7.
Christoph> SCSI-2/SPI actually needs the tagged/untagged flag in the
Christoph> request to work properly.  Revert this patch and add a follow
Christoph> on to set it in the right place.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
