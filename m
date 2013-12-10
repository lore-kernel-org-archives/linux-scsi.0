From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15950] Hang in dc395x driver
Date: Tue, 10 Dec 2013 22:15:21 +0000
Message-ID: <bug-15950-11613-NkpumqPimn@https.bugzilla.kernel.org/>
References: <bug-15950-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46629 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab3LJWPY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 17:15:24 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4F5682069C
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2013 22:15:23 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2410220699
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2013 22:15:22 +0000 (UTC)
In-Reply-To: <bug-15950-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15950

--- Comment #8 from ltskinol@gmail.com ---
Could be.  Haven't found another inexpensive SCSI adapter.

I say the driver probably needs to get fixed or removed, though.  No point in
having it in the kernel giving folks false hope that it'll work!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
