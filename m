From: Mike Brown <mbrown@emc.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 15:40:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031204021.GW574@lapi0061>
References: <20021031200758.GB30047@redhat.com> <Pine.BSF.4.21.0210311225260.23076-100000@beppo> <20021031203832.GG30047@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021031203832.GG30047@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

> And we recently added INQUIRY with the EVPD bit set and an EVPD page 0.  
> >From the reports I've seen, I'm pretty sure it's causing a more than
> trivial number of devices to lock up on boot.  I suspect blindly pulling a
> REPORT_LUNS on SCSI-2 devices would likely cause similar problems.

What about adding BLIST_FORCE_REPORT_LUNS?

-Michael F. Brown, EMC Corp.

Email:            mbrown@emc.com
EMC Tie Line:             x43416
External Line:    (508) 249-3416

"5 years from now everyone will be running free
 GNU on their 200 MIPS, 64M SPARCstation-5."      -Andrew Tanenbaum '92

(In late 1997 I installed Linux for the first time on my 200Mhz, 128M
 AMD x86 clone)
