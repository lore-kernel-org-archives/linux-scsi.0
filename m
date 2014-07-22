From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/14] scsi: convert target_busy to an atomic_t
Date: Mon, 21 Jul 2014 23:56:56 -0400
Message-ID: <yq1tx6akpvb.fsf@sermon.lab.mkp.net>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-7-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:05 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Avoid taking the host-wide host_lock to check the per-target
Christoph> queue limit.  Instead we do an atomic_inc_return early on to
Christoph> grab our slot in the queue, and if nessecary decrement it

Minor nit:                                    necessary

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
