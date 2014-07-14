From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: scsi-mq V2
Date: Mon, 14 Jul 2014 13:15:18 -0400
Message-ID: <20140714171518.GD11326@kvack.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net> <x497g3l10x6.fsf@segfault.boston.devel.redhat.com> <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net> <94D0CD8314A33A4D9D801C0FE68B402958B979E6@G9W0745.americas.hpqcorp.net> <20140711061441.GA29629@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958B98323@G9W0745.americas.hpqcorp.net> <20140711145524.GB12478@kvack.org> <94D0CD8314A33A4D9D801C0FE68B402958B9969F@G9W0745.americas.hpqcorp.net> <94D0CD8314A33A4D9D801C0FE68B402958B9F2DB@G9W0745.americas.hpqcorp.net> <94D0CD8314A33A4D9D801C0FE68B402958BA02EF@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BA02EF@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Robert,

On Sun, Jul 13, 2014 at 05:15:15PM +0000, Elliott, Robert (Server Storage) wrote:
> > > I will see if that solves the problem with the scsi-mq-3 tree, or
> > > at least some of the bisect trees leading up to it.
> > 
> > scsi-mq-3 is still going after 45 minutes.  I'll leave it running
> > overnight.
> > 
> 
> That has been going strong for 18 hours, so I think that's the patch
> we need.

Thanks for taking the time to narrow this down.  I've applied the fix to 
my aio-fixes tree at git://git.kvack.org/~bcrl/aio-fixes.git and fowarded 
it on to Linus as well.

		-ben
-- 
"Thought is the essence of where you are now."
