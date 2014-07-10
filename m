From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 15:36:21 -0400
Message-ID: <x4938e90zwq.fsf@segfault.boston.devel.redhat.com>
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
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x497g3l10x6.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Thu, 10 Jul 2014 15:14:29 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, Benjamin LaHaise <bcrl@kvack.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi, Rob,
>
> Can you get sysrq-t output for me?  I don't know how/why we'd continue
> to get io_submits for an exiting process.

Also, do you know what sys_io_submit is returning?
