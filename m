From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 12/14] scatterlist: allow chaining to preallocated chunks
Date: Fri, 25 Jul 2014 15:15:04 -0400
Message-ID: <yq1fvhpgshz.fsf@sermon.lab.mkp.net>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-13-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-13-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:11 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Blk-mq drivers usually preallocate their S/G list as part of
Christoph> the request, but if we want to support the very large S/G
Christoph> lists currently supported by the SCSI code that would tie up
Christoph> a lot of memory in the preallocated request pool.  Add
Christoph> support to the scatterlist code so that it can initialize a
Christoph> S/G list that uses a preallocated first chunks and
Christoph> dynamically allocated additional chunks.  That way the
Christoph> scsi-mq code can preallocate a first page worth of S/G
Christoph> entries as part of the request, and dynamically extend the
Christoph> S/G list when needed.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
