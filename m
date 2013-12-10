From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15950] Hang in dc395x driver
Date: Tue, 10 Dec 2013 19:51:12 +0000
Message-ID: <bug-15950-11613-rZ3ug4YF7I@https.bugzilla.kernel.org/>
References: <bug-15950-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37303 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab3LJTvP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 14:51:15 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5BFD620608
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2013 19:51:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D8BE820614
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2013 19:51:12 +0000 (UTC)
In-Reply-To: <bug-15950-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15950

ltskinol@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|OBSOLETE                    |---

--- Comment #6 from ltskinol@gmail.com ---
Reopening.  Not obsolete.  Reproduceable in 3.5.3, which is what I'm using at
present.  (I can upgrade to a newer version if need-be.)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
