From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/11] scsi: remove abuses of scsi_populate_tag
Date: Tue, 4 Nov 2014 11:37:45 +0100
Message-ID: <20141104103745.GC19154@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-6-git-send-email-hch@lst.de> <5458923E.3010603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51267 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaKDKhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 05:37:50 -0500
Content-Disposition: inline
In-Reply-To: <5458923E.3010603@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

> Hmm. Either ->task needs to be initialized with TSK_SIMPLE (=0),
> then it's missing with the other instances below.
> Or it doesn't, but then this line is pointless.
> 
> For clarification I'd rather have it set explicitly below.

This just keeps the inconsistency the driver already had.   If the
qlogic folks care it could be cleaned up later.

> The function description needs to be adapted; it still refers
> to the original function name 'scsi_populate_tag_msg;

Thanks, fixed.
