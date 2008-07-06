From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Sun,  6 Jul 2008 13:28:48 -0700 (PDT)
Message-ID: <20080706202848.E0D31108045@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624AbYGFU2u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jul 2008 16:28:50 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m66KSngn022704
	for <linux-scsi@vger.kernel.org>; Sun, 6 Jul 2008 13:28:50 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #2 from kurk@shiftmail.org  2008-07-06 13:28 -------
The ACPI thing, if it is a bug (I didn't realize that) I think was introduced
much earlier than 2.6.26. I think the same ACPI error strings are visible in
2.6.24 and probably even much earlier kernels. However they don't prevent
booting. Thank you.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
