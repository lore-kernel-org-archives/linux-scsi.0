From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31212] aacraid is generally unstable with newer kernels
Date: Sun,  4 Nov 2012 16:05:49 +0000 (UTC)
Message-ID: <20121104160549.CBEDE11FB1E@bugzilla.kernel.org>
References: <bug-31212-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50104 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab2KDQFw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Nov 2012 11:05:52 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4AABD201D8
	for <linux-scsi@vger.kernel.org>; Sun,  4 Nov 2012 16:05:51 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 765FE201D0
	for <linux-scsi@vger.kernel.org>; Sun,  4 Nov 2012 16:05:50 +0000 (UTC)
In-Reply-To: <bug-31212-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31212


Ryan Underwood <nemesis@icequake.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |UNREPRODUCIBLE




--- Comment #8 from Ryan Underwood <nemesis@icequake.net>  2012-11-04 16:05:49 ---
I have found that there are at least two different versions of the ASR-2120S. 
There is an older version which shipped with v5xxx and v6xxx firmware which has
a RAID processor which looks like a PPGA Intel Celeron.  There is a newer
version which is labeled RoHS on the product label, comes with v8208 firmware
(latest), and has a "shiny" BGA looking RAID processor.  This latter version
has been working since I last reported without a single crash or other problem.

I think there may be hardware defects arising in the older versions perhaps due
to age or due to problems solved in later versions.  Since when the older
vesrions of the card crashes Linux it remains upset in other ways (will not
POST, will not bring drives online, etc), I am reluctant to blame this on Linux
and am therefore closing this bug.  Anyone having problems with ASR-2120S
should seek the later RoHS hardware revision which can visually be identified
by the RoHS indication on the product sticker and the shiny surfaced RAID
processor.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
