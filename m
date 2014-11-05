From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/11] scsi: always assign block layer tags if enabled
Date: Tue, 04 Nov 2014 21:34:49 -0500
Message-ID: <yq1egtifk8m.fsf@sermon.lab.mkp.net>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
	<1415087656-9491-9-git-send-email-hch@lst.de>
	<yq1ioiufkcz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaKECgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 21:36:43 -0500
In-Reply-To: <yq1ioiufkcz.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 04 Nov 2014 21:32:12 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> Also, when I read the disable case it's not immediately obvious
Martin> whether the 0 is the queue depth or the tag type (although in
Martin> the example above it's obvious due to it being cmd_per_lun).

Ignore me. Just made it to patch 09/11.

-- 
Martin K. Petersen	Oracle Linux Engineering
