From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: set REQ_QUEUE for the blk-mq case
Date: Mon, 27 Oct 2014 20:24:45 -0400
Message-ID: <yq1sii9oxbm.fsf@sermon.lab.mkp.net>
References: <1413731638-28305-1-git-send-email-hch@lst.de>
	<1413731638-28305-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413731638-28305-3-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 19 Oct 2014 17:13:58 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> To generate the right SPI tag messages we need to properly
Christoph> set QUEUE_FLAG_QUEUED in the request_queue and mirror it to
Christoph> the request.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
