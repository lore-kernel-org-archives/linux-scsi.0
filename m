From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 20:12:17 +0200
Message-ID: <20080625181216.GH20851@kernel.dk>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com> <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk> <20080625172015.GR4392@parisc-linux.org> <20080625172638.GE20851@kernel.dk> <yq1d4m575je.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:17368 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYFYSMT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 14:12:19 -0400
Content-Disposition: inline
In-Reply-To: <yq1d4m575je.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Boaz Harrosh <bharrosh@panasas.com>, Ric Wheeler <ricwheeler@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Jun 25 2008, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> Uhm, but it IS "a blatant layering violation", it's doing things
> Jens> from the wrong side up :-)
> 
> I also disagree with mucking with the elevator directly in sd.c.
> 
> The whole point of my I/O hints work is to expose the I/O topology in
> a generic fashion so that upper layers can take advantage of them.
> 
> I'll post a new batch of those patches shortly...

Good, that sounds useful! Sounds a lot like what I referred to as
'device profiles'.

-- 
Jens Axboe

