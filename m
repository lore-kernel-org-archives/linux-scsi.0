From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi tree build failure
Date: Fri, 03 Apr 2009 01:16:40 +0000
Message-ID: <1238721400.13399.23.camel@mulgrave.int.hansenpartnership.com>
References: <20090402164927.97958f84.sfr@canb.auug.org.au>
	 <1238682141.3383.11.camel@mulgrave.int.hansenpartnership.com>
	 <1238692778.15031.56.camel@fritz>
	 <1238696622.13399.11.camel@mulgrave.int.hansenpartnership.com>
	 <20090403112602.fa3010c8.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090403112602.fa3010c8.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robert Love <robert.w.love@intel.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "Dev, Vasu" <vasu.dev@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2009-04-03 at 11:26 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> On Thu, 02 Apr 2009 18:23:42 +0000 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> > On Thu, 2009-04-02 at 10:19 -0700, Robert Love wrote:
> > >
> > > I built using gcc version 4.3.2 (on x86_64) and didn't see this either.
> 
> It may be powerpc specific, I guess.
> 
> > > > diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> > > > index 5cdda6e..94e1e31 100644
> > > > --- a/drivers/scsi/fcoe/fcoe.c
> > > > +++ b/drivers/scsi/fcoe/fcoe.c
> > > > @@ -979,7 +979,6 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
> > > >  	}
> > > >  	return crc;
> > > >  }
> > > > -EXPORT_SYMBOL_GPL(fcoe_fc_crc);
> > > >  
> > > >  /**
> > > >   * fcoe_xmit() - FCoE frame transmit function
> > > > 
> > > > 
> > Right at the moment, I need someone to verify that this is the fix,
> > since I don't have a complaining compiler myself.  If it's this simple,
> > I can adjust the patch accordingly.
> 
> This fixes it for me.  I will apply that patch to linux-next for today
> (instead of the reverts I did yesterday).

Perfect, thanks!

I fixed up the patch in my tree, so you should not need this next time
around.

James
