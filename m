From: Jens Axboe <axboe@suse.de>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Sun, 29 Aug 2004 15:45:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040829134505.GB10384@suse.de>
References: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org> <Pine.LNX.4.44L0.0408271100590.1238-100000@ida.rowland.org> <20040828143124.GB2518@suse.de> <1093715498.3682.4.camel@mulgrave> <20040828175547.GA8339@suse.de> <1093717255.3682.13.camel@mulgrave> <20040828184104.GA8460@suse.de> <1093742128.1670.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:31619 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267830AbUH2NpO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Aug 2004 09:45:14 -0400
Content-Disposition: inline
In-Reply-To: <1093742128.1670.2.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pat LaVarre <p.lavarre@ieee.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, Aug 29 2004, James Bottomley wrote:
> On Sat, 2004-08-28 at 14:41, Jens Axboe wrote:
> > Since SCSI doesn't build > 128 pages anyways, yes it doesn't make sense
> > to maintain a BIO_MAX_PAGES of 256. Didn't the SCSI part used to be 256
> 
> Agreed.
> 
> > pages as well, I'm pretty sure that's what I put in when the
> > scsi_malloc() crud was dumped?
> 
> I don't think so.  I only looked at it about six months ago when SGI
> wanted better merging for qla.  There was quite a bit of work to get the
> maximum to be 256.

Probably a bad recollection on my part.

> > bio has 1, 4, 16, 64, 128, 256 pools. 32 might make more sense, I seem
> > to recall mpages using that. I'll see if I can sneak a BIO_MAX_PAGES
> > reduction in, and spend that extra pool on 32 instead :)
> 
> OK I'll follow whatever you do in SCSI.  I think at least aligning all
> of our pool maximums is the correct thing to do.

Definitely. I'll toss something out.

-- 
Jens Axboe

