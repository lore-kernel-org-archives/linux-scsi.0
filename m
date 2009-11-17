From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Tue, 17 Nov 2009 05:15:04 GMT
Message-ID: <200911170515.nAH5F4LF024816@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36688 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZKQFO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 00:14:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAH5F4Yw024817
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2009 05:15:04 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #7 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-11-17 05:15:02 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

> > Performing tape backups using amanda 2.6.0-p2 [using 512kB block size] leads to
> > spurious 'EIO' errors when writing to the tape; most of the time a kernel BUG
> > is hit shortly thereafter.
> > 
> 
> Can you try this with debugging enabled in st? (Edit st.c to
> '#define DEBUG 1' and recompile the module.) This might give more 
> information about the source of the EIO and the code path it uses.

Sorry about that bug.

Looks like that st drivers messes up memory management but the log
doesn't give enough information.

As Kai suggested, please enable the debug option and send the new log.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
