From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 12:04:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0210311203510.23076-100000@beppo>
References: <20021031200350.GA30047@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021031200350.GA30047@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org


> On Thu, Oct 31, 2002 at 11:30:57AM -0800, Matthew Jacob wrote:
> > 
> > 
> > > On Thu, 2002-10-31 at 18:28, Matthew Jacob wrote:
> > > > > 3) Linux should be using the Report Luns command to determine how
> > > > >    many luns are on a device and at what locations.  This might
> > > > >    even allow you to never probe more than 8 luns on a SCSI 2
> > > > >    device unless they support this command.  Does the Symetrix support
> > > > >    it?  Going beyond 8 luns on a SCSI2 device is really a hack
> > > > >    otherwise.
> > > > 
> > > > Absolutely.
> > > 
> > > Now is the right time to fix this properly for 2.5
> > > 
> > > 
> > 
> > Well, yes.
> 
> 2.5 does this already.


*blush*

I was actually going to start finally working 2.5 next week (don't hit
me! don't hit me)


