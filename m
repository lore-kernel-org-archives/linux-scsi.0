From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] mptscsih: ioc0: attempting task abort when heavy disk
 operations on MPT SAS
Date: Tue, 14 Feb 2012 18:52:45 GMT
Message-ID: <201202141852.q1EIqjAe019998@bugzilla.kernel.org>
References: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:57086 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab2BNSwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 13:52:45 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1EIqjmT019999
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2012 18:52:45 GMT
In-Reply-To: <bug-18652-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652


Eric <eric.hidle@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |eric.hidle@gmail.com




--- Comment #9 from Eric <eric.hidle@gmail.com>  2012-02-14 18:52:44 ---
I have this issue as well (Bug #42765) in Linux on VMWare, but the patch from
lkml is not in ESXi 5.0. I created a VIB to patch the ESXi scsi-mptsas driver
and will follow up when I have time to test it.

Mine occurs during high disk write utilization, seemingly independent of what
disk is attached to the controller.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
