From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84091] Unloading qla2xxx kernel module triggers segmentation
 fault
Date: Mon, 08 Sep 2014 16:21:32 +0000
Message-ID: <bug-84091-11613-BVso43EQGv@https.bugzilla.kernel.org/>
References: <bug-84091-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54389 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbaIHQVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 12:21:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C9A5220120
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2014 16:21:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3318D20170
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2014 16:21:33 +0000 (UTC)
In-Reply-To: <bug-84091-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=84091

--- Comment #2 from Bart Van Assche <bvanassche@acm.org> ---
This issue doesn't occur anymore with that patch applied. Thanks !

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
