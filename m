From: Matthew Frost <artusemrys@yahoo.com>
Subject: Re: BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
Date: Wed, 30 Jul 2008 08:39:42 -0700 (PDT)
Message-ID: <749062.6878.qm@web83206.mail.mud.yahoo.com>
References: <Pine.LNX.4.44L0.0807301014420.2584-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761339AbYG3Pjx@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0807301014420.2584-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Matt Frost <artusemrys@sbcglobal.net>, linux-scsi <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

--- Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 29 Jul 2008, James Bottomley wrote:
> 
> > > Summary:
> > > Between 2.6.26-rc9-git10 and rc9-git11, the kernel stopped properly
> > > recognizing my USB-card-reader-mounted SDHC 4GB card.  The problem
> seems to
> > > come up between usb-storage recognizing the device, and the handoff to
> scsi
> > > to read the disk properties.  The bug remains in 2.6.26 and 2.6.27-rc1;
> > > kernels before 2.6.26-rc9-git10 are unaffected.  On the same EHCI
> controller,
> > > an old-spec SD 1GB card and its reader are unaffected by this bug.
> 
> > > After the bug, initialization looks the same until the device scan
> finishes. 
> > > Handoff to scsi produces the following (taken from rc9-git12):
> 
> > > sd 5:0:0:0: [sdf] Sector size 0 reported, assuming 512.
> > > sd 5:0:0:0: [sdf] 1 512-byte hardware sectors (0 MB)
> > > sd 5:0:0:0: [sdf] Write Protect is off
> > > sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> > > sd 5:0:0:0: [sdf] Assuming drive cache: write through
> > > sd 5:0:0:0: [sdf] Sector size 0 reported, assuming 512.
> > > sd 5:0:0:0: [sdf] 1 512-byte hardware sectors (0 MB)
> > > sd 5:0:0:0: [sdf] Write Protect is off
> > > sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> > > sd 5:0:0:0: [sdf] Assuming drive cache: write through
> > >  sdf: sdf1
> > >  sdf: p1 exceeds device capacity
> > > sd 5:0:0:0: [sdf] Attached SCSI removable disk
> > > sd 5:0:0:0: Attached scsi generic sg7 type 0
> 
> The problem will most likely be fixed by this patch:
> 
> 	http://marc.info/?l=linux-usb&m=121734710306509&w=2
> 
> Alan Stern
> 
> 

Thanks.  Giving it a try now.

Matt Frost
