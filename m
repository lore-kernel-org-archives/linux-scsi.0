From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Wed, 16 Jul 2003 19:04:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030716170456.GK833@suse.de>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net> <1058359278.1856.8.camel@mulgrave> <20030716124549.GX833@suse.de> <1058360162.1850.15.camel@mulgrave> <20030716132036.GB833@suse.de> <1058364455.1856.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:22460 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S270950AbTGPQuF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 12:50:05 -0400
Content-Disposition: inline
In-Reply-To: <1058364455.1856.28.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Haverkamp <markh@osdl.org>, Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jul 16 2003, James Bottomley wrote:
> On Wed, 2003-07-16 at 09:20, Jens Axboe wrote:
> > blk_insert_request() is close, but it does a little more (it's useful
> > another place in the scsi queueing, though). How about something like
> > this? Then I can add the 'back on queue but not completed' stuff after
> > that.
> 
> Looks fine well except that it needs an EXPORT_SYMBOL.  How do you want
> to submit?  I'm getting close to attempting a SCSI merge, so I can send
> it in with that?

Sure go ahead. I'll add the missing bits when it is in.

-- 
Jens Axboe

