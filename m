From: Meelis Roos <mroos@linux.ee>
Subject: Re: Sym2 scsi hang on boot on sparc64
Date: Wed, 20 Aug 2014 15:14:34 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1408201513520.57@math.ut.ee>
References: <alpine.SOC.1.00.1408191420150.4929@math.ut.ee>  <1408451668.2645.2.camel@jarvis>  <alpine.SOC.1.00.1408191736190.7767@math.ut.ee>  <1408459655.3491.1.camel@jarvis>  <20140819201748.GC4885@drone.musicnaut.iki.fi>
 <1408480638.4424.0.camel@jarvis>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1408480638.4424.0.camel@jarvis>
Sender: sparclinux-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, linux-parisc@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

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

Yes, works for both sparc64 and parisc.

-- 
Meelis Roos (mroos@linux.ee)
