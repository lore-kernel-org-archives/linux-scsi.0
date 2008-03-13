From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10226] BusLogic Flashpoint SCSI Adapter not working with x86_64 kernels
Date: Wed, 12 Mar 2008 23:10:30 -0700 (PDT)
Message-ID: <20080313061030.97F8A11D107@picon.linux-foundation.org>
References: <bug-10226-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbYCMGLB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 02:11:01 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2D6BKRa021344
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2008 23:11:21 -0700
In-Reply-To: <bug-10226-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10226





------- Comment #10 from us-@gmx.de  2008-03-12 23:10 -------
On Wednesday March 12 2008, James Bottomley wrote:
> On Wed, 2008-03-12 at 21:25 +0100, Ulrich Schweitzer wrote:
> > Sorry for straying off topic, but this has to be the right crowd to ask:
> > I assume that the driver won't be ported to x86_64 soon (if ever),
>
> Not unless someone volunteers, but FlashPoint.c is huge.

If its not going to be ported, I guess we should add a sentence to the help 
text of CONFIG_SCSI_BUSLOGIC so people like me don't think its a bug. 
Something like "Flashpoint Host Adapter support is only available on x86 but 
not on x86_64 systems."
Would one of you please submit such a patch? I've never submitted a kernel 
patch and don't know how to do it.

Ulrich


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
