From: Jens Axboe <axboe@suse.de>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Sat, 14 Dec 2002 11:42:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021214104227.GH11892@suse.de>
References: <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1313340000.1039622906@aslan.scsiguy.com> <20021211162318.A24958@infradead.org> <20021212071636.GA4318@suse.de> <261670000.1039713623@aslan.btc.adaptec.com> <20021212173818.GA6481@suse.de> <20021213210643.B15074@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021213210643.B15074@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Dec 13 2002, Christoph Hellwig wrote:
> On Thu, Dec 12, 2002 at 06:38:18PM +0100, Jens Axboe wrote:
> > > 1) You have to set a flag when you've already told the system you
> > >    dma capabilities.
> > 
> > All drivers blindly copy the setting of the dma mask, typically means
> > nothing.
> 
> Maybe it's a bit to dangerous for 2.4, but for 2.5 Justin's suggestion
> looks very nice, IMHO.

The whole discussion was about the 2.4 patch. For 2.5 I'm not adverse to
doing it this way.

-- 
Jens Axboe

