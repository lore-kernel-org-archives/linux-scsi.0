From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: scsi-mq V2
Date: Fri, 11 Jul 2014 06:02:03 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B979E6@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
	<20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
	<53BD9A24.7010203@kernel.dk>
	<94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
	<20140710062040.GB20146@infradead.org>
	<94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
	<20140710160422.GA13728@infradead.org>
	<20140710161438.GA30792@infradead.org>
	<94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
 <x497g3l10x6.fsf@segfault.boston.devel.redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, Benjamin LaHaise <bcrl@kvack.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Elliott, Robert (Server Storage)
> 
> I added some prints in aio_setup_ring and  ioctx_alloc and
> rebooted.  This time it took much longer to hit the problem.  It
> survived dozens of ^Cs.  Running a few minutes, though, IOPS
> eventually dropped.  So, sometimes it happens immediately,
> sometimes it takes time to develop.
> 
> I will rerun bisect-1 -2 and -3 for longer times to increase
> confidence that they didn't just appear good.

Allowing longer run times before declaring success, the problem 
does appear in all of the bisect trees.  I just let fio
continue to run for many minutes - no ^Cs necessary.

no-rebase: good for > 45 minutes (I will leave that running for
  8 more hours)
bisect-1: bad
bisect-2: bad
bisect-3: bad
bisect-4: bad
