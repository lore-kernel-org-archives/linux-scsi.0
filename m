From: Joachim Feise <jfeise@ics.uci.edu>
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Mon, 23 Feb 2004 23:18:36 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58L0.0402232309220.1571@pv105234.reshsg.uci.edu>
References: <403512B8.2060403@ics.uci.edu> <4036867C.60803@ics.uci.edu>
 <Pine.LNX.4.58.0402231329480.1749@kai.makisara.local> <20040223132634.GD32010@suse.de>
 <Pine.LNX.4.58.0402231615270.1749@kai.makisara.local> <20040223142531.GF32010@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pv105234.reshsg.uci.edu ([128.195.105.234]:18948 "HELO
	pv105234.reshsg.uci.edu") by vger.kernel.org with SMTP
	id S262194AbUBXHSp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 02:18:45 -0500
In-Reply-To: <20040223142531.GF32010@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Michael Guntsche <mike@it-loops.com>, Andrew Morton <akpm@osdl.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Frank Pieczynski <pieczy@web.de>

On Mon, 23 Feb 2004, Jens Axboe wrote:

> On Mon, Feb 23 2004, Kai Makisara wrote:
> > Now it is slightly tested: it works with my SCSI tape test program. Since
> > the program only does an inquiry, I tried it with the SCSI system disk
> > without problems. Unfortunately, I don't have access to a SCSI CDROM now.
>
> Great, that's promising (code like this tends to either break at first
> access, or work :-). Thanks for testing.

I tried it with my SCSI DVD. Writing to and reading from DVD+RW
works fine.
Thanks for the fix.

-Joe
