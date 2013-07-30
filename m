From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 30 Jul 2013 10:12:35 +0000
Message-ID: <bug-60644-11613-R9rkCSgJPF@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40412 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3G3KMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jul 2013 06:12:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 926392045B
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2013 10:12:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id ADFAA20464
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2013 10:12:35 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #13 from liveaxle@live.com ---
One more thing , the MD-RAID0 has XFS but that doesn't matter because it used
to have EXT4 with the same results .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
