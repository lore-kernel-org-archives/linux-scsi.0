From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11302] I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Sun, 10 Aug 2008 23:34:04 -0700 (PDT)
Message-ID: <20080811063404.1D96D108038@picon.linux-foundation.org>
References: <bug-11302-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbYHKGeF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2008 02:34:05 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7B6Y4OZ023353
	for <linux-scsi@vger.kernel.org>; Sun, 10 Aug 2008 23:34:05 -0700
In-Reply-To: <bug-11302-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11302





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-08-10 23:34 -------
Reply-To: akpm@linux-foundation.org

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


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
