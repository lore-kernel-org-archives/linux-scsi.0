From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Fri, 15 Jan 2010 02:49:53 GMT
Message-ID: <201001150249.o0F2nrcc021199@demeter.kernel.org>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36570 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0AOCtx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 21:49:53 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0F2nreG021200
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2010 02:49:53 GMT
In-Reply-To: <bug-15007-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007





--- Comment #6 from nick cheng <nick.cheng@areca.com.tw>  2010-01-15 02:49:48 ---
OK. I got it.
But based on 128 sg entries issue on my original driver I found it bugs every
time while doing mkfs.ext3 on a default NTFS filesystem, but if I do it on a
ext3 filesystem, it works smoothly.
Besides, it bugs on SMP platforms always but doesn't on non-SMP plaform.
Can your inference explain it?
Thanks so much for your help.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
