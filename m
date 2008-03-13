From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10226] BusLogic Flashpoint SCSI Adapter not working with x86_64 kernels
Date: Thu, 13 Mar 2008 10:12:44 -0700 (PDT)
Message-ID: <20080313171244.D82F9108066@picon.linux-foundation.org>
References: <bug-10226-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbYCMRNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 13:13:36 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2DHDaCG016910
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2008 10:13:37 -0700
In-Reply-To: <bug-10226-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10226





------- Comment #13 from matthew@wil.cx  2008-03-13 10:12 -------
On Thu, Mar 13, 2008 at 12:45:37PM -0400, Christoph Hellwig wrote:
> On Thu, Mar 13, 2008 at 06:55:08AM -0600, Matthew Wilcox wrote:
> > How does this look?  I've inverted the sense of the flashpoint config
> > option and neatened up the PCI-less support while I was there.
> 
> I think it's a good start.  Long-term flashpoint should either die or
> become a driver of it's own - these cards have very little in common
> with the regular intelligent buslogic cards and if you look at the
> driver it's full of if (flashpoint) in every major function.

Completely agreed about the long term direction.

I'm not volunteering to work on this particular obsolescent driver
though.  Advansys is quite enough trouble for me.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
