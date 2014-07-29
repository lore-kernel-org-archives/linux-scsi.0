From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Tue, 29 Jul 2014 19:59:54 +0000
Message-ID: <bug-11646-11613-GEpTlm9cUh@https.bugzilla.kernel.org/>
References: <bug-11646-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42485 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbaG2UAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 16:00:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C5AFC20142
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 19:59:59 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 90FC4201BF
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 19:59:57 +0000 (UTC)
In-Reply-To: <bug-11646-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=11646

Ravshan DM <mravshan@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mravshan@gmail.com

--- Comment #38 from Ravshan DM <mravshan@gmail.com> ---
I had this issue reproduced on my environment: 2.6.36.4 #848 SMP Thu Jul 17
19:55:17 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

It took time to figure out the root cause, which turned to be a bad SFP, once I
replaced it, all on HBA qla2462, the FC switch recognized the FC port(s)
immediately and all LUNs re-appeared on the host. I hope this info helps.

-- 
You are receiving this mail because:
You are the assignee for the bug.
