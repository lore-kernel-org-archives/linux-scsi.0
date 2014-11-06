From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] scsi: provide a generic change_queue_type method
Date: Thu, 6 Nov 2014 16:35:55 +0100
Message-ID: <20141106153555.GC22415@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-2-git-send-email-hch@lst.de> <545B93A9.3070206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57568 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaKFPf6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 10:35:58 -0500
Content-Disposition: inline
In-Reply-To: <545B93A9.3070206@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On Thu, Nov 06, 2014 at 04:28:41PM +0100, Bart Van Assche wrote:
> A minor nit: do we really need to keep the scsi_dev->tagged_supported test 
> in the above code ? Anyway,

It's not needed, but the whole function will go away later in the series.
