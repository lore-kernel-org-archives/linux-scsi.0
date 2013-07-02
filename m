From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59601] commit 97dec564fd4948e0e560869c80b76e166ca2a83e breaks
 communication with XYRATEX disk shelves
Date: Tue,  2 Jul 2013 22:15:42 +0000 (UTC)
Message-ID: <20130702221542.90FA011FA50@bugzilla.kernel.org>
References: <bug-59601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48050 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3GBWPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jul 2013 18:15:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 08A2420129
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2013 22:15:44 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 95502200F0
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2013 22:15:42 +0000 (UTC)
In-Reply-To: <bug-59601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59601





--- Comment #8 from Jack Hill <jackhill@jackhill.us>  2013-07-02 22:15:42 ---
Also, I think the commit that I claimed introduced the problem after my bisect
run was the wrong one, it appears to be the last good commit. I think the one
that introduces the bug is ff2fc42e74e43721310bff710416230aae6ce0b9

Sorry about that,
Jack

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
