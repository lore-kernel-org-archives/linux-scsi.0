From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 12:41:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0210311241260.23076-100000@beppo>
References: <20021031204021.GW574@lapi0061>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021031204021.GW574@lapi0061>
List-Id: linux-scsi@vger.kernel.org
To: Mike Brown <mbrown@emc.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org


Yeah, but lets get out of the tailchasing exercise of list updates if we
can...


> > And we recently added INQUIRY with the EVPD bit set and an EVPD page 0.  
> > >From the reports I've seen, I'm pretty sure it's causing a more than
> > trivial number of devices to lock up on boot.  I suspect blindly pulling a
> > REPORT_LUNS on SCSI-2 devices would likely cause similar problems.
> 
> What about adding BLIST_FORCE_REPORT_LUNS?
> 
> -Michael F. Brown, EMC Corp.
> 
> Email:            mbrown@emc.com
> EMC Tie Line:             x43416
> External Line:    (508) 249-3416
> 
> "5 years from now everyone will be running free
>  GNU on their 200 MIPS, 64M SPARCstation-5."      -Andrew Tanenbaum '92
> 
> (In late 1997 I installed Linux for the first time on my 200Mhz, 128M
>  AMD x86 clone)
> 

