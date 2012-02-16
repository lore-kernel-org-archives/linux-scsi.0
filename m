From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] Kernel ooops when disconnecting the USB flash disk, in
 which I've just modified partition table
Date: Thu, 16 Feb 2012 17:07:03 GMT
Message-ID: <201202161707.q1GH73wc002913@bugzilla.kernel.org>
References: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:33062 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2BPRHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 12:07:04 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1GH73tU002914
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2012 17:07:03 GMT
In-Reply-To: <bug-42783-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783


Bart Van Assche <bvanassche@acm.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org




--- Comment #3 from Bart Van Assche <bvanassche@acm.org>  2012-02-16 17:07:02 ---
It would help if you could test whether this patch helps:
http://www.spinics.net/lists/linux-scsi/msg57426.html

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
