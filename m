From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/14] scsi: split __scsi_queue_insert
Date: Mon, 21 Jul 2014 23:44:06 -0400
Message-ID: <yq1bnsim515.fsf@sermon.lab.mkp.net>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-3-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:01 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Factor out a helper to set the _blocked values, which we'll
Christoph> reuse for the blk-mq code path.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
