From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10226] BusLogic Flashpoint SCSI Adapter not working with x86_64 kernels
Date: Wed, 12 Mar 2008 14:36:12 -0700 (PDT)
Message-ID: <20080312213613.02B1F11D107@picon.linux-foundation.org>
References: <bug-10226-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbYCLVgo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 17:36:44 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2CLb0si021063
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2008 14:37:02 -0700
In-Reply-To: <bug-10226-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10226





------- Comment #9 from anonymous@kernel-bugs.osdl.org  2008-03-12 14:36 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2008-03-12 at 21:25 +0100, Ulrich Schweitzer wrote:
> Sorry for straying off topic, but this has to be the right crowd to ask:
> I assume that the driver won't be ported to x86_64 soon (if ever),

Not unless someone volunteers, but FlashPoint.c is huge.

>  so I'll 
> need a different SCSI adapter. Is the Adaptec AHA-2940 supported on x86_64 
> (those are cheap on ebay)? If not, what other, preferably cheap, SE SCSI 
> adapter would you recommend?

Yes, the adaptec 7xxx/79xx series work fine both on 64 bits and big
endian.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
