From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Wed, 19 Mar 2014 10:01:26 +0000
Message-ID: <bug-71231-11613-HGQNjt4iwl@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51741 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaCSSS5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2014 14:18:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CA8EB203C4
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2014 10:01:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AD4C2203B1
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2014 10:01:26 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #9 from Alex <alexandernaumann@gmx.de> ---
Kernel 3.11.10 is working fine too.
So only 3.10 and 3.12 have this problem (regardless of the subversions).

-- 
You are receiving this mail because:
You are the assignee for the bug.
