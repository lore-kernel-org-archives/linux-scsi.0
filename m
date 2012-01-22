From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29442] target: Race between target driver unregistration and
 LUN removal
Date: Sun, 22 Jan 2012 19:30:30 GMT
Message-ID: <201201221930.q0MJUUYW013690@bugzilla.kernel.org>
References: <bug-29442-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:34471 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2AVULP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jan 2012 15:11:15 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0MJUUan013691
	for <linux-scsi@vger.kernel.org>; Sun, 22 Jan 2012 19:30:30 GMT
In-Reply-To: <bug-29442-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=29442


Bart Van Assche <bvanassche@acm.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
