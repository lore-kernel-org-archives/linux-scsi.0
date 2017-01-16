From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Mon, 16 Jan 2017 17:30:40 +0100
Message-ID: <20170116163040.GB15938@gmail.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
 <20170115091925.GA26656@gmail.com>
 <1484496665.2405.2.camel@HansenPartnership.com>
 <20170116092255.GB1398@gmail.com>
 <1484576642.2540.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484576642.2540.17.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2017-01-16 at 10:22 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Sun, 2017-01-15 at 10:19 +0100, Ingo Molnar wrote:
> > > > So there's a new mpt3sas SCSI driver boot regression, introduced
> > > > in 
> > > > this merge window, which made one of my servers unbootable.
> > > 
> > > We're not reverting a fix that would cause regressions for others. 
> > 
> > You really need to reconsider that stance ...
> > 
> > > However, The fix was manifestly wrong, so does this fix of the fix
> > > work for you:
> > > 
> > > http://marc.info/?l=linux-scsi&m=148329237807604
> > > 
> > > It's been languishing a bit because no-one seemed to care enough to
> > > test or review it.  IOf you can add a tested by, that will give the
> > > two
> > > we need to push it.
> > 
> > I have tested your other patch that you pointed to:
> > 
> >   http://marc.info/?l=linux-scsi&m=148449968522828
> > 
> > Which patch fixes the bug too (I removed my revert first) - so you
> > can add my:
> > 
> >   Reported-by: Ingo Molnar <mingo@kernel.org>
> >   Tested-by: Ingo Molnar <mingo@kernel.org>
> 
> Thanks ... just checking you tested the second version with the
> concurrency part?

I tested the one I linked to:

   http://marc.info/?l=linux-scsi&m=148449968522828

I don't know which version that is exactly, I just tested what you asked me to 
test.

Thanks,

	Ingo
