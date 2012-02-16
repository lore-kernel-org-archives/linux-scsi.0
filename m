From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] Kernel ooops when disconnecting the USB flash disk, in
 which I've just modified partition table
Date: Thu, 16 Feb 2012 15:38:36 GMT
Message-ID: <201202161538.q1GFcaPO000909@bugzilla.kernel.org>
References: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:32832 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2BPPig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 10:38:36 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1GFca93000910
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2012 15:38:36 GMT
In-Reply-To: <bug-42783-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783


Alan Stern <stern@rowland.harvard.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |stern@rowland.harvard.edu




--- Comment #2 from Alan Stern <stern@rowland.harvard.edu>  2012-02-16 15:38:35 ---
For bug reports like this, it's generally more useful to attach the output from
the "dmesg" command rather than copying the system log file or the contents of
the console directly into the text of the report.

Also, when tracking down problems in the kernel, it helps to build your kernel
with CONFIG_FRAME_POINTER enabled.

Why are you running hald-addon-stor?  hal has been obsolete for some time.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
