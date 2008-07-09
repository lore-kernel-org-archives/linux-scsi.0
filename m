From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Wed,  9 Jul 2008 01:40:02 -0700 (PDT)
Message-ID: <20080709084002.4D9F511D109@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575AbYGIIkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 04:40:04 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m698e2YC019259
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jul 2008 01:40:03 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #13 from kurk@shiftmail.org  2008-07-09 01:40 -------
>Hi,
>Can you please attach the complete log that you collected with a
>serial console to this bug report:
>  http://bugzilla.kernel.org/show_bug.cgi?id=11045
>
>The excerpts are missing important information about how the MPT
>interrupt is routed when the driver claims the device.  It's
>easier if we can just look at the complete log; sometimes it
>answers questions we didn't think of the first time around.
>
>Thanks,
>  Bjorn

Hi Bjorn,
what I pasted in, it is absolutely the complete log obtained with the serial
cable. I did not modify it in any way or cut away parts. As I wrote, I obtained
it twice, once stopping the boot after 8 minutes, the other stopping after 5
(and stack traces are slightly different in the two boots as you can see). The
error messages loop as you can see and never end so it is necessary to stop
that after a while. The other attachments like dmesg (2.6.25), lspci (2.6.25),
.config yes, I grepped or cut them, but not the serial dump.

(Is it ok if I reply from the web interface or should I do via email? Sorry
it's the first time I use bugzilla.kernel.org)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
