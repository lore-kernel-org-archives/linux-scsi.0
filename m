From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Mon, 23 Feb 2004 16:22:28 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402231615270.1749@kai.makisara.local>
References: <403512B8.2060403@ics.uci.edu> <4036867C.60803@ics.uci.edu>
 <Pine.LNX.4.58.0402231329480.1749@kai.makisara.local> <20040223132634.GD32010@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep22-0.kolumbus.fi ([193.229.0.60]:29772 "EHLO
	fep22-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261874AbUBWOWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 09:22:31 -0500
In-Reply-To: <20040223132634.GD32010@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Joachim Feise <jfeise@ics.uci.edu>, linux-scsi@vger.kernel.org, Michael Guntsche <mike@it-loops.com>, Andrew Morton <akpm@osdl.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Frank Pieczynski <pieczy@web.de>

On Mon, 23 Feb 2004, Jens Axboe wrote:

> On Mon, Feb 23 2004, Kai Makisara wrote:
...
> > I hope someone sees no where the real problem is.
> 
> SCSI io completion path (sr/sd/st rw_intr() -> scsi_io_completion() ->
> scsi_end_request()) doesn't properly handle non-sector aligned data
> transfers. This patch should fix it up. Warning: untested.
> 
Now it is slightly tested: it works with my SCSI tape test program. Since 
the program only does an inquiry, I tried it with the SCSI system disk 
without problems. Unfortunately, I don't have access to a SCSI CDROM now.

-- 
Kai
