From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] Kernel ooops when disconnecting the USB flash disk, in
 which I've just modified partition table
Date: Sun, 25 Mar 2012 20:22:25 GMT
Message-ID: <201203252022.q2PKMP3A029113@bugzilla.kernel.org>
References: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:39373 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab2CYUW0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Mar 2012 16:22:26 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2PKMPX0029114
	for <linux-scsi@vger.kernel.org>; Sun, 25 Mar 2012 20:22:25 GMT
In-Reply-To: <bug-42783-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783





--- Comment #8 from Stefan Richter <stefanr@s5r6.in-berlin.de>  2012-03-25 20:22:24 ---
This bug should have been fixed between v3.3-rc7 and v3.3 by commit
fe316bf2d5847bc5dd975668671a7b1067603bc7 and
9f53d2fe815b4011ff930a7b6db98385d45faa68.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
