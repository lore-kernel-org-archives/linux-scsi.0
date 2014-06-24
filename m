From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15562] SCSI Generic block io queueing can lock up
Date: Tue, 24 Jun 2014 17:07:47 +0000
Message-ID: <bug-15562-11613-cdoPwX0eYe@https.bugzilla.kernel.org/>
References: <bug-15562-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58878 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbaFXRHu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 13:07:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7402E20380
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2014 17:07:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id AFDAA20374
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2014 17:07:47 +0000 (UTC)
In-Reply-To: <bug-15562-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15562

xerofoify@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xerofoify@gmail.com

--- Comment #1 from xerofoify@gmail.com ---
This bug is against obsolete kernel. Please test newer 
kernel to see if fixed.
Cheers Nick

-- 
You are receiving this mail because:
You are the assignee for the bug.
