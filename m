From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata error handling fixes (ATAPI)
Date: Sat, 19 Nov 2005 14:27:50 +0100
Message-ID: <20051119132750.GJ25454@suse.de>
References: <4379B28E.9070708@gmail.com> <4379C062.3010302@pobox.com> <20051115120016.GD7787@suse.de> <437A2814.1060308@cs.wisc.edu> <20051115184131.GJ7787@suse.de> <20051116124035.GX7787@suse.de> <58cb370e0511160704w4803a085h7bd6ab352d8c94e6@mail.gmail.com> <20051116153119.GN7787@suse.de> <58cb370e0511160806t1defd373w981e213d1cdeb2b3@mail.gmail.com> <20051119105555.GA25402@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051119105555.GA25402@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 19 2005, Christoph Hellwig wrote:
> On Wed, Nov 16, 2005 at 05:06:45PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > This will also allow us to remove ide_do_drive_cmd()
> > and use blk_execute_rq() exclusively.
> 
> While we're talking about moving things to generic request-based stuff,
> any chance one of you could look over to convert ide-cd internal request
> submissions to BLOCK_PC?  It's the last user of REQ_PC.  After that changing
> the CD layer to submit BLOCK_PC commands directly instead of the
> ->packet_command hook would be a logical next step.

Yup, that's clearly the way to go.

-- 
Jens Axboe

