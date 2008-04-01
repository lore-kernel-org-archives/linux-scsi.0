From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Tue,  1 Apr 2008 07:12:09 -0700 (PDT)
Message-ID: <20080401141209.4775611D108@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886AbYDAOML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 10:12:11 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m31EC9IB011617
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 07:12:10 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-04-01 07:12 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-04-01 at 01:15 -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> > Steps to reproduce:
> > 
> > Let udev load sym53c8xx in kernel 2.6.23 or newer.
> 
> urgh.  Perhaps it's related to platform IRQ routing or something.
> 
> I'd suggest that the next step would be to send us the `dmesg -s 1000000'
> output for both good and bad kernels.  A comparison might show where things
> went bad.

Yes, that would be my guess too ... although I don't see anything amiss
in the dmesg   I note you have two ethernet interfaces:

eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:03:ba:08:61:7c
eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)

I'm assuming eth0 is the problem?

Could you also send us the output of /proc/interrupts, /proc/iomem
and /proc/ioports just to see if we have a problem.  Also, if eth0 is on
its own interrupt line, does the interrupt count rise even while the
interface is non functional?

Thanks,

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
