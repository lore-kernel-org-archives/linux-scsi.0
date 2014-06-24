From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15564] SCSI Generic queueing of insufficient dxferlen for
 command can succeed
Date: Tue, 24 Jun 2014 17:09:25 +0000
Message-ID: <bug-15564-11613-suCBy7oUCo@https.bugzilla.kernel.org/>
References: <bug-15564-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58966 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668AbaFXRJ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 13:09:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 085DA20380
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2014 17:09:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A323420379
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2014 17:09:25 +0000 (UTC)
In-Reply-To: <bug-15564-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15564

xerofoify@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xerofoify@gmail.com

--- Comment #1 from xerofoify@gmail.com ---
This bug is old.Please test against newer kernel
to see it's fixed.
Nick

-- 
You are receiving this mail because:
You are the assignee for the bug.
