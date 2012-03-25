From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] Kernel ooops when disconnecting the USB flash disk, in
 which I've just modified partition table
Date: Sun, 25 Mar 2012 18:38:21 GMT
Message-ID: <201203251838.q2PIcLPO018226@bugzilla.kernel.org>
References: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:39027 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab2CYSiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Mar 2012 14:38:22 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2PIcLKw018227
	for <linux-scsi@vger.kernel.org>; Sun, 25 Mar 2012 18:38:21 GMT
In-Reply-To: <bug-42783-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783


mlambda@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mlambda@gmail.com




--- Comment #7 from mlambda@gmail.com  2012-03-25 18:38:19 ---
I hit the same (?) bug, but without modifying the partition table:
https://bugzilla.kernel.org/show_bug.cgi?id=42951

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
