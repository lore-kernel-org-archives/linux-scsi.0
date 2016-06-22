From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: parisc late boot crash in 4.4-rc, scsi-related
Date: Wed, 22 Jun 2016 23:26:47 +0300
Message-ID: <20160622202647.GF11384@raspberrypi.musicnaut.iki.fi>
References: <alpine.LRH.2.20.1601082329270.23187@math.ut.ee>
 <56902D77.1020200@gmx.de>
 <alpine.LRH.2.20.1605162336050.12607@math.ut.ee>
 <9d1ae51e-69c3-c3f6-60aa-e5238dd18241@bell.net>
 <alpine.LRH.2.20.1606221451310.11869@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.20.1606221451310.11869@math.ut.ee>
Sender: linux-parisc-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Wed, Jun 22, 2016 at 02:52:40PM +0300, Meelis Roos wrote:
> > > > > I noticed on RP3440 and A500 that recent 4.4-rc* crashes on boot.
> > > > >
> > > > >I've not seen it with 4.4-rc yet, but I've seen it on debian kernel
> > > > >4.3.3:
> > > This is still present in 4.6, just tested. All my pariscs are broken
> > > - A500, RP3410, RP3440. 4.3 is the latest working release for me. If
> > > 4.3.3 is broken, it might be possible to bisect more easily.
> > 
> > I believe this is fixed in current gcc versions (4.9 and latter). It was
> > exposed by a blk-merge
> > change.  It was fixed by this change:
> 
> Out of interest, how do other parisc users get the new compiler?
> 
> What distro are you using?
> 
> My pariscs are gentoo and still only the old versions are available on 
> hppa.

I compile everything from scratch. Currently using GCC 6.1.

A.
