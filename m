From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/11] mptfusion: don't change queue type in ->change_queue_depth
Date: Tue, 04 Nov 2014 21:17:36 -0500
Message-ID: <yq1r3xifl1b.fsf@sermon.lab.mkp.net>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
	<1415087656-9491-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18256 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaKECT3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 21:19:29 -0500
In-Reply-To: <1415087656-9491-7-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Tue, 4 Nov 2014 08:54:11 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This function shouldn't change the queue type, just the
Christoph> depth.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
