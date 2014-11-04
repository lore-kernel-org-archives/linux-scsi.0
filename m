From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/11] scsi: add new scsi-command flag for tagged
	commands
Date: Tue, 4 Nov 2014 11:35:35 +0100
Message-ID: <20141104103535.GB19154@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-3-git-send-email-hch@lst.de> <5458906D.4090708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51248 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaKDKfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 05:35:37 -0500
Content-Disposition: inline
In-Reply-To: <5458906D.4090708@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On Tue, Nov 04, 2014 at 09:38:05AM +0100, Hannes Reinecke wrote:
> Hmm. Flags with just one value in it ...
> bitfield, maybe?

Bitfields are nasty.  And I see more use for flags, e.g. whatever is
left of eh_ehflags after the no_async_abort removal could be merged into
it.

