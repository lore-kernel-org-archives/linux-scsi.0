From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If I try to
 attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Sun, 10 Aug 2008 23:33:52 -0700
Message-ID: <20080810233352.8423614f.akpm@linux-foundation.org>
References: <bug-11302-10286@http.bugzilla.kernel.org/>
	<20080810135344.6f900129.akpm@linux-foundation.org>
	<20080811074553.11b06602@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbYHKGeE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2008 02:34:04 -0400
In-Reply-To: <20080811074553.11b06602@mjolnir.drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, pinc_o@yahoo.it, James Bottomley <James.Bottomley@HansenPartnership.com>

On Mon, 11 Aug 2008 07:45:53 +0200 Pierre Ossman <drzeus@drzeus.cx> wrote:

> On Sun, 10 Aug 2008 13:53:44 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > (switched to email.  Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> > 
> > On Sun, 10 Aug 2008 13:45:49 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=11302
> > > 
> > >            Summary: I get a kernel OOPS! If I try to attach an usb card
> > >                     reader, SD, MMC, ecc.. to my Slamd64
> > >            Product: IO/Storage
> > >            Version: 2.5
> > >      KernelVersion: 2.6.26.2
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: blocking
> > >           Priority: P1
> > >          Component: SCSI
> > >         AssignedTo: linux-scsi@vger.kernel.org
> > >         ReportedBy: pinc_o@yahoo.it
> > 
> > Is this a scsi regresion, or an mmc regression?
> > 

OK.  There have been some regressions in the scsi area but I thought
that a) they were fixed and b) none manifested as an oops in
slave_alloc().

Perhaps James can take a look please?

> There are no USB based "real" MMC controllers, so I'd say SCSI.
> 
> > > If attach my usb card reader, without load mmc_block an mmc_core modules, then
> > > the follow OOPS appear(If first load them, simply doesn't mount the SD. Please
> > > note: I always use "automatic loading kernel modules" compiled in "my" kernelS.
> > > But from many time, the recent kernelS not load the mmc_block module):
> 
> I don't know what kind of weird ass scripts loaded them for USB mass
> storage to begin with. As for the claimed lack of crashes when loaded;
> no idea as there is no interaction between the SCSI and MMC layer.
> 
> > > Modules linked in: nvidia(P) [last unloaded: nvidia]
> 
> This is always a good start..

I very much doubt it.

Paolo, can you please check to see if the crash happens in a kernel
into which the nvidia driver has never been loaded?

