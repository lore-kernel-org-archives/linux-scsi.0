From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11302] I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Mon, 11 Aug 2008 06:33:40 -0700 (PDT)
Message-ID: <20080811133340.33E2911D109@picon.linux-foundation.org>
References: <bug-11302-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbYHKNeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2008 09:34:10 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7BDXe48015930
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2008 06:33:41 -0700
In-Reply-To: <bug-11302-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11302





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-08-11 06:33 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Sun, 2008-08-10 at 23:33 -0700, Andrew Morton wrote:
> On Mon, 11 Aug 2008 07:45:53 +0200 Pierre Ossman <drzeus@drzeus.cx> wrote:
> 
> > On Sun, 10 Aug 2008 13:53:44 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > (switched to email.  Please respond via emailed reply-to-all, not via the
> > > bugzilla web interface).
> > > 
> > > On Sun, 10 Aug 2008 13:45:49 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > > 
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=11302
> > > > 
> > > >            Summary: I get a kernel OOPS! If I try to attach an usb card
> > > >                     reader, SD, MMC, ecc.. to my Slamd64
> > > >            Product: IO/Storage
> > > >            Version: 2.5
> > > >      KernelVersion: 2.6.26.2
> > > >           Platform: All
> > > >         OS/Version: Linux
> > > >               Tree: Mainline
> > > >             Status: NEW
> > > >           Severity: blocking
> > > >           Priority: P1
> > > >          Component: SCSI
> > > >         AssignedTo: linux-scsi@vger.kernel.org
> > > >         ReportedBy: pinc_o@yahoo.it
> > > 
> > > Is this a scsi regresion, or an mmc regression?
> > > 
> 
> OK.  There have been some regressions in the scsi area but I thought
> that a) they were fixed and b) none manifested as an oops in
> slave_alloc().
> 
> Perhaps James can take a look please?

Well, this does illustrate one of the problems of making everything
static:  slave_configure isn't a terribly distinguished name.  However,
I'd bet this is usbstorage/scsiglue.c:slave_configure()

the taxonomy looks identical to bugs 11088 and 11072.  Which are being
fixed (have been fixed) in the USB tree.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
