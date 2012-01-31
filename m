From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42702] MPT2SAS - devices disabled at boot
Date: Tue, 31 Jan 2012 13:39:01 GMT
Message-ID: <201201311339.q0VDd1bb001178@bugzilla.kernel.org>
References: <bug-42702-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:55070 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2AaNjB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2012 08:39:01 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0VDd1C2001179
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2012 13:39:01 GMT
In-Reply-To: <bug-42702-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42702


nagalakshmi <nagalakshmi.nandigama@lsi.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nagalakshmi.nandigama@lsi.c
                   |                            |om




--- Comment #1 from nagalakshmi <nagalakshmi.nandigama@lsi.com>  2012-01-31 13:39:00 ---
Please apply this patch
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
