From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Fri, 13 Dec 2002 21:06:43 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021213210643.B15074@infradead.org>
References: <hch@infradead.org> <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1313340000.1039622906@aslan.scsiguy.com> <20021211162318.A24958@infradead.org> <20021212071636.GA4318@suse.de> <261670000.1039713623@aslan.btc.adaptec.com> <20021212173818.GA6481@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021212173818.GA6481@suse.de>; from axboe@suse.de on Thu, Dec 12, 2002 at 06:38:18PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Dec 12, 2002 at 06:38:18PM +0100, Jens Axboe wrote:
> > 1) You have to set a flag when you've already told the system you
> >    dma capabilities.
> 
> All drivers blindly copy the setting of the dma mask, typically means
> nothing.

Maybe it's a bit to dangerous for 2.4, but for 2.5 Justin's suggestion
looks very nice, IMHO.


> > 2) That flag is not documented in hosts.h or in the Documentation directory.
> 
> That is true. Name of the member is a good clue, though.

Hmm, actually I documented it at some point, I just can't remember
in what tree that was..

> > 4) highio requires that all SCSI drivers support single length S/G lists,
> >    but since single buffers are still allowed by the interfaces, even
> >    compliant SCSI drivers cannot strip out this code.
> 
> This is not a new requirement, it's just spelled out now. The special
> casing of an sg request with one entry was silly, imho. And yes you do
> have to support both single entry sg requests and non-sg requests. I
> wouldn't mind getting rid of that, but this is the 2.4 series and
> changes must be kept small(ish).

IIRC Alan planned to kill non-sg requests for 2.5.  But I don't know how
far he got.

