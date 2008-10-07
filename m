From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Tue,  7 Oct 2008 13:38:48 -0700 (PDT)
Message-ID: <20081007203848.760DF108047@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbYJGUjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 16:39:19 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m97KcmEo015082
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2008 13:38:49 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #11 from seokmann.ju@qlogic.com  2008-10-07 13:38 -------
Thanks.
Below is the feedback from our firmware folks.
---
Looks like you have a bad part.

b.txt (fw_dump_4) showed us reading a register to go into a jmp table.  I
should
have read '1' (was at the time of the dump), but looks like I got 0.
RISC then paused on the parity error.
---

So, please go ahead and contact QLogic services to get serviced or replaced it.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
