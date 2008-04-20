From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] sparc: export kmap_atomic_to_page
Date: Mon, 21 Apr 2008 02:55:43 +0300
Message-ID: <20080420235543.GB26897@cs181133002.pp.htv.fi>
References: <20080414141956.GN6695@cs181133002.pp.htv.fi> <20080415.003910.50277238.davem@davemloft.net> <20080420201443.GB14788@cs181133002.pp.htv.fi> <20080420.132829.220464348.davem@davemloft.net> <20080420234011.GT20637@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080420234011.GT20637@parisc-linux.org>
Sender: sparclinux-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: David Miller <davem@davemloft.net>, aacraid@adaptec.com, James.Bottomley@HansenPartnership.com, wli@holomorphy.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Apr 20, 2008 at 05:40:11PM -0600, Matthew Wilcox wrote:
> On Sun, Apr 20, 2008 at 01:28:29PM -0700, David Miller wrote:
> > From: Adrian Bunk <bunk@kernel.org>
> > Date: Sun, 20 Apr 2008 23:14:43 +0300
> > 
> > > On Tue, Apr 15, 2008 at 12:39:10AM -0700, David Miller wrote:
> > > > From: Adrian Bunk <bunk@kernel.org>
> > > >...
> > > > > <--  snip  -->
> > > > > 
> > > > >   MODPOST 1741 modules
> > > > > ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
> > > > > ...
> > > > > make[2]: *** [__modpost] Error 1
> > > > > 
> > > > > <--  snip  -->
> > > > > 
> > > > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > > 
> > > > Applied, thanks Adrian.
> > > 
> > > Please drop - aacraid no longer uses it in 2.6.26.
> > 
> > Ok, will do.
> 
> Looks like the only remaining user is in mm/shmem.c.  I guess it can be
> unexported now?

I'm already doing this (but the test compiles are still running).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

