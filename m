From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] Kernel ooops when disconnecting the USB flash disk, in
 which I've just modified partition table
Date: Thu, 16 Feb 2012 18:24:15 GMT
Message-ID: <201202161824.q1GIOFH3004540@bugzilla.kernel.org>
References: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:33282 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2BPSYQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 13:24:16 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1GIOFbC004541
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2012 18:24:15 GMT
In-Reply-To: <bug-42783-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783





--- Comment #4 from Alan Stern <stern@rowland.harvard.edu>  2012-02-16 18:24:14 ---
This patch may be a better solution:

http://marc.info/?l=linux-kernel&m=132935572612353&w=2

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
