From: Jens Axboe <axboe@suse.de>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Thu, 12 Dec 2002 08:16:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212071636.GA4318@suse.de>
References: <hch@infradead.org> <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1313340000.1039622906@aslan.scsiguy.com> <20021211162318.A24958@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021211162318.A24958@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Dec 11 2002, Christoph Hellwig wrote:
> > I have no problem with interfaces changing for good reason, but, for
> > example,
> > a driver that alread sets unchecked_isa_dma to 0 and uses the PCI dma mask
> > shouldn't have to set addition flags (with different names in different
> > vendor's trees) to enable HIGHIO.  It's yet-another *stupid* interface
> > change.
> 
> Maybe you could have complained about that more than one year ago when the
> patch came up first?

And I still dont see a better way to do it. Remember that this is 2.4
and we must be able to toggle the highmem io capability on a per-driver
basis easily and default to off until a given piece of hardware (and
driver) has been verified.

Saying the high io stuff could have been done with zero impact to
drivers just shows that you have no idea what you are talking about
here and are living in your Justin world again. Tons of drivers needed
to be changed to be able to deal with highmem pages sanely.

-- 
Jens Axboe

