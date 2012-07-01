From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42918] fcoe: Enabling VN2VN mode triggers a circular locking
 complaint
Date: Sun,  1 Jul 2012 09:48:30 +0000 (UTC)
Message-ID: <20120701094830.1B8B711FA62@bugzilla.kernel.org>
References: <bug-42918-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47132 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab2GAJsc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Jul 2012 05:48:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C3699201F4
	for <linux-scsi@vger.kernel.org>; Sun,  1 Jul 2012 09:48:31 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1D9DE201DE
	for <linux-scsi@vger.kernel.org>; Sun,  1 Jul 2012 09:48:30 +0000 (UTC)
In-Reply-To: <bug-42918-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42918





--- Comment #4 from Florian Mickler <florian@mickler.org>  2012-07-01 09:48:29 ---
A patch referencing this bug report has been merged in Linux v3.5-rc1:

commit 949e71f17d9a5c59fa7b02cce3b548384bff1c92
Author: Robert Love <robert.w.love@intel.com>
Date:   Fri Apr 20 12:16:43 2012 -0700

    [SCSI] fcoe: Don't hold rtnl_mutex in fcoe_update_src_mac

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
