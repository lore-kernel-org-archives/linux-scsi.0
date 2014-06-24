From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 10554] scsi_scan doesn't set the queue depth for tape drive
Date: Tue, 24 Jun 2014 16:52:04 +0000
Message-ID: <bug-10554-11613-tDgCrjpSa9@https.bugzilla.kernel.org/>
References: <bug-10554-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbaFXQwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 12:52:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 372F0201BA
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2014 16:52:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3233420374
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2014 16:52:05 +0000 (UTC)
In-Reply-To: <bug-10554-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=10554

xerofoify@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xerofoify@gmail.com

--- Comment #1 from xerofoify@gmail.com ---
Can you test this against a Newer Kernel as this bug may be fixed as it's very
old
since it's now 2014.
Thanks Nick

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
