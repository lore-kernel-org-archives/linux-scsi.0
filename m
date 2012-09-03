From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 46891] scsi/bnx2fc/bnx2fc_io.c:1810: bad call to memset
Date: Mon,  3 Sep 2012 15:53:52 +0000 (UTC)
Message-ID: <20120903155352.3116211FC43@bugzilla.kernel.org>
References: <bug-46891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42397 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2ICPxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Sep 2012 11:53:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9E65A201F9
	for <linux-scsi@vger.kernel.org>; Mon,  3 Sep 2012 15:53:54 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B279620157
	for <linux-scsi@vger.kernel.org>; Mon,  3 Sep 2012 15:53:53 +0000 (UTC)
In-Reply-To: <bug-46891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=46891


Bhanu Prakash Gollapudi <bprakash@broadcom.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bprakash@broadcom.com




--- Comment #2 from Bhanu Prakash Gollapudi <bprakash@broadcom.com>  2012-09-03 15:53:51 ---
Agree. I'll fix this soon.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
