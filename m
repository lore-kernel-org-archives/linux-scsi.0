From: Frank Pieczynski <pieczy@web.de>
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Mon, 23 Feb 2004 19:21:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200402231921.33895.pieczy@web.de>
References: <403512B8.2060403@ics.uci.edu> <Pine.LNX.4.58.0402231615270.1749@kai.makisara.local> <20040223142531.GF32010@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.web.de ([217.72.192.151]:12037 "EHLO smtp.web.de")
	by vger.kernel.org with ESMTP id S261986AbUBWSVo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 13:21:44 -0500
In-Reply-To: <20040223142531.GF32010@suse.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Joachim Feise <jfeise@ics.uci.edu>, linux-scsi@vger.kernel.org, Michael Guntsche <mike@it-loops.com>, Andrew Morton <akpm@osdl.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>

On Monday 23 February 2004 15:25, Jens Axboe wrote:
> > > > I hope someone sees no where the real problem is.
> > >
> > > SCSI io completion path (sr/sd/st rw_intr() -> scsi_io_completion() ->
> > > scsi_end_request()) doesn't properly handle non-sector aligned data
> > > transfers. This patch should fix it up. Warning: untested.
> >
> > Now it is slightly tested: it works with my SCSI tape test program. Since
> > the program only does an inquiry, I tried it with the SCSI system disk
> > without problems. Unfortunately, I don't have access to a SCSI CDROM now.
>
> Great, that's promising (code like this tends to either break at first
> access, or work :-). Thanks for testing.

Hello all,
yes, this fix works! I can open k3b now without problems.
And yes, my other SCSI devices are still working, also my SATA disks using 
libata.
Thank you ver much,
Frank
