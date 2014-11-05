From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/11] scsi: add new scsi-command flag for tagged commands
Date: Tue, 04 Nov 2014 21:12:08 -0500
Message-ID: <yq14muegzuv.fsf@sermon.lab.mkp.net>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
	<1415087656-9491-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16760 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaKECOB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 21:14:01 -0500
In-Reply-To: <1415087656-9491-3-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Tue, 4 Nov 2014 08:54:07 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Currently scsi piggy backs on the block layer to define the
Christoph> concept of a tagged command.  But we want to be able to have
Christoph> block-level host-wide tags assigned even for untagged
Christoph> commands like the initial INQUIRY, so add a new SCSI-level
Christoph> flag for commands that are tagged at the scsi level, so that
Christoph> even commands without that set can have tags assigned to
Christoph> them.  Note that this alredy is the case for the blk-mq code
Christoph> path, and this just lets the old path catch up with it.

Christoph> We also set this flag based upon sdev->simple_tags instead of
Christoph> the block queue flag, so that it is entirely independent of
Christoph> the block layer tagging, and thus always correct even if a
Christoph> driver doesn't use block level tagging yet.

Christoph> Also remove the old blk_rq_tagged; it was only used by SCSI
Christoph> drivers, and removing it forces them to look for the proper
Christoph> replacement.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
