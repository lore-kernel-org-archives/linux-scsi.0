From: Mike Brown <mbrown@emc.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 16:00:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031210054.GX574@lapi0061>
References: <20021031204021.GW574@lapi0061> <Pine.BSF.4.21.0210311241260.23076-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0210311241260.23076-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: Mike Brown <mbrown@emc.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

I'd rather have to add a list entry for one of a few dozen storage
array vendors then get hundreds bug reports from noname USB
block devices that blew up when we sent REPORT_LUNS.  Considering
a lot of them blow up if you ask for more than a 36 byte INQUIRY
response, I think REPORT_LUNS should be special cased in the
blacklist.

I haven't been tracking 2.5, but I knew there were plans to push
push the scanning code and the blacklist stuff into a userspace
scsid.  Did this make it?

On Thu, Oct 31, 2002 at 12:41:50PM -0800, Matthew Jacob wrote:
> 
> Yeah, but lets get out of the tailchasing exercise of list updates if we
> can...
> 
> 
> > > And we recently added INQUIRY with the EVPD bit set and an EVPD page 0.  
> > > >From the reports I've seen, I'm pretty sure it's causing a more than
> > > trivial number of devices to lock up on boot.  I suspect blindly pulling a
> > > REPORT_LUNS on SCSI-2 devices would likely cause similar problems.
> > 
> > What about adding BLIST_FORCE_REPORT_LUNS?
> > 
> > -Michael F. Brown, EMC Corp.
> > 
> > Email:            mbrown@emc.com
> > EMC Tie Line:             x43416
> > External Line:    (508) 249-3416
> > 
> > "5 years from now everyone will be running free
> >  GNU on their 200 MIPS, 64M SPARCstation-5."      -Andrew Tanenbaum '92
> > 
> > (In late 1997 I installed Linux for the first time on my 200Mhz, 128M
> >  AMD x86 clone)
> > 
-Michael F. Brown, EMC Corp.

Email:            mbrown@emc.com
EMC Tie Line:             x43416
External Line:    (508) 249-3416

"5 years from now everyone will be running free
 GNU on their 200 MIPS, 64M SPARCstation-5."      -Andrew Tanenbaum '92

(In late 1997 I installed Linux for the first time on my 200Mhz, 128M
 AMD x86 clone)
