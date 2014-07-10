From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 06:50:51 -0700
Message-ID: <20140710135051.GA28227@infradead.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <20140708144829.GA5539@infradead.org>
 <53BD7041.5010300@interlog.com>
 <53BD9A24.7010203@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
 <20140710062040.GB20146@infradead.org>
 <20140710133609.GO12478@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140710133609.GO12478@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 10, 2014 at 09:36:09AM -0400, Benjamin LaHaise wrote:
> There is one possible concern that could be exacerbated by other changes in 
> the system: if the application is running close to the bare minimum number 
> of requests allocated in io_setup(), the per cpu reference counters will 
> have a hard time batching things.  It might be worth testing with an 
> increased number of requests being allocated if this is the case.

Well, Robert said reverting the two aio commits didn't help.  Either he
didn't manage to boot into the right kernel, or we need to look
elsewhere for the culprit.
