From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/11] scsi: don't set tagging state from scsi_adjust_queue_depth
Date: Tue, 04 Nov 2014 21:50:09 -0500
Message-ID: <yq1a946fjj2.fsf@sermon.lab.mkp.net>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
	<1415087656-9491-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24961 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaKECvD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 21:51:03 -0500
In-Reply-To: <1415087656-9491-10-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Tue, 4 Nov 2014 08:54:14 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Remove the tagged argument from scsi_adjust_queue_depth, and
Christoph> just let it handle the queue depth.  For most drivers those
Christoph> two are fairly separate, given that most modern drivers don't
Christoph> care about the SCSI "tagged" status of a command at all, and
Christoph> many old drivers allow queuing of multiple untagged commands
Christoph> in the driver.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
