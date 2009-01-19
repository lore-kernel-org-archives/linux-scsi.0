From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12481] mt takes two minutes to determine that the tape drive is empty
Date: Mon, 19 Jan 2009 12:37:14 -0800 (PST)
Message-ID: <20090119203714.61A6B108043@picon.linux-foundation.org>
References: <bug-12481-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416AbZASUho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 15:37:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0JKbEnC031975
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2009 12:37:15 -0800
In-Reply-To: <bug-12481-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12481


kmshanah@ucwb.org.au changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |REJECTED
         Resolution|                            |INVALID




------- Comment #3 from kmshanah@ucwb.org.au  2009-01-19 12:37 -------
Thanks, I think you are probably right.
strace shows it (GNU mt) is using open("/dev/nst0", O_RDONLY).

That would also explain why I remember something about the output being
different. I remember now that I had to change my backup script - mt-st outputs
to stdout and shows the status bits of the drive with "DR_OPEN" to indicate the
tape isn't yet loaded, but exits with status 0. GNU mt prints it's error
message to stderr and exits with status 1 when the tape isn't loaded.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
