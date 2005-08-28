From: Jens Axboe <axboe@suse.de>
Subject: Re: libata: clustering on or off?
Date: Sun, 28 Aug 2005 17:09:34 +0200
Message-ID: <20050828150933.GV4018@suse.de>
References: <20050828094218.GA29145@havoc.gtf.org> <1125224541.3219.13.camel@laptopd505.fenrus.org> <20050828142018.GS4018@suse.de> <20050828145806.GA22634@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050828145806.GA22634@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 28 2005, Christoph Hellwig wrote:
> On Sun, Aug 28, 2005 at 04:20:19PM +0200, Jens Axboe wrote:
> > Agree, we should just remove the ability to control clustering, as it
> > really overlaps with the segment settings anyways.
> 
> What are we going to do with iscsi then?  It really doesn't like segments
> over a pages size.  Best thing would probably be to switch networking to
> use sg lists and dma_map_sg, but that's not a trivial task.

Limit the segment size, then. There are provisions for doing both length
and boundary limits, that should suffice.

-- 
Jens Axboe

