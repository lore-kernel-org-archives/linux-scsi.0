From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: Sym2 scsi hang on boot on sparc64
Date: Tue, 19 Aug 2014 23:48:43 +0300
Message-ID: <20140819204843.GD4885@drone.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1408191420150.4929@math.ut.ee>
 <1408451668.2645.2.camel@jarvis>
 <alpine.SOC.1.00.1408191736190.7767@math.ut.ee>
 <1408459655.3491.1.camel@jarvis>
 <20140819201748.GC4885@drone.musicnaut.iki.fi>
 <1408480638.4424.0.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408480638.4424.0.camel@jarvis>
Sender: sparclinux-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, linux-parisc@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Tue, Aug 19, 2014 at 03:37:18PM -0500, James Bottomley wrote:
> On Tue, 2014-08-19 at 23:17 +0300, Aaro Koskinen wrote:
> > Bisection (on PA-RISC) points to:
> > 
> > 71e75c97f97a9645d25fbf3d8e4165a558f18747 is the first bad commit
> > commit 71e75c97f97a9645d25fbf3d8e4165a558f18747
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Fri Apr 11 19:07:01 2014 +0200
> > 
> >     scsi: convert device_busy to atomic_t
> 
> That's fixed upstream:
> 
> commit 480cadc2b7e0fa2bbab20141efb547dfe0c3707c
> Author: Guenter Roeck <linux@roeck-us.net>
> Date:   Sun Aug 10 05:54:25 2014 -0700
> 
>     scsi: Fix qemu boot hang problem
> 
> Could you try with a kernel that has that fix?

Yes, the box boots now fine with the fix.

Thanks,

A.
