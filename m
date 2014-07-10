From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 11:11:10 -0400
Message-ID: <x49k37l1c6p.fsf@segfault.boston.devel.redhat.com>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
	<20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
	<53BD9A24.7010203@kernel.dk>
	<94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
	<20140710062040.GB20146@infradead.org>
	<20140710133609.GO12478@kvack.org>
	<20140710135051.GA28227@infradead.org> <53BE9AB1.6090603@kernel.dk>
	<94D0CD8314A33A4D9D801C0FE68B402958B96CF0@G9W0745.americas.hpqcorp.net>
	<20140710144539.GU12478@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140710144539.GU12478@kvack.org> (Benjamin LaHaise's message of
	"Thu, 10 Jul 2014 10:45:39 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

>> 
>> [  186.339064] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>> [  186.339065] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>> [  186.339067] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>> [  186.339068] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>> [  186.339069] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>
> Something is horribly wrong here.  There is no way that value for nr_events 
> should be passed in to ioctx_alloc().  This implies that userland is calling 
> io_setup() with an impossibly large value for nr_events.  Can you post the 
> actual diff for your fs/aio.c relative to linus' tree?
>

fio does exactly this!  it passes INT_MAX.

Cheers,
Jeff
