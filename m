From: Jens Axboe <axboe@suse.de>
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Mon, 23 Feb 2004 15:25:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223142531.GF32010@suse.de>
References: <403512B8.2060403@ics.uci.edu> <4036867C.60803@ics.uci.edu> <Pine.LNX.4.58.0402231329480.1749@kai.makisara.local> <20040223132634.GD32010@suse.de> <Pine.LNX.4.58.0402231615270.1749@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:36018 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261872AbUBWOZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 09:25:35 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0402231615270.1749@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Joachim Feise <jfeise@ics.uci.edu>, linux-scsi@vger.kernel.org, Michael Guntsche <mike@it-loops.com>, Andrew Morton <akpm@osdl.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Frank Pieczynski <pieczy@web.de>

On Mon, Feb 23 2004, Kai Makisara wrote:
> On Mon, 23 Feb 2004, Jens Axboe wrote:
> 
> > On Mon, Feb 23 2004, Kai Makisara wrote:
> ...
> > > I hope someone sees no where the real problem is.
> > 
> > SCSI io completion path (sr/sd/st rw_intr() -> scsi_io_completion() ->
> > scsi_end_request()) doesn't properly handle non-sector aligned data
> > transfers. This patch should fix it up. Warning: untested.
> > 
> Now it is slightly tested: it works with my SCSI tape test program. Since 
> the program only does an inquiry, I tried it with the SCSI system disk 
> without problems. Unfortunately, I don't have access to a SCSI CDROM now.

Great, that's promising (code like this tends to either break at first
access, or work :-). Thanks for testing.

-- 
Jens Axboe

