From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Tue,  8 Jul 2008 13:57:52 -0700 (PDT)
Message-ID: <20080708205752.4A7C110800B@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbYGHU6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 16:58:12 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m68Kvql2013689
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2008 13:57:53 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #9 from bjorn.helgaas@hp.com  2008-07-08 13:57 -------
On Tuesday 08 July 2008 11:23:33 am James Bottomley wrote:
> On Tue, 2008-07-08 at 10:51 -0600, Bjorn Helgaas wrote:
> > Which ACPI screw up is that?  And what's the usual recipe?
> 
> The usual screw up where subtle ACPI breakage from release to release
> causes some IRQs to get misrouted.
> 
> Usually you start with noacpi and cycle through the pci routing options

Don't worry, I wasn't trying to talk you out of an ACPI bug report;
I just wanted to get enough specifics so I could see whether it was
something I could fix.

> If you actually read this bug report, you'll see there was a message
> 
> ACPI: Resource is not an IRQ entry
> 
> Just before the fusion IRQ failed to get delivered, so I think it's a
> good indicator that there *are* ACPI problems ...

These messages also happen with 2.6.25, where the MPT Fusion driver
worked, so Kurk opened a separate bugzilla,
  http://bugzilla.kernel.org/show_bug.cgi?id=11049
for them.

Yakui Zhao thinks the messages are harmless because they're
related to interrupt link devices that we don't use in IOAPIC mode,
and given that the driver works in 2.6.25, that seems plausible
to me.

Regardless, the messages are alarming and annoying.  I'd like
to understand them better, but I'll pursue that in the 11049
bugzilla.

Bjorn


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
