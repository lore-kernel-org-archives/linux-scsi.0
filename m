From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Thu, 14 Jan 2010 10:54:44 GMT
Message-ID: <201001141054.o0EAsiJd013909@demeter.kernel.org>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41224 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0ANKyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 05:54:44 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0EAsisR013910
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 10:54:44 GMT
In-Reply-To: <bug-15007-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007





--- Comment #2 from nick cheng <nick.cheng@areca.com.tw>  2010-01-14 10:54:42 ---
Thanks for reply.
I am sure that hardware and firmware can handle 1024 scatter gather
entries.
I can not limit the AP to dispatch a write command with 128 sg entries.
I just execute mkfs.ext3 /dev/sdX and print it out as the sg entry number is
128. I found the 128th entry indeed has no data.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
