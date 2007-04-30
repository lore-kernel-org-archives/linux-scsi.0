From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Mon, 30 Apr 2007 15:07:34 +0200
Message-ID: <20070430130734.GN21015@kernel.dk>
References: <46225E18.7070404@panasas.com> <462261E8.5090005@panasas.com> <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp> <4634BE6B.3000808@panasas.com> <1177872588.3688.79.camel@mulgrave.il.steeleye.com> <20070430111157.GI21015@kernel.dk> <4635E9B5.1020708@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:10453 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423235AbXD3NLz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 09:11:55 -0400
Content-Disposition: inline
In-Reply-To: <4635E9B5.1020708@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <tomof@acm.org>, akpm@osdl.org, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bhalevy@panasas.com

On Mon, Apr 30 2007, Mark Lord wrote:
> Jens Axboe wrote:
> >
> >So basically just add a struct request pointer, so you can do rq =
> >rq->next_rq or something for the next data phase. I bet this would be a
> >LOT less invasive as well, and we can get by with a few helpers to
> >support it.
> 
> Hey, I want a way to issue those (linked requests) from userspace (SG_IO), 
> too.
> Specifically for use with the new SMART Command Transport (SCT) feature set
> on modern SATA drives.  As well as for a disk recovery utility I'm working 
> on.
> 
> Sounds generally useful, that.

Yep, one of the reasons why I like (my :-) proposal as well, we could
potentially find other uses for linking commands like that.
> 

-- 
Jens Axboe

