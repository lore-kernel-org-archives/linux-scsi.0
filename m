From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Mon, 22 Dec 2008 09:44:02 -0800 (PST)
Message-ID: <20081222174402.EBB6B10800D@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbYLVRoc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2008 12:44:32 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBMHi3HY014805
	for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2008 09:44:04 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #1 from alan@lxorguk.ukuu.org.uk  2008-12-22 09:44 -------
Ok so the earliest you found the bug is 2.6.16 but I assume from the comments
about distibution you also tried recent kernels as well and saw the same ?

The cases where /dev/st will return EBUSY are pretty limited
- An asynchronous command already being active
- Out of control blocks for the tape
- Buffer/request too large (which seems the likely candidate)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
