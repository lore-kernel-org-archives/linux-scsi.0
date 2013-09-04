From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Wed, 04 Sep 2013 09:16:21 +0000
Message-ID: <bug-60758-11613-NtulKBTEwI@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33765 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3IDJQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Sep 2013 05:16:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F31D720397
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2013 09:16:27 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B3D2320363
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2013 09:16:21 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #28 from zakrzewskim@wp.pl ---
One more thing - these boards does not boot kernel-lt-3.0.94-1 and latest
official CentOS kernel too !

-- 
You are receiving this mail because:
You are the assignee for the bug.
