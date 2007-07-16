From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Mon, 16 Jul 2007 15:04:47 +0200
Message-ID: <20070716130447.GO5195@kernel.dk>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be> <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de> <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be> <1184340528.3402.32.camel@localhost.localdomain> <Pine.LNX.4.62.0707132212520.23000@chinchilla.sonytel.be> <Pine.LNX.4.62.0707161338230.1072@pademelon.sonytel.be> <20070716121649.GI5195@kernel.dk> <Pine.LNX.4.62.0707161459010.1072@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764820AbXGPNFm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0707161459010.1072@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Alessandro Rubini <rubini@vision.unipv.it>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16 2007, Geert Uytterhoeven wrote:
> On Mon, 16 Jul 2007, Jens Axboe wrote:
> > On Mon, Jul 16 2007, Geert Uytterhoeven wrote:
> > > On Fri, 13 Jul 2007, Geert Uytterhoeven wrote:
> > > > Ah, that explains it. flush_dcache_page() is used in some drivers.
> > > > I'll update my patches. Thanks for the comments!
> > > 
> > > Does this look OK?
> > >   - Replaced KM_USER0 by KM_IRQ0 (all routines are either called from an
> > >     interrupt handler, from .request_fn (ps3disk), or from .queuecommand
> > >     (ps3rom))
> > 
> > That looks good.
> > 
> > >   - Add a call to flush_kernel_dcache_page() in routines that write to buffers
> > 
> > Hmm, I would have thought a flush_dcache_page() would be more
> > appropriate, the backing could be page cache pages.
> 
> OK, I'll change it to flush_dcache_page().

Then you may add my acked-by as well, if you want.

-- 
Jens Axboe
