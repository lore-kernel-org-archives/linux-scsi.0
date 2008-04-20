From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [2.6 patch] sparc: export kmap_atomic_to_page
Date: Sun, 20 Apr 2008 17:40:11 -0600
Message-ID: <20080420234011.GT20637@parisc-linux.org>
References: <20080414141956.GN6695@cs181133002.pp.htv.fi> <20080415.003910.50277238.davem@davemloft.net> <20080420201443.GB14788@cs181133002.pp.htv.fi> <20080420.132829.220464348.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080420.132829.220464348.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: bunk@kernel.org, aacraid@adaptec.com, James.Bottomley@HansenPartnership.com, wli@holomorphy.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Apr 20, 2008 at 01:28:29PM -0700, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Sun, 20 Apr 2008 23:14:43 +0300
> 
> > On Tue, Apr 15, 2008 at 12:39:10AM -0700, David Miller wrote:
> > > From: Adrian Bunk <bunk@kernel.org>
> > >...
> > > > <--  snip  -->
> > > > 
> > > >   MODPOST 1741 modules
> > > > ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
> > > > ...
> > > > make[2]: *** [__modpost] Error 1
> > > > 
> > > > <--  snip  -->
> > > > 
> > > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > 
> > > Applied, thanks Adrian.
> > 
> > Please drop - aacraid no longer uses it in 2.6.26.
> 
> Ok, will do.

Looks like the only remaining user is in mm/shmem.c.  I guess it can be
unexported now?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
